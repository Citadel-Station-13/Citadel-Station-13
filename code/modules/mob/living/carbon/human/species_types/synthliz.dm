/datum/species/synthliz
	name = "Synthetic Lizardperson"
	id = "synthliz"
	icon_limbs = DEFAULT_BODYPART_ICON_CITADEL
	say_mod = "beeps"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,NOTRANSSTING,EYECOLOR,LIPS,HAIR)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	mutant_bodyparts = list("ipc_antenna","mam_tail", "mam_snouts","legs", "mam_body_markings", "taur")
	default_features = list("ipc_antenna" = "Synthetic Lizard - Antennae","mam_tail" = "Synthetic Lizard", "mam_snouts" = "Synthetic Lizard - Snout", "legs" = "Digitigrade", "mam_body_markings" = "Synthetic Lizard - Plates", "taur" = "None")
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/ipc
	gib_types = list(/obj/effect/gibspawner/ipc, /obj/effect/gibspawner/ipc/bodypartless)
	mutanttongue = /obj/item/organ/tongue/robot/ipc
	//Just robo looking parts.
	mutant_heart = /obj/item/organ/heart/ipc
	mutantlungs = /obj/item/organ/lungs/ipc
	mutantliver = /obj/item/organ/liver/ipc
	mutantstomach = /obj/item/organ/stomach/ipc
	mutanteyes = /obj/item/organ/eyes/ipc

	exotic_bloodtype = "S"


/datum/species/synthliz/qualifies_for_rank(rank, list/features)
	return TRUE

//I wag in death
/datum/species/synthliz/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/synthliz/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/synthliz/can_wag_tail(mob/living/carbon/human/H)
	return ("mam_tail" in mutant_bodyparts) || ("mam_waggingtail" in mutant_bodyparts)

/datum/species/synthliz/is_wagging_tail(mob/living/carbon/human/H)
	return ("mam_waggingtail" in mutant_bodyparts)

/datum/species/synthliz/start_wagging_tail(mob/living/carbon/human/H)
	if("mam_tail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_tail"
		mutant_bodyparts |= "mam_waggingtail"
	H.update_body()

/datum/species/synthliz/stop_wagging_tail(mob/living/carbon/human/H)
	if("mam_waggingtail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_waggingtail"
		mutant_bodyparts |= "mam_tail"
	H.update_body()