/datum/species/insect
	name = "Anthromorphic Insect"
	id = "insect"
	default_color = "00FF00"
	species_traits = list(LIPS,EYECOLOR,HAIR,FACEHAIR,MUTCOLORS,HORNCOLOR,WINGCOLOR)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutant_bodyparts = list("mam_ears","mam_tail", "taur", "insect_wings","mam_snout", "mam_snouts", "insect_fluff","insect_markings")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "mam_tail" = "None", "mam_ears" = "None",
							"insect_wings" = "None", "insect_fluff" = "None", "mam_snouts" = "None", "taur" = "None", "insect_markings" = "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/insect
	liked_food = MEAT | FRUIT
	disliked_food = TOXIC
	icon_limbs = DEFAULT_BODYPART_ICON_CITADEL

/datum/species/insect/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/insect/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/insect/can_wag_tail(mob/living/carbon/human/H)
	return ("mam_tail" in mutant_bodyparts) || ("mam_waggingtail" in mutant_bodyparts)

/datum/species/insect/is_wagging_tail(mob/living/carbon/human/H)
	return ("mam_waggingtail" in mutant_bodyparts)

/datum/species/insect/start_wagging_tail(mob/living/carbon/human/H)
	if("mam_tail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_tail"
		mutant_bodyparts |= "mam_waggingtail"
	H.update_body()

/datum/species/insect/stop_wagging_tail(mob/living/carbon/human/H)
	if("mam_waggingtail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_waggingtail"
		mutant_bodyparts |= "mam_tail"
	H.update_body()

/datum/species/insect/qualifies_for_rank(rank, list/features)
	return TRUE