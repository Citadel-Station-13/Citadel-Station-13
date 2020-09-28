/datum/species/synthliz/on_species_gain(mob/living/carbon/C)
	. = ..()
	C.grant_language(/datum/language/machine)

/datum/species/synthliz/on_species_loss(mob/living/carbon/human/C)
	..()
	C.remove_language(/datum/language/machine)
