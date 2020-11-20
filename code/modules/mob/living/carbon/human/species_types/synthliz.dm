/datum/species/synthliz
	name = "Synthetic Lizardperson"
	id = SPECIES_SYNTH_LIZARD
	say_mod = "beeps"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,NOTRANSSTING,EYECOLOR,LIPS,HAIR,ROBOTIC_LIMBS,HAS_FLESH,HAS_BONE)
	inherent_traits = list(TRAIT_EASYDISMEMBER,TRAIT_LIMBATTACHMENT,TRAIT_NO_PROCESS_FOOD, TRAIT_ROBOTIC_ORGANISM)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	mutant_bodyparts = list("ipc_antenna" = "Synthetic Lizard - Antennae","mam_tail" = "Synthetic Lizard", "mam_snouts" = "Synthetic Lizard - Snout", "legs" = "Digitigrade", "mam_body_markings" = "Synthetic Lizard - Plates", "taur" = "None")
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/ipc
	gib_types = list(/obj/effect/gibspawner/ipc, /obj/effect/gibspawner/ipc/bodypartless)
	//Just robo looking parts.
	mutant_heart = /obj/item/organ/heart/ipc
	mutantlungs = /obj/item/organ/lungs/ipc
	mutantliver = /obj/item/organ/liver/ipc
	mutantstomach = /obj/item/organ/stomach/ipc
	mutanteyes = /obj/item/organ/eyes/ipc
	mutantears = /obj/item/organ/ears/ipc
	mutanttongue = /obj/item/organ/tongue/robot/ipc
	mutant_brain = /obj/item/organ/brain/ipc
	languagewhitelist = list("Encoded Audio Language")

	//special cybernetic organ for getting power from apcs
	mutant_organs = list(/obj/item/organ/cyberimp/arm/power_cord)

	exotic_bloodtype = "S"
	exotic_blood_color = BLOOD_COLOR_OIL

	tail_type = "mam_tail"
	wagging_type = "mam_waggingtail"
	species_category = SPECIES_CATEGORY_ROBOT
