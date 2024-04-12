/datum/species/android
	name = "Android"
	id = SPECIES_ANDROID
	say_mod = "states"
	species_traits = list(NOBLOOD,NOGENITALS,NOAROUSAL,ROBOTIC_LIMBS)
	inherent_traits = list(TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_NOFIRE,TRAIT_PIERCEIMMUNE,TRAIT_NOHUNGER,TRAIT_LIMBATTACHMENT, TRAIT_ROBOTIC_ORGANISM)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	gib_types = /obj/effect/gibspawner/robot
	damage_overlay_type = "synth"
	mutanttongue = /obj/item/organ/tongue/robot
	species_language_holder = /datum/language_holder/synthetic
	limbs_id = SPECIES_SYNTH
	species_category = SPECIES_CATEGORY_ROBOT
	wings_icons = SPECIES_WINGS_ROBOT
