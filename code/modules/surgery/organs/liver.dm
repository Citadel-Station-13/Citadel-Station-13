#define LIVER_DEFAULT_HEALTH 100 //amount of damage required for liver failure
#define LIVER_DEFAULT_TOX_TOLERANCE 3 //amount of toxins the liver can filter out
#define LIVER_DEFAULT_TOX_LETHALITY 0.01 //lower values lower how harmful toxins are to the liver

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

	high_threshold_passed = "<span class='warning'>You feel a stange ache in your abdomen, almost like a stitch. This pain is encumbering your movements.</span>"
	high_threshold_cleared = "<span class='notice'>The stitching ache in your abdomen passes away, unencumbering your movements.</span>"
	now_fixed = "<span class='notice'>The stabbing pain in your abdomen slowly calms down into a more tolerable ache.</span>"

	var/alcohol_tolerance = ALCOHOL_RATE//affects how much damage the liver takes from alcohol
	var/toxTolerance = LIVER_DEFAULT_TOX_TOLERANCE//maximum amount of toxins the liver can just shrug off
	var/toxLethality = LIVER_DEFAULT_TOX_LETHALITY//affects how much damage toxins do to the liver
	var/filterToxins = TRUE //whether to filter toxins
	var/cachedmoveCalc = 1

/obj/item/organ/liver/on_life()
	. = ..()
	if(!. || !owner)//can't process reagents with a failing liver
		return

	if(filterToxins && !HAS_TRAIT(owner, TRAIT_TOXINLOVER))
		//handle liver toxin filtration
		for(var/datum/reagent/toxin/T in owner.reagents.reagent_list)
			var/thisamount = owner.reagents.get_reagent_amount(T.type)
			if (thisamount && thisamount <= toxTolerance)
				owner.reagents.remove_reagent(T.type, 1)
			else
				damage += (thisamount*toxLethality)

	//metabolize reagents
	owner.reagents.metabolize(owner, can_overdose=TRUE)

	if(damage > 10 && prob(damage/3))//the higher the damage the higher the probability
		to_chat(owner, "<span class='warning'>You feel a dull pain in your abdomen.</span>")

/obj/item/organ/liver/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent(/datum/reagent/iron, 5)
	return S

/obj/item/organ/liver/applyOrganDamage(d, maximum = maxHealth)
	. = ..()
	if(!. || QDELETED(owner))
		return
	if(damage >= high_threshold)
		var/move_calc = 1+((round(damage) - high_threshold)/(high_threshold/3))
		owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/liver_cirrhosis, multiplicative_slowdown = move_calc)
		sizeMoveMod(move_calc, owner)
	else
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/liver_cirrhosis)
		sizeMoveMod(1, owner)

/obj/item/organ/liver/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(. && damage >= high_threshold)
		var/move_calc = 1+((round(damage) - high_threshold)/(high_threshold/3))
		M.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/liver_cirrhosis, multiplicative_slowdown = move_calc)
		sizeMoveMod(move_calc, owner)

/obj/item/organ/liver/Remove(special = FALSE)
	if(!QDELETED(owner))
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/liver_cirrhosis)
		sizeMoveMod(1, owner)
	return ..()

/obj/item/organ/liver/proc/sizeMoveMod(value, mob/living/carbon/C)
	if(cachedmoveCalc == value)
		return
	C.next_move_modifier /= cachedmoveCalc
	C.next_move_modifier *= value
	cachedmoveCalc = value

/obj/item/organ/liver/fly
	name = "insectoid liver"
	icon_state = "liver-x" //xenomorph liver? It's just a black liver so it fits.
	desc = "A mutant liver designed to handle the unique diet of a flyperson."
	alcohol_tolerance = 0.007 //flies eat vomit, so a lower alcohol tolerance is perfect!

/obj/item/organ/liver/plasmaman
	name = "reagent processing crystal"
	icon_state = "liver-p"
	desc = "A large crystal that is somehow capable of metabolizing chemicals, these are found in plasmamen."

/obj/item/organ/liver/ipc
	name = "reagent processing liver"
	icon_state = "liver-c"

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
	toxTolerance = 15 //can shrug off up to 15u of toxins
	toxLethality = 0.008 //20% less damage than a normal liver

/obj/item/organ/liver/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(1)
			damage+=100
		if(2)
			damage+=50
