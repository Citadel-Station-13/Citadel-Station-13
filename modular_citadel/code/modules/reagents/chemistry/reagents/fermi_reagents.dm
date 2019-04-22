//Fermichem!!
//Fun chems for all the family

//MCchem
//BE PE chemical
//Angel/astral chemical
//And tips their hat
//Naninte chem

/datum/reagent/fermi
	name = "Fermi"
	id = "fermi"
	taste_description = "If a petpat had a taste, this would be it."

/datum/reagent/fermi/on_mob_life(mob/living/carbon/M)
	current_cycle++
	holder.remove_reagent(src.id, metabolization_rate / M.metabolism_efficiency) //fermi reagents stay longer if you have a better metabolism

/datum/reagent/fermi/overdose_start(mob/living/carbon/M)
	current_cycle++

//eigenstate Chem
//Teleports you to chemistry and back
//OD teleports you randomly around the Station
//Addiction send you on a wild ride and replaces you with an alternative reality version of yourself.

/datum/reagent/fermi/eigenstate
	name = "Eigenstasium"
	id = "eigenstate"
	description = "A strange mixture formed from a controlled reaction of bluespace with plasma, that causes localised eigenstate fluxuations within the patient"
	color = "#60A584" // rgb: 96, 0, 255
	overdose_threshold = 20
	addiction_threshold = 30
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	addiction_stage2_end = 20
	addiction_stage3_end = 22
	addiction_stage4_end = 24 //Incase it's too long
	var/turf/open/location_created = null
	var/turf/open/location_return = null
	var/addictCyc3 = 1
	var/mob/living/fermi_Tclone = null
	var/teleBool = FALSE


///obj/item/reagent/fermi/eigenstate/Initialize()
/datum/reagent/fermi/eigenstate/on_new()
	. = ..() //Needed!
	location_created = get_turf(src) //Sets up coordinate of where it was created
	..()

/datum/reagent/fermi/eigenstate/New()
	. = ..() //Needed!
	location_created = get_turf(src) //Sets up coordinate of where it was created
	..()


/datum/reagent/fermi/eigenstate/on_mob_life(mob/living/carbon/M) //Teleports to chemistry!
	if (teleBool == TRUE)
		do_sparks(5,FALSE,M)
	else
		location_return = get_turf(src)	//sets up return point
		to_chat(M, "<span class='userdanger'>You feel your wavefunction split!</span>")
		do_sparks(5,FALSE,M)
		M.forceMove(location_created) //Teleports to creation location
		do_sparks(5,FALSE,M)
		teleBool = TRUE
	..()

/datum/reagent/fermi/eigenstate/on_mob_delete(mob/living/M) //returns back to original location
	do_sparks(5,FALSE,src)
	to_chat(M, "<span class='userdanger'>You feel your wavefunction collapse!</span>")
	M.forceMove(location_return) //Teleports home
	do_sparks(5,FALSE,src)
	teleBool = FALSE
	..()

/datum/reagent/fermi/eigenstate/overdose_start(mob/living/M) //Overdose, makes you teleport randomly
	. = ..()
	//switch(current_cycle)
	//	if(1)
	to_chat(M, "<span class='userdanger'>Oh god, you feel like your wavefunction is about to hurl.</span>")
	M.Jitter(10)

	//if(3 to INFINITY)
	do_sparks(5,FALSE,src)
	do_teleport(src, get_turf(src), 50, asoundin = 'sound/effects/phasein.ogg')
	do_sparks(5,FALSE,src)
	//M.reagents.remove_reagent("eigenstate",1)//So you're not stuck for 10 minutes teleporting
	..()


	//..() //loop function


/datum/reagent/fermi/eigenstate/addiction_act_stage1(mob/living/M) //Welcome to Fermis' wild ride.
	to_chat(M, "<span class='userdanger'>Your wavefunction feels like it's been ripped in half. You feel empty inside.</span>")
	M.Jitter(10)
	M.nutrition = M.nutrition - (M.nutrition/10)
	..()

/datum/reagent/fermi/eigenstate/addiction_act_stage2(mob/living/M)
	to_chat(M, "<span class='userdanger'>You start to convlse violently as you feel your consciousness split and merge across realities as your possessions fly wildy off your body.</span>")
	M.Jitter(50)
	M.AdjustKnockdown(-40, 0)
	for(var/item in M.get_contents())
		var/obj/item/I = item
		M.dropItemToGround(I, TRUE)
		do_teleport(I, get_turf(I), 5, no_effects=TRUE);
	//..()

/datum/reagent/fermi/eigenstate/addiction_act_stage3(mob/living/M)//Pulls multiple copies of the character from alternative realities while teleporting them around!
	M.Jitter(100)
	M.AdjustKnockdown(-40, 0)
	to_chat(M, "<span class='userdanger'>Your eigenstate starts to rip apart, causing a localised collapsed field as you're ripped from alternative universes, trapped around the densisty of the eigenstate event horizon.</span>")

	//Clone function - spawns a clone then deletes it - simulates multiple copies of the player teleporting in
	switch(src.addictCyc3)
		if(1)
			var/typepath = M.type
			fermi_Tclone = new typepath(M.loc)
			//var/mob/living/carbon/O = M
			//var/mob/living/carbon/C = fermi_Tclone
			fermi_Tclone.appearance = M.appearance

			//Incase Kevin breaks my code:
			//if(istype(C) && istype(O))
			//	C.real_name = O.real_name
			//	O.dna.transfer_identity(C)
			//	C.updateappearance(mutcolor_update=1)

			M.visible_message("[M] collapses in from an alternative reality!")
			message_admins("Fermi T Clone: [fermi_Tclone]")
		if(2)
			do_teleport(fermi_Tclone, get_turf(fermi_Tclone), 3, no_effects=TRUE) //teleports clone so it's hard to find the real one!
		if(3)
			qdel(fermi_Tclone) //Deletes CLONE, or at least I hope it is.
			M.visible_message("[M] is snapped across to a different alternative reality!")
			src.addictCyc3 = 1 //counter
			fermi_Tclone = null

	do_teleport(src, get_turf(src), 3, no_effects=TRUE) //Teleports player randomly
	..() //loop function

/datum/reagent/fermi/eigenstate/addiction_act_stage4(mob/living/M) //Thanks for riding Fermis' wild ride. Mild jitter and player buggery.
	M.Jitter(50)
	M.AdjustKnockdown(0, 0)
	to_chat(M, "<span class='userdanger'>You feel your eigenstate settle, snapping an alternative version of yourself into reality. All your previous memories are lost and replaced with the alternative version of yourself. This version of you feels more [pick("affectionate", "happy", "lusty", "radical", "shy", "ambitious", "frank", "voracious", "sensible", "witty")] than your previous self, sent to god knows what universe.</span>")
	M.emote("me",1,"gasps and gazes around in a bewildered and highly confused fashion!",TRUE)
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "Alternative dimension", /datum/mood_event/eigenstate)
	//..()

///datum/reagent/fermi/eigenstate/overheat_explode(mob/living/M)
//	return

//eigenstate END

//Clone serum #chemClone
/datum/reagent/fermi/SDGF
	name = "synthetic-derived growth factor"
	id = "SDGF"
	description = "A rapidly diving mass of Embryonic stem cells. These cells are missing a nucleus and quickly replicate a host’s DNA before growing to form an almost perfect clone of the host. In some cases neural replication takes longer, though the underlying reason underneath has yet to be determined."
	color = "#60A584" // rgb: 96, 0, 255
	//var/fClone_current_controller = OWNER
	var/mob/living/split_personality/clone//there's two so they can swap without overwriting
	var/mob/living/split_personality/owner
	//var/mob/living/carbon/SM

/datum/reagent/fermi/SGDF/on_mob_life(mob/living/carbon/M) //Clones user, then puts a ghost in them! If that fails, makes a braindead clone.
	//Setup clone


	var/list/candidates = pollCandidatesForMob("Do you want to play as a clone of [M.name] and do you agree to respect their character and act in a similar manner to them? ", ROLE_SENTIENCE, null, ROLE_SENTIENCE, 50, M, POLL_IGNORE_SENTIENCE_POTION) // see poll_ignore.dm, should allow admins to ban greifers or bullies
	if(LAZYLEN(candidates))

		//var/typepath = owner.type
		//clone = new typepath(owner.loc)
		var/typepath = M.type
		var/mob/living/carbon/fermi_Gclone = new typepath(M.loc)
		//var/mob/living/carbon/SM = owner
		//var/mob/living/carbon/M = M
		var/mob/living/carbon/SM = fermi_Gclone
		if(istype(SM) && istype(M))
			SM.real_name = M.real_name
			M.dna.transfer_identity(SM)
			SM.updateappearance(mutcolor_update=1)

		var/mob/dead/observer/C = pick(candidates)
		SM.key = C.key
		SM.mind.enslave_mind_to_creator(M)
		//SM.sentience_act()
		to_chat(SM, "<span class='warning'>You feel a strange sensation building in your mind as you realise there's two of you, before you get a chance to think about it, you suddenly split from your old body, and find yourself face to face with yourself, or rather, your original self.</span>")
		to_chat(SM, "<span class='userdanger'>While you find your newfound existence strange, you share the same memories as [M.real_name]. [pick("However, You find yourself indifferent to the goals you previously had, and take more interest in your newfound independence, but still have an indescribable care for the safety of your original", "Your mind has not deviated from the tasks you set out to do, and now that there's two of you the tasks should be much easier.")]</span>")
		to_chat(M, "<span class='notice'>You feel a strange sensation building in your mind as you realise there's two of you, before you get a chance to think about it, you suddenly split from your old body, and find yourself face to face with yourself.</span>")
		M.visible_message("[M] suddenly shudders, and splits into two identical twins!")
		SM.copy_known_languages_from(M, FALSE)
		//after_success(user, SM)
		//qdel(src)
	else
		if(20)
			M.apply_status_effect(/datum/status_effect/chem/SGDF)

	..()


//Breast englargement
/datum/reagent/fermi/BElarger
	name = "Sucubus Draft"
	id = "BEenlager"
	description = "A volatile collodial mixture derived from milk that encourages mammary production via a potent estrogen mix."
	color = "#60A584" // rgb: 96, 0, 255
	overdose_threshold = 12

/datum/reagent/fermi/BElarger/overdose_start(mob/living/M) //Turns you into a female if male and ODing
	if(M.gender == MALE)
		M.gender = FEMALE
		M.visible_message("<span class='boldnotice'>[M] suddenly looks more feminine!</span>", "<span class='boldwarning'>You suddenly feel more feminine!</span>")

	if(M.gender == FEMALE)
		M.gender = MALE
		M.visible_message("<span class='boldnotice'>[M] suddenly looks more masculine!</span>", "<span class='boldwarning'>You suddenly feel more masculine!</span>")
