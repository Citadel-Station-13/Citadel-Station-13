/datum/species/human
	name = "Human"
	id = "human"
	default_color = "FFFFFF"
	species_traits = list(MUTCOLORS_PARTSONLY,SPECIES_ORGANIC,EYECOLOR,HAIR,FACEHAIR,LIPS)
	mutant_bodyparts = list("mam_tail", "mam_ears", "wings", "taur")
	default_features = list("mcolor" = "FFF", "mam_tail" = "None", "mam_ears" = "None", "wings" = "None", "taur" = "none")
	use_skintones = 1
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED


/datum/species/human/qualifies_for_rank(rank, list/features)
	return TRUE

//Curiosity killed the cat's wagging tail.
/datum/species/human/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

/datum/species/human/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		H.endTailWag()
	. = ..()

/datum/species/human/space_move(mob/living/carbon/human/H)
	var/obj/item/device/flightpack/F = H.get_flightpack()
	if(istype(F) && (F.flight) && F.allow_thrust(0.01, src))
		return TRUE

/datum/species/human/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	if(H.dna.features["ears"] == "Cat")
		mutantears = /obj/item/organ/ears/cat
	if(H.dna.features["tail_human"] == "Cat")
		mutanttail = /obj/item/organ/tail/cat
	..()
