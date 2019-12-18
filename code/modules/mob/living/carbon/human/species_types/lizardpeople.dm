/datum/species/lizard
	// Reptilian humanoids with scaled skin and tails.
	name = "Anthromorphic Lizard"
	id = "lizard"
	say_mod = "hisses"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,LIPS,HORNCOLOR,WINGCOLOR)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID, MOB_REPTILE)
	randomized_features = list(FEAT_TAIL_LIZARD, FEAT_SNOUT, FEAT_SPINES, FEAT_FRILLS, FEAT_MARKINGS, FEAT_MUTCOLOR)
	mutant_bodyparts = list(FEAT_TAIL_LIZARD, FEAT_SNOUT, FEAT_SPINES, FEAT_HORNS, FEAT_FRILLS, FEAT_MARKINGS, FEAT_LEGS, FEAT_TAUR, FEAT_DECO_WINGS)
	mutanttongue = /obj/item/organ/tongue/lizard
	mutanttail = /obj/item/organ/tail/lizard
	coldmod = 1.5
	heatmod = 0.67
	default_features = list(FEAT_MUTCOLOR = "0F0", FEAT_MUTCOLOR2 = "0F0", FEAT_MUTCOLOR3 = "0F0", FEAT_TAIL_LIZARD = "Smooth", FEAT_SNOUT = "Round",
							 FEAT_HORNS = "None", FEAT_FRILLS = "None", FEAT_SPINES = "None", FEAT_MARKINGS = "None",
							  FEAT_LEGS = "Digitigrade", FEAT_TAUR = "None", FEAT_DECO_WINGS = "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	gib_types = list(/obj/effect/gibspawner/lizard, /obj/effect/gibspawner/lizard/bodypartless)
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	exotic_bloodtype = "L"
	disliked_food = GRAIN | DAIRY
	liked_food = GROSS | MEAT

/datum/species/lizard/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.grant_language(/datum/language/draconic)

/datum/species/lizard/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_lizard_name(gender)

	var/randname = lizard_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/lizard/qualifies_for_rank(rank, list/features)
	return TRUE

//I wag in death
/datum/species/lizard/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/lizard/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/lizard/can_wag_tail(mob/living/carbon/human/H)
	return (FEAT_TAIL_LIZARD in mutant_bodyparts) || (FEAT_TAIL_LIZARD_WAG in mutant_bodyparts)

/datum/species/lizard/is_wagging_tail(mob/living/carbon/human/H)
	return (FEAT_TAIL_LIZARD_WAG in mutant_bodyparts)

/datum/species/lizard/start_wagging_tail(mob/living/carbon/human/H)
	if(FEAT_TAIL_LIZARD in mutant_bodyparts)
		mutant_bodyparts -= FEAT_TAIL_LIZARD
		mutant_bodyparts -= FEAT_SPINES
		mutant_bodyparts |= FEAT_TAIL_LIZARD_WAG
		mutant_bodyparts |= FEAT_SPINES_WAG
	H.update_body()

/datum/species/lizard/stop_wagging_tail(mob/living/carbon/human/H)
	if(FEAT_TAIL_LIZARD_WAG in mutant_bodyparts)
		mutant_bodyparts -= FEAT_TAIL_LIZARD_WAG
		mutant_bodyparts -= FEAT_SPINES_WAG
		mutant_bodyparts |= FEAT_TAIL_LIZARD
		mutant_bodyparts |= FEAT_SPINES
	H.update_body()

/datum/species/lizard/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	if((FEAT_LEGS in C.dna.species.mutant_bodyparts) && (C.dna.features[FEAT_LEGS] == "Digitigrade" || C.dna.features[FEAT_LEGS] == "Avian"))
		species_traits += DIGITIGRADE
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(FALSE)
	return ..()

/datum/species/lizard/on_species_loss(mob/living/carbon/human/C, datum/species/new_species)
	if((FEAT_LEGS in C.dna.species.mutant_bodyparts) && C.dna.features[FEAT_LEGS] == "Plantigrade")
		species_traits -= DIGITIGRADE
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(TRUE)

/*
 Lizard subspecies: ASHWALKERS
*/
/datum/species/lizard/ashwalker
	name = "Ash Walker"
	id = "ashlizard"
	limbs_id = "lizard"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,DIGITIGRADE)
	inherent_traits = list(TRAIT_NOGUNS)
	mutantlungs = /obj/item/organ/lungs/ashwalker
	burnmod = 0.9
	brutemod = 0.9

/datum/species/lizard/ashwalker/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	if((C.dna.features[FEAT_SPINES] != "None" ) && (C.dna.features[FEAT_TAIL_LIZARD] == "None")) //tbh, it's kinda ugly for them not to have a tail yet have floating spines
		C.dna.features[FEAT_TAIL_LIZARD] = "Smooth"
		C.update_body()
	return ..()
