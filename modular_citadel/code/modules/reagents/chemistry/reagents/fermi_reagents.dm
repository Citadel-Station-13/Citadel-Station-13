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

///datum/reagent/fermi/on_mob_life(mob/living/carbon/M)
	//current_cycle++
	//holder.remove_reagent(src.id, metabolization_rate / M.metabolism_efficiency, FALSE) //fermi reagents stay longer if you have a better metabolism
	//return ..()

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
	taste_description = "wiggly"
	color = "#5020H4" // rgb: 50, 20, 255
	overdose_threshold = 15
	addiction_threshold = 20
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	addiction_stage2_end = 30
	addiction_stage3_end = 40
	addiction_stage4_end = 43 //Incase it's too long
	var/location_created
	var/turf/open/location_return = null
	var/addictCyc1 = 1
	var/addictCyc2 = 1
	var/addictCyc3 = 1
	var/addictCyc4 = 1
	var/mob/living/fermi_Tclone = null
	var/teleBool = FALSE
	mob/living/carbon/purgeBody

/*
/datum/reagent/fermi/eigenstate/on_new()
	location_created = get_turf(loc) //Sets up coordinate of where it was created
	message_admins("Attempting to get creation location from init() [location_created]")
	//..()
*/
//Main functions
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
	holder.remove_reagent(src.id, 0.5)//So you're not stuck for 10 minutes teleporting
	..() //loop function

//Addiction
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
		if(0)
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
			M.reagents.remove_all_type(/datum/reagent, 100, 0, 1)
			for (var/datum/mood_event/i in M)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, i) //Why does this not work?
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "Alternative dimension", /datum/mood_event/eigenstate)


	if(prob(20))
		do_sparks(5,FALSE,M)
	src.addictCyc4++

	..()
	//. = 1

///datum/reagent/fermi/eigenstate/overheat_explode(mob/living/M)
//	return

//eigenstate END

/*SDGF
////////////////////////////////////////////////////
// 		synthetic-derived growth factor			 //
//////////////////////////////////////////////////
WHAT IT DOES

Several outcomes are possible (in priority order):

Before the chem is even created, there is a risk of the reaction "exploding", which produces an angry teratoma that attacks the player.
0. Before the chem is activated, the purity is checked, if the purity of the reagent is less than 0.5, then sythetic-derived zombie factor is metabolised instead
	0.1 If SDZF is injected, the chem appears to act the same as normal, with nutrition gain, until the end, where it becomes toxic instead, giving a short window of warning to the player
		0.1.2 If the player can take pent in time, the player will spawn a hostile teratoma on them (less damaging), if they don't, then a zombie is spawned instead, with a small defence increase propotional to the volume
	0.2 If the purity is above 0.5, then the remaining impure volume created SDGFtox instead, which reduces blood volume and causes clone damage
1.Normal function creates a (another)player controlled clone of the player, which is spawned nude, with damage to the clone
	1.1 The remaining volume is transferred to the clone, which heals it over time, thus the player has to make a substantial ammount of the chem in order to produce a healthy clone
	1.2 If the player is infected with a zombie tumor, the tumor is transferred to the ghost controlled clone ONLY.
2. If no player can be found, a brainless clone is created over a long period of time, this body has no controller.
	2.1 If the player dies with a clone, then they play as the clone instead. However no memories are retained after splitting.
3. If there is already a clone, then SDGF heals clone, fire and brute damage slowly. This shouldn't normalise this chem as the de facto clone healing chem, as it will always try to make a ghost clone, and then a brainless clone first.
4. If there is insuffient volume to complete the cloning process, there are two outcomes
	4.1 At lower volumes, the players nutrition and blood is refunded, with light healing
	4.2 At higher volumes a stronger heal is applied to the user

IMPORTANT FACTORS TO CONSIDER WHILE BALANCING
1. The most important factor is the required volume, this is easily edited with the metabolism rate, this chem is HARD TO MAKE, You need to make a lot of it and it's a substantial effort on the players part. There is also a substantial risk; you could spawn a hotile teratoma during the reation, you could damage yourself with clone damage, you could accidentally spawn a zombie... Basically, you've a good chance of killing yourself.
	1.1 Additionally, if you're trying to make SDZF purposely, you've no idea if you have or not, and that reaction is even harder to do. Plus, the player has a huge time window to get to medical to deal with it. If you take pent while it's in you, it'll be removed before it can spawn, and only spawns a teratoma if it's late stage.
2. The rate in which the clone is made, This thing takes time to produce fruits, it slows you down and makes you useless in combat/working. Basically you can't do anything during it. It will only get you killed if you use it in combat, If you do use it and you spawn a player clone, they're gimped for a long time, as they have to heal off the clone damage.
3. The healing - it's pretty low and a cyropod is more Useful
4. If you're an antag, you've a 50% chance of making a clone that will help you with your efforts, and you've no idea if they will or not. While clones can't directly harm you and care for you, they can hinder your efforts.
5. If people are being arses when they're a clone, slap them for it, they are told to NOT bugger around with someone else character, if it gets bad I'll add a blacklist, or do a check to see if you've played X amount of hours.
	5.1 Another solution I'm okay with is to rename the clone to [M]'s clone, so it's obvious, this obviously ruins anyone trying to clone themselves to get an alibi however. I'd prefer this to not be the case.
	5.2 Additionally, this chem is a soft buff to changelings, which apparently need a buff!
	5.3 Other similar things exist already though in the codebase; impostors, split personalites, abductors, ect.
6. Giving this to someone without concent is against space law and gets you sent to gulag.
*/

//Clone serum #chemClone
/datum/reagent/fermi/SDGF //vars, mostly only care about keeping track if there's a player in the clone or not.
	name = "synthetic-derived growth factor"
	id = "SDGF"
	description = "A rapidly diving mass of Embryonic stem cells. These cells are missing a nucleus and quickly replicate a host’s DNA before growing to form an almost perfect clone of the host. In some cases neural replication takes longer, though the underlying reason underneath has yet to be determined."
	color = "#60A584" // rgb: 96, 0, 255
	var/playerClone = FALSE
	var/unitCheck = FALSE
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	//var/datum/status_effect/chem/SDGF/candidates/candies
	var/list/candies = list()
	//var/polling = FALSE
	var/list/result = list()
	var/list/group = null
	var/pollStarted = FALSE
	var/location_created
	var/startHunger

	//var/fClone_current_controller = OWNER
	//var/mob/living/split_personality/clone//there's two so they can swap without overwriting
	//var/mob/living/split_personality/owner
	//var/mob/living/carbon/SM

//Main SDGF chemical
/datum/reagent/fermi/SDGF/on_mob_life(mob/living/carbon/M) //Clones user, then puts a ghost in them! If that fails, makes a braindead clone.
	//Setup clone
	switch(current_cycle)
		if(1)
			startHunger = M.nutrition
			if(pollStarted == FALSE)
				pollStarted = TRUE
				candies = pollGhostCandidates("Do you want to play as a clone and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you.")
		if(20 to INFINITY)
			message_admins("Number of candidates [LAZYLEN(candies)]")
			if(LAZYLEN(candies) && src.playerClone == FALSE) //If there's candidates, clone the person and put them in there!
				message_admins("Candidate found!")
				to_chat(M, "<span class='warning'>The cells reach a critical micelle concentration, nucleating rapidly within your body!</span>")
				//var/typepath = owner.type
				//clone = new typepath(owner.loc)
				var/typepath = M.type
				var/mob/living/carbon/human/fermi_Gclone = new typepath(M.loc)
				//var/mob/living/carbon/SM = owner
				//var/mob/living/carbon/M = M
				var/mob/living/carbon/human/SM = fermi_Gclone
				if(istype(SM) && istype(M))
					SM.real_name = M.real_name
					M.dna.transfer_identity(SM)
					SM.updateappearance(mutcolor_update=1)
				var/mob/dead/observer/C = pick(candies)
				SM.key = C.key
				SM.mind.enslave_mind_to_creator(M)

				//If they're a zombie, they can try to negate it with this.
				//I seriously wonder if anyone will ever use this function.
				if(M.getorganslot(ORGAN_SLOT_ZOMBIE))//sure, it "treats" it, but "you've" still got it. Doesn't always work as well; needs a ghost.
					var/obj/item/organ/zombie_infection/ZI = M.getorganslot(ORGAN_SLOT_ZOMBIE)
					ZI.Remove(M)
					ZI.Insert(SM)

				//SM.sentience_act()
				to_chat(SM, "<span class='warning'>You feel a strange sensation building in your mind as you realise there's two of you, before you get a chance to think about it, you suddenly split from your old body, and find yourself face to face with yourself, or rather, your original self.</span>")
				to_chat(SM, "<span class='userdanger'>While you find your newfound existence strange, you share the same memories as [M.real_name]. [pick("However, You find yourself indifferent to the goals you previously had, and take more interest in your newfound independence, but still have an indescribable care for the safety of your original", "Your mind has not deviated from the tasks you set out to do, and now that there's two of you the tasks should be much easier.")]</span>")
				to_chat(M, "<span class='warning'>You feel a strange sensation building in your mind as you realise there's two of you, before you get a chance to think about it, you suddenly split from your old body, and find yourself face to face with yourself.</span>")
				M.visible_message("[M] suddenly shudders, and splits into two identical twins!")
				SM.copy_known_languages_from(M, FALSE)
				playerClone =  TRUE
				M.next_move_modifier = 1
				M.nutrition -= 500
				//reaction_mob(SM, )I forget what this is for
				//Damage the clone
				SM.blood_volume = BLOOD_VOLUME_NORMAL/2
				SM.adjustCloneLoss(80, 0)
				SM.setBrainLoss(40)
				SM.nutrition = startHunger/2
				//var/datum/reagents/SMR = SM
				///datum/reagents
				//var/mob/living/carbon/human has a holder, carbon does not
				// You need to add to a holder.
				// reagentS not reagent (?)
				//SM.create_reagents()

				//Really hacky way to deal with this stupid problem I have
				SM.reagents.add_reagent("SDGFheal", volume)
				//holder.add_reagent("SDGFheal", volume)
				holder.remove_reagent(src.id, 999)
				//SMR = locate(/datum/reagents in SM)
				//holder.trans_to(SMR, volume)

				return
				//BALANCE: should I make them a pacifist, or give them some cellular damage or weaknesses?

				//after_success(user, SM)
				//qdel(src)

			else if(src.playerClone == FALSE) //No candidates leads to two outcomes; if there's already a braincless clone, it heals the user, as well as being a rare souce of clone healing (thematic!).
				message_admins("Failed to find clone Candidate")
				src.unitCheck = TRUE
				if(M.has_status_effect(/datum/status_effect/chem/SGDF)) // Heal the user if they went to all this trouble to make it and can't get a clone, the poor fellow.
					switch(current_cycle)
						if(21)
							to_chat(M, "<span class='notice'>The cells fail to catalyse around a nucleation event, instead merging with your cells.</span>") //This stuff is hard enough to make to rob a user of some benefit. Shouldn't replace Rezadone as it requires the user to not only risk making a player controlled clone, but also requires them to have split in two (which also requires 30u of SGDF).
							M.remove_trait(TRAIT_DISFIGURED, TRAIT_GENERIC)
						if(22 to INFINITY)
							M.adjustCloneLoss(-1, 0)
							M.adjustBruteLoss(-1, 0)
							M.adjustFireLoss(-1, 0)
							M.heal_bodypart_damage(1,1)
				else //If there's no ghosts, but they've made a large amount, then proceed to make flavourful clone, where you become fat and useless until you split.
					switch(current_cycle)
						if(21)
							to_chat(M, "<span class='notice'>You feel the synethic cells rest uncomfortably within your body as they start to pulse and grow rapidly.</span>")
						if(22 to 29)
							M.nutrition = M.nutrition + (M.nutrition/10)
						if(30)
							to_chat(M, "<span class='notice'>You feel the synethic cells grow and expand within yourself, bloating your body outwards.</span>")
						if(31 to 49)
							M.nutrition = M.nutrition + (M.nutrition/5)
						if(50)
							to_chat(M, "<span class='notice'>The synthetic cells begin to merge with your body, it feels like your body is made of a viscous water, making your movements difficult.</span>")
							M.next_move_modifier += 4//If this makes you fast then please fix it, it should make you slow!!
							//candidates = pollGhostCandidates("Do you want to play as a clone of [M.name] and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you. ", "FermiClone", null, ROLE_SENTIENCE, 300) // see poll_ignore.dm, should allow admins to ban greifers or bullies
						if(51 to 79)
							M.nutrition = M.nutrition + (M.nutrition/2)
						if(80)
							to_chat(M, "<span class='notice'>The cells begin to precipitate outwards of your body, you feel like you'll split soon...</span>")
							if (M.nutrition < 20000)
								M.nutrition = 20000 //https://www.youtube.com/watch?v=Bj_YLenOlZI
						if(86)//Upon splitting, you get really hungry and are capable again. Deletes the chem after you're done.
							M.nutrition = 15//YOU BEST BE EATTING AFTER THIS YOU CUTIE
							M.next_move_modifier -= 4
							to_chat(M, "<span class='notice'>Your body splits away from the cell clone of yourself, leaving you with a drained and hollow feeling inside.</span>")
							M.apply_status_effect(/datum/status_effect/chem/SGDF)
						if(87 to INFINITY)
							holder.remove_reagent(src.id, 1)//removes SGDF on completion.
							message_admins("Purging SGDF [volume]")
					message_admins("Growth nucleation occuring (SDGF), step [current_cycle] of 77")


	..()

/datum/reagent/fermi/SDGF/on_mob_delete(mob/living/M) //When the chem is removed, a few things can happen, mostly consolation prizes.
	pollStarted = FALSE
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
		to_chat(M, "<span class='notice'>the cells fail to hold enough mass to generate a clone, instead diffusing into your system.</span>")
		M.adjustBruteLoss(-10, 0)
		M.adjustFireLoss(-10, 0)
		M.blood_volume += 100
		M.next_move_modifier = 1
		if (M.nutrition < 1500)
			M.nutrition += 500
//If the reaction explodes
/*
/datum/reagent/fermi/SDGF/FermiExplode(turf/open/T)//Spawns an angery teratoma!! Spooky..! be careful!!
	//var/mob/living/simple_animal/slime/S = new(get_turf(location_created),"grey")
	var/mob/living/simple_animal/slime/S = new(T,"grey")//should work, in theory
	S.damage_coeff = list(BRUTE = 0.9 , BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	S.name = "Living teratoma"
	S.real_name = "Living teratoma"//horrifying!!
	S.rabid = 1//Make them an angery boi
	to_chat("<span class='notice'>The cells clump up into a horrifying tumour.</span>")
*/

//Unobtainable, used in clone spawn.
/datum/reagent/fermi/SDGFheal
	name = "synthetic-derived growth factor"
	id = "SDGFheal"
	metabolization_rate = 1

/datum/reagent/fermi/SDGFheal/on_mob_life(mob/living/carbon/M)//Used to heal the clone after splitting, the clone spawns damaged. (i.e. insentivies players to make more than required, so their clone doesn't have to be treated)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume += 10
	M.adjustCloneLoss(-2, 0)
	M.setBrainLoss(-1)
	M.nutrition += 10
	..()

//Unobtainable, used if SDGF is impure but not too impure
/datum/reagent/fermi/SDGFtox
	name = "synthetic-derived growth factor"
	id = "SDGFtox"
	description = "A chem that makes Fermis angry at you if you're reading this, how did you get this???"
	metabolization_rate = 1

/datum/reagent/fermi/SDGFtox/on_mob_life(mob/living/carbon/M)//Damages the taker if their purity is low. Extended use of impure chemicals will make the original die. (thus can't be spammed unless you've very good)
	M.blood_volume -= 10
	M.adjustCloneLoss(2, 0)
	..()

//Fail state of SDGF
/datum/reagent/fermi/SDZF
	name = "synthetic-derived growth factor"
	id = "SDZF"
	description = "A horribly peverse mass of Embryonic stem cells made real by the hands of a failed chemist. This message should never appear, how did you manage to get a hold of this?"
	color = "#60A584" // rgb: 96, 0, 255
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	var/startHunger

/datum/reagent/fermi/SDZF/on_mob_life(mob/living/carbon/M) //If you're bad at fermichem, turns your clone into a zombie instead.
	message_admins("SGZF ingested")
	switch(current_cycle)//Pretends to be normal
		if(20)
			to_chat(M, "<span class='notice'>You feel the synethic cells rest uncomfortably within your body as they start to pulse and grow rapidly.</span>")
			startHunger = M.nutrition
		if(21 to 29)
			M.nutrition = M.nutrition + (M.nutrition/10)
		if(30)
			to_chat(M, "<span class='notice'>You feel the synethic cells grow and expand within yourself, bloating your body outwards.</span>")
		if(31 to 49)
			M.nutrition = M.nutrition + (M.nutrition/5)
		if(50)
			to_chat(M, "<span class='notice'>The synethic cells begin to merge with your body, it feels like your body is made of a viscous water, making your movements difficult.</span>")
			M.next_move_modifier = 4//If this makes you fast then please fix it, it should make you slow!!
		if(51 to 73)
			M.nutrition = M.nutrition + (M.nutrition/2)
		if(74)
			to_chat(M, "<span class='notice'>The cells begin to precipitate outwards of your body, but... something is wrong, the sythetic cells are beginnning to rot...</span>")
			if (M.nutrition < 20000)
				M.nutrition = 20000 //https://www.youtube.com/watch?v=Bj_YLenOlZI
		if(75 to 85)
			M.adjustToxLoss(1, 0)// the warning!
		if(86)
			if (!holder.has_reagent("pen_acid"))//Counterplay is pent.)
				message_admins("Zombie spawned at [M.loc]")
				M.nutrition = startHunger - 500//YOU BEST BE RUNNING AWAY AFTER THIS YOU BADDIE
				M.next_move_modifier = 1
				to_chat(M, "<span class='warning'>Your body splits away from the cell clone of yourself, your attempted clone birthing itself violently from you as it begins to shamble around, a terrifying abomination of science.</span>")
				M.visible_message("[M] suddenly shudders, and splits into a funky smelling copy of themselves!")
				M.emote("scream")
				M.adjustToxLoss(30, 0)
				var/mob/living/simple_animal/hostile/zombie/ZI = new(get_turf(M.loc))
				ZI.damage_coeff = list(BRUTE = ((1 / volume)**0.25) , BURN = ((1 / volume)**0.1), TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
				ZI.real_name = M.real_name//Give your offspring a big old kiss.
				ZI.name = M.real_name
				ZI.desc = "[M]'s clone, gone horribly wrong."
				ZI.zombiejob = null
				//ZI.updateappearance(mutcolor_update=1)
				holder.remove_reagent(src.id, 20)
			else//easier to deal with
				to_chat(M, "<span class='notice'>The pentetic acid seems to have stopped the decay for now, clumping up the cells into a horrifying tumour!</span>")
				M.nutrition = startHunger - 500
				var/mob/living/simple_animal/slime/S = new(get_turf(M.loc),"grey") //TODO: replace slime as own simplemob/add tumour slime cores for science/chemistry interplay
				S.damage_coeff = list(BRUTE = ((1 / volume)**0.1) , BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
				S.name = "Living teratoma"
				S.real_name = "Living teratoma"//horrifying!!
				S.rabid = 1//Make them an angery boi
				//S.updateappearance(mutcolor_update=1)
				holder.remove_reagent(src.id, 20)
				to_chat(M, "<span class='warning'>A large glob of the tumour suddenly splits itself from your body. You feel grossed out and slimey...</span>")
		if(87 to INFINITY)//purges chemical fast, producing a "slime"  for each one. Said slime is weak to fire. TODO: turn tumour slime into real variant.
			M.adjustToxLoss(1, 0)
	message_admins("Growth nucleation occuring (SDGF), step [current_cycle] of 20")
	..()

//breast englargement
//Honestly the most requested chems
//I'm not a very kinky person, sorry if it's not great
//I tried to make it interesting..!!
/datum/reagent/fermi/BElarger
	name = "Sucubus milk"
	id = "BEenlager"
	description = "A volatile collodial mixture derived from milk that encourages mammary production via a potent estrogen mix."
	color = "#E60584" // rgb: 96, 0, 255
	taste_description = "a milky ice cream like flavour."
	overdose_threshold = 12
	metabolization_rate = 0.5
	var/mob/living/carbon/human/H

/datum/reagent/fermi/BElarger/on_mob_add(mob/living/carbon/M)
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/breasts/B = H.getorganslot("breasts")
	if(!B)
		return
	var/sizeConv =  list("a" =  1, "b" = 2, "c" = 3, "d" = 4, "e" = 5)
	B.prev_size = B.size
	B.cached_size = [sizeConv[B.size]]
	message_admins("init B size: [B.size], prev: [B.prev_size], cache = [B.cached_size], raw: [sizeConv[B.size]]")

/datum/reagent/fermi/BElarger/on_mob_life(mob/living/carbon/M) //Increases breast size
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/breasts/B = M.getorganslot("breasts")
	if(!B) //If they don't have breasts, give them breasts.
		message_admins("No breasts found!")
		var/obj/item/organ/genital/breasts/nB = new
		nB.Insert(M)
		if(nB)
			if(M.dna.species.use_skintones && M.dna.features["genitals_use_skintone"])
				nB.color = skintone2hex(H.skin_tone)
			else if(M.dna.features["breasts_color"])
				nB.color = "#[M.dna.features["breasts_color"]]"
			else
				nB.color = skintone2hex(H.skin_tone)
			nB.size = "flat"
			nB.cached_size = 0
			nB.prev_size = 0
			to_chat(M, "<span class='warning'>Your chest feels warm, tingling with newfound sensitivity.</b></span>")
			M.reagents.remove_reagent(src.id, 5)
			B = nB
	//If they have them, increase size. If size is comically big, limit movement and rip clothes.
	//message_admins("Breast size: [B.size], [B.cached_size], [holder]")
	B.cached_size = B.cached_size + 0.1
	if (B.cached_size >= 8.5 && B.cached_size < 9)
		if(H.w_uniform || H.wear_suit)
			var/target = M.get_bodypart(BODY_ZONE_CHEST)
			to_chat(M, "<span class='warning'>Your breasts begin to strain against your clothes tightly!</b></span>")
			M.adjustOxyLoss(10, 0)
			M.apply_damage(2, BRUTE, target)
	B.update()
	..()

/datum/reagent/fermi/BElarger/overdose_process(mob/living/carbon/M) //Turns you into a female if male and ODing, doesn't touch nonbinary and object genders.

	var/obj/item/organ/genital/penis/P = M.getorganslot("penis")
	var/obj/item/organ/genital/testicles/T = M.getorganslot("testicles")
	var/obj/item/organ/genital/vagina/V = M.getorganslot("vagina")
	var/obj/item/organ/genital/womb/W = M.getorganslot("womb")

	if(M.gender == MALE)
		M.gender = FEMALE
		M.visible_message("<span class='boldnotice'>[M] suddenly looks more feminine!</span>", "<span class='boldwarning'>You suddenly feel more feminine!</span>")

	if(P)
		P.length = P.length - 0.1
		message_admins("lewdsnek size: [P.size], [P.cached_length], [holder]")
		P.update()
	if(T)
		T.Remove(M)
	if(!V)
		var/obj/item/organ/genital/vagina/nV = new
		nV.Insert(M)
		V = nV
	if(!W)
		var/obj/item/organ/genital/womb/nW = new
		nW.Insert(M)
		W = nW
	..()

/datum/reagent/fermi/PElarger // Due to popular demand...!
	name = "Incubus draft"
	id = "PElarger"
	description = "A volatile collodial mixture derived from various masculine solutions that encourages a larger gentleman's package via a potent testosterone mix." //The toxic masculinity thing is a joke because I thought it would be funny to include it in the reagents, but I don't think many would find it funny?
	color = "#H60584" // rgb: 96, 0, 255
	taste_description = "a salty and sticky substance."
	overdose_threshold = 12
	metabolization_rate = 0.5
	//var/mob/living/carbon/M
	//var/mob/living/carbon/human/species/S
	/*
	var/obj/item/organ/genital/penis/P
	var/obj/item/organ/genital/testicles/T
	var/obj/item/organ/genital/vagina/V
	var/obj/item/organ/genital/womb/W
	var/obj/item/organ/genital/breasts/B
	*/
	var/mob/living/carbon/human/H

/datum/reagent/fermi/PElarger/on_mob_life(mob/living/carbon/M) //Increases penis size
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/penis/P = M.getorganslot("penis")
	if(!P)
		message_admins("No penis found!")//They do have a preponderance for escapism, or so I've heard.
		var/obj/item/organ/genital/penis/nP = new
		nP.Insert(M)
		if(nP)
			nP.length = 0.2
			to_chat(M, "<span class='warning'>Your groin feels warm, as you feel a newly forming bulge down below.</b></span>")//OwO
			nP.cached_length = 0.1
			nP.prev_size = 0.1
			M.reagents.remove_reagent(src.id, 5)
			P = nP

	P.cached_length = P.cached_length + 0.1
	if (P.cached_length >= 10.5 && P.cached_length < 11) //too low?
		if(H.w_uniform || H.wear_suit)
			var/target = M.get_bodypart(BODY_ZONE_CHEST)
			to_chat(M, "<span class='warning'>Your cock begin to strain against your clothes tightly!</b></span>")
			M.apply_damage(5, BRUTE, target)

	P.update()
	..()

/datum/reagent/fermi/PElarger/overdose_process(mob/living/carbon/M) //Turns you into a male if female and ODing, doesn't touch nonbinary and object genders.
	var/obj/item/organ/genital/breasts/B = M.getorganslot("breasts")
	var/obj/item/organ/genital/testicles/T = M.getorganslot("testicles")
	var/obj/item/organ/genital/vagina/V = M.getorganslot("vagina")
	var/obj/item/organ/genital/womb/W = M.getorganslot("womb")

	message_admins("PE Breast status: [B]")
	if(M.gender == FEMALE)
		M.gender = MALE
		M.visible_message("<span class='boldnotice'>[M] suddenly looks more masculine!</span>", "<span class='boldwarning'>You suddenly feel more masculine!</span>")

	if(B)
		B.cached_size = B.cached_size - 0.1
		message_admins("Breast size: [B.size], [B.cached_size], [holder]")
		B.update()
	if(V)
		V.Remove(M)
	if(W)
		W.Remove(M)
	if(!T)
		var/obj/item/organ/genital/testicles/nT = new
		nT.Insert(M)
		T = nT
	..()

/datum/reagent/fermi/astral // Gives you the ability to astral project for a moment!
	name = "Astrogen"
	id = "astral"
	description = "An opalescent murky liquid that is said to distort your soul from your being."
	color = "#A080H4" // rgb: , 0, 255
	taste_description = "velvety brambles"
	metabolization_rate = 0//Removal is exponential, see code
	overdose_threshold = 20
	addiction_threshold = 30
	addiction_stage1_end = 9999//Should never end.
	var/mob/living/carbon/origin
	var/mob/living/simple_animal/hostile/retaliate/ghost/G = null
	var/ODing = FALSE
	//var/Svol = volume

/datum/reagent/fermi/astral/on_mob_life(mob/living/M) // Gives you the ability to astral project for a moment!
	M.alpha = 255//Reset addiction
	switch(current_cycle)
		if(0)//Require a minimum
			//var/mob/living/carbon/H = M
			//M.alpha = 255
			origin = M
			if (G == null)
				G = new(get_turf(M.loc))
			G.attacktext = "raises the hairs on the neck of"
			G.response_harm = "disrupts the concentration of"
			G.response_disarm = "wafts"
			G.loot = null
			G.maxHealth = 5
			G.health = 5
			G.melee_damage_lower = 0
			G.melee_damage_upper = 0
			G.deathmessage = "disappears as if it was never really there to begin with"
			G.incorporeal_move = 1
			G.alpha = 35
			G.name = "[M]'s astral projection"
			M.mind.transfer_to(G)
	holder.remove_reagent(src.id, current_cycle, FALSE)
	..()

/datum/reagent/fermi/astral/on_mob_delete(mob/living/carbon/M)
	G.mind.transfer_to(origin)
	qdel(G)
	if(ODing == TRUE)
		M.Sleeping(10*volume, 0)
		ODing = FALSE
	..()

/datum/reagent/fermi/astral/overdose_process(mob/living/carbon/M)
	ODing = TRUE
	if (!G == null)
		if(prob(70))
			to_chat(M, "<span class='warning'>The high conentration of Astrogen in your blood causes you to lapse your concentration for a moment, bringing your projection back to yourself!</b></span>")
			do_teleport(G, M.loc)
	..()

//Okay so, this might seem a bit too good, but my counterargument is that it'll likely take all round to eventually kill you this way, then you have to be revived without a body. It takes approximately 60-80 minutes to die from this.
/datum/reagent/fermi/astral/addiction_act_stage1(mob/living/carbon/M)
	if(prob(65))
		M.alpha = M.alpha - 1
	switch(M.alpha)
		if(245)
			to_chat(M, "<span class='warning'>You notice your body starting to disappear, maybe you took too much Astrogen...?</b></span>")
			M.alpha = M.alpha - 1
		if(220)
			to_chat(M, "<span class='notice'>Your addiction is only getting worse as your body disappears. Maybe you should get some more, and fast?</b></span>")
			M.alpha = M.alpha - 1
		if(180)
			to_chat(M, "<span class='notice'>You're starting to get scared as more and more of your body and consciousness begins to fade.</b></span>")
			M.alpha = M.alpha - 1
		if(120)
			to_chat(M, "<span class='notice'>As you lose more and more of yourself, you start to think that maybe shedding your mortality isn't too bad.</b></span>")
			M.alpha = M.alpha - 1
		if(100)
			to_chat(M, "<span class='notice'>You feel a substantial part of your soul flake off into the ethereal world, rendering yourself unclonable.</b></span>")
			M.alpha = M.alpha - 1
			M.add_trait(TRAIT_NOCLONE)
		if(80)
			to_chat(M, "<span class='notice'>You feel a thrill shoot through your body as what's left of your mind contemplates the forthcoming oblivion.</b></span>")
			M.alpha = M.alpha - 1
		if(45)
			to_chat(M, "<span class='warning'>The last vestiges of your mind eagerly await your imminent annihilation.</b></span>")
			M.alpha = M.alpha - 1
		if(0 to 30)
			to_chat(M, "<span class='warning'>Your body disperses from existence, as you become one with the universe.</b></span>")
			to_chat(M, "<span class='userdanger'>As your body disappears, your consciousness doesn't. Should you find a way back into the mortal coil, your memories of the afterlife remain with you. (At the cost of staying in character while dead.)</span>")//Legalised IC OOK? I have a suspicion this won't make it past the review. At least it'll be presented as a neat idea! If this is unacceptable how about the player can retain living memories across lives if they die in this way only.
			M.visible_message("[M] suddenly disappears, their body evaporating from existence, freeing [M] from their mortal coil.")
			qdel(M) //Approx 60minutes till death from initial addiction
	..()

/datum/reagent/fermi/enthral
	name = "Need a name"
	id = "enthral"
	description = "Need a description."
	color = "#A080H4" // rgb: , 0, 255
	taste_description = "synthetic chocolate, a base tone of alcohol, and high notes of roses"
	metabolization_rate = 0
	overdose_threshold = 20
	addiction_threshold = 30
	addiction_stage1_end = 9999//Should never end.
	var/creatorID  //add here

/datum/reagent/fermi/enthral/on_mob_life(mob/living/carbon/M)
	if(!creatorID)
		CRASH("Something went wrong in enthral creation")
	if(M.ID == creatorID)
		var/obj/item/organ/tongue/T = M.getorganslot(ORGAN_SLOT_TONGUE)
		var/obj/item/organ/tongue/nT = new /obj/item/organ/tongue/silver
		T.Remove(M)
		nT.Insert(M)
		qdel(T)

//Requires player to be within vicinity of creator
//bonuses to mood
//gives creator a silver(velvet?) tongue
//Addiction is applied when creator is out of viewer
//

///////////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/fermi/furranium
	name = "Furranium"
	id = "furranium"
	description = "OwO whats this?"
	color = "#H04044" // rgb: , 0, 255
	taste_description = "dewicious degenyewacy"

/datum/reagent/fermi/furranium/on_mob_life(mob/living/carbon/M)

	switch(current_cycle)
		if(1 to 9)
			if(prob(20))
				to_chat(M, "<span class='notice'>Your tongue feels... fluffy</span>")
		if(10 to 20)
			if(prob(20))
				to_chat(M, "You find yourself unable to supress the desire to meow!")
				M.emote("nya")
			if(prob(20))
				to_chat(M, "You find yourself unable to supress the desire to howl!")
				M.emote("awoo")
			if(prob(20))
				var/list/seen = viewers(5, get_turf(M))//Sound and sight checkers
				//for(var/victim in seen)
				to_chat(M, "You notice [pick([victim])]'s bulge [pick("OwO!", "uwu!")]")
		if(21)
			var/obj/item/organ/tongue/T = M.getorganslot(ORGAN_SLOT_TONGUE)
			var/obj/item/organ/tongue/nT = new /obj/item/organ/tongue/OwO
			T.Remove(M)
			nT.Insert(M)
			qdel(T)
		if(22 to INFINITY)
			if(prob(20))
				to_chat(M, "You find yourself unable to supress the desire to meow!")
				M.emote("nya")
			if(prob(20))
				to_chat(M, "You find yourself unable to supress the desire to howl!")
				M.emote("awoo")
			if(prob(20))
				var/list/seen = viewers(5, get_turf(M))//Sound and sight checkers
				for(var/victim in seen)
					to_chat(M, "You notice [pick([victim])]'s bulge [pick("OwO!", "uwu!")]")
	..()

/*
/mob/living/simple_animal/hostile/retaliate/ghost
incorporeal_move = 1
name
alpha = 20
reduce viewrange?
*/

/*
//Nanite removal
//Writen by Trilby!!
/datum/reagent/fermi/naninte_b_gone
	name = "Naninte bain"
	id = "naninte_b_gone"
	description = "A rather simple toxin to small nano machines that will kill them off at a rapid rate well in system."
	color = "#5a7267" // rgb: 90, 114, 103
	overdose_threshold = 25
	v/component/nanites/nan

/datum/reagent/fermi/naninte_b_gone/on_mob_life(mob/living/carbon/C)
	var/component/nanites/nane = C.GetComponent(/component/nanites)
	if(isnull(nane))
		return
	nane.regen_rate = -5.0

/datum/reagent/fermi/naninte_b_gone/overdose_start(mob/living/carbon/C)
	var/component/nanites/nane = C.GetComponent(/component/nanites)
	if(isnull(nane))
		return
	nane.regen_rate = -7.5
*/

/*
 _________________________________________
||Fermichem toxic / impure chems here.   ||
||										 ||
||_______________________________________||
*/
