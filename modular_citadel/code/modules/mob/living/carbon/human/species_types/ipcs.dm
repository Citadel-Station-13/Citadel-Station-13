/datum/species/ipc //robots
	name = "IPC"
	id = "ipc"
	say_mod = "beeps"
	default_color = "00FF00"
	blacklisted = 0
	sexes = 0
	mutant_bodyparts = list("screen")
	default_features = list("screen" = "Screen")
	species_traits = list(MUTCOLORS)
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/ipc
	disliked_food = NONE
	liked_food = NONE

/datum/species/ipc/on_species_gain(mob/living/carbon/human/C)
	C.draw_hippie_parts()
	. = ..()

/datum/species/ipc/on_species_loss(mob/living/carbon/human/C)
	C.draw_hippie_parts(TRUE)
	. = ..()

/datum/species/ipc/get_spans()
	return SPAN_ROBOT
