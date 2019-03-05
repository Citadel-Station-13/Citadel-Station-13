/datum/species
	var/should_draw_citadel = FALSE

/datum/species/proc/alt_spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return TRUE
	CHECK_DNA_AND_SPECIES(M)
	CHECK_DNA_AND_SPECIES(H)

	if(!istype(M)) //sanity check for drones.
		return TRUE
	if(M.mind)
		attacker_style = M.mind.martial_art
	if((M != H) && M.a_intent != INTENT_HELP && H.check_shields(M, 0, M.name, attack_type = UNARMED_ATTACK))
		log_combat(M, H, "attempted to touch")
		H.visible_message("<span class='warning'>[M] attempted to touch [H]!</span>")
		return TRUE
	switch(M.a_intent)
		if(INTENT_HELP)
			if(M == H)
				althelp(M, H, attacker_style)
				return TRUE
			return FALSE
		if(INTENT_DISARM)
			altdisarm(M, H, attacker_style)
			return TRUE
	return FALSE

/datum/species/proc/althelp(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(user == target && istype(user))
		if(user.getStaminaLoss() >= STAMINA_SOFTCRIT)
			to_chat(user, "<span class='warning'>You're too exhausted for that.</span>")
			return
		if(!user.resting)
			to_chat(user, "<span class='notice'>You can only force yourself up if you're on the ground.</span>")
			return
		user.visible_message("<span class='notice'>[user] forces [p_them()]self up to [p_their()] feet!</span>", "<span class='notice'>You force yourself up to your feet!</span>")
		user.resting = 0
		user.update_canmove()
		user.adjustStaminaLossBuffered(user.stambuffer) //Rewards good stamina management by making it easier to instantly get up from resting
		playsound(user, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/datum/species/proc/altdisarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(user.getStaminaLoss() >= STAMINA_SOFTCRIT)
		to_chat(user, "<span class='warning'>You're too exhausted.</span>")
		return FALSE
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s shoving attempt!</span>")
		return FALSE
	if(attacker_style && attacker_style.disarm_act(user,target))
		return TRUE
	if(user.resting)
		return FALSE
	else
		if(user == target)
			return
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
		user.adjustStaminaLossBuffered(4)
		playsound(target, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)

		if(target.w_uniform)
			target.w_uniform.add_fingerprint(user)
		SEND_SIGNAL(target, COMSIG_HUMAN_DISARM_HIT, user, user.zone_selected)

		if(!target.resting)
			target.adjustStaminaLoss(5)


		var/turf/target_oldturf = target.loc
		var/shove_dir = get_dir(user.loc, target_oldturf)
		var/turf/target_shove_turf = get_step(target.loc, shove_dir)
		var/mob/living/carbon/human/collateral_human
		var/obj/structure/table/target_table
		var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied
		var/directional_obstruction = FALSE //used for checking if a directional structure on the tile is potentially blocking
		
		//WARNING: INCOMING MEGA HELLCODE
		//Blame that directional windows are insane and that diagonal movement is kind of a bitch.
		for(var/obj/O in target_oldturf.contents)
			if(O.flags_1 & ON_BORDER_1)
				directional_obstruction = TRUE
				break
		if(directional_obstruction)
			if(!(shove_dir in GLOB.diagonals)) //the logic is a bit different for diagonal shoves, see later in the code
				for(var/obj/A in target_oldturf.contents)
					if(A.flags_1 & ON_BORDER_1 && A.dir == shove_dir)
						shove_blocked = TRUE
			else
				var/dir_1 = turn(shove_dir, -45) //No randomization on the assignment here because the situation that requires randomization can't happen
				var/dir_1_blocked = FALSE
				var/dir_2 = turn(shove_dir, 45)
				var/dir_2_blocked = FALSE
				for(var/obj/A in target_oldturf.contents)
					if(A.flags_1 & ON_BORDER_1)
						if(A.dir == dir_1)
							dir_1_blocked = TRUE
						else if(A.dir == dir_2)
							dir_2_blocked = TRUE
						if(dir_1_blocked && dir_2_blocked)
							break
				if(dir_1_blocked && dir_2_blocked)
					shove_blocked = TRUE
				else if(dir_1_blocked && !dir_2_blocked)
					shove_dir = dir_2
				else if(dir_2 && !dir_1_blocked)
					shove_dir = dir_1
				target_shove_turf = get_step(target.loc, shove_dir)
				
		if(!shove_blocked) //Skip this if it's already directionally blocked for speed reasons
			if (!(shove_dir in GLOB.diagonals)) //Diagonals have a lot more complicated of logic, so if it's not a diagonal a much faster check can be run
				if(is_blocked_turf(target_shove_turf, FALSE))
					var/blocking_dir = turn(shove_dir, 180)
					var/no_directionals = TRUE
					var/blocked_by_directional = FALSE
					for(var/obj/O in target_shove_turf.contents)
						if(O.anchored)
							shove_blocked = TRUE
						if(O.flags_1 & ON_BORDER_1)
							no_directionals = FALSE
							if(O.dir == blocking_dir)
								blocked_by_directional = TRUE
					if(no_directionals && blocked_by_directional)
						shove_blocked = TRUE
			else
				var/turf/diagonal_turf = target_shove_turf
				var/turf/cardinal_turf_1
				var/turf/cardinal_turf_2
				target_shove_turf = diagonal_turf
				if(prob(50)) //Check the two turfs in a random order to make sure if both are free one isn't always favored
					cardinal_turf_1 = get_step(target.loc, turn(shove_dir, -45))
					cardinal_turf_2 = get_step(target.loc, turn(shove_dir, 45))
				else
					cardinal_turf_1 = get_step(target.loc, turn(shove_dir, 45))
					cardinal_turf_2 = get_step(target.loc, turn(shove_dir, -45))
				var/cardinal_1_free = FALSE
				var/cardinal_2_free = FALSE
				var/diagonal_free = FALSE
				if(!is_blocked_turf(cardinal_turf_1, FALSE))
					target_shove_turf = cardinal_turf_1
					cardinal_1_free = TRUE
				if(!is_blocked_turf(cardinal_turf_2, FALSE))
					target_shove_turf = cardinal_turf_2
					cardinal_2_free = TRUE
				if(cardinal_1_free && cardinal_2_free && !is_blocked_turf(diagonal_turf, FALSE)) //Check the diagonal last because the other two need to be clear as well
					target_shove_turf = diagonal_turf
					diagonal_free = TRUE
				if(!cardinal_1_free && !cardinal_2_free && !diagonal_free) //If a free tile wasn't found, we need to do even more expensive of checks
					shove_blocked = TRUE
					if(!istype(cardinal_turf_1, /turf/closed))
						for(var/content in cardinal_turf_1.contents)
							if(istype(content, /obj/structure/table))
								target_table = content
								break
							if(ishuman(content))
								collateral_human = content
								break
						if(target_table || collateral_human)
							target_shove_turf = cardinal_turf_1
					if(!target_table && !collateral_human && !istype(cardinal_turf_2, /turf/closed))
						for(var/content in cardinal_turf_2.contents)
							if(istype(content, /obj/structure/table))
								target_table = content
								break
							if(ishuman(content))
								collateral_human = content
								break
						if(target_table || collateral_human)
							target_shove_turf = cardinal_turf_2

		var/targetatrest = target.resting
		if(shove_blocked && !target.is_shove_knockdown_blocked())
			if((!target_table || !collateral_human) && !directional_obstruction && !(shove_dir in GLOB.diagonals))
				for(var/content in target_shove_turf.contents)
					if(istype(content, /obj/structure/table))
						target_table = content
						break
					if(ishuman(content))
						collateral_human = content
						break
			if(target_table)
				if(!targetatrest)
					target.Knockdown(SHOVE_KNOCKDOWN_TABLE)
				user.visible_message("<span class='danger'>[user.name] shoves [target.name] onto \the [target_table]!</span>",
					"<span class='danger'>You shove [target.name] onto \the [target_table]!</span>", null, COMBAT_MESSAGE_RANGE)
				target.forceMove(target_shove_turf)
				log_combat(user, target, "shoved", "onto [target_table]")
			else if(collateral_human && !targetatrest)
				target.Knockdown(SHOVE_KNOCKDOWN_HUMAN)
				collateral_human.Knockdown(SHOVE_KNOCKDOWN_COLLATERAL)
				user.visible_message("<span class='danger'>[user.name] shoves [target.name] into [collateral_human.name]!</span>",
					"<span class='danger'>You shove [target.name] into [collateral_human.name]!</span>", null, COMBAT_MESSAGE_RANGE)
				log_combat(user, target, "shoved", "into [collateral_human.name]")
			else
				target.Move(target_shove_turf) //This move should be blocked anyways, this fixes some odd behavior with things like doors and grills
				if(!targetatrest)
					target.Knockdown(SHOVE_KNOCKDOWN_SOLID)
				user.visible_message("<span class='danger'>[user.name] shoves [target.name][targetatrest ? ".": ", knocking them down!"]</span>",
					"<span class='danger'>You shove [target.name][targetatrest ? ".": ", knocking them down!"]</span>", null, COMBAT_MESSAGE_RANGE)
				log_combat(user, target, "shoved", "knocking them down")
		else
			user.visible_message("<span class='danger'>[user.name] shoves [target.name]!</span>",
				"<span class='danger'>You shove [target.name]!</span>", null, COMBAT_MESSAGE_RANGE)
			var/target_held_item = target.get_active_held_item()
			var/knocked_item = FALSE
			if(!is_type_in_typecache(target_held_item, GLOB.shove_disarming_types))
				target_held_item = null
			if(!target.has_movespeed_modifier(SHOVE_SLOWDOWN_ID))
				target.add_movespeed_modifier(SHOVE_SLOWDOWN_ID, multiplicative_slowdown = SHOVE_SLOWDOWN_STRENGTH)
				if(target_held_item)
					target.visible_message("<span class='danger'>[target.name]'s grip on \the [target_held_item] loosens!</span>",
						"<span class='danger'>Your grip on \the [target_held_item] loosens!</span>", null, COMBAT_MESSAGE_RANGE)
				addtimer(CALLBACK(target, /mob/living/carbon/human/proc/clear_shove_slowdown), SHOVE_SLOWDOWN_LENGTH)
			else if(target_held_item)
				target.dropItemToGround(target_held_item)
				knocked_item = TRUE
				target.visible_message("<span class='danger'>[target.name] drops \the [target_held_item]!!</span>",
					"<span class='danger'>You drop \the [target_held_item]!!</span>", null, COMBAT_MESSAGE_RANGE)
			target.Move(target_shove_turf)
			var/append_message = ""
			if(target_held_item)
				if(knocked_item)
					append_message = "causing them to drop [target_held_item]"
				else
					append_message = "loosening their grip on [target_held_item]"
			log_combat(user, target, "shoved", append_message)


////////////////////
/////BODYPARTS/////
////////////////////


/obj/item/bodypart
	var/should_draw_citadel = FALSE

/datum/species/proc/citadel_mutant_bodyparts(bodypart, mob/living/carbon/human/H)
	switch(bodypart)
		if("ipc_screen")
			return GLOB.ipc_screens_list[H.dna.features["ipc_screen"]]
		if("ipc_antenna")
			return GLOB.ipc_antennas_list[H.dna.features["ipc_antenna"]]
		if("mam_tail")
			return GLOB.mam_tails_list[H.dna.features["mam_tail"]]
		if("mam_waggingtail")
			return GLOB.mam_tails_animated_list[H.dna.features["mam_tail"]]
		if("mam_body_markings")
			return GLOB.mam_body_markings_list[H.dna.features["mam_body_markings"]]
		if("mam_ears")
			return GLOB.mam_ears_list[H.dna.features["mam_ears"]]
		if("mam_snouts")
			return GLOB.mam_snouts_list[H.dna.features["mam_snouts"]]
		if("taur")
			return GLOB.taur_list[H.dna.features["taur"]]
		if("xenodorsal")
			return GLOB.xeno_dorsal_list[H.dna.features["xenodorsal"]]
		if("xenohead")
			return GLOB.xeno_head_list[H.dna.features["xenohead"]]
		if("xenotail")
			return GLOB.xeno_tail_list[H.dna.features["xenotail"]]
