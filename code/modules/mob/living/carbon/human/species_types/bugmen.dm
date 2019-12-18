/datum/species/insect
	name = "Anthromorphic Insect"
	id = "insect"
	default_color = "00FF00"
	species_traits = list(LIPS,EYECOLOR,HAIR,FACEHAIR,MUTCOLORS,HORNCOLOR,WINGCOLOR)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID, MOB_BUG)
	mutant_bodyparts = list(FEAT_MAM_EARS, FEAT_MAM_SNOUT, FEAT_TAIL_MAM, FEAT_TAUR, FEAT_INSECT_WINGS, FEAT_MAM_SNOUT, FEAT_INSECT_FLUFF,FEAT_HORNS)
	default_features = list(FEAT_MUTCOLOR = "FFF",FEAT_MUTCOLOR2 = "FFF",FEAT_MUTCOLOR3 = "FFF", FEAT_TAIL_MAM = "None", FEAT_MAM_EARS = "None",
							FEAT_INSECT_WINGS = "None", FEAT_INSECT_FLUFF = "None", FEAT_MAM_SNOUT = "None", FEAT_TAUR = "None",FEAT_HORNS = "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/insect
	liked_food = MEAT | FRUIT
	disliked_food = TOXIC
	should_draw_citadel = TRUE

/datum/species/insect/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/insect/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/insect/can_wag_tail(mob/living/carbon/human/H)
	return (FEAT_TAIL_MAM in mutant_bodyparts) || (FEAT_TAIL_MAM_WAG in mutant_bodyparts)

/datum/species/insect/is_wagging_tail(mob/living/carbon/human/H)
	return (FEAT_TAIL_MAM_WAG in mutant_bodyparts)

/datum/species/insect/start_wagging_tail(mob/living/carbon/human/H)
	if(FEAT_TAIL_MAM in mutant_bodyparts)
		mutant_bodyparts -= FEAT_TAIL_MAM
		mutant_bodyparts |= FEAT_TAIL_MAM_WAG
	H.update_body()

/datum/species/insect/stop_wagging_tail(mob/living/carbon/human/H)
	if(FEAT_TAIL_MAM_WAG in mutant_bodyparts)
		mutant_bodyparts -= FEAT_TAIL_MAM_WAG
		mutant_bodyparts |= FEAT_TAIL_MAM
	H.update_body()

/datum/species/insect/qualifies_for_rank(rank, list/features)
	return TRUE