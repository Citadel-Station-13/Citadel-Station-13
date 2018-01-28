/datum/species/android
	name = "Android"
	id = "android"
	say_mod = "states"
	species_traits = list(SPECIES_ROBOTIC,NOBREATH,RESISTHOT,RESISTCOLD,RESISTPRESSURE,NOFIRE,NOBLOOD,PIERCEIMMUNE,NOHUNGER,EASYLIMBATTACHMENT)
	meat = null
	damage_overlay_type = "synth"
	mutanttongue = /obj/item/organ/tongue/robot
	limbs_id = "synth"

/datum/species/android/on_species_gain(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_ROBOTIC, FALSE, TRUE)

/datum/species/android/on_species_loss(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_ORGANIC,FALSE, TRUE)
