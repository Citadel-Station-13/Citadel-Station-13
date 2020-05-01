/obj/item/organ/appendix
	name = "appendix"
	icon_state = "appendix"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_APPENDIX
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	now_failing = "<span class='warning'>An explosion of pain erupts in your lower right abdomen!</span>"
	now_fixed = "<span class='info'>The pain in your abdomen has subsided.</span>"

	var/inflamed

/obj/item/organ/appendix/on_life()
	. = ..()
	if(. || !owner)
		return
	owner.adjustToxLoss(4, TRUE, TRUE)	//forced to ensure people don't use it to gain tox as slime person

/obj/item/organ/appendix/update_icon_state()
	if(inflamed)
		icon_state = "appendixinflamed"
		name = "inflamed appendix"
	else
		icon_state = "appendix"
		name = "appendix"

/obj/item/organ/appendix/Remove(special = FALSE)
	if(owner)
		for(var/datum/disease/appendicitis/A in owner.diseases)
			A.cure()
			inflamed = TRUE
	update_icon()
	..()

/obj/item/organ/appendix/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	..()
	if(inflamed)
		M.ForceContractDisease(new /datum/disease/appendicitis(), FALSE, TRUE)

/obj/item/organ/appendix/prepare_eat()
	var/obj/S = ..()
	if(inflamed)
		S.reagents.add_reagent(/datum/reagent/toxin/bad_food, 5)
	return S
