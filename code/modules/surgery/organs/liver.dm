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
	if(is_cold())
		return
	var/mob/living/carbon/C = owner

	if(istype(C))
		if(!(organ_flags & ORGAN_FAILING))//can't process reagents with a failing liver
			//metabolize reagents
			metabolic_stress_calc()
			if(damage > 10 && prob(damage/3))//the higher the damage the higher the probability
				to_chat(C, "<span class='warning'>You feel a dull throb in your abdomen.</span>")
		else
			C.liver_failure()

		if(swelling >= 10)
			pharmacokinesis()

	if(damage > maxHealth)//cap liver damage
		damage = maxHealth


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
	var/reagentCount = LAZYLEN(owner.reagents.reagent_list)
	switch(metabolic_stress)
		if(-INFINITY to -10)
			ignoreTox = TRUE
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, 0.5, ORGAN_TREAT_CHRONIC)
			owner.adjustToxLoss(-0.2, TRUE, TRUE)
		if(-10 to -0.1)
			ignoreTox = TRUE
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, 0.25, ORGAN_TREAT_ACUTE)
			owner.adjustToxLoss(-0.1, TRUE, TRUE)
		if(-0.1 to 15)
			if(damage != 0)
				passive_regen(1/(reagentCount+1)) //pesky zeroes!
			ignoreTox = TRUE
		if(15 to 25)
			applyOrganDamage(0.05)
		if(25 to 40)
			applyOrganDamage(0.1)
			owner.adjustToxLoss(0.05, TRUE, TRUE)
		if(40 to 60)
			applyOrganDamage(0.15)
			owner.adjustToxLoss(0.15, TRUE, TRUE)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.1)
		if(60 to 90)
			applyOrganDamage(0.2)
			owner.adjustToxLoss(0.2, TRUE, TRUE)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.15)
			owner.adjustStaminaLoss(1)
			swelling += 0.02
		if(90 to INFINITY)
			applyOrganDamage(0.25)
			owner.adjustToxLoss(0.25, TRUE, TRUE)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.2)
			owner.adjustStaminaLoss(2)
			swelling += 0.1


	if(filterToxins)
		//handle liver toxin filtration
		for(var/I in owner.reagents.reagent_list)
			var/datum/reagent/pickedreagent = I
			if(istype(pickedreagent, /datum/reagent/toxin))
				var/datum/reagent/toxin/T = I
				var/stress = 0.5
				if((T.toxpwr/reagentCount) > stress)
					stress = (T.toxpwr/reagentCount)
				if(GLOB.Debug2)
					message_admins("Stress:[stress], [ignoreTox ? (stress + (T.current_cycle/reagentCount)) : T.toxpwr/reagentCount]), cycle:[T.current_cycle] no.reagents:[reagentCount]")
				if(T.volume <= toxTolerance*(1-(damage/100)))
					C.reagents.remove_reagent(initial(pickedreagent.id), toxTolerance)
					adjustMetabolicStress(stress)
					continue
				if(ignoreTox)
					stress = stress + (T.current_cycle/reagentCount)
					T.current_cycle++
					C.reagents.remove_reagent(initial(pickedreagent.id), pickedreagent.metabolization_rate)
					adjustMetabolicStress(stress)
					continue
				adjustMetabolicStress(stress)

	if(HAS_TRAIT(owner, TRAIT_TOXINLOVER))
		ignoreTox = FALSE
	if(ignoreTox)
		ignoreTox = /datum/reagent/toxin //lil hacky but it works

	C.reagents.metabolize(C, can_overdose=TRUE, chem_resist = ignoreTox)

	var/metabolic_replenish = 0.25-((2*(((damage*100)/maxHealth)/100))/10)//0.05 - 0.25
	equilibrateMetabolicStress(metabolic_replenish)

/obj/item/organ/liver/proc/adjustMetabolicStress(amount, minimum, maximum, absolute = FALSE)
	if(!amount)
		return FALSE
	if(!maximum)
		maximum = 105
	if(!minimum)
		minimum = min(0, metabolic_stress)
	if(metabolic_stress>=maximum)
		return FALSE
	metabolic_stress = CLAMP(metabolic_stress + amount, minimum*minStressMod, maximum)
	return TRUE

/obj/item/organ/liver/proc/equilibrateMetabolicStress(amount, _absolute = FALSE)
	if(metabolic_stress > 0)
		adjustMetabolicStress(-amount, absolute = _absolute)
	else if (metabolic_stress < 0)
		adjustMetabolicStress(amount, absolute = _absolute)

/obj/item/organ/liver/fly
	name = "insectoid liver"
	icon_state = "liver-x" //xenomorph liver? It's just a black liver so it fits.
	desc = "A mutant liver designed to handle the unique diet of a flyperson."
	alcohol_tolerance = 0.007 //flies eat vomit, so a lower alcohol tolerance is perfect!

/obj/item/organ/liver/plasmaman
	name = "reagent processing crystal"
	icon_state = "liver-p"
	desc = "A large crystal that is somehow capable of metabolizing chemicals, these are found in plasmamen."

/obj/item/organ/liver/slime
	name = "Filturatum"
	icon_state = "liver-s"
	desc = "A sponge like organ that absorbs and filters out impure reagents when unstressed."
	maxHealth = 90 //Slimes can treat liver damage a lot easier than most.

/obj/item/organ/liver/slime/on_life()
	.=..()
	if(metabolic_stress < -95) //Because metabolic stress doesn't proc on a failed liver.
		owner.cureOrganDamage(ORGAN_SLOT_LIVER, 0.05, ORGAN_TREAT_END_STAGE)

/obj/item/organ/liver/slime/metabolic_stress_calc()
	var/mob/living/carbon/C = owner
	var/ignoreMeds = FALSE
	var/reagentCount = LAZYLEN(owner.reagents.reagent_list)
	switch(metabolic_stress)
		if(-INFINITY to -95)
			ignoreMeds = TRUE
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, 0.05, ORGAN_TREAT_END_STAGE)
			owner.Jitter(5)
			C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.15)
			owner.Dizzy(2)
		if(-95 to -80)
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, 0.05, ORGAN_TREAT_CHRONIC)
			ignoreMeds = TRUE
			owner.Jitter(2)
			owner.Dizzy(1.5)
			C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.1)
		if(-80 to -55)
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, 0.1, ORGAN_TREAT_CHRONIC)
			ignoreMeds = TRUE
			owner.Jitter(1.5)
			owner.Dizzy(1)
			C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.05)
		if(-50 to -35)
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, 0.35, ORGAN_TREAT_CHRONIC)
			owner.Jitter(0.5)
			owner.adjustToxLoss(-0.05, TRUE, TRUE)
		if(-35 to -20)
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, 0.25, ORGAN_TREAT_CHRONIC)
		if(-25 to -10)
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, 0.4, ORGAN_TREAT_ACUTE)
			owner.adjustToxLoss(-0.2, TRUE, TRUE)
		if(-10 to -0.1)
			owner.cureOrganDamage(ORGAN_SLOT_LIVER, 0.2, ORGAN_TREAT_ACUTE)
			owner.adjustToxLoss(-0.05, TRUE, TRUE)
		if(-0.1 to 15)
			if(damage != 0)
				passive_regen(1/(reagentCount+1)) //pesky zeroes!
		if(15 to 25)
			applyOrganDamage(0.05)
		if(25 to 40)
			applyOrganDamage(0.1)
			owner.adjustToxLoss(0.05, TRUE, TRUE)
		if(40 to 60)
			applyOrganDamage(0.15)
			owner.adjustToxLoss(0.15, TRUE, TRUE)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.1)
			owner.slurring += 1
		if(60 to 90)
			applyOrganDamage(0.2)
			owner.adjustToxLoss(0.2, TRUE, TRUE)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.15)
			owner.adjustStaminaLoss(1)
			swelling += 0.02
			owner.slurring += 1
		if(90 to INFINITY)
			applyOrganDamage(0.25)
			owner.adjustToxLoss(0.25, TRUE, TRUE)
			owner.adjustOrganLoss(ORGAN_SLOT_HEART, 0.2)
			owner.adjustStaminaLoss(2)
			swelling += 0.1
			owner.slurring += 2


	if(filterToxins)
		//handle liver toxin filtration
		for(var/I in owner.reagents.reagent_list)
			var/datum/reagent/pickedreagent = I
			//toxins reduce stress
			if(istype(pickedreagent, /datum/reagent/toxin))
				var/datum/reagent/toxin/T = I
				adjustMetabolicStress(-(T.metabolization_rate*T.toxpwr), absolute = TRUE)

			//medicines apply stress
			if(istype(pickedreagent, /datum/reagent/medicine))
				var/datum/reagent/medicine/M = I
				if(M.slime_friendly)
					continue
				adjustMetabolicStress(M.metabolization_rate/4, absolute = TRUE)

	if(ignoreMeds) //If we're really unstressed, medicines are ignored.
		ignoreMeds = /datum/reagent/medicine

	C.reagents.metabolize(C, can_overdose=TRUE, chem_resist = ignoreMeds)

	var/metabolic_replenish = 0.15-(((((damage*100)/maxHealth)/100))/10) //0.05 - 0.15 - slower regen
	equilibrateMetabolicStress(metabolic_replenish, TRUE)

//Slimes are inverse
/obj/item/organ/liver/slime/adjustMetabolicStress(amount, minimum, maximum, absolute = FALSE)
	if(!amount)
		return FALSE
	if(!absolute)
		amount -= amount //Inverted metabolic effects! Toxins and impurities heal, medicines, etc cause it.
	if(!maximum)
		maximum = 105
	if(!minimum)
		minimum = -100
	if(metabolic_stress>=maximum)
		return FALSE
	metabolic_stress = CLAMP(metabolic_stress + amount, minimum*minStressMod, maximum)
	return TRUE

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
