/datum/species/human
	name = "Human"
	id = SPECIES_HUMAN
	default_color = "FFFFFF"

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,MUTCOLORS_PARTSONLY,WINGCOLOR,HAS_FLESH,HAS_BONE)
	mutant_bodyparts = list("mcolor" = "FFFFFF", "mcolor2" = "FFFFFF","mcolor3" = "FFFFFF","tail_human" = "None", "ears" = "None", "taur" = "None", "deco_wings" = "None", "legs" = "Plantigrade")
	use_skintones = USE_SKINTONES_GRAYSCALE_CUSTOM
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED

	tail_type = "tail_human"
	wagging_type = "waggingtail_human"
	species_category = SPECIES_CATEGORY_BASIC

/datum/species/human/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/human/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()
