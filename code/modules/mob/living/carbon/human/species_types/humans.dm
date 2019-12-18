/datum/species/human
	name = "Human"
	id = "human"
	default_color = "FFFFFF"

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,MUTCOLORS_PARTSONLY,WINGCOLOR)
	mutant_bodyparts = list(FEAT_EARS, FEAT_TAIL_HUMAN, FEAT_WINGS, FEAT_TAUR, FEAT_DECO_WINGS) // CITADEL EDIT gives humans snowflake parts
	default_features = list(FEAT_MUTCOLOR = "FFF", FEAT_MUTCOLOR2 = "FFF",FEAT_MUTCOLOR3 = "FFF",FEAT_TAIL_HUMAN = "None", FEAT_EARS = "None", FEAT_WINGS = "None", FEAT_TAUR = "None", FEAT_DECO_WINGS = "None")
	use_skintones = 1
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED

/datum/species/human/qualifies_for_rank(rank, list/features)
	return TRUE	//Pure humans are always allowed in all roles.

/datum/species/human/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/human/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/human/can_wag_tail(mob/living/carbon/human/H)
	return (FEAT_TAIL_HUMAN in mutant_bodyparts) || (FEAT_TAIL_HUMAN_WAG in mutant_bodyparts)

/datum/species/human/is_wagging_tail(mob/living/carbon/human/H)
	return (FEAT_TAIL_HUMAN_WAG in mutant_bodyparts)

/datum/species/human/start_wagging_tail(mob/living/carbon/human/H)
	if(FEAT_TAIL_HUMAN in mutant_bodyparts)
		mutant_bodyparts -= FEAT_TAIL_HUMAN
		mutant_bodyparts |= FEAT_TAIL_HUMAN_WAG
	H.update_body()

/datum/species/human/stop_wagging_tail(mob/living/carbon/human/H)
	if(FEAT_TAIL_HUMAN_WAG in mutant_bodyparts)
		mutant_bodyparts -= FEAT_TAIL_HUMAN_WAG
		mutant_bodyparts |= FEAT_TAIL_HUMAN
	H.update_body()
