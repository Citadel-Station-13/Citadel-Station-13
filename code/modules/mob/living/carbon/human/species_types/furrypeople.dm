/datum/species/mammal
	name = "Anthromorph"
	id = "mammal"
	default_color = "4B4B4B"
	icon_limbs = DEFAULT_BODYPART_ICON_CITADEL
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR,HORNCOLOR,WINGCOLOR)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BEAST
	mutant_bodyparts = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "mam_snouts" = "Husky", "mam_tail" = "Husky", "mam_ears" = "Husky", "deco_wings" = "None",
						 "mam_body_markings" = "Husky", "taur" = "None", "horns" = "None", "legs" = "Plantigrade", "meat_type" = "Mammalian")
	attack_verb = "claw"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/mammal
	liked_food = MEAT | FRIED
	disliked_food = TOXIC

	tail_type = "mam_tail"
	wagging_type = "mam_waggingtail"
	species_type = "furry"

/datum/species/mammal/can_wag_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["mam_tail"] || mutant_bodyparts["mam_waggingtail"]

/datum/species/mammal/is_wagging_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["mam_waggingtail"]

/datum/species/mammal/start_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["mam_tail"])
		mutant_bodyparts["mam_waggingtail"] = mutant_bodyparts["mam_tail"]
		mutant_bodyparts -= "mam_tail"
	H.update_body()

/datum/species/mammal/stop_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["mam_waggingtail"])
		mutant_bodyparts["mam_tail"] = mutant_bodyparts["mam_waggingtail"]
		mutant_bodyparts -= "mam_waggingtail"
	H.update_body()
