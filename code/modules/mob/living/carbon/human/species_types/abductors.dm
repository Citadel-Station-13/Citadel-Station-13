/datum/species/abductor
	name = "Abductor"
	id = "abductor"
	say_mod = "gibbers"
	sexes = FALSE
	species_traits = list(NOBLOOD,NOBREATH,VIRUSIMMUNE,NOGUNS,NOHUNGER)
	mutanttongue = /obj/item/organ/tongue/abductor
	var/scientist = FALSE // vars to not pollute spieces list with castes

/datum/species/abductor/copy_properties_from(datum/species/abductor/old_species)
	scientist = old_species.scientist

/datum/species/abductor/on_species_gain(mob/living/carbon/C) //Abductor bodyparts are flubber and boneless.
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_FLUBBER, FALSE, TRUE)

/datum/species/abductor/on_species_loss(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_ORGANIC,FALSE, TRUE)