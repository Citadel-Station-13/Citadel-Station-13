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
	taste_description = "If affection had a taste, this would be it."

/datum/reagent/fermi/on_mob_life(mob/living/carbon/M)
	//current_cycle++
	holder.remove_reagent(src.id, metabolization_rate / M.metabolism_efficiency, FALSE) //fermi reagents stay longer if you have a better metabolism
	return ..()

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
	taste_description = "."
	color = "#60A584" // rgb: 96, 0, 255
	overdose_threshold = 15
	addiction_threshold = 20
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	addiction_stage2_end = 30
	addiction_stage3_end = 40
	addiction_stage4_end = 43 //Incase it's too long
	var/turf/open/location_created = null
	var/turf/open/location_return = null
	var/addictCyc1 = 1
	var/addictCyc2 = 1
	var/addictCyc3 = 1
	var/addictCyc4 = 1
	var/mob/living/fermi_Tclone = null
	var/teleBool = FALSE
	mob/living/carbon/purgeBody


/*
/datum/reagent/fermi/eigenstate/oew()
	. = ..() //Needed!
	location_created = get_turf(src) //Sets up coordinate of where it was created
	message_admins("Attempting to get creation location from on_new() [location_created]")
	//..()s
*/
/datum/reagent/fermi/eigenstate/on_new()
//obj/item/reagent/fermi/eigenstate/Initialize()
//datum/reagent/fermi/eigenstate/Initialize()
	. = ..() //Needed!
	//if(holder && holder.my_atom)
	location_created = get_turf(loc) //Sets up coordinate of where it was created
	message_admins("Attempting to get creation location from init() [location_created]")
	//..()


/datum/reagent/fermi/eigenstate/on_mob_life(mob/living/M) //Teleports to chemistry!
	switch(current_cycle)
		if(0)
			location_return = get_turf(M)	//sets up return point
			to_chat(M, "<span class='userdanger'>You feel your wavefunction split!</span>")
			do_sparks(5,FALSE,M)
			do_teleport(M, location_created, 0, asoundin = 'sound/effects/phasein.ogg')
			//M.forceMove(location_created) //Teleports to creation location
			do_sparks(5,FALSE,M)
	if(prob(20))
		do_sparks(5,FALSE,M)
	message_admins("eigenstate state: [current_cycle]")
	..()

/datum/reagent/fermi/eigenstate/on_mob_delete(mob/living/M) //returns back to original location
	do_sparks(5,FALSE,src)
	to_chat(M, "<span class='userdanger'>You feel your wavefunction collapse!</span>")
	do_teleport(M, location_return, 0, asoundin = 'sound/effects/phasein.ogg') //Teleports home
	do_sparks(5,FALSE,src)
	..()

/datum/reagent/fermi/eigenstate/overdose_start(mob/living/M) //Overdose, makes you teleport randomly
	. = ..()
	to_chat(M, "<span class='userdanger'>Oh god, you feel like your wavefunction is about to tear.</span>")
	M.Jitter(10)

/datum/reagent/fermi/eigenstate/overdose_process(mob/living/M) //Overdose, makes you teleport randomly
	do_sparks(5,FALSE,src)
	do_teleport(M, get_turf(M), 10, asoundin = 'sound/effects/phasein.ogg')
	do_sparks(5,FALSE,src)
	holder.remove_reagent("eigenstate",0.5)//So you're not stuck for 10 minutes teleporting
	..() //loop function


/datum/reagent/fermi/eigenstate/addiction_act_stage1(mob/living/M) //Welcome to Fermis' wild ride.
	switch(src.addictCyc1)
		if(1)
			to_chat(M, "<span class='userdanger'>Your wavefunction feels like it's been ripped in half. You feel empty inside.</span>")
			M.Jitter(10)
	M.nutrition = M.nutrition - (M.nutrition/15)
	src.addictCyc1++
	..()

/datum/reagent/fermi/eigenstate/addiction_act_stage2(mob/living/M)
	switch(src.addictCyc2)
		if(1)
			to_chat(M, "<span class='userdanger'>You start to convlse violently as you feel your consciousness split and merge across realities as your possessions fly wildy off your body.</span>")
			M.Jitter(50)
			M.Knockdown(100)
			M.Stun(40)

	var/items = M.get_contents()
	var/obj/item/I = pick(items)
	M.dropItemToGround(I, TRUE)
	do_sparks(5,FALSE,I)
	do_teleport(I, get_turf(I), 5, no_effects=TRUE);
	do_sparks(5,FALSE,I)
	src.addictCyc2++
	..()

/datum/reagent/fermi/eigenstate/addiction_act_stage3(mob/living/M)//Pulls multiple copies of the character from alternative realities while teleporting them around!

	//Clone function - spawns a clone then deletes it - simulates multiple copies of the player teleporting in
	switch(src.addictCyc3)
		if(0)
			M.Jitter(100)
			to_chat(M, "<span class='userdanger'>Your eigenstate starts to rip apart, causing a localised collapsed field as you're ripped from alternative universes, trapped around the densisty of the eigenstate event horizon.</span>")
		if(1)
			var/typepath = M.type
			fermi_Tclone = new typepath(M.loc)
			var/mob/living/carbon/C = fermi_Tclone
			fermi_Tclone.appearance = M.appearance
			C.real_name = M.real_name
			M.visible_message("[M] collapses in from an alternative reality!")
			message_admins("Fermi T Clone: [fermi_Tclone]")
			do_teleport(C, get_turf(C), 2, no_effects=TRUE) //teleports clone so it's hard to find the real one!
			do_sparks(5,FALSE,C)
			C.emote("spin")
			M.emote("spin")
			M.emote("me",1,"flashes into reality suddenly, gasping as they gaze around in a bewildered and highly confused fashion!",TRUE)
			C.emote("me",1,"[pick("says", "cries", "mewls", "giggles", "shouts", "screams", "gasps", "moans", "whispers", "announces")], \"[pick("Bugger me, whats all this then?", "Hot damn, where is this?", "sacre bleu! O� suis-je?!", "Yee haw!", "WHAT IS HAPPENING?!", "Picnic!", "Das ist nicht deutschland. Das ist nicht akzeptabel!!!", "Ciekawe co na obiad?", "You fool! You took too much eigenstasium! You've doomed us all!", "Watashi no nihon'noanime no yona monodesu!", "What...what's with these teleports? It's like one of my Japanese animes...!", "Ik stond op het punt om mehki op tafel te zetten, en nu, waar ben ik?", "This must be the will of Stein's gate.", "Detta �r sista g�ngen jag dricker beepsky smash.", "Now neither of us will be virgins!")]\"")
			message_admins("Fermi T Clone: [fermi_Tclone] teleport attempt")
		if(2)
			var/mob/living/carbon/C = fermi_Tclone
			do_sparks(5,FALSE,C)
			qdel(C) //Deletes CLONE, or at least I hope it is.
			message_admins("Fermi T Clone: [fermi_Tclone] deletion attempt")
			M.visible_message("[M] is snapped across to a different alternative reality!")
			src.addictCyc3 = 0 //counter
			fermi_Tclone = null
	src.addictCyc3++
	message_admins("[src.addictCyc3]")
	do_teleport(M, get_turf(M), 2, no_effects=TRUE) //Teleports player randomly
	do_sparks(5,FALSE,M)
	..() //loop function

/datum/reagent/fermi/eigenstate/addiction_act_stage4(mob/living/M) //Thanks for riding Fermis' wild ride. Mild jitter and player buggery.
	switch(src.addictCyc4)
		if(1)
			do_sparks(5,FALSE,M)
			do_teleport(M, get_turf(M), 2, no_effects=TRUE) //teleports clone so it's hard to find the real one!
			do_sparks(5,FALSE,M)
			M.Sleeping(50, 0)
			M.Jitter(50)
			M.Knockdown(0)
			to_chat(M, "<span class='userdanger'>You feel your eigenstate settle, snapping an alternative version of yourself into reality. All your previous memories are lost and replaced with the alternative version of yourself. This version of you feels more [pick("affectionate", "happy", "lusty", "radical", "shy", "ambitious", "frank", "voracious", "sensible", "witty")] than your previous self, sent to god knows what universe.</span>")
			M.emote("me",1,"flashes into reality suddenly, gasping as they gaze around in a bewildered and highly confused fashion!",TRUE)
			M.reagents.remove_all_type(/datum/reagent/toxin, 5*REM, 0, 1)
			for(var/i in M.mood_events)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, i.id)
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "Alternative dimension", /datum/mood_event/eigenstate)


	if(prob(20))
		do_sparks(5,FALSE,M)
	src.addictCyc4++

	..()
	. = 1

///datum/reagent/fermi/eigenstate/overheat_explode(mob/living/M)
//	return

//eigenstate END

//Clone serum #chemClone
/datum/reagent/fermi/SDGF //vars, mostly only care about keeping track if there's a player in the clone or not.
	name = "synthetic-derived growth factor"
	id = "SDGF"
	description = "A rapidly diving mass of Embryonic stem cells. These cells are missing a nucleus and quickly replicate a host’s DNA before growing to form an almost perfect clone of the host. In some cases neural replication takes longer, though the underlying reason underneath has yet to be determined."
	color = "#60A584" // rgb: 96, 0, 255
	var/playerClone = FALSE
	var/unitCheck = FALSE
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	//var/datum/status_effect/chem/SDGF/candidates/candies
	var/list/candies = list()
	//var/polling = FALSE
	var/list/result = list()
	var/list/group = null

	//var/fClone_current_controller = OWNER
	//var/mob/living/split_personality/clone//there's two so they can swap without overwriting
	//var/mob/living/split_personality/owner
	//var/mob/living/carbon/SM
/*
/datum/reagent/fermi/SDGF/New()
	candidates = pollGhostCandidates("Do you want to play as a clone and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you. ", "FermiClone", null, ROLE_SENTIENCE, 300) // see poll_ignore.dm, should allow admins to ban greifers or bullies
	message_admins("Attempting to poll")
^^^breaks everything
*/
/datum/reagent/fermi/proc/sepPoll()
	var/list/procCandies = list()
	procCandies = pollGhostCandidates("Do you want to play as a clone and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you. ", "FermiClone", null, ROLE_SENTIENCE, 20) // see poll_ignore.dm, should allow admins to ban greifers or bullies
	return procCandies

	/*if(1) //I'm not sure how pollCanditdates works, so I did this. Gives a chance for people to say yes.
		M.apply_status_effect(/datum/status_effect/chem/SDGF/candidates)
		/datum/status_effect/chem/SDGF/candidates/candies = new /datum/status_effect/chem/SDGF/candidates
		///datum/status_effect/chem/SDGF/candidates/candies = M.apply_status_effect(/datum/status_effect/chem/SDGF/candidates)
		//candies = pollGhostCandidates("Do you want to play as a clone of [M.name] and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you. ", "FermiClone", null, ROLE_SENTIENCE, 300) // see poll_ignore.dm, should allow admins to ban greifers or bullies
		message_admins("Attempting to poll")*/

/datum/reagent/fermi/SDGF/on_mob_life(mob/living/carbon/M) //Clones user, then puts a ghost in them! If that fails, makes a braindead clone.
	//Setup clone
	switch(current_cycle)
		if(1)
			for(var/mob/dead/observer/G in GLOB.player_list)
				group += G
			for(var/m in group)
				var/mob/W = m
			message_admins("Attempting to poll")
			showCandidatePollWindow(M, 190, "Do you want to play as a clone of [M.name] and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you.", result, null, current_cycle, TRUE)
		if(19)
			for(var/mob/W in result)
				if(!W.key || !W.client)
					result -= W
			candies = result
		if(20 to INFINITY)
			message_admins("Number of candidates [LAZYLEN(candies)]")
			if(LAZYLEN(candies) && src.playerClone == FALSE) //If there's candidates, clone the person and put them in there!
				message_admins("Candidate found!")
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
				var/mob/dead/observer/C = pick(candies)
				SM.key = C.key
				SM.mind.enslave_mind_to_creator(M)

				if(M.getorganslot(ORGAN_SLOT_ZOMBIE))//sure, it "treats" it, but "you've" still got it. Doesn't always work as well; needs a ghost.
					var/obj/item/organ/zombie_infection/ZI = M.getorganslot(ORGAN_SLOT_ZOMBIE)
					ZI.Remove(M)
					ZI.Insert(SM)

				//SM.sentience_act()
				to_chat(SM, "<span class='warning'>You feel a strange sensation building in your mind as you realise there's two of you, before you get a chance to think about it, you suddenly split from your old body, and find yourself face to face with yourself, or rather, your original self.</span>")
				to_chat(SM, "<span class='userdanger'>While you find your newfound existence strange, you share the same memories as [M.real_name]. [pick("However, You find yourself indifferent to the goals you previously had, and take more interest in your newfound independence, but still have an indescribable care for the safety of your original", "Your mind has not deviated from the tasks you set out to do, and now that there's two of you the tasks should be much easier.")]</span>")
				to_chat(M, "<span class='notice'>You feel a strange sensation building in your mind as you realise there's two of you, before you get a chance to think about it, you suddenly split from your old body, and find yourself face to face with yourself.</span>")
				M.visible_message("[M] suddenly shudders, and splits into two identical twins!")
				SM.copy_known_languages_from(M, FALSE)
				playerClone =  TRUE

				M.next_move_modifier = 1
				M.nutrition = 150
				//BALANCE: should I make them a pacifist, or give them some cellular damage or weaknesses?

				//after_success(user, SM)
				//qdel(src)

			else //No candidates leads to two outcomes; if there's already a braincless clone, it heals the user, as well as being a rare souce of clone healing (thematic!).
				message_admins("Failed to find clone Candidate")
				src.unitCheck = TRUE
				if(M.has_status_effect(/datum/status_effect/chem/SGDF)) // Heal the user if they went to all this trouble to make it and can't get a clone, the poor fellow.
					to_chat(M, "<span class='notice'>The cells fail to catalyse around a nucleation event, instead merging with your cells.</span>") //This stuff is hard enough to make to rob a user of some benefit. Shouldn't replace Rezadone as it requires the user to not only risk making a player controlled clone, but also requires them to have split in two (which also requires 30u of SGDF).
					M.adjustCloneLoss(-2, 0)
					M.adjustBruteLoss(-2, 0)
					M.adjustFireLoss(-2, 0)
					M.heal_bodypart_damage(1,1)
					M.remove_trait(TRAIT_DISFIGURED, TRAIT_GENERIC)
				else //If there's no ghosts, but they've made a large amount, then proceed to make flavourful clone, where you become fat and useless until you split.
					switch(current_cycle)
						if(10)
							to_chat(M, "<span class='notice'>You feel the synethic cells rest uncomfortably within your body as they start to pulse and grow rapidly.</span>")
						if(11 to 19)
							M.nutrition = M.nutrition + (M.nutrition/10)
						if(20)
							to_chat(M, "<span class='notice'>You feel the synethic cells grow and expand within yourself, bloating your body outwards.</span>")
						if(21 to 39)
							M.nutrition = M.nutrition + (M.nutrition/5)
						if(40)
							to_chat(M, "<span class='notice'>The synthetic cells begin to merge with your body, it feels like your body is made of a viscous water, making your movements difficult.</span>")
							M.next_move_modifier = 4//If this makes you fast then please fix it, it should make you slow!!
							//candidates = pollGhostCandidates("Do you want to play as a clone of [M.name] and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you. ", "FermiClone", null, ROLE_SENTIENCE, 300) // see poll_ignore.dm, should allow admins to ban greifers or bullies
						if(41 to 69)
							M.nutrition = M.nutrition + (M.nutrition/2)
						if(70)
							to_chat(M, "<span class='notice'>The cells begin to precipitate outwards of your body, you feel like you'll split soon...</span>")
							if (M.nutrition < 20000)
								M.nutrition = 20000 //https://www.youtube.com/watch?v=Bj_YLenOlZI
						if(76)//Upon splitting, you get really hungry and are capable again. Deletes the chem after you're done.
							M.nutrition = 15//YOU BEST BE EATTING AFTER THIS YOU CUTIE
							M.next_move_modifier = 1
							to_chat(M, "<span class='notice'>Your body splits away from the cell clone of yourself, leaving you with a drained and hollow feeling inside.</span>")
							M.apply_status_effect(/datum/status_effect/chem/SGDF)
						if(77 to INFINITY)
							holder.remove_reagent("SGDF", 1)//removes SGDF on completion.
							message_admins("Purging SGDF [volume]")
					message_admins("Growth nucleation occuring (SDGF), step [current_cycle] of 77")


	..()

/datum/reagent/fermi/SDGF/on_mob_delete(mob/living/M) //When the chem is removed, a few things can happen.
	if (playerClone == TRUE)//If the player made a clone with it, then thats all they get.
		playerClone = FALSE
		return
	if (M.next_move_modifier == 4 && !M.has_status_effect(/datum/status_effect/chem/SGDF))//checks if they're ingested over 20u of the stuff, but fell short of the required 30u to make a clone.
		to_chat(M, "<span class='notice'>You feel the cells begin to merge with your body, unable to reach nucleation, they instead merge with your body, healing any wounds.</span>")
		M.adjustCloneLoss(-10, 0) //I don't want to make Rezadone obsolete.
		M.adjustBruteLoss(-25, 0)// Note that this takes a long time to apply and makes you fat and useless when it's in you, I don't think this small burst of healing will be useful considering how long it takes to get there.
		M.adjustFireLoss(-25, 0)
		M.blood_volume += 250
		M.heal_bodypart_damage(1,1)
		M.next_move_modifier = 1
		if (M.nutrition < 1500)
			M.nutrition += 250
	else if (src.unitCheck == TRUE && !M.has_status_effect(/datum/status_effect/chem/SGDF))// If they're ingested a little bit (10u minimum), then give them a little healing.
		src.unitCheck = FALSE
		to_chat(M, "<span class='notice'>the cells fail to hold enough mass to generate a clone, instead diffusing into your system instead. you can fee</span>")
		M.adjustBruteLoss(-10, 0)
		M.adjustFireLoss(-10, 0)
		M.blood_volume += 100
		if (M.nutrition < 1500)
			M.nutrition += 500

/datum/reagent/fermi/SDZF
	name = "synthetic-derived zombie factor"
	id = "SDZF"
	description = "A horribly peverse mass of Embryonic stem cells made real by the hands of a failed chemist. This message should never appear, how did you manage to get a hold of this?"
	color = "#60A584" // rgb: 96, 0, 255
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	var/fermi_Zombie

/datum/reagent/fermi/SDZF/on_mob_life(mob/living/carbon/M) //If you're bad at fermichem, turns your clone into a zombie instead.
	message_admins("SGZF ingested")
	switch(current_cycle)//Pretends to be normal
		if(10)
			to_chat(M, "<span class='notice'>You feel the synethic cells rest uncomfortably within your body as they start to pulse and grow rapidly.</span>")
		if(11 to 19)
			M.nutrition = M.nutrition + (M.nutrition/10)
		if(20)
			to_chat(M, "<span class='notice'>You feel the synethic cells grow and expand within yourself, bloating your body outwards.</span>")
		if(21 to 39)
			M.nutrition = M.nutrition + (M.nutrition/5)
		if(40)
			to_chat(M, "<span class='notice'>The synethic cells begin to merge with your body, it feels like your body is made of a viscous water, making your movements difficult.</span>")
			M.next_move_modifier = 4//If this makes you fast then please fix it, it should make you slow!!
		if(41 to 63)
			M.nutrition = M.nutrition + (M.nutrition/2)
		if(64)
			to_chat(M, "<span class='notice'>The cells begin to precipitate outwards of your body, but... something is wrong, the sythetic cells are beginnning to rot...</span>")
			if (M.nutrition < 20000)
				M.nutrition = 20000 //https://www.youtube.com/watch?v=Bj_YLenOlZI
		if(65 to 75)
			M.adjustToxLoss(1, 0)// the warning!
		if(76)
			if (!holder.has_reagent("pen_acid"))//Counterplay is pent.)
				message_admins("Zombie spawned at [M.loc]")
				M.nutrition -= 18500//YOU BEST BE RUNNING AWAY AFTER THIS YOU BADDIE
				M.next_move_modifier = 1
				to_chat(M, "<span class='warning'>Your body splits away from the cell clone of yourself, your attempted clone birthing itself violently from you as it begins to shamble around, a terrifying abomination of science.</span>")
				M.visible_message("[M] suddenly shudders, and splits into a funky smelling copy of themselves!")
				M.emote("scream")
				M.adjustToxLoss(30, 0)
				//fermi_Zombie = new typepath(M.loc)
				var/mob/living/simple_animal/hostile/zombie/ZI = new(get_turf(M.loc))
				ZI.damage_coeff = list(BRUTE = ((1 / volume)**0.25) , BURN = ((1 / volume)**0.1), TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
				ZI.real_name = M.real_name//Give your offspring a big old kiss.
				ZI.name = M.real_name
				//ZI.updateappearance(mutcolor_update=1)
				holder.remove_reagent("SGZF", 50)
			else
				to_chat(M, "<span class='notice'>The pentetic acid seems to have stopped the decay for now, clumping up the cells into a horrifying tumour.</span>")
		if(77 to INFINITY)//purges chemical fast, producing a "slime"  for each one. Said slime is weak to fire.
			M.nutrition -= 100
			var/mob/living/simple_animal/slime/S = new(get_turf(M.loc),"grey")
			S.damage_coeff = list(BRUTE = ((1 / volume)**0.1) , BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
			S.name = "Living teratoma"
			S.real_name = "Living teratoma"
			//S.updateappearance(mutcolor_update=1)
			holder.remove_reagent("SGZF", 50)
			M.adjustToxLoss(10, 0)
			to_chat(M, "<span class='warning'>A large glob of the tumour suddenly splits itself from your body. You feel grossed out and slimey...</span>")
	message_admins("Growth nucleation occuring (SDGF), step [current_cycle] of 20")
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
/*
//Nanite removal
/datum/reagent/fermi/naninte_b_gone
	name = "Naninte bain"
	id = "naninte_b_gone"
	description = "A rather simple toxin to small nano machines that will kill them off at a rapid rate well in system."
	color = "#5a7267" // rgb: 90, 114, 103
	overdose_threshold = 25

/datum/reagent/fermi/naninte_b_gone/on_mob_life(mob/living/carbon/C)
	if(C./datum/component/nanites)
		regen_rate = -5.0
	else
		return

/datum/reagent/fermi/naninte_b_gone/overdose_start(mob/living/carbon/C)
	if(C./datum/component/nanites)
		regen_rate = -7.5
	else
		return
*/
