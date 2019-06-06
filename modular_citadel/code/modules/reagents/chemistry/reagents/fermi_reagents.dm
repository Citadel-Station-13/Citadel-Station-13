 //Fermichem!!
//Fun chems for all the family

/datum/reagent/fermi
	name = "Fermi" 	//Why did I putthis here?
	id = "fermi"	//It's meeee
	taste_description	= "affection and love!"
	var/ImpureChem 			= "fermiTox"			// What chemical is metabolised with an inpure reaction
	var/InverseChemVal 		= 0.25					// If the impurity is below 0.5, replace ALL of the chem with InverseChem upon metabolising
	var/InverseChem 		= "fermiTox" 	// What chem is metabolised when purity is below InverseChemVal, this shouldn't be made, but if it does, well, I guess I'll know about it.
	var/DoNotSplit			= FALSE				// If impurity is handled within the main chem itself
	var/OnMobMergeCheck		= FALSE
	//var/addProc 			= FALSE //When this reagent is added to a new beaker, it does something. Implemented but unused.

//Called when added to a beaker without any of the reagent present. #add_reagent
/datum/reagent/fermi/proc/FermiNew(holder)
	return

//This should process fermichems to find out how pure they are and what effect to do.
//TODO: add this to the main on_mob_add proc, and check if Fermichem = TRUE
/datum/reagent/fermi/on_mob_add(mob/living/carbon/M, amount)
	. = ..()
	if(!M)
		return
	if(src.purity < 0)
		CRASH("Purity below 0 for chem: [src.id], Please let Fermis Know!")
	if (src.purity == 1 || src.DoNotSplit == TRUE)
		return
	else if (src.InverseChemVal > src.purity)//Turns all of a added reagent into the inverse chem
		M.reagents.remove_reagent(src.id, amount, FALSE)
		M.reagents.add_reagent(src.InverseChem, amount, FALSE, other_purity = 1)
		return
	else
		//var/pureVol = amount * puritys
		var/impureVol = amount * (1 - purity) //turns impure ratio into impure chem
		M.reagents.remove_reagent(src.id, (impureVol), FALSE)
		M.reagents.add_reagent(src.ImpureChem, impureVol, FALSE, other_purity = 1)
	return

//When merging two fermichems, see above
/datum/reagent/fermi/on_merge(data, amount, mob/living/carbon/M, purity)//basically on_mob_add but for merging
	. = ..()
	if(!ishuman(M))
		return
	if (purity < 0)
		CRASH("Purity below 0 for chem: [src.id], Please let Fermis Know!")
	if (purity == 1 || src.DoNotSplit == TRUE)
		return
	else if (src.InverseChemVal > purity)
		M.reagents.remove_reagent(src.id, amount, FALSE)
		M.reagents.add_reagent(src.InverseChem, amount, FALSE, other_purity = 1)
		for(var/datum/reagent/fermi/R in M.reagents.reagent_list)
			if(R.name == "")
				R.name = src.name//Negative effects are hidden
		return
	else
		var/impureVol = amount * (1 - purity)
		M.reagents.remove_reagent(src.id, impureVol, FALSE)
		M.reagents.add_reagent(src.ImpureChem, impureVol, FALSE, other_purity = 1)
		for(var/datum/reagent/fermi/R in M.reagents.reagent_list)
			if(R.name == "")
				R.name = src.name//Negative effects are hidden
	return


////////////////////////////////////////////////////////////////////////////////////////////////////
//										EIGENSTASIUM
///////////////////////////////////////////////////////////////////////////////////////////////////
//eigenstate Chem
//Teleports you to chemistry and back
//OD teleports you randomly around the Station
//Addiction send you on a wild ride and replaces you with an alternative reality version of yourself.
//During the process you get really hungry, then your items start teleporting randomly,
//then alternative versions of yourself are brought in from a different universe and they yell at you.
//and finally you yourself get teleported to an alternative universe, and character your playing is replaced with said alternative

/datum/reagent/fermi/eigenstate
	name = "Eigenstasium"
	id = "eigenstate"
	description = "A strange mixture formed from a controlled reaction of bluespace with plasma, that causes localised eigenstate fluxuations within the patient"
	taste_description = "wiggly cosmic dust."
	color = "#5020H4" // rgb: 50, 20, 255
	overdose_threshold = 15
	addiction_threshold = 15
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	addiction_stage2_end = 30
	addiction_stage3_end = 41
	addiction_stage4_end = 44 //Incase it's too long
	var/location_created
	//var/turf/open/location_created
	var/turf/open/location_return = null
	var/addictCyc1 = 0
	var/addictCyc2 = 0
	var/addictCyc3 = 0
	var/addictCyc4 = 0
	var/mob/living/fermi_Tclone = null
	var/teleBool = FALSE
	mob/living/carbon/purgeBody
	pH = 3.7

//Main functions
/datum/reagent/fermi/eigenstate/on_mob_life(mob/living/M) //Teleports to chemistry!
	switch(current_cycle)
		if(0)
			location_return = get_turf(M)	//sets up return point
			to_chat(M, "<span class='userdanger'>You feel your wavefunction split!</span>")
			if(purity > 0.75) //Teleports you home if it's pure enough
				var/turf/open/creation = location_created
				do_sparks(5,FALSE,M)
				do_teleport(M, creation, 0, asoundin = 'sound/effects/phasein.ogg')
				do_sparks(5,FALSE,M)
	if(prob(20))
		do_sparks(5,FALSE,M)
	..()

/datum/reagent/fermi/eigenstate/on_mob_delete(mob/living/M) //returns back to original location
	do_sparks(5,FALSE,M)
	to_chat(M, "<span class='userdanger'>You feel your wavefunction collapse!</span>")
	do_teleport(M, location_return, 0, asoundin = 'sound/effects/phasein.ogg') //Teleports home
	do_sparks(5,FALSE,M)
	..()

/datum/reagent/fermi/eigenstate/overdose_start(mob/living/M) //Overdose, makes you teleport randomly
	. = ..()
	to_chat(M, "<span class='userdanger'>Oh god, you feel like your wavefunction is about to tear.</span>")
	M.Jitter(10)

/datum/reagent/fermi/eigenstate/overdose_process(mob/living/M) //Overdose, makes you teleport randomly, probably one of my favourite effects. Sometimes kills you.
	do_sparks(5,FALSE,src)
	do_teleport(M, get_turf(M), 10, asoundin = 'sound/effects/phasein.ogg')
	do_sparks(5,FALSE,src)
	M.reagents.remove_reagent(src.id, 0.5)//So you're not stuck for 10 minutes teleporting
	..()

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
	if(!LAZYLEN(items))
		return ..()
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
			do_teleport(C, get_turf(C), 2, no_effects=TRUE) //teleports clone so it's hard to find the real one!
			do_sparks(5,FALSE,C)
			C.emote("spin")
			M.emote("spin")
			M.emote("me",1,"flashes into reality suddenly, gasping as they gaze around in a bewildered and highly confused fashion!",TRUE)
			C.emote("me",1,"[pick("says", "cries", "mewls", "giggles", "shouts", "screams", "gasps", "moans", "whispers", "announces")], \"[pick("Bugger me, whats all this then?", "Hot damn, where is this?", "sacre bleu! O� suis-je?!", "Yee haw! This is one hell of a hootenanny!", "WHAT IS HAPPENING?!", "Picnic!", "Das ist nicht deutschland. Das ist nicht akzeptabel!!!", "I've come from the future to warn you to not take eigenstasium! Oh no! I'm too late!", "You fool! You took too much eigenstasium! You've doomed us all!", "What...what's with these teleports? It's like one of my Japanese animes...!", "Ik stond op het punt om mehki op tafel te zetten, en nu, waar ben ik?", "This must be the will of Stein's gate.", "Fermichem was a mistake", "This is one hell of a beepsky smash.", "Now neither of us will be virgins!")]\"")
		if(2)
			var/mob/living/carbon/C = fermi_Tclone
			do_sparks(5,FALSE,C)
			qdel(C) //Deletes CLONE, or at least I hope it is.
			M.visible_message("[M] is snapped across to a different alternative reality!")
			src.addictCyc3 = 0 //counter
			fermi_Tclone = null
	src.addictCyc3++
	do_teleport(M, get_turf(M), 2, no_effects=TRUE) //Teleports player randomly
	do_sparks(5,FALSE,M)
	..()

/datum/reagent/fermi/eigenstate/addiction_act_stage4(mob/living/M) //Thanks for riding Fermis' wild ride. Mild jitter and player buggery.
	switch(src.addictCyc4)
		if(0)
			do_sparks(5,FALSE,M)
			do_teleport(M, get_turf(M), 2, no_effects=TRUE) //teleports clone so it's hard to find the real one!
			do_sparks(5,FALSE,M)
			M.Sleeping(50, 0)
			M.Jitter(50)
			M.Knockdown(0)
			to_chat(M, "<span class='userdanger'>You feel your eigenstate settle, snapping an alternative version of yourself into reality. All your previous memories are lost and replaced with the alternative version of yourself. This version of you feels more [pick("affectionate", "happy", "lusty", "radical", "shy", "ambitious", "frank", "voracious", "sensible", "witty")] than your previous self, sent to god knows what universe.</span>")
			M.emote("me",1,"flashes into reality suddenly, gasping as they gaze around in a bewildered and highly confused fashion!",TRUE)
			M.reagents.remove_all_type(/datum/reagent, 100, 0, 1)
			for(var/datum/mood_event/Me in M)
				SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, Me) //Why does this not work?
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "Alternative dimension", /datum/mood_event/eigenstate)


	if(prob(20))
		do_sparks(5,FALSE,M)
	src.addictCyc4++
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "[src.id]_overdose")//holdover until above fix works
	..()

//eigenstate END

/*SDGF
////////////////////////////////////////////////////
// 		synthetic-derived growth factor			 //
//////////////////////////////////////////////////
other files that are relivant:
modular_citadel/code/datums/status_effects/chems.dm - SDGF
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
	ImpureChem 			= "SDGFtox"
	InverseChemVal 		= 0.5
	InverseChem 		= "SDZF"

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
			if(LAZYLEN(candies) && src.playerClone == FALSE) //If there's candidates, clone the person and put them in there!
				message_admins("Ghost candidate found! [candies] is becoming a clone of [M]! Hee~!! Exciting!!")
				to_chat(M, "<span class='warning'>The cells reach a critical micelle concentration, nucleating rapidly within your body!</span>")
				var/typepath = M.type
				var/mob/living/carbon/human/fermi_Gclone = new typepath(M.loc)
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

				to_chat(SM, "<span class='warning'>You feel a strange sensation building in your mind as you realise there's two of you, before you get a chance to think about it, you suddenly split from your old body, and find yourself face to face with yourself, or rather, your original self.</span>")
				to_chat(SM, "<span class='userdanger'>While you find your newfound existence strange, you share the same memories as [M.real_name]. [pick("However, You find yourself indifferent to the goals you previously had, and take more interest in your newfound independence, but still have an indescribable care for the safety of your original", "Your mind has not deviated from the tasks you set out to do, and now that there's two of you the tasks should be much easier.")]</span>")
				to_chat(M, "<span class='warning'>You feel a strange sensation building in your mind as you realise there's two of you, before you get a chance to think about it, you suddenly split from your old body, and find yourself face to face with yourself.</span>")
				M.visible_message("[M] suddenly shudders, and splits into two identical twins!")
				SM.copy_known_languages_from(M, FALSE)
				playerClone =  TRUE
				M.next_move_modifier = 1
				M.nutrition -= 500

				//Damage the clone
				SM.blood_volume = (BLOOD_VOLUME_NORMAL*SM.blood_ratio)/2
				SM.adjustCloneLoss(60, 0)
				SM.setBrainLoss(40)
				SM.nutrition = startHunger/2

				//Transfer remaining reagent to clone. I think around 30u will make a healthy clone, otherwise they'll have clone damage, blood loss, brain damage and hunger.
				SM.reagents.add_reagent("SDGFheal", volume)
				M.reagents.remove_reagent(src.id, src.volume)
				return

			else if(src.playerClone == FALSE) //No candidates leads to two outcomes; if there's already a braincless clone, it heals the user, as well as being a rare souce of clone healing (thematic!).
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
							M.reagents.remove_reagent(src.id, 1)//faster rate of loss.
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
							M.reagents.remove_reagent(src.id, src.volume)//removes SGDF on completion. Has to do it this way because of how i've coded it. If some madlab gets over 1k of SDGF, they can have the clone healing.


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

//Unobtainable, used in clone spawn.
/datum/reagent/fermi/SDGFheal
	name = "synthetic-derived growth factor"
	id = "SDGFheal"
	metabolization_rate = 1

/datum/reagent/fermi/SDGFheal/on_mob_life(mob/living/carbon/M)//Used to heal the clone after splitting, the clone spawns damaged. (i.e. insentivies players to make more than required, so their clone doesn't have to be treated)
	if(M.blood_volume < (BLOOD_VOLUME_NORMAL*M.blood_ratio))
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
			if (M.nutrition < 20000) //whoever knows the maxcap, please let me know, this seems a bit low.
				M.nutrition = 20000 //https://www.youtube.com/watch?v=Bj_YLenOlZI
		if(75 to 85)
			M.adjustToxLoss(1, 0)// the warning!
		if(86)//mean clone time!
			if (!M.reagents.has_reagent("pen_acid"))//Counterplay is pent.)
				message_admins("(non-infectious) Zombie spawned at [M.loc], produced by impure chem, wah!")
				M.nutrition = startHunger - 500//YOU BEST BE RUNNING AWAY AFTER THIS YOU BADDIE
				M.next_move_modifier = 1
				to_chat(M, "<span class='warning'>Your body splits away from the cell clone of yourself, your attempted clone birthing itself violently from you as it begins to shamble around, a terrifying abomination of science.</span>")
				M.visible_message("[M] suddenly shudders, and splits into a funky smelling copy of themselves!")
				M.emote("scream")
				M.adjustToxLoss(30, 0)
				var/mob/living/simple_animal/hostile/unemployedclone/ZI = new(get_turf(M.loc))
				ZI.damage_coeff = list(BRUTE = ((1 / volume)**0.25) , BURN = ((1 / volume)**0.1), TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
				ZI.real_name = M.real_name//Give your offspring a big old kiss.
				ZI.name = M.real_name
				ZI.desc = "[M]'s clone, gone horribly wrong."

				M.reagents.remove_reagent(src.id, 20)
			else//easier to deal with
				to_chat(M, "<span class='notice'>The pentetic acid seems to have stopped the decay for now, clumping up the cells into a horrifying tumour!</span>")
				M.nutrition = startHunger - 500
				var/mob/living/simple_animal/slime/S = new(get_turf(M.loc),"grey") //TODO: replace slime as own simplemob/add tumour slime cores for science/chemistry interplay
				S.damage_coeff = list(BRUTE = ((1 / volume)**0.1) , BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
				S.name = "Living teratoma"
				S.real_name = "Living teratoma"//horrifying!!
				S.rabid = 1//Make them an angery boi
				//S.updateappearance(mutcolor_update=1)
				M.reagents.remove_reagent(src.id, src.volume)
				to_chat(M, "<span class='warning'>A large glob of the tumour suddenly splits itself from your body. You feel grossed out and slimey...</span>")
		if(87 to INFINITY)//purges chemical fast, producing a "slime"  for each one. Said slime is weak to fire. TODO: turn tumour slime into real variant.
			M.adjustToxLoss(1, 0)
	..()

////////////////////////////////////////////////////////////////////////////////////////////////////
//										BREAST ENLARGE
///////////////////////////////////////////////////////////////////////////////////////////////////
//Other files that are relivant:
//modular_citadel/code/datums/status_effects/chems.dm
//modular_citadel/code/modules/arousal/organs/breasts.dm

//breast englargement
//Honestly the most requested chems
//I'm not a very kinky person, sorry if it's not great
//I tried to make it interesting..!!

//Normal function increases your breast size by 0.1, 5units = 1 cup.
//If you get stupid big, it presses against your clothes, causing brute and oxydamage. Then rips them off.
//If you keep going, it makes you slower, in speed and action.
//decreasing your size will return you to normal.
//(see the status effect in chem.dm)
//Overdosing on (what is essentially space estrogen) makes you female, removes balls and shrinks your dick.
//OD is low for a reason. I'd like fermichems to have low ODs, and dangerous ODs, and since this is a meme chem that everyone will rush to make, it'll be a lesson learnt early.

/datum/reagent/fermi/BElarger
	name = "Sucubus milk"
	id = "BElarger"
	description = "A volatile collodial mixture derived from milk that encourages mammary production via a potent estrogen mix."
	color = "#E60584" // rgb: 96, 0, 255
	taste_description = "a milky ice cream like flavour."
	overdose_threshold = 12
	metabolization_rate = 0.5
	ImpureChem 			= "BEsmaller" //If you make an inpure chem, it stalls growth
	InverseChemVal 		= 0.3
	InverseChem 		= "BEsmaller" //At really impure vols, it just becomes 100% inverse

/datum/reagent/fermi/BElarger/on_mob_add(mob/living/carbon/M)
	. = ..()
	if(!ishuman(M)) //The monkey clause
		if(volume >= 15) //To prevent monkey breast farms
			var/turf/T = get_turf(M)
			var/obj/item/organ/genital/breasts/B = new /obj/item/organ/genital/breasts(T)
			var/list/seen = viewers(8, T)
			for(var/mob/S in seen)
				to_chat(S, "<span class='warning'>A pair of breasts suddenly fly out of the [M]!</b></span>")
			//var/turf/T2 = pick(turf in view(5, M))
			var/T2 = get_random_station_turf()
			M.adjustBruteLoss(25)
			M.Knockdown(50)
			M.Stun(50)
			B.throw_at(T2, 8, 1)
		M.reagents.remove_reagent(src.id, src.volume)
		return
	var/mob/living/carbon/human/H = M
	H.genital_override = TRUE
	var/obj/item/organ/genital/breasts/B = H.getorganslot("breasts")
	if(!B)
		H.emergent_genital_call()
		return
	if(!B.size == "huge")
		var/sizeConv =  list("a" =  1, "b" = 2, "c" = 3, "d" = 4, "e" = 5)
		B.prev_size = B.size
		B.cached_size = sizeConv[B.size]

/datum/reagent/fermi/BElarger/on_mob_life(mob/living/carbon/M) //Increases breast size
	if(!ishuman(M))//Just in case
		return..()

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/breasts/B = M.getorganslot("breasts")
	if(!B) //If they don't have breasts, give them breasts.

		//If they have Acute hepatic pharmacokinesis, then route processing though liver.
		if(M.has_trait(TRAIT_PHARMA))
			var/obj/item/organ/liver/L = M.getorganslot("liver")
			L.swelling+= 0.1
			return..()

		//otherwise proceed as normal
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

	//Acute hepatic pharmacokinesis.
	if(M.has_trait(TRAIT_PHARMA))
		var/obj/item/organ/liver/L = M.getorganslot("liver")
		L.swelling+= 0.05
		return ..()

	var/obj/item/organ/genital/penis/P = M.getorganslot("penis")
	var/obj/item/organ/genital/testicles/T = M.getorganslot("testicles")
	var/obj/item/organ/genital/vagina/V = M.getorganslot("vagina")
	var/obj/item/organ/genital/womb/W = M.getorganslot("womb")

	if(M.gender == MALE)
		M.gender = FEMALE
		M.visible_message("<span class='boldnotice'>[M] suddenly looks more feminine!</span>", "<span class='boldwarning'>You suddenly feel more feminine!</span>")

	if(P)
		P.cached_length = P.cached_length - 0.1
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

/datum/reagent/fermi/BEsmaller
	name = "Sucubus milk"
	id = "BEsmaller"
	description = "A volatile collodial mixture derived from milk that encourages mammary production via a potent estrogen mix."
	color = "#E60584" // rgb: 96, 0, 255
	taste_description = "a milky ice cream like flavour."
	metabolization_rate = 0.5

/datum/reagent/fermi/BEsmaller/on_mob_life(mob/living/carbon/M)
	var/obj/item/organ/genital/breasts/B = M.getorganslot("breasts")
	if(!B)
		//Acute hepatic pharmacokinesis.
		if(M.has_trait(TRAIT_PHARMA))
			var/obj/item/organ/liver/L = M.getorganslot("liver")
			L.swelling-= 0.1
			return ..()

		//otherwise proceed as normal
		return..()
	B.cached_size = B.cached_size - 0.1
	B.update()
	..()


////////////////////////////////////////////////////////////////////////////////////////////////////
//										PENIS ENLARGE
///////////////////////////////////////////////////////////////////////////////////////////////////
//See breast explanation, it's the same but with taliwhackers
//instead of slower movement and attacks, it slows you and increases the total blood you need in your system.
//Since someone else made this in the time it took me to PR it, I merged them.
/datum/reagent/fermi/PElarger // Due to popular demand...!
	name = "Incubus draft"
	id = "PElarger"
	description = "A volatile collodial mixture derived from various masculine solutions that encourages a larger gentleman's package via a potent testosterone mix, formula derived from a collaboration from Fermichem  and Doctor Ronald Hyatt, who is well known for his phallus palace." //The toxic masculinity thing is a joke because I thought it would be funny to include it in the reagents, but I don't think many would find it funny? dumb
	color = "#888888" // This is greyish..?
	taste_description = "chinese dragon powder"
	overdose_threshold = 12 //ODing makes you male and removes female genitals
	metabolization_rate = 0.5
	ImpureChem 			= "PEsmaller" //If you make an inpure chem, it stalls growth
	InverseChemVal 		= 0.3
	InverseChem 		= "PEsmaller" //At really impure vols, it just becomes 100% inverse and shrinks instead.

/datum/reagent/fermi/PElarger/on_mob_add(mob/living/carbon/M)
	. = ..()
	if(!ishuman(M)) //Just monkeying around.
		if(volume >= 15) //to prevent monkey penis farms
			var/turf/T = get_turf(M)
			var/obj/item/organ/genital/penis/P = new /obj/item/organ/genital/penis(T)
			var/list/seen = viewers(8, T)
			for(var/mob/S in seen)
				to_chat(S, "<span class='warning'>A penis suddenly flies out of the [M]!</b></span>")
			var/T2 = get_random_station_turf()
			M.adjustBruteLoss(25)
			M.Knockdown(50)
			M.Stun(50)
			P.throw_at(T2, 8, 1)
		M.reagents.remove_reagent(src.id, src.volume)
		return
	var/mob/living/carbon/human/H = M
	H.genital_override = TRUE
	var/obj/item/organ/genital/penis/P = M.getorganslot("penis")
	if(!P)
		H.emergent_genital_call()
		return
	P.prev_length = P.length
	P.cached_length = P.length

/datum/reagent/fermi/PElarger/on_mob_life(mob/living/carbon/M) //Increases penis size, 5u = +1 inch.
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/penis/P = M.getorganslot("penis")
	if(!P)//They do have a preponderance for escapism, or so I've heard.

		//If they have Acute hepatic pharmacokinesis, then route processing though liver.
		if(M.has_trait(TRAIT_PHARMA))
			var/obj/item/organ/liver/L = M.getorganslot("liver")
			L.swelling+= 0.1
			return..()

		//otherwise proceed as normal
		var/obj/item/organ/genital/penis/nP = new
		nP.Insert(M)
		if(nP)
			nP.length = 1
			to_chat(M, "<span class='warning'>Your groin feels warm, as you feel a newly forming bulge down below.</b></span>")
			nP.cached_length = 1
			nP.prev_length = 1
			M.reagents.remove_reagent(src.id, 5)
			P = nP

	P.cached_length = P.cached_length + 0.1
	if (P.cached_length >= 20.5 && P.cached_length < 21)
		if(H.w_uniform || H.wear_suit)
			var/target = M.get_bodypart(BODY_ZONE_CHEST)
			to_chat(M, "<span class='warning'>Your cock begin to strain against your clothes tightly!</b></span>")
			M.apply_damage(5, BRUTE, target)

	P.update()
	..()

/datum/reagent/fermi/PElarger/overdose_process(mob/living/carbon/M) //Turns you into a male if female and ODing, doesn't touch nonbinary and object genders.
	//Acute hepatic pharmacokinesis.
	if(M.has_trait(TRAIT_PHARMA))
		var/obj/item/organ/liver/L = M.getorganslot("liver")
		L.swelling+= 0.05
		return..()

	var/obj/item/organ/genital/breasts/B = M.getorganslot("breasts")
	var/obj/item/organ/genital/testicles/T = M.getorganslot("testicles")
	var/obj/item/organ/genital/vagina/V = M.getorganslot("vagina")
	var/obj/item/organ/genital/womb/W = M.getorganslot("womb")

	if(M.gender == FEMALE)
		M.gender = MALE
		M.visible_message("<span class='boldnotice'>[M] suddenly looks more masculine!</span>", "<span class='boldwarning'>You suddenly feel more masculine!</span>")

	if(B)
		B.cached_size = B.cached_size - 0.1
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

/datum/reagent/fermi/PEsmaller // Due to cozmo's request...!
	name = "Incubus draft"
	id = "PEsmaller"
	description = "A volatile collodial mixture derived from various masculine solutions that encourages a larger gentleman's package via a potent testosterone mix, formula derived from a collaboration from Fermichem  and Doctor Ronald Hyatt, who is well known for his phallus palace." //The toxic masculinity thing is a joke because I thought it would be funny to include it in the reagents, but I don't think many would find it funny? dumb
	color = "#888888" // This is greyish..?
	taste_description = "chinese dragon powder"
	metabolization_rate = 0.5

/datum/reagent/fermi/PEsmaller/on_mob_life(mob/living/carbon/M)
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/genital/penis/P = H.getorganslot("penis")
	if(!P)
		//Acute hepatic pharmacokinesis.
		if(M.has_trait(TRAIT_PHARMA))
			var/obj/item/organ/liver/L = M.getorganslot("liver")
			L.swelling-= 0.1
			return..()

		//otherwise proceed as normal
		return..()
	P.cached_length = P.cached_length - 0.1
	P.update()
	..()
/*
////////////////////////////////////////////////////////////////////////////////////////////////////
//										ASTROGEN
///////////////////////////////////////////////////////////////////////////////////////////////////
More fun chems!
When you take it, it spawns a ghost that the player controls. (No access to deadchat)
This ghost moves pretty quickly and is mostly invisible, but is still visible for people with eyes.
When it's out of your system, you return back to yourself. It doesn't last long and metabolism of the chem is exponential.
Addiction is particularlly brutal, it slowly turns you invisible with flavour text, then kills you at a low enough alpha. (i've also added something to prevent geneticists speeding this up)
There's afairly major catch regarding the death though. I'm not gonna say here, go read the code, it explains it and puts my comments on it in context. I know that anyone reading it without understanding it is going to freak out so, this is my attempt to get you to read it and understand it.
I'd like to point out from my calculations it'll take about 60-80 minutes to die this way too. Plenty of time to visit me and ask for some pills to quench your addiction.
*/

/datum/reagent/fermi/astral // Gives you the ability to astral project for a moment!
	name = "Astrogen"
	id = "astral"
	description = "An opalescent murky liquid that is said to distort your soul from your being."
	color = "#A080H4" // rgb: , 0, 255
	taste_description = "velvety brambles"
	metabolization_rate = 0//Removal is exponential, see code
	overdose_threshold = 20
	addiction_threshold = 24.5
	addiction_stage1_end = 9999//Should never end. There is no escape make your time
	var/mob/living/carbon/origin
	var/mob/living/simple_animal/hostile/retaliate/ghost/G = null
	var/antiGenetics = 255
	var/sleepytime = 0
	InverseChemVal = 0.25

/datum/reagent/fermi/astral/on_mob_life(mob/living/M) // Gives you the ability to astral project for a moment!
	M.alpha = 255
	switch(current_cycle)
		if(0)//Require a minimum
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
			sleepytime = 15*volume
	if(overdosed)
		if(prob(50))
			to_chat(G, "<span class='warning'>The high conentration of Astrogen in your blood causes you to lapse your concentration for a moment, bringing your projection back to yourself!</b></span>")
			do_teleport(G, M.loc)
	M.reagents.remove_reagent(src.id, current_cycle/2, FALSE)
	..()

/datum/reagent/fermi/astral/on_mob_delete(mob/living/carbon/M)
	G.mind.transfer_to(origin)
	qdel(G)
	if(overdosed)
		to_chat(M, "<span class='warning'>The high volume of Astrogren you just took causes you to black out momentarily as your mind snaps back to your body.</b></span>")
		M.Sleeping(sleepytime, 0)
	antiGenetics = 255
	..()

//Okay so, this might seem a bit too good, but my counterargument is that it'll likely take all round to eventually kill you this way, then you have to be revived without a body. It takes approximately 60-80 minutes to die from this.
/datum/reagent/fermi/astral/addiction_act_stage1(mob/living/carbon/M)
	if(addiction_stage < 2)
		antiGenetics = 255//Doesn't reset when you take more, which is weird for me, it should.
		M.alpha = 255 //Antigenetics is to do with stopping geneticists from turning people invisible to kill them.
	if(prob(65))
		M.alpha--
		antiGenetics--
	switch(antiGenetics)
		if(245)
			to_chat(M, "<span class='warning'>You notice your body starting to disappear, maybe you took too much Astrogen...?</b></span>")
			M.alpha--
			antiGenetics--
		if(220)
			to_chat(M, "<span class='notice'>Your addiction is only getting worse as your body disappears. Maybe you should get some more, and fast?</b></span>")
			M.alpha--
			antiGenetics--
		if(180)
			to_chat(M, "<span class='notice'>You feel fear build up in yourself as more and more of your body and consciousness begins to fade.</b></span>")
			M.alpha--
			antiGenetics--
		if(120)
			to_chat(M, "<span class='notice'>As you lose more and more of yourself, you start to think that maybe shedding your mortality isn't too bad.</b></span>")
			M.alpha--
			antiGenetics--
		if(100)
			to_chat(M, "<span class='notice'>You feel a substantial part of your soul flake off into the ethereal world, rendering yourself unclonable.</b></span>")
			M.alpha--
			antiGenetics--
			M.add_trait(TRAIT_NOCLONE) //So you can't scan yourself, then die, to metacomm. You can only use your memories if you come back as something else.
		if(80)
			to_chat(M, "<span class='notice'>You feel a thrill shoot through your body as what's left of your mind contemplates your forthcoming oblivion.</b></span>")
			M.alpha--
			antiGenetics--
		if(45)
			to_chat(M, "<span class='warning'>The last vestiges of your mind eagerly await your imminent annihilation.</b></span>")
			M.alpha--
			antiGenetics--
		if(0 to 30)
			to_chat(M, "<span class='warning'>Your body disperses from existence, as you become one with the universe.</b></span>")
			to_chat(M, "<span class='userdanger'>As your body disappears, your consciousness doesn't. Should you find a way back into the mortal coil, your memories of your previous life remain with you. (At the cost of staying in character while dead. Failure to do this may get you banned from this chem. You are still obligated to follow your directives if you play a midround antag, you do not remember the afterlife IC)</span>")//Legalised IC OOK? I have a suspicion this won't make it past the review. At least it'll be presented as a neat idea! If this is unacceptable how about the player can retain living memories across lives if they die in this way only.
			deadchat_broadcast("<span class='warning'>[M] has become one with the universe, meaning that their IC conciousness is continuous in a new life. If they find a way back to life, they are allowed to remember their previous life. Be careful what you say. If they abuse this, bwoink the FUCK outta them.</span>")
			M.visible_message("[M] suddenly disappears, their body evaporating from existence, freeing [M] from their mortal coil.")
			message_admins("[M] (ckey: [M.ckey]) has become one with the universe, and have continuous memories thoughout their lives should they find a way to come back to life (such as an inteligence potion, midround antag, ghost role).")
			qdel(M) //Approx 60minutes till death from initial addiction
	..()

/*
////////////////////////////////////////
//				MKULTA				  //
////////////////////////////////////////
The magnum opus of FermiChem -
Long and complicated, I highly recomend you look at the two other files heavily involved in this
modular_citadel/code/datums/status_effects/chems.dm - handles the subject's reactions
code/modules/surgery/organs/vocal_cords.dm - handles the enchanter speaking

HOW IT WORKS
Fermis_Reagent.dm
There's 3 main ways this chemical works; I'll start off with discussing how it's set up.
Upon reacting with blood as a catalyst, the blood is used to define who the enthraller is - thus only the creator is/can choose who the master will be. As a side note, you can't adminbus this chem, even admins have to earn it.
This uses the fermichem only proc; FermiCreate, which is basically the same as On_new, except it doesn't require "data" which is something to do with blood and breaks everything so I said bugger it and made my own proc. It basically sets up vars.
When it's first made, the creator has to drink some of it, in order to give them the vocal chords needed.
When it's given to someone, it gives them the status effect and kicks off that side of things. For every metabolism tick, it increases the enthrall tally.
Finally, if you manage to pump 100u into some poor soul, you overload them, and mindbreak them. Making them your willing, but broken slave. Which can only be reversed by; fixing their brain with mannitol and neurine (100 / 50u respectively) (or less with both),

vocal_cords.dm
This handles when the enchanter speaks - basically uses code from voice of god, but only for people with the staus effect. Most of the words are self explainitory, and has a smaller range of commands. If you're not sure what one does, it likely affects the enthrall tally, or the resist tally.
list of commands:

-mixables-
enthral_words
reward_words
punish_words
0
saymyname_words
wakeup_words
1
silence_words
antiresist_words
resist_words
forget_words
attract_words
orgasm_words
2
awoo_words
nya_words
sleep_words
strip_words
walk_words
run_words
knockdown_words
3
statecustom_words
custom_words
objective_words
heal_words
stun_words
hallucinate_words
hot_words
cold_words
getup_words
pacify_words
charge_words

Mixables can be used intersperced with other commands, 0 is commands that work on sleeper against (i.e. players enthralled to state 3, then ordered to wake up and forget, they can be triggered back instantly)
1 is for players who immediately are injected with the chem - no stuns, only a silence and something that draws them towrds them. This is the best time to try to fight it and you're likely to win by spamming resist, unless the enchantress has plans.
2 is the seconds stage, which allows removal of clothes, slowdown and light stunning. You can also make them nya and awoo, because cute.
3 is the finaly state, which allows application of a few status effects (see chem.dm) and allows custom triggers to be installed (kind of like nanites), again, see chem.dm
In a nutshell, this is the way you enthrall people, by typing messages into chat and managing cooldowns on the stronger words. You have to type words and your message strength is increases with the number of characters - if you type short messages the cooldown will be too much and the other player will overcome the chem.
I suppose people could spam gdjshogndjoadphgiuaodp but, the truth of this chem is that it mostly allows a casus beli for subs to give in, and everyones a sub on cit (mostly), so if you aujigbnadjgipagdsjk then they might resist harder cause you're a baddie and baddies don't deserve pets.
Also, the use of this chem as a murder aid is antithetic to it's design, the subject gains bonus resistance if they're hurt or hungry (I'd like to expland this more, I like the idea that you have to look after all of them otherwise they aren't as effective, kind of like tamagachis!). If this becomes a problem, I'll deal with it, I'm not happy with people abusing this chem for an easy murder. (I might make it so you an't strike your pet when health is too low.)
Additionaly, in lieu of previous statement - the pet is ordered to not kill themselves, even if ordered to.

chem.dm
oof
There's a few basic things that have to be understood with this status effect
1. There is a min loop which calculates the enthrall state of the subject, when the entrall tally is over a certain amount, it will push you up 1 phase.
0 - Sleeper
1 - initial
2 - enthralled
3 - Fully entranced
4 - mindbroken
4 can only be reached via OD, whereas you can increment up from 1 > 2 > 3. 0 is only obtainable on a state 3 pet, and it toggles between the two.

1.5 Chem warfare
Since this is a chem, it's expected that you will use all of the chemicals at your disposal. Using aphro and aphro+ will weaken the resistance of the subject, while ananphro, anaphro+, mannitol and neurine will strengthen it.
Additionally, the more aroused you are, the weaker your resistance will be, as a result players immune to aphro and anaphro give a flat bonus to the enthraller.
using furranium and hatmium on the enchanter weakens their power considerably, because they sound rediculous. "Youwe fweewing wery sweepy uwu" This completely justifies their existance.
The impure toxin for this chem increases resistance too, so if they're a bad chemist it'll be unlikely they have a good ratio (and as a secret bonus, really good chemists cann purposely make the impure chem, to use either to combat the use of it against them, or as smoke grenades to deal with a large party)

2. There is a resistance proc which occurs whenever the player presses resist. You have to press it a lot, this is intentional. If you're trying to fight the enchanter, then you can't click both. You usually will win if you just mash resist and the enchanter does nothing, so you've got to react.
Each step futher it becomes harder to resist, in state 2 it's longer, but resisting is still worthwhile. If you're not in state 3, and you've not got MKultra inside of you, you generate resistance very fast. So in some cases the better option will be to stall out any attempts to entrance you.
At the moment, resistance doesn't affect the commands - mostly because it's a way to tell if a state 3 is trying to resist. But this might change if it gets too hard to fight them off.
Durign state 3, it's impossible to resist if the enthraller is in your presence (8 tiles), you generate no resistance if so. If they're out of your range, then you start to go into the addiction processed
As your resistance is tied to your arousal, sometimes your best option is to wah

3. The addition process starts when the enthraller is out of range, it roughtly follows the five stages of grief; denial, anger, bargaining, depression and acceptance.
What it mostly does makes you sad, hurts your brain, and sometimes you lash out in anger.
Denial - minor brain damaged
bargaining - 50:50 chance of brain damage and brain healing
anger - randomly lashing out and hitting people
depression - massive mood loss, stuttering, jittering, hallucinations and brain damage
depression, again - random stunning and crying, brain damage, and resistance
acceptance - minor brain damage and resistance.
You can also resist while out of range, but you can only break free of a stange 3 enthrallment by hitting the acceptance phase with a high enough resistance.
Finally, being near your enthraller reverts the damages caused.
It is expected that if you intend to break free you'll need to use psicodine and mannitol or you'll end up in a bad, but not dead, state. This gives more work for medical!! Finally the true rational of this complicated chem comes out.

4. Status effects in status effects.
There's a few commands that give status effects, such as antiresist, which will cause resistance presses to increase the enthrallment instead, theses are called from the vocal chords.
They're mostly self explainitory; antiresist, charge, pacify and heal. Heals quite weak for obvious reasons. I'd like to add more, maybe some weak adneals with brute/exhaustion costs after the status is over. A truth serum might be neat too.
State 4 pets don't get status effects.

5. Custom triggers
Because it wasnt complicated enough already.
Custom triggers are set by stating a trigger word, which will call a sub proc, which is also defined when the trigger is Called
The effects avalible at the moment are:
Speak - forces pet to say a preallocated phrase in response to the trigger
Echo - sends a message to that player only (i.e. makes them think something)
Shock - gives them a seizure/zaps them
You can look this one up yourself - it's what you expect, it's cit
kneel - gives a short knockdown
strip - strips jumpsuit only
objective - gives the pet a new objective. This requires a high ammount of mental capasity - which is determined by how much you resist. If you resist enough during phase 1 and 2, then they can't give you an objective.
Feel free to add more.
triggers work when said by ANYONE, not just the enchanter.
This is only state 3 pets, state 4 pets cannot get custom triggers, you broke them you bully.

7. If you're an antage you get a bonus to resistance AND to enthralling. Thus it can be worth using this on both sides. It shouldn't be hard to resist as an antag. There are futher bonuses to command, Chaplains and chemist.
If you give your pet a collar then their resistance reduced too.
(I think thats everything?)

Failstates:
Blowing up the reaction produces a gas that causes everyone to fall in love with one another.

Creating a chem with a low purity will make you permanently fall in love with someone, and tasked with keeping them safe. If someone else drinks it, you fall for them.
*/

/datum/reagent/fermi/enthrall
	name = "MKUltra"
	id = "enthrall"
	description = "A forbidden deep red mixture that overwhelms a foreign body with waves of pleasure, intoxicating them into servitude. When taken by the creator, it will enhance the draw of their voice to those affected by it."
	color = "#2C051A" // rgb: , 0, 255
	taste_description = "synthetic chocolate, a base tone of alcohol, and high notes of roses"
	overdose_threshold = 100 //If this is too easy to get 100u of this, then double it please.
	DoNotSplit = TRUE
	metabolization_rate = 0.1//It has to be slow, so there's time for the effect.
	data = list("creatorID" = null, "creatorGender" = null, "creatorName" = null)
	var/creatorID  //ckey
	var/creatorGender
	var/creatorName
	var/mob/living/creator
	pH = 10
	OnMobMergeCheck = TRUE //Procs on_mob_add when merging into a human

/datum/reagent/fermi/enthrall/test
	name = "MKUltraTest"
	id = "enthrallTest"
	description = "A forbidden deep red mixture that overwhelms a foreign body with waves of joy, intoxicating them into servitude. When taken by the creator, it will enhance the draw of their voice to those affected by it."
	color = "#2C051A" // rgb: , 0, 255
	data = list("creatorID" = "honkatonkbramblesnatch", "creatorGender" = "Mistress", "creatorName" = "Fermis Yakumo")
	creatorID  = "honkatonkbramblesnatch"//ckey
	creatorGender = "Mistress"
	creatorName = "Fermis Yakumo"
	purity = 1
	DoNotSplit = TRUE

/datum/reagent/fermi/enthrall/test/on_new()
	id = "enthrall"
	..()
	creator = get_mob_by_key(creatorID)

/datum/reagent/fermi/enthrall/on_new(list/data)
	creatorID = data.["creatorID"]
	creatorGender = data.["creatorGender"]
	creatorName = data.["creatorName"]
	creator = get_mob_by_key(creatorID)

/datum/reagent/fermi/enthrall/on_mob_add(mob/living/carbon/M)
	. = ..()
	if(!ishuman(M))//Just to make sure screwy stuff doesn't happen.
		return
	if(!creatorID)
		//This happens when the reaction explodes.
		return
	var/datum/status_effect/chem/enthrall/E = M.has_status_effect(/datum/status_effect/chem/enthrall) //Somehow a beaker got here? (what)
	if(E)
		if(E.creatorID == M.ckey && creatorName != M.real_name)//If you're enthralled to yourself (from OD) and someone else tries to enthrall you, you become thralled to them instantly.
			E.enthrallID = creatorID
			E.enthrallGender = creatorGender
			E.master = get_mob_by_key(creatorID)
			to_chat(M, to_chat(M, "<span class='big love'><i>Your aldled, plastic, mind bends under the chemical influence of a new [(owner.lewd?"master":"leader")]. Your highest priority is now to stay by [creatorName]'s side, following and aiding them at all costs.</i></span>")) //THIS SHOULD ONLY EVER APPEAR IF YOU MINDBREAK YOURSELF AND THEN GET INJECTED FROM SOMEONE ELSE.
		return
	if(purity < 0.5)//Impure chems don't function as you expect
		return
	if((M.ckey == creatorID) && (creatorName == M.real_name)) //same name AND same player - same instance of the player. (should work for clones?)
		/*if(M.has_status_effect(STATUS_EFFECT_INLOVE) //Not sure if I need/want this.
			to_chat(M, "<span class='warning'><i>You are too captivated by your love to think about anything else</i></span>")
			return*/
		var/obj/item/organ/vocal_cords/Vc = M.getorganslot(ORGAN_SLOT_VOICE)
		var/obj/item/organ/vocal_cords/nVc = new /obj/item/organ/vocal_cords/velvet
		if(Vc)
			Vc.Remove(M)
		nVc.Insert(M)
		qdel(Vc)
		to_chat(M, "<span class='notice'><i>You feel your vocal chords tingle as your voice comes out in a more sultry tone.</span>")
	else
		message_admins("MKUltra: [creatorName], [creatorID], is enthralling [M.name], [M.ckey]")
		M.apply_status_effect(/datum/status_effect/chem/enthrall)

/datum/reagent/fermi/enthrall/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(purity < 0.5)//DO NOT SPLIT INTO DIFFERENT CHEM: This relies on DoNotSplit - has to be done this way.
		if (M.ckey == creatorID && creatorName == M.real_name)//If the creator drinks it, they fall in love randomly. If someone else drinks it, the creator falls in love with them.
			if(M.has_status_effect(STATUS_EFFECT_INLOVE))//Can't be enthralled when enthralled, so to speak.
				return
			var/list/seen = viewers(7, get_turf(M))
			for(var/victim in seen)
				if((victim == /mob/living/simple_animal/pet/) || (victim == M) || (!M.client) || (M.stat == DEAD))
					seen = seen - victim
			if(!seen)
				return
			M.reagents.remove_reagent(src.id, src.volume)
			FallInLove(M, pick(seen))
			return
		else // If someone else drinks it, the creator falls in love with them!
			var/mob/living/carbon/C = get_mob_by_key(creatorID)
			if(M.has_status_effect(STATUS_EFFECT_INLOVE))
				return
			if((C in viewers(7, get_turf(M))) && (C.client))
				M.reagents.remove_reagent(src.id, src.volume)
				FallInLove(C, M)
			return
		if(volume < 1)//You don't get to escape that easily
			FallInLove(pick(GLOB.player_list), M)
	if (M.ckey == creatorID && creatorName == M.real_name)//If you yourself drink it, it does nothing.
		return
	if(!M.client)
		metabolization_rate = 0 //Stops powergamers from quitting to avoid affects. but prevents affects on players that don't exist for performance.
		return
	if(metabolization_rate == 0)
		metabolization_rate = 0.5
	var/datum/status_effect/chem/enthrall/E = M.has_status_effect(/datum/status_effect/chem/enthrall)//If purity is over 5, works as intended
	if(!E)
		return
	else
		E.enthrallTally += 1
	if(prob(1))
		M.adjustBrainLoss(1)//Honestly this could be removed, in testing it made everyone brain damaged, but on the other hand, we were chugging tons of it.
	..()

/datum/reagent/fermi/enthrall/overdose_start(mob/living/carbon/M)//I made it so the creator is set to gain the status for someone random.
	. = ..()
	if (M.ckey == creatorID && creatorName == M.real_name)//If the creator drinks 100u, then you get the status for someone random (They don't have the vocal chords though, so it's limited.)
		to_chat(M, "<span class='love'><i>You are unable to resist your own charms anymore, and become a full blown narcissist.</i></span>")
		/*Old way of handling, left in as an option B
		var/list/seen = viewers(7, get_turf(M))//Sound and sight checkers
		for(var/mob/living/carbon/victim in seen)
			if(victim == M)//as much as I want you to fall for beepsky, he doesn't have a ckey
				seen = seen - victim
			if(!victim.ckey)
				seen = seen - victim
		var/mob/living/carbon/chosen = pick(seen)
		creatorID = chosen.ckey
		if (chosen.gender == "female")
			creatorGender = "Mistress"
		else
			creatorGender = "Master"
		creatorName = chosen.real_name
		creator = get_mob_by_key(creatorID)
		*/
	M.add_trait(TRAIT_PACIFISM, "MKUltra")
	var/datum/status_effect/chem/enthrall/E
	if (!M.has_status_effect(/datum/status_effect/chem/enthrall))
		M.apply_status_effect(/datum/status_effect/chem/enthrall)
		E = M.has_status_effect(/datum/status_effect/chem/enthrall)
		E.enthrallID = creatorID
		E.enthrallGender = creatorGender
		E.master = creator
	else
		E = M.has_status_effect(/datum/status_effect/chem/enthrall)
	to_chat(M, "<span class='big love'><i>Your mind shatters under the volume of the mild altering chem inside of you, breaking all will and thought completely. Instead the only force driving you now is the instinctual desire to obey and follow [creatorName]. Your highest priority is now to stay by their side at all costs.</i></span>")
	M.slurring = 100
	M.confused = 100
	E.phase = 4
	E.mental_capacity = 0
	E.customTriggers = list()

/datum/reagent/fermi/enthrall/overdose_process(mob/living/carbon/M)
	M.adjustBrainLoss(0.1)//should be 15 in total
	..()

//Creates a gas cloud when the reaction blows up, causing everyone in it to fall in love with someone/something while it's in their system.
/datum/reagent/fermi/enthrallExplo//Created in a gas cloud when it explodes
	name = "MKUltra"
	id = "enthrallExplo"
	description = "A forbidden deep red mixture that overwhelms a foreign body with waves of pleasure, intoxicating them into servitude. When taken by the creator, it will enhance the draw of their voice to those affected by it."
	color = "#2C051A" // rgb: , 0, 255
	metabolization_rate = 0.1
	taste_description = "synthetic chocolate, a base tone of alcohol, and high notes of roses."
	DoNotSplit = TRUE
	var/mob/living/carbon/love

/datum/reagent/fermi/enthrallExplo/on_mob_life(mob/living/carbon/M)//Love gas, only affects while it's in your system,Gives a positive moodlet if close, gives brain damagea and a negative moodlet if not close enough.
	if(!M.has_status_effect(STATUS_EFFECT_INLOVE))
		var/list/seen = viewers(7, get_turf(M))//Sound and sight checkers
		for(var/victim in seen)
			if((victim == /mob/living/simple_animal/pet/) || (victim == M) || (M.stat == DEAD))
				seen = seen - victim
		if(seen.len == 0)
			return
		love = pick(seen)
		if(!love)
			return
		M.apply_status_effect(STATUS_EFFECT_INLOVE, love)
		to_chat(M, "<span class='big love'>You develop overwhelmingly deep feelings for [love], your heart beginning to race as you look upon them with new eyes. You are determined to keep them safe above all other priorities.</span>")
	else
		if(get_dist(M, love) < 8)
			if(M.has_trait(TRAIT_NYMPHO)) //Add this back when merged/updated.
				M.adjustArousalLoss(5)
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "InLove", /datum/mood_event/InLove)
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "MissingLove")
		else
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "MissingLove", /datum/mood_event/MissingLove)
			SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "InLove")
			if(prob(10))
				M.Stun(10)
				M.emote("whimper")//does this exist?
				to_chat(M, "<span class='love'> You're overcome with a desire to see [love].</span>")
				M.adjustBrainLoss(1)//I found out why everyone was so damaged!
	..()

/datum/reagent/fermi/enthrallExplo/on_mob_delete(mob/living/carbon/M)
	M.remove_status_effect(STATUS_EFFECT_INLOVE)
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "InLove")
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "MissingLove")
	to_chat(M, "Your feelings for [love] suddenly vanish!")
	..()

/datum/reagent/fermi/proc/FallInLove(mob/living/carbon/Lover, mob/living/carbon/Love)
	if(Lover.has_status_effect(STATUS_EFFECT_INLOVE))
		to_chat(Lover, "<span class='warning'>You are already fully devoted to someone else!</span>")
		return
	to_chat(Lover, "<span class='love'>You develop deep feelings for [Love], your heart beginning to race as you look upon them with new eyes.</span>")
	if(Lover.mind)
		Lover.mind.store_memory("You are in love with [Love].")
	Lover.faction |= "[REF(Love)]"
	Lover.apply_status_effect(STATUS_EFFECT_INLOVE, Love)
	forge_valentines_objective(Lover, Love, TRUE)
	return

//For addiction see chem.dm

////////////////////////////////////////////////////////////////////////////////////////////////////
//										HATIMUIM
///////////////////////////////////////////////////////////////////////////////////////////////////
//Adds a heat upon your head, and tips their hat
//Also has a speech alteration effect when the hat is there
//Increase armour; 1 armour per 10u
//but if you OD it becomes negative.


/datum/reagent/fermi/hatmium //for hatterhat
	name = "Hat growth serium"
	id = "hatmium"
	description = "A strange substance that draws in a hat from the hat dimention, "
	color = "#A080H4" // rgb: , 0, 255
	taste_description = "like jerky, whiskey and an off aftertaste of a crypt"
	overdose_threshold = 25
	var/obj/item/clothing/head/hattip/hat
	DoNotSplit = TRUE
	pH = 4


/datum/reagent/fermi/hatmium/on_mob_add(mob/living/carbon/human/M)
	. = ..()
	var/items = M.get_contents()
	for(var/obj/item/W in items)
		if(W == M.head)
			if(W == /obj/item/clothing/head/hattip)
				qdel(W)
			else
				M.dropItemToGround(W, TRUE)
	hat = new /obj/item/clothing/head/hattip()
	M.equip_to_slot(hat, SLOT_HEAD, 1, 1)


/datum/reagent/fermi/hatmium/on_mob_life(mob/living/carbon/human/M)
	//hat.armor = list("melee" = (1+(current_cycle/20)), "bullet" = (1+(current_cycle/20)), "laser" = (1+(current_cycle/20)), "energy" = (1+(current_cycle/20)), "bomb" = (1+(current_cycle/20)), "bio" = (1+(current_cycle/20)), "rad" = (1+(current_cycle/20)), "fire" = (1+(current_cycle/20)), "acid" = (1+(current_cycle/20)))
	var/hatArmor = (1+(current_cycle/30))*purity
	if(!overdosed)
		hat.armor = list("melee" = hatArmor, "bullet" = hatArmor, "laser" = hatArmor, "energy" = hatArmor, "bomb" = hatArmor, "bio" = hatArmor, "rad" = hatArmor, "fire" = hatArmor)
	else
		hat.armor = list("melee" = -hatArmor, "bullet" = -hatArmor, "laser" = -hatArmor, "energy" = -hatArmor, "bomb" = -hatArmor, "bio" = -hatArmor, "rad" = -hatArmor, "fire" = -hatArmor)
	..()

////////////////////////////////////////////////////////////////////////////////////////////////////
//										FURRANIUM
///////////////////////////////////////////////////////////////////////////////////////////////////
//OwO whats this?
//Makes you nya and awoo
//At a certain amount of time in your system it gives you a fluffy tongue, if pure enough, it's permanent.

/datum/reagent/fermi/furranium
	name = "Furranium"
	id = "furranium"
	description = "OwO whats this?"
	color = "#H04044" // rgb: , 0, 255
	taste_description = "dewicious degenyewacy"
	InverseChemVal 		= 0
	var/obj/item/organ/tongue/nT
	DoNotSplit = TRUE
	pH = 5
	var/obj/item/organ/tongue/T

/datum/reagent/fermi/furranium/on_mob_life(mob/living/carbon/M)

	switch(current_cycle)
		if(1 to 9)
			if(prob(20))
				to_chat(M, "<span class='notice'>Your tongue feels... fluffy</span>")
		if(10 to 15)
			if(prob(10))
				to_chat(M, "You find yourself unable to supress the desire to meow!")
				M.emote("nya")
			if(prob(10))
				to_chat(M, "You find yourself unable to supress the desire to howl!")
				M.emote("awoo")
			if(prob(20))
				var/list/seen = viewers(5, get_turf(M))//Sound and sight checkers
				for(var/victim in seen)
					if((victim == /mob/living/simple_animal/pet/) || (victim == M))
						seen = seen - victim
				if(seen)
					to_chat(M, "You notice [pick(seen)]'s bulge [pick("OwO!", "uwu!")]")
		if(16)
			T = M.getorganslot(ORGAN_SLOT_TONGUE)
			var/obj/item/organ/tongue/nT = new /obj/item/organ/tongue/OwO
			T.Remove(M)
			nT.Insert(M)
			T.moveToNullspace()//To the zelda room.
			to_chat(M, "<span class='notice'>Youw tongue feews... weally fwuffy!!</span>")
		if(17 to INFINITY)
			if(prob(10))
				to_chat(M, "You find yourself unable to supress the desire to meow!")
				M.emote("nya")
			if(prob(10))
				to_chat(M, "You find yourself unable to supress the desire to howl!")
				M.emote("awoo")
			if(prob(20))
				var/list/seen = viewers(5, get_turf(M))//Sound and sight checkers
				for(var/victim in seen)
					if((victim = /mob/living/simple_animal/pet/) || (victim == M))
						seen = seen - victim
				if(seen)
					to_chat(M, "You notice [pick(seen)]'s bulge [pick("OwO!", "uwu!")]")
	..()

/datum/reagent/fermi/furranium/on_mob_delete(mob/living/carbon/M)
	if(purity < 0.9)//Only permanent if you're a good chemist.
		nT = M.getorganslot(ORGAN_SLOT_TONGUE)
		nT.Remove(M)
		qdel(nT)
		T.Insert(M)
		to_chat(M, "<span class='notice'>You feel your tongue.... unfluffify...?</span>")
		M.say("Pleh!")

///////////////////////////////////////////////////////////////////////////////////////////////
//Nanite removal
//Writen by Trilby!! Embellsished a little by me.

/datum/reagent/fermi/naninte_b_gone
	name = "Naninte bain"
	id = "naninte_b_gone"
	description = "A rather simple toxin to small nano machines that will kill them off at a rapid rate well in system."
	color = "#5a7267" // rgb: 90, 114, 103
	overdose_threshold = 15
	ImpureChem 			= "naninte_b_goneTox" //If you make an inpure chem, it stalls growth
	InverseChemVal 		= 0.25
	InverseChem 		= "naninte_b_goneTox" //At really impure vols, it just becomes 100% inverse
	taste_description = "what can only be described as licking a battery."
	pH = 9

/datum/reagent/fermi/naninte_b_gone/on_mob_life(mob/living/carbon/C)
	//var/component/nanites/N = M.GetComponent(/datum/component/nanites)
	GET_COMPONENT_FROM(N, /datum/component/nanites, C)
	if(isnull(N))
		return ..()
	N.nanite_volume = -0.55//0.5 seems to be the default to me, so it'll neuter them.
	..()

/datum/reagent/fermi/naninte_b_gone/overdose_process(mob/living/carbon/C)
	//var/component/nanites/N = M.GetComponent(/datum/component/nanites)
	GET_COMPONENT_FROM(N, /datum/component/nanites, C)
	if(prob(5))
		to_chat(C, "<span class='warning'>The residual voltage from the nanites causes you to seize up!</b></span>")
		C.electrocute_act(10, (get_turf(C)), 1, FALSE, FALSE, FALSE, TRUE)
	if(prob(10))
		//empulse((get_turf(C)), 3, 2)//So the nanites randomize
		var/atom/T = C
		T.emp_act(EMP_HEAVY)
		to_chat(C, "<span class='warning'>The nanintes short circuit within your system!</b></span>")
	if(isnull(N))
		return ..()
	N.nanite_volume = -2//12.5 seems crazy high?
	..()

//Unobtainable, used if SDGF is impure but not too impure
/datum/reagent/fermi/naninte_b_goneTox
	name = "Naninte bain"
	id = "naninte_b_goneTox"
	description = "Poorly made, and shocks you!"
	metabolization_rate = 1

//Increases shock events.
/datum/reagent/fermi/naninte_b_goneTox/on_mob_life(mob/living/carbon/C)//Damages the taker if their purity is low. Extended use of impure chemicals will make the original die. (thus can't be spammed unless you've very good)
	if(prob(15))
		to_chat(C, "<span class='warning'>The residual voltage in your system causes you to seize up!</b></span>")
		C.electrocute_act(10, (get_turf(C)), 1, FALSE, FALSE, FALSE, TRUE)
	if(prob(50))
		//empulse((get_turf(C)), 2, 1, 1)//So the nanites randomize
		var/atom/T = C
		T.emp_act(EMP_HEAVY)
		to_chat(C, "<span class='warning'>You feel your hair stand on end as you glow brightly for a moment!</b></span>")
	..()


///////////////////////////////////////////////////////////////////////////////////////////////
//				MISC FERMICHEM CHEMS FOR SPECIFIC INTERACTIONS ONLY
///////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/fermi/fermiAcid
	name = "Acid vapour"
	id = "fermiAcid"
	description = "Someone didn't do like an otter, and add acid to water."
	taste_description = "acid burns, ow"
	color = "#FFFFFF"
	pH = 0

/datum/reagent/fermi/fermiAcid/reaction_mob(mob/living/carbon/C, method)
	var/target = C.get_bodypart(BODY_ZONE_CHEST)
	var/acidstr = ((5-C.reagents.pH)*2)
	C.adjustFireLoss(acidstr/2, 0)
	if((method==VAPOR) && (!C.wear_mask))
		if(prob(20))
			to_chat(C, "<span class='warning'>You can feel your lungs burning!</b></span>")
		var/obj/item/organ/lungs/L = C.getorganslot(ORGAN_SLOT_LUNGS)
		L.adjustLungLoss(acidstr, C)
		C.apply_damage(acidstr/5, BURN, target)
	C.acid_act(acidstr, volume)
	..()

/datum/reagent/fermi/fermiAcid/reaction_obj(obj/O, reac_volume)
	if(ismob(O.loc)) //handled in human acid_act()
		return
	if((holder.pH > 5) || (volume < 0.1)) //Shouldn't happen, but just in case
		return
	reac_volume = round(volume,0.1)
	var/acidstr = (5-holder.pH)*2 //(max is 10)
	O.acid_act(acidstr, volume)
	..()

/datum/reagent/fermi/fermiAcid/reaction_turf(turf/T, reac_volume)
	if (!istype(T))
		return
	reac_volume = round(volume,0.1)
	var/acidstr = (5-holder.pH)
	T.acid_act(acidstr, volume)
	..()

/datum/reagent/fermi/fermiTest
	name = "Fermis Test Reagent"
	id = "fermiTest"
	description = "You should be really careful with this...! Also, how did you get this?"
	addProc = TRUE

/datum/reagent/fermi/fermiTest/on_new(datum/reagents/holder)
	..()
	if(LAZYLEN(holder.reagent_list) == 1)
		return
	else
		holder.remove_reagent("fermiTest", src.volume)//Avoiding recurrsion
	var/location = get_turf(holder.my_atom)
	if(purity < 0.34 || purity == 1)
		var/datum/effect_system/foam_spread/s = new()
		s.set_up(volume*2, location, holder)
		s.start()
	if((purity < 0.67 && purity >= 0.34)|| purity == 1)
		var/datum/effect_system/smoke_spread/chem/s = new()
		s.set_up(holder, volume*2, location)
		s.start()
	if(purity >= 0.67)
		for (var/datum/reagent/reagent in holder.reagent_list)
			if (istype(reagent, /datum/reagent/fermi))
				var/datum/chemical_reaction/fermi/Ferm  = GLOB.chemical_reagents_list[reagent.id]
				Ferm.FermiExplode(src, holder.my_atom, holder, holder.total_volume, holder.chem_temp, holder.pH)
			else
				var/datum/chemical_reaction/Ferm  = GLOB.chemical_reagents_list[reagent.id]
				Ferm.on_reaction(holder, reagent.volume)
	for(var/mob/M in viewers(8, location))
		to_chat(M, "<span class='danger'>The solution reacts dramatically, with a meow!</span>")
		playsound(get_turf(M), 'modular_citadel/sound/voice/merowr.ogg', 50, 1)
	holder.clear_reagents()

/datum/reagent/fermi/fermiTox
	name = "FermiTox"
	id = "fermiTox"
	description = "You should be really careful with this...! Also, how did you get this? You shouldn't have this!"
	data = "merge"
	color = "FFFFFF"

//I'm concerned this is too weak, but I also don't want deathmixes.
/datum/reagent/fermi/fermiTox/on_mob_life(mob/living/carbon/C, method)
	if(C.dna && istype(C.dna.species, /datum/species/jelly))
		C.adjustToxLoss(-2)
	else
		C.adjustToxLoss(2)
	..()

/datum/reagent/fermi/fermiABuffer
	name = "Acidic buffer"//defined on setup
	id = "fermiABuffer"
	description = "This reagent will consume itself and move the pH of a beaker towards 3 when added to another."
	taste_description = "an acidy sort of taste, blech."
	color = "#fbc314"
	pH = 3

//Consumes self on addition and shifts pH
/datum/reagent/fermi/fermiABuffer/on_new(datapH)
	src.data = datapH
	if(LAZYLEN(holder.reagent_list) == 1)
		return
	holder.pH = ((holder.pH * holder.total_volume)+(pH * (src.volume*3)))/(holder.total_volume + (src.volume*3)) //Shouldn't be required
	var/list/seen = viewers(5, get_turf(holder))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The beaker fizzes as the pH changes!</b></span>")
	playsound(get_turf(holder), 'sound/FermiChem/bufferadd.ogg', 50, 1)
	holder.remove_reagent(src.id, src.volume)
	..()

/datum/reagent/fermi/fermiBBuffer
	name = "Basic buffer"//defined on setup
	id = "fermiBBuffer"
	description = "This reagent will consume itself and move the pH of a beaker towards 11 when added to another."
	taste_description = "an soapy sort of taste, blech."
	color = "#3853a4"
	pH = 11

/datum/reagent/fermi/fermiBBuffer/on_new(datapH)
	src.data = datapH
	if(LAZYLEN(holder.reagent_list) == 1)
		return
	holder.pH = ((holder.pH * holder.total_volume)+(pH * (src.volume*3)))/(holder.total_volume + (src.volume*3)) //Shouldn't be required Might be..?
	var/list/seen = viewers(5, get_turf(holder))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The beaker froths as the pH changes!</b></span>")
	playsound(get_turf(holder.my_atom), 'sound/FermiChem/bufferadd.ogg', 50, 1)
	holder.remove_reagent(src.id, src.volume)
	..()

//ReagentVars
//Turns you into a cute catto while it's in your system.
//If you manage to gamble perfectly, makes you a catgirl after you transform back. But really, you shouldn't end up with that with how random it is.
/datum/reagent/fermi/secretcatchem //Should I hide this from code divers? A secret cit chem?
	name = "secretcatchem" //an attempt at hiding it
	id = "secretcatchem"
	description = "An illegal and hidden chem that turns people into cats. It's said that it's so rare and unstable that having it means you've been blessed."
	taste_description = "hairballs and cream"
	color = "#ffc224"
	var/catshift = FALSE
	var/mob/living/simple_animal/pet/cat/custom_cat/catto = null

/datum/reagent/fermi/secretcatchem/New()
	name = "Catbalti[pick("a","u","e","y")]m [pick("apex", "prime", "meow")]"

/datum/reagent/fermi/secretcatchem/on_mob_add(mob/living/carbon/human/H)
	. = ..()
	var/current_species = H.dna.species.type
	var/datum/species/mutation = /datum/species/human/felinid
	if((mutation != current_species) && (purity >= 0.8))//ONLY if purity is high, and given the stuff is random. It's very unlikely to get this to 1. It already requires felind too, so no new functionality there.
		H.set_species(mutation)
		H.gender = FEMALE
		//exception(al) handler:
		H.dna.features["mam_tail"] = "Cat"
		H.dna.features["tail_human"] = "Cat"
		H.dna.features["ears"]  = "Cat"
		H.dna.features["mam_ears"] = "Cat"
		H.dna.features["tail_lizard"] = "Cat"
		H.dna.features["mam_tail"] = "Cat"
		H.dna.features["mam_tail_animated"] = "Cat"
		H.facial_hair_style = "Shaved"
		H.verb_say = "mewls"
		catshift = TRUE
		playsound(get_turf(H), 'modular_citadel/sound/voice/merowr.ogg', 50, 1, -1)
	to_chat(H, "<span class='notice'>You suddenly turn into a cat!</span>")
	catto = new(get_turf(H.loc))
	H.mind.transfer_to(catto)
	catto.name = H.name
	catto.desc = "A cute catto! They remind you of [H] somehow."
	catto.color = "#[H.dna.features["mcolor"]]"
	H.moveToNullspace()

/datum/reagent/fermi/secretcatchem/on_mob_life(mob/living/carbon/H)
	if(prob(5))
		playsound(get_turf(catto), 'modular_citadel/sound/voice/merowr.ogg', 50, 1, -1)
		catto.say("lets out a meowrowr!*")
	..()

/datum/reagent/fermi/secretcatchem/on_mob_delete(mob/living/carbon/H)
	var/words = "Your body shifts back to normal."
	H.forceMove(catto.loc)
	catto.mind.transfer_to(H)
	if(catshift == TRUE)
		words += " ...But wait, are those ears and a tail?"
		H.say("*wag")//force update sprites.
	to_chat(H, "<span class='notice'>[words]</span>")
	qdel(catto)
