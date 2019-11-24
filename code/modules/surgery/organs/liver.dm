#define LIVER_DEFAULT_HEALTH 100 //amount of damage required for liver failure
#define LIVER_DEFAULT_TOX_TOLERANCE 2 //amount of toxins the liver can filter out
#define LIVER_DEFAULT_TOX_LETHALITY 0.1 //lower values lower how harmful toxins are to the liver
#define LIVER_SWELLING_MOVE_MODIFY "pharma"

/obj/item/organ/liver
	name = "liver"
	icon_state = "liver"
	w_class = WEIGHT_CLASS_NORMAL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LIVER
	desc = "Pairing suggestion: chianti and fava beans."

	maxHealth = STANDARD_ORGAN_THRESHOLD
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	var/alcohol_tolerance = ALCOHOL_RATE//affects how much damage the liver takes from alcohol
	var/failing //is this liver failing?
	var/toxTolerance = LIVER_DEFAULT_TOX_TOLERANCE//maximum amount of toxins the liver can just shrug off
	var/toxLethality = LIVER_DEFAULT_TOX_LETHALITY//affects how much damage toxins do to the liver
	var/filterToxins = TRUE //whether to filter toxins
	var/swelling = 0
	var/cachedmoveCalc = 1
	var/metabolic_stress = 0
	var/minStressMod = 1 //modifies the minimum it can go to in case of trauma.

/obj/item/organ/liver/on_life()
	var/mob/living/carbon/C = owner

	if(istype(C))
		if(!(organ_flags & ORGAN_FAILING))//can't process reagents with a failing liver
			//metabolize reagents
			metabolic_stress_calc()
			if(damage > 10 && prob(damage/3))//the higher the damage the higher the probability
				to_chat(C, "<span class='warning'>You feel a dull throb in your abdomen.</span>")
		else
			C.liver_failure()

	if(damage > maxHealth)//cap liver damage
		damage = maxHealth

	if(swelling >= 10)
		pharmacokinesis()



/obj/item/organ/liver/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("iron", 5)
	return S

//Just in case
/obj/item/organ/liver/Remove(mob/living/carbon/M, special = 0)
	..()
	M.remove_movespeed_modifier(LIVER_SWELLING_MOVE_MODIFY)
	M.ResetBloodVol() //At the moment, this shouldn't allow application twice. You either have this OR a thirsty ferret.
	sizeMoveMod(1, M)

//Applies some of the effects to the patient.
/obj/item/organ/liver/proc/pharmacokinesis()
	var/moveCalc = 1+((round(swelling) - 9)/3)
	if(moveCalc == cachedmoveCalc)//reduce calculations
		return
	if(prob(5))
		to_chat(owner, "<span class='notice'>You feel a stange ache in your side, almost like a stitch. This pain is affecting your movements and making you feel lightheaded.</span>")
	var/mob/living/carbon/human/H = owner
	H.add_movespeed_modifier(LIVER_SWELLING_MOVE_MODIFY, TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = moveCalc)
	H.AdjustBloodVol(moveCalc/3)
	sizeMoveMod(moveCalc, H)

/obj/item/organ/liver/proc/sizeMoveMod(var/value, mob/living/carbon/human/H)
	if(cachedmoveCalc == value)
		return
	H.next_move_modifier /= cachedmoveCalc
	H.next_move_modifier *= value
	cachedmoveCalc = value

/obj/item/organ/liver/proc/metabolic_stress_calc()
	var/mob/living/carbon/C = owner
	var/ignoreTox = FALSE
	switch(metabolic_stress)
		if(-INFINITY to -10)
			ignoreTox = TRUE
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, -0.2, ORGAN_TREAT_CHRONIC)
			owner.adjustToxLoss(-0.2, TRUE)
		if(-10 to 0)
			ignoreTox = TRUE
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, -0.1, ORGAN_TREAT_ACUTE)
			owner.adjustToxLoss(-0.1, TRUE)
		if(0 to 15)
			ignoreTox = TRUE
		if(15 to 25)
			ignoreTox = TRUE
			applyOrganDamage(0.1)
		if(25 to 40)
			applyOrganDamage(0.15)
			owner.adjustToxLoss(0.1, TRUE)
		if(40 to 60)
			applyOrganDamage(0.2)
			owner.adjustToxLoss(0.2, TRUE)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.2)
		if(60 to 85)
			applyOrganDamage(0.25)
			owner.adjustToxLoss(0.25, TRUE)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.25)
			owner.adjustStaminaLoss(0.25)
		if(85 to INFINITY)
			applyOrganDamage(0.3)
			owner.adjustToxLoss(0.3, TRUE)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.3)
			owner.adjustStaminaLoss(0.3)
			swelling += 0.1



	if(filterToxins && !HAS_TRAIT(owner, TRAIT_TOXINLOVER))
		//handle liver toxin filtration
		for(var/I in owner.reagents.reagent_list)
			var/datum/reagent/pickedreagent = I
			if(istype(pickedreagent, /datum/reagent/toxin))
				var/datum/reagent/toxin/T = pickedreagent
				var/stress = 0.5
				if(T.toxpwr > stress)
					stress = T.toxpwr
				if(metabolic_stress <= 15)
					if(T.volume <= toxTolerance)
						C.reagents.remove_reagent(initial(pickedreagent.id), 1)
						adjustMetabolicStress(stress)
						continue

				adjustMetabolicStress(stress)
				if(ignoreTox)
					C.reagents.remove_reagent(initial(pickedreagent.id), pickedreagent.metabolization_rate)
					continue
				//damage += (stress*toxLethality)

			C.reagents.metabolize(C, can_overdose=TRUE)


	var/metabolic_replenish = (4-(((damage*100)/maxHealth)/25))/10
	adjustMetabolicStress(-metabolic_replenish)

/obj/item/organ/liver/proc/adjustMetabolicStress(amount, minimum, maximum)
	if(!amount)
		return FALSE
	if(!maximum)
		maximum = INFINITY
	if(!minimum)
		minimum = 0
	if(metabolic_stress>=maximum)
		return FALSE
	metabolic_stress = CLAMP(metabolic_stress + amount, minimum*minStressMod, maximum)
	return TRUE

/obj/item/organ/liver/fly
	name = "insectoid liver"
	icon_state = "liver-x" //xenomorph liver? It's just a black liver so it fits.
	desc = "A mutant liver designed to handle the unique diet of a flyperson."
	alcohol_tolerance = 0.007 //flies eat vomit, so a lower alcohol tolerance is perfect!

/obj/item/organ/liver/plasmaman
	name = "reagent processing crystal"
	icon_state = "liver-p"
	desc = "A large crystal that is somehow capable of metabolizing chemicals, these are found in plasmamen."

/obj/item/organ/liver/cybernetic
	name = "cybernetic liver"
	icon_state = "liver-c"
	desc = "An electronic device designed to mimic the functions of a human liver. It has no benefits over an organic liver, but is easy to produce."
	organ_flags = ORGAN_SYNTHETIC
	maxHealth = 1.1 * STANDARD_ORGAN_THRESHOLD

/obj/item/organ/liver/cybernetic/upgraded
	name = "upgraded cybernetic liver"
	icon_state = "liver-c-u"
	desc = "An upgraded version of the cybernetic liver, designed to improve upon organic livers. It is resistant to alcohol poisoning and is very robust at filtering toxins."
	alcohol_tolerance = 0.001
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 5 //can shrug off up to 15u of toxins
	toxLethality = 0.08 //20% less damage than a normal liver

/obj/item/organ/liver/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(1)
			damage+=100
		if(2)
			damage+=50
