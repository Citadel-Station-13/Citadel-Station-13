/mob/living/carbon/proc/monkeyize(tr_flags = (TR_KEEPITEMS | TR_KEEPVIRUS | TR_DEFAULTMSG))
	if (notransform)
		return
	//Handle items on mob

	//first implants & organs
	var/list/stored_implants = list()
	var/list/int_organs = list()

	if (tr_flags & TR_KEEPIMPLANTS)
		for(var/X in implants)
			var/obj/item/implant/IMP = X
			stored_implants += IMP
			IMP.removed(src, 1, 1)

	var/list/missing_bodyparts_zones = get_missing_limbs()

	var/obj/item/cavity_object

	var/obj/item/bodypart/chest/CH = get_bodypart(BODY_ZONE_CHEST)
	if(CH.cavity_item)
		cavity_object = CH.cavity_item
		CH.cavity_item = null

	if(tr_flags & TR_KEEPITEMS)
		var/Itemlist = get_equipped_items(TRUE)
		Itemlist += held_items
		for(var/obj/item/W in Itemlist)
			dropItemToGround(W)

	//Make mob invisible and spawn animation
	notransform = TRUE
	Stun(INFINITY, ignore_canstun = TRUE)
	icon = null
	cut_overlays()
	invisibility = INVISIBILITY_MAXIMUM

	new /obj/effect/temp_visual/monkeyify(loc)
	sleep(22)
	var/mob/living/carbon/monkey/O = new /mob/living/carbon/monkey( loc )

	// hash the original name?
	if(tr_flags & TR_HASHNAME)
		O.name = "monkey ([copytext_char(md5(real_name), 2, 6)])"
		O.real_name = "monkey ([copytext_char(md5(real_name), 2, 6)])"

	//handle DNA and other attributes
	dna.transfer_identity(O)
	O.updateappearance(icon_update=0)

	if(tr_flags & TR_KEEPSE)
		O.dna.mutation_index = dna.mutation_index
		O.dna.set_se(1, GET_INITIALIZED_MUTATION(RACEMUT))

	if(suiciding)
		O.suiciding = suiciding
	if(hellbound)
		O.hellbound = hellbound
	O.a_intent = INTENT_HARM

	//keep viruses?
	if (tr_flags & TR_KEEPVIRUS)
		O.diseases = diseases
		diseases = list()
		for(var/thing in O.diseases)
			var/datum/disease/D = thing
			D.affected_mob = O

	//keep damage?
	if (tr_flags & TR_KEEPDAMAGE)
		O.setToxLoss(getToxLoss(), 0)
		O.adjustBruteLoss(getBruteLoss(), 0)
		O.setOxyLoss(getOxyLoss(), 0)
		O.setCloneLoss(getCloneLoss(), 0)
		O.adjustFireLoss(getFireLoss(), 0)
		O.setOrganLoss(ORGAN_SLOT_BRAIN, getOrganLoss(ORGAN_SLOT_BRAIN), 0)
		O.adjustStaminaLoss(getStaminaLoss(), 0)//CIT CHANGE - makes monkey transformations inherit stamina
		O.updatehealth()
		O.radiation = radiation

	//re-add implants to new mob
	if (tr_flags & TR_KEEPIMPLANTS)
		for(var/Y in implants)
			var/obj/item/implant/IMP = Y
			IMP.implant(O, null, 1)

	//re-add organs to new mob. this order prevents moving the mind to a brain at any point
	if(tr_flags & TR_KEEPORGANS)
		for(var/X in O.internal_organs)
			var/obj/item/organ/I = X
			I.Remove(TRUE)

		if(mind)
			mind.transfer_to(O)
			var/datum/antagonist/changeling/changeling = O.mind.has_antag_datum(/datum/antagonist/changeling)
			if(changeling)
				var/obj/effect/proc_holder/changeling/humanform/HF = new /obj/effect/proc_holder/changeling/humanform(null)
				changeling.purchasedpowers += HF
				HF.action.Grant(O)

		for(var/X in internal_organs)
			var/obj/item/organ/I = X
			int_organs += I
			I.Remove(TRUE)

		for(var/X in int_organs)
			var/obj/item/organ/I = X
			I.Insert(O, 1)

	var/obj/item/bodypart/chest/torso = O.get_bodypart(BODY_ZONE_CHEST)
	if(cavity_object)
		torso.cavity_item = cavity_object //cavity item is given to the new chest
		cavity_object.forceMove(O)

	for(var/missing_zone in missing_bodyparts_zones)
		var/obj/item/bodypart/BP = O.get_bodypart(missing_zone)
		BP.drop_limb(1)
		if(!(tr_flags & TR_KEEPORGANS)) //we didn't already get rid of the organs of the newly spawned mob
			for(var/X in O.internal_organs)
				var/obj/item/organ/G = X
				if(BP.body_zone == check_zone(G.zone))
					if(mind && mind.has_antag_datum(/datum/antagonist/changeling) && istype(G, /obj/item/organ/brain))
						continue //so headless changelings don't lose their brain when transforming
					qdel(G) //we lose the organs in the missing limbs
		qdel(BP)

	//transfer mind if we didn't yet
	if(mind)
		mind.transfer_to(O)
		var/datum/antagonist/changeling/changeling = O.mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling)
			var/obj/effect/proc_holder/changeling/humanform/HF = new /obj/effect/proc_holder/changeling/humanform(null)
			changeling.purchasedpowers += HF
			HF.action.Grant(O)

	if (tr_flags & TR_DEFAULTMSG)
		to_chat(O, "<B>You are now a monkey.</B>")

	for(var/A in loc.vars)
		if(loc.vars[A] == src)
			loc.vars[A] = O

	transfer_observers_to(O)

	. = O

	qdel(src)

//////////////////////////           Humanize               //////////////////////////////
//Could probably be merged with monkeyize but other transformations got their own procs, too

/mob/living/carbon/proc/humanize(tr_flags = (TR_KEEPITEMS | TR_KEEPVIRUS | TR_DEFAULTMSG))
	if (notransform)
		return
	//Handle items on mob

	//first implants & organs
	var/list/stored_implants = list()
	var/list/int_organs = list()

	if (tr_flags & TR_KEEPIMPLANTS)
		for(var/X in implants)
			var/obj/item/implant/IMP = X
			stored_implants += IMP
			IMP.removed(src, 1, 1)

	var/list/missing_bodyparts_zones = get_missing_limbs()

	var/obj/item/cavity_object

	var/obj/item/bodypart/chest/CH = get_bodypart(BODY_ZONE_CHEST)
	if(CH.cavity_item)
		cavity_object = CH.cavity_item
		CH.cavity_item = null

	//now the rest
	if (tr_flags & TR_KEEPITEMS)
		var/Itemlist = get_equipped_items(TRUE)
		Itemlist += held_items
		for(var/obj/item/W in Itemlist)
			dropItemToGround(W, TRUE)
			if (client)
				client.screen -= W



	//Make mob invisible and spawn animation
	notransform = TRUE
	Stun(22, ignore_canstun = TRUE)
	icon = null
	cut_overlays()
	invisibility = INVISIBILITY_MAXIMUM
	new /obj/effect/temp_visual/monkeyify/humanify(loc)
	sleep(22)
	var/mob/living/carbon/human/O = new( loc )
	for(var/obj/item/C in O.loc)
		O.equip_to_appropriate_slot(C)

	dna.transfer_identity(O)
	O.updateappearance(mutcolor_update=1)

	if(findtext(O.dna.real_name, "monkey", 1, 7)) //7 == length("monkey") + 1
		O.real_name = random_unique_name(O.gender)
		O.dna.generate_unique_enzymes(O)
	else
		O.real_name = O.dna.real_name
	O.name = O.real_name

	if(tr_flags & TR_KEEPSE)
		O.dna.mutation_index = dna.mutation_index
		O.dna.set_se(0, GET_INITIALIZED_MUTATION(RACEMUT))
		O.domutcheck()

	if(suiciding)
		O.suiciding = suiciding
	if(hellbound)
		O.hellbound = hellbound

	//keep viruses?
	if (tr_flags & TR_KEEPVIRUS)
		O.diseases = diseases
		diseases = list()
		for(var/thing in O.diseases)
			var/datum/disease/D = thing
			D.affected_mob = O
		O.med_hud_set_status()

	//keep damage?
	if (tr_flags & TR_KEEPDAMAGE)
		O.setToxLoss(getToxLoss(), 0)
		O.adjustBruteLoss(getBruteLoss(), 0)
		O.setOxyLoss(getOxyLoss(), 0)
		O.setCloneLoss(getCloneLoss(), 0)
		O.adjustFireLoss(getFireLoss(), 0)
		O.setOrganLoss(ORGAN_SLOT_BRAIN, getOrganLoss(ORGAN_SLOT_BRAIN), 0)
		O.adjustStaminaLoss(getStaminaLoss(), 0)//CIT CHANGE - makes monkey transformations inherit stamina
		O.updatehealth()
		O.radiation = radiation

	//re-add implants to new mob
	if (tr_flags & TR_KEEPIMPLANTS)
		for(var/Y in implants)
			var/obj/item/implant/IMP = Y
			IMP.implant(O, null, 1)

	if(tr_flags & TR_KEEPORGANS)
		for(var/X in O.internal_organs)
			var/obj/item/organ/I = X
			I.Remove(TRUE)

		if(mind)
			mind.transfer_to(O)
			var/datum/antagonist/changeling/changeling = O.mind.has_antag_datum(/datum/antagonist/changeling)
			if(changeling)
				for(var/obj/effect/proc_holder/changeling/humanform/HF in changeling.purchasedpowers)
					changeling.purchasedpowers -= HF

		for(var/X in internal_organs)
			var/obj/item/organ/I = X
			int_organs += I
			I.Remove(TRUE)

		for(var/X in int_organs)
			var/obj/item/organ/I = X
			I.Insert(O, 1)


	var/obj/item/bodypart/chest/torso = get_bodypart(BODY_ZONE_CHEST)
	if(cavity_object)
		torso.cavity_item = cavity_object //cavity item is given to the new chest
		cavity_object.forceMove(O)

	for(var/missing_zone in missing_bodyparts_zones)
		var/obj/item/bodypart/BP = O.get_bodypart(missing_zone)
		BP.drop_limb(1)
		if(!(tr_flags & TR_KEEPORGANS)) //we didn't already get rid of the organs of the newly spawned mob
			for(var/X in O.internal_organs)
				var/obj/item/organ/G = X
				if(BP.body_zone == check_zone(G.zone))
					if(mind && mind.has_antag_datum(/datum/antagonist/changeling) && istype(G, /obj/item/organ/brain))
						continue //so headless changelings don't lose their brain when transforming
					qdel(G) //we lose the organs in the missing limbs
		qdel(BP)

	if(mind)
		mind.transfer_to(O)
		var/datum/antagonist/changeling/changeling = O.mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling)
			for(var/obj/effect/proc_holder/changeling/humanform/HF in changeling.purchasedpowers)
				changeling.purchasedpowers -= HF

	O.a_intent = INTENT_HELP
	if (tr_flags & TR_DEFAULTMSG)
		to_chat(O, "<B>You are now a human.</B>")

	transfer_observers_to(O)

	. = O

	for(var/A in loc.vars)
		if(loc.vars[A] == src)
			loc.vars[A] = O

	qdel(src)

/mob/living/carbon/human/AIize()
	if (notransform)
		return
	for(var/t in bodyparts)
		qdel(t)

	return ..()

/mob/living/carbon/AIize()
	if(notransform)
		return
	for(var/obj/item/W in src)
		dropItemToGround(W)
	regenerate_icons()
	notransform = TRUE
	Paralyze(INFINITY)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	return ..()

/mob/proc/AIize(transfer_after = TRUE)
	var/list/turf/landmark_loc = list()
	for(var/obj/effect/landmark/start/ai/sloc in GLOB.landmarks_list)
		if(locate(/mob/living/silicon/ai) in sloc.loc)
			continue
		if(sloc.primary_ai)
			LAZYCLEARLIST(landmark_loc)
			landmark_loc += sloc.loc
			break
		landmark_loc += sloc.loc
	if(!landmark_loc.len)
		to_chat(src, "Oh god sorry we can't find an unoccupied AI spawn location, so we're spawning you on top of someone.")
		for(var/obj/effect/landmark/start/ai/sloc in GLOB.landmarks_list)
			landmark_loc += sloc.loc

	if(!landmark_loc.len)
		message_admins("Could not find ai landmark for [src]. Yell at a mapper! We are spawning them at their current location.")
		landmark_loc += loc

	if(client)
		stop_sound_channel(CHANNEL_LOBBYMUSIC)

	if(!transfer_after)
		mind.active = FALSE

	. = new /mob/living/silicon/ai(pick(landmark_loc), null, src)

	qdel(src)

/mob/living/carbon/human/proc/Robotize(delete_items = 0, transfer_after = TRUE)
	if (notransform)
		return
	for(var/obj/item/W in src)
		if(delete_items)
			qdel(W)
		else
			dropItemToGround(W)
	regenerate_icons()
	notransform = TRUE
	Paralyze(INFINITY)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	for(var/t in bodyparts)
		qdel(t)

	var/mob/living/silicon/robot/R = new /mob/living/silicon/robot(loc)

	R.gender = gender
	R.invisibility = 0

	if(mind)		//TODO
		if(!transfer_after)
			mind.active = FALSE
		mind.transfer_to(R)
	else if(transfer_after)
		transfer_ckey(R)

	R.apply_pref_name("cyborg")

	if(R.mmi)
		R.mmi.name = "Man-Machine Interface: [real_name]"
		if(R.mmi.brain)
			R.mmi.brain.name = "[real_name]'s brain"
		if(R.mmi.brainmob)
			R.mmi.brainmob.real_name = real_name //the name of the brain inside the cyborg is the robotized human's name.
			R.mmi.brainmob.name = real_name

	R.job = "Cyborg"
	R.notify_ai(NEW_BORG)

	. = R
	qdel(src)

//human -> alien
/mob/living/carbon/human/proc/Alienize(mind_transfer = TRUE)
	if (notransform)
		return
	for(var/obj/item/W in src)
		dropItemToGround(W)
	regenerate_icons()
	notransform = 1
	Paralyze(INFINITY)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	for(var/t in bodyparts)
		qdel(t)

	var/alien_caste = pick("Hunter","Sentinel","Drone")
	var/mob/living/carbon/alien/humanoid/new_xeno
	switch(alien_caste)
		if("Hunter")
			new_xeno = new /mob/living/carbon/alien/humanoid/hunter(loc)
		if("Sentinel")
			new_xeno = new /mob/living/carbon/alien/humanoid/sentinel(loc)
		if("Drone")
			new_xeno = new /mob/living/carbon/alien/humanoid/drone(loc)

	new_xeno.a_intent = INTENT_HARM
	if(mind && mind_transfer)
		mind.transfer_to(new_xeno)
	else
		transfer_ckey(new_xeno)

	to_chat(new_xeno, "<B>You are now an alien.</B>")
	. = new_xeno
	qdel(src)

/mob/living/carbon/human/proc/slimeize(reproduce, mind_transfer = TRUE)
	if (notransform)
		return
	for(var/obj/item/W in src)
		dropItemToGround(W)
	regenerate_icons()
	notransform = 1
	Paralyze(INFINITY)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	for(var/t in bodyparts)
		qdel(t)

	var/mob/living/simple_animal/slime/new_slime
	if(reproduce)
		var/number = pick(14;2,3,4)	//reproduce (has a small chance of producing 3 or 4 offspring)
		var/list/babies = list()
		for(var/i=1,i<=number,i++)
			var/mob/living/simple_animal/slime/M = new/mob/living/simple_animal/slime(loc)
			M.nutrition = round(nutrition/number)
			step_away(M,src)
			babies += M
		new_slime = pick(babies)
	else
		new_slime = new /mob/living/simple_animal/slime(loc)
	new_slime.a_intent = INTENT_HARM
	if(mind && mind_transfer)
		mind.transfer_to(new_slime)
	else
		transfer_ckey(new_slime)

	to_chat(new_slime, "<B>You are now a slime. Skreee!</B>")
	. = new_slime
	qdel(src)

/mob/proc/become_overmind(starting_points = 60, mind_transfer = FALSE)
	var/mob/camera/blob/B = new /mob/camera/blob(get_turf(src), starting_points)
	if(mind && mind_transfer)
		mind.transfer_to(B)
	else
		transfer_ckey(B)
	. = B
	qdel(src)


/mob/living/carbon/human/proc/corgize(mind_transfer = TRUE)
	if (notransform)
		return
	for(var/obj/item/W in src)
		dropItemToGround(W)
	regenerate_icons()
	notransform = TRUE
	Paralyze(INFINITY)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	for(var/t in bodyparts)	//this really should not be necessary
		qdel(t)

	var/mob/living/simple_animal/pet/dog/corgi/new_corgi = new /mob/living/simple_animal/pet/dog/corgi (loc)
	new_corgi.a_intent = INTENT_HARM
	if(mind && mind_transfer)
		mind.transfer_to(new_corgi)
	else
		transfer_ckey(new_corgi)

	to_chat(new_corgi, "<B>You are now a Corgi. Yap Yap!</B>")
	. = new_corgi
	qdel(src)

/mob/living/carbon/proc/gorillize(mind_transfer = TRUE)
	if(notransform)
		return

	SSblackbox.record_feedback("amount", "gorillas_created", 1)

	var/Itemlist = get_equipped_items(TRUE)
	Itemlist += held_items
	for(var/obj/item/W in Itemlist)
		dropItemToGround(W, TRUE)

	regenerate_icons()
	notransform = TRUE
	Paralyze(INFINITY)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	var/mob/living/simple_animal/hostile/gorilla/new_gorilla = new (get_turf(src))
	new_gorilla.a_intent = INTENT_HARM
	if(mind && mind_transfer)
		mind.transfer_to(new_gorilla)
	else
		transfer_ckey(new_gorilla)
	to_chat(new_gorilla, "<B>You are now a gorilla. Ooga ooga!</B>")
	. = new_gorilla
	qdel(src)

/mob/living/carbon/human/Animalize(mind_transfer = TRUE)

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") as null|anything in mobtypes
	if(!mobpath)
		return
	if(mind)
		mind_transfer = alert("Want to transfer their mind into the new mob", "Mind Transfer", "Yes", "No") == "Yes" ? TRUE : FALSE

	if(notransform)
		return
	for(var/obj/item/W in src)
		dropItemToGround(W)

	regenerate_icons()
	notransform = TRUE
	Paralyze(INFINITY)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	for(var/t in bodyparts)
		qdel(t)

	var/mob/new_mob = new mobpath(src.loc)
	if(mind && mind_transfer)
		mind.transfer_to(new_mob)
	else
		transfer_ckey(new_mob)
	new_mob.a_intent = INTENT_HARM


	to_chat(new_mob, "You suddenly feel more... animalistic.")
	. = new_mob
	qdel(src)

/mob/proc/Animalize(mind_transfer = TRUE)

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") as null|anything in mobtypes
	if(!mobpath)
		return
	if(mind)
		mind_transfer = alert("Want to transfer their mind into the new mob", "Mind Transfer", "Yes", "No") == "Yes" ? TRUE : FALSE

	var/mob/new_mob = new mobpath(src.loc)

	if(mind && mind_transfer)
		mind.transfer_to(new_mob)
	else
		transfer_ckey(new_mob)
	new_mob.a_intent = INTENT_HARM
	to_chat(new_mob, "You feel more... animalistic")

	. = new_mob
	qdel(src)
