//Fermichem!!
//Fun chems for all the family

//MCchem
//BE PE chemical
//Angel/astral chemical

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
	addiction_stage3_end = 40
	addiction_stage4_end = 55 //Incase it's too long

/obj/item/reagent/fermi/eigenstate/Initialize()
	//. = ..() Unneeded?
	var/turf/open/T = get_turf(src)//Sets up coordinate of where it was created

/datum/reagent/fermi/eigenstate/on_mob_life(mob/living/carbon/M) //Teleports to chemistry!
	if(holder.!has_reagent("eigenstate"))
	var/turf/open/T2 = get_turf(src)	//sets up return point
	to_chat(M, "<span class='userdanger'>You feel your wavefunction split!</span>")
	do_sparks(5,FALSE,src)
	src.forceMove(T) //Teleports to creation location
	do_sparks(5,FALSE,src)

/datum/reagent/fermi/eigenstate/on_mob_delete(mob/living/M) //returns back to original location
	do_sparks(5,FALSE,src)
	to_chat(M, "<span class='userdanger'>You feel your wavefunction collapse!</span>")
	src.forceMove(T2) //Teleports home
	do_sparks(5,FALSE,src)

/datum/reagent/fermi/eigenstate/overdose_start(mob/living/M) //Overdose, makes you teleport randomly
	if(10)
		to_chat(M, "<span class='userdanger'>Oh god, you feel like your wavefunction is about to hurl.</span>")
		M.Jitter(10)

	if(15 to INFINITY)
		do_sparks(5,FALSE,src)
		do_teleport(src, get_turf(src), 50, asoundin = 'sound/effects/phasein.ogg')
		do_sparks(5,FALSE,src)
		M.reagents.remove_reagent("eigenstate",1)//So you're not stuck for 10 minutes teleporting


	//..() //loop function


/datum/reagent/fermi/eigenstate/addiction_act_stage1(mob/living/M) //Welcome to Fermis' wild ride.
	to_chat(M, "<span class='userdanger'>Your wavefunction feels like it's been ripped in half. You feel empty inside.</span>")
	M.Jitter(10)
	M.nutrition = M.nutrition - (M.nutrition/10)

/datum/reagent/fermi/eigenstate/addiction_act_stage2(mob/living/M)
	to_chat(M, "<span class='userdanger'>You start to convlse violently as you feel your consciousness split and merge across realities as your possessions fly wildy off your body.</span>")
	M.Jitter(50)
	M.AdjustKnockdown(-40, 0)
	for(var/obj/item/I in mob.get_contents()); do_teleport(I, get_turf(I), 5, no_effects=TRUE);

/datum/reagent/fermi/eigenstate/addiction_act_stage3(mob/living/M)//Pulls multiple copies of the character from alternative realities while teleporting them around!
	M.Jitter(100)
	M.AdjustKnockdown(-40, 0)
	to_chat(M, "<span class='userdanger'>Your eigenstate starts to rip apart, causing a localised collapsed field as you're ripped from alternative universes, trapped around the densisty of the eigenstate event horizon.</span>")

	//Clone function - spawns a clone then deletes it - simulates multiple copies of the player teleporting in
	if(1)
		var/typepath = owner.type
		clone = new typepath(owner.loc)
		var/mob/living/carbon/O = owner
		var/mob/living/carbon/C = clone
		if(istype(C) && istype(O))
			C.real_name = O.real_name
			O.dna.transfer_identity(C)
			C.updateappearance(mutcolor_update=1)
			visible_message("[M] collapses in from an alternative reality!")
	if(2)
		do_teleport(C, get_turf(C), 3, no_effects=TRUE) //teleports clone so it's hard to find the real one!
	if(3)
		qdel(C) //Deletes CLONE, or at least I hope it is.
		visible_message("[M] is snapped across to a different alternative reality!")
		.=1 //counter

	do_teleport(src, get_turf(src), 3, no_effects=TRUE) //Teleports player randomly
	//..() //loop function

/datum/reagent/fermi/eigenstate/addiction_act_stage4(mob/living/M) //Thanks for riding Fermis' wild ride. Mild jitter and player buggery.
	M.Jitter(50)
	M.AdjustKnockdown(0, 0)
	to_chat(M, "<span class='userdanger'>You feel your eigenstate settle, snapping an alternative version of yourself into reality. All your previous memories are lost and replaced with the alternative version of yourself. This version of you feels more [pick("affectionate", "happy", "lusty", "radical", "shy", "ambitious", "frank", "voracious", "sensible", "witty")] than your pervious self, sent to god knows what universe.</span>")
	mob.emote("me",1,"gasps and gazes around in a bewildered and highly confused fashion!",TRUE)
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "Alternative dimension", /datum/mood_event/eigenstate)

//eigenstate END
