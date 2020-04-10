/datum/syndicate_contract
	var/id = 0
	var/status = CONTRACT_STATUS_INACTIVE
	var/datum/objective/contract/contract = new()
	var/target_rank
	var/ransom = 0
	var/payout_type = null
	var/list/victim_belongings = list()

/datum/syndicate_contract/New(contract_owner, blacklist, type=CONTRACT_PAYOUT_SMALL)
	contract.owner = contract_owner
	payout_type = type
	generate(blacklist)

/datum/syndicate_contract/proc/generate(blacklist)
	contract.find_target(null, blacklist)
	var/datum/data/record/record = find_record("name", contract.target.name, GLOB.data_core.general)
	if(record)
		target_rank = record.fields["rank"]
	else
		target_rank = "Unknown"
	if (payout_type == CONTRACT_PAYOUT_LARGE)
		contract.payout_bonus = rand(9,13)
	else if(payout_type == CONTRACT_PAYOUT_MEDIUM)
		contract.payout_bonus = rand(6,8)
	else
		contract.payout_bonus = rand(2,4)
	contract.payout = rand(0, 2)
	contract.generate_dropoff()
	ransom = 100 * rand(18, 45)

/datum/syndicate_contract/proc/handle_extraction(var/mob/living/user)
	if (contract.target && contract.dropoff_check(user, contract.target.current))
		var/turf/free_location = find_obstruction_free_location(3, user, contract.dropoff)
		if(free_location)	// We've got a valid location, launch.
			launch_extraction_pod(free_location)
			return TRUE
	return FALSE

// Launch the pod to collect our victim.
/datum/syndicate_contract/proc/launch_extraction_pod(turf/empty_pod_turf)
	var/obj/structure/closet/supplypod/extractionpod/empty_pod = new()
	RegisterSignal(empty_pod, COMSIG_ATOM_ENTERED, .proc/enter_check)
	empty_pod.stay_after_drop = TRUE
	empty_pod.reversing = TRUE
	empty_pod.explosionSize = list(0,0,0,1)
	empty_pod.leavingSound = 'sound/effects/podwoosh.ogg'
	new /obj/effect/abstract/DPtarget(empty_pod_turf, empty_pod)

/datum/syndicate_contract/proc/enter_check(datum/source, sent_mob)
	if(istype(source, /obj/structure/closet/supplypod/extractionpod))
		if(isliving(sent_mob))
			var/mob/living/M = sent_mob
			var/datum/antagonist/traitor/traitor_data = contract.owner.has_antag_datum(/datum/antagonist/traitor)
			if(M == contract.target.current)
				traitor_data.contractor_hub.contract_TC_to_redeem += contract.payout
				if(M.stat != DEAD)
					traitor_data.contractor_hub.contract_TC_to_redeem += contract.payout_bonus
				status = CONTRACT_STATUS_COMPLETE
				if(traitor_data.contractor_hub.current_contract == src)
					traitor_data.contractor_hub.current_contract = null
				traitor_data.contractor_hub.contract_rep += 2
			else
				status = CONTRACT_STATUS_ABORTED // Sending a target that wasn't even yours is as good as just aborting it
				if(traitor_data.contractor_hub.current_contract == src)
					traitor_data.contractor_hub.current_contract = null
			if(iscarbon(M))
				for(var/obj/item/W in M)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(W == H.w_uniform || W == H.shoes)
							continue	//So all they're left with are shoes and uniform.
					M.transferItemToLoc(W)
					victim_belongings.Add(W)
			var/obj/structure/closet/supplypod/extractionpod/pod = source
			pod.send_up(pod)	// Handle the pod returning
			if(ishuman(M))
				var/mob/living/carbon/human/target = M	// After we remove items, at least give them what they need to live.
				target.dna.species.give_important_for_life(target)
			handleVictimExperience(M)	// After pod is sent we start the victim narrative/heal.
			var/points_to_check = SSshuttle.points	// This is slightly delayed because of the sleep calls above to handle the narrative. We don't want to tell the station instantly.
			if(points_to_check >= ransom)
				SSshuttle.points -= ransom
			else
				SSshuttle.points -= points_to_check
			priority_announce("One of your crew was captured by a rival organisation - we've needed to pay their ransom to bring them back. \
								As is policy we've taken a portion of the station's funds to offset the overall cost.", null, "attention", null, "Nanotrasen Asset Protection")

/datum/syndicate_contract/proc/handleVictimExperience(var/mob/living/M)	// They're off to holding - handle the return timer and give some text about what's going on.
	addtimer(CALLBACK(src, .proc/returnVictim, M), 4 MINUTES)	// Ship 'em back - dead or alive... 4 minutes wait.
	if(M.stat != DEAD)	//Even if they weren't the target, we're still treating them the same.
		M.reagents.add_reagent(/datum/reagent/medicine/regen_jelly, 20)	// Heal them up - gets them out of crit/soft crit. -- now 100% toxinlover friendly!!
		M.flash_act()
		M.confused += 10
		M.blur_eyes(5)
		to_chat(M, "<span class='warning'>You feel strange...</span>")
		sleep(60)
		to_chat(M, "<span class='warning'>That pod did something to you...</span>")
		M.Dizzy(35)
		sleep(65)
		to_chat(M, "<span class='warning'>Your head pounds... It feels like it's going to burst out your skull!</span>")
		M.flash_act()
		M.confused += 20
		M.blur_eyes(3)
		sleep(30)
		to_chat(M, "<span class='warning'>Your head pounds...</span>")
		sleep(100)
		M.flash_act()
		M.Unconscious(200)
		to_chat(M, "<span class='reallybig hypnophrase'>A million voices echo in your head... <i>\"Your mind held many valuable secrets - \
					we thank you for providing them. Your value is expended, and you will be ransomed back to your station. We always get paid, \
					so it's only a matter of time before we ship you back...\"</i></span>")
		M.blur_eyes(10)
		M.Dizzy(15)
		M.confused += 20

/datum/syndicate_contract/proc/returnVictim(var/mob/living/M)	// We're returning the victim
	var/list/possible_drop_loc = list()
	for(var/turf/possible_drop in contract.dropoff.contents)
		if(!is_blocked_turf(possible_drop))
			possible_drop_loc.Add(possible_drop)
	if(possible_drop_loc.len > 0)
		var/pod_rand_loc = rand(1, possible_drop_loc.len)
		var/obj/structure/closet/supplypod/return_pod = new()
		return_pod.bluespace = TRUE
		return_pod.explosionSize = list(0,0,0,0)
		return_pod.style = STYLE_SYNDICATE
		do_sparks(8, FALSE, M)
		M.visible_message("<span class='notice'>[M] vanishes...</span>")
		for(var/obj/item/W in M)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(W == H.w_uniform || W == H.shoes)
					continue //So all they're left with are shoes and uniform.
			M.dropItemToGround(W)
		for(var/obj/item/W in victim_belongings)
			W.forceMove(return_pod)
		M.forceMove(return_pod)
		M.flash_act()
		M.blur_eyes(30)
		M.Dizzy(35)
		M.confused += 20
		new /obj/effect/abstract/DPtarget(possible_drop_loc[pod_rand_loc], return_pod)
	else
		to_chat(M, "<span class='reallybig hypnophrase'>A million voices echo in your head... <i>\"Seems where you got sent here from won't \
					be able to handle our pod... You will die here instead.\"</i></span>")
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(C.can_heartattack())
				C.set_heartattack(TRUE)
