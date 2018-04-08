/datum/species/turian
	name = "Turian"
	id = "turian"
	say_mod = "talks "
	default_color = "00FF00"
	blacklisted = 0
	sexes = 1
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,SPECIES_ORGANIC)
	mutant_bodyparts = list("turian_face_plate", "turian_face_paint")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF","turian_face_paint" = "None")
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/mammal
	liked_food = MEAT | FRIED
	disliked_food = TOXIC

/datum/species/turian/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/turian/on_species_gain(mob/living/carbon/human/C)
	C.draw_citadel_parts()
	. = ..()

/datum/species/ipc/on_species_loss(mob/living/carbon/human/C)
	C.draw_citadel_parts(TRUE)
	. = ..()

/mob/living/carbon/human/dummy
	no_vore = TRUE

/mob/living/carbon/human/vore
	devourable = TRUE