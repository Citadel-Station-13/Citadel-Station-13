/obj/item/organ/stomach
	name = "stomach"
	icon_state = "stomach"
	w_class = WEIGHT_CLASS_NORMAL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_STOMACH
	attack_verb = list("gored", "squished", "slapped", "digested")
	desc = "Onaka ga suite imasu."
	var/disgust_metabolism = 1

	healing_factor = STANDARD_ORGAN_HEALING*3
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = "<span class='info'>Your stomach flashes with pain before subsiding. Food doesn't seem like a good idea right now.</span>"
	high_threshold_passed = "<span class='warning'>Your stomach flares up with constant pain- you can hardly stomach the idea of food right now!</span>"
	high_threshold_cleared = "<span class='info'>The pain in your stomach dies down for now, but food still seems unappealing.</span>"
	low_threshold_cleared = "<span class='info'>The last bouts of pain in your stomach have died out.</span>"

/obj/item/organ/stomach/on_life()
	if(is_cold())
		return
	var/datum/reagent/consumable/nutriment/Nutri
	var/mob/living/carbon/C = owner
	var/mob/living/carbon/human/H = owner
	if(ishuman(owner))
		if(!(organ_flags & ORGAN_FAILING))
			H.dna.species.handle_digestion(H)
		handle_disgust(H)

	if(!C.reagents)
		return
	var/deltapH = C.reagents.pH
	if(deltapH>7)
		deltapH = 14-deltapH
	switch(C.reagents.pH)
		if(-INFINITY to 2)
			applyOrganDamage(0.25)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.2) //heartburn!
			owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, 3)
			owner.adjustOrganLoss(ORGAN_SLOT_TONGUE, 1)
			C.apply_damage(1, BURN, C.get_bodypart(BODY_ZONE_CHEST))
			if(prob(10))
				to_chat("You feel a burning sensation in your chest!")
		if(2 to 4)
			owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, 1.5)
			applyOrganDamage(0.15)
		if(4 to 5.5)
			applyOrganDamage(0.1)
		if(5.5 to INFINITY)
			passive_regen()

	if(organ_flags & ORGAN_FAILING)
		return
	//stomach acid stuff
	if(C.reagents.pH > 7.25)
		C.reagents.pH -= 0.1-(damage/1000)
	else if (C.reagents.pH < 6.75)
		C.reagents.pH += 0.1-(damage/1000)

	var/datum/reagent/metabolic/stomach_acid/SA = C.reagents.has_reagent("stomach_acid")
	if(!SA)
		owner.reagents.add_reagent("stomach_acid", 1)
		applyOrganDamage(5)
	else if(SA.volume < 50)
		SA.volume = CLAMP(SA.volume + 1, 0, 50)

	if(damage < low_threshold)
		return

	Nutri = locate(/datum/reagent/consumable/nutriment) in C.reagents.reagent_list

	if(Nutri)
		if(prob((damage/40) * Nutri.volume * Nutri.volume))
			C.vomit(damage)
			to_chat(C, "<span class='warning'>Your stomach reels in pain as you're incapable of holding down all that food!</span>")

	else if(Nutri && damage > high_threshold)
		if(prob((damage/10) * Nutri.volume * Nutri.volume))
			C.vomit(damage)
			to_chat(C, "<span class='warning'>Your stomach reels in pain as you're incapable of holding down all that food!</span>")





/obj/item/organ/stomach/proc/handle_disgust(mob/living/carbon/human/H)
	if(H.disgust)
		var/pukeprob = 5 + 0.05 * H.disgust
		if(H.disgust >= DISGUST_LEVEL_GROSS)
			if(prob(10))
				H.stuttering += 1
				H.confused += 2
			if(prob(10) && !H.stat)
				to_chat(H, "<span class='warning'>You feel kind of iffy...</span>")
			H.jitteriness = max(H.jitteriness - 3, 0)
		if(H.disgust >= DISGUST_LEVEL_VERYGROSS)
			if(prob(pukeprob)) //iT hAndLeS mOrE ThaN PukInG
				H.confused += 2.5
				H.stuttering += 1
				H.vomit(10, 0, 1, 0, 1, 0)
			H.Dizzy(5)
		if(H.disgust >= DISGUST_LEVEL_DISGUSTED)
			if(prob(25))
				H.blur_eyes(3) //We need to add more shit down here

		H.adjust_disgust(-0.5 * disgust_metabolism)
	switch(H.disgust)
		if(0 to DISGUST_LEVEL_GROSS)
			H.clear_alert("disgust")
			SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "disgust")
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			H.throw_alert("disgust", /obj/screen/alert/gross)
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "disgust", /datum/mood_event/gross)
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			H.throw_alert("disgust", /obj/screen/alert/verygross)
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "disgust", /datum/mood_event/verygross)
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			H.throw_alert("disgust", /obj/screen/alert/disgusted)
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "disgust", /datum/mood_event/disgusted)

/obj/item/organ/stomach/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	.=..()
	if(owner.reagents)
		owner.reagents.add_reagent("stomach_acid", 50)

/obj/item/organ/stomach/Remove(mob/living/carbon/M, special = 0)
	var/mob/living/carbon/human/H = owner
	if(istype(H))
		H.clear_alert("disgust")
		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "disgust")
	if(owner.reagents)
		owner.reagents.remove_reagent("stomach_acid", 50)
	..()

/obj/item/organ/stomach/fly
	name = "insectoid stomach"
	icon_state = "stomach-x" //xenomorph liver? It's just a black liver so it fits.
	desc = "A mutant stomach designed to handle the unique diet of a flyperson."

/obj/item/organ/stomach/plasmaman
	name = "digestive crystal"
	icon_state = "stomach-p"
	desc = "A strange crystal that is responsible for metabolizing the unseen energy force that feeds plasmamen."
