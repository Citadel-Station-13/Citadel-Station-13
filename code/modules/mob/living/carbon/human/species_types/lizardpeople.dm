/datum/species/lizard
	// Reptilian humanoids with scaled skin and tails.
	name = "Anthromorphic Lizard"
	id = "lizard"
	say_mod = "hisses"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,LIPS,HORNCOLOR,WINGCOLOR)
	mutant_bodyparts = list("tail_lizard", "snout", "spines", "horns", "frills", "body_markings", "legs", "taur", "deco_wings")
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_REPTILE
	mutanttongue = /obj/item/organ/tongue/lizard
	mutanttail = /obj/item/organ/tail/lizard
	coldmod = 1.5
	heatmod = 0.67
	mutant_bodyparts = list("mcolor" = "0F0", "mcolor2" = "0F0", "mcolor3" = "0F0", "tail_lizard" = "Smooth", "snout" = "Round",
							 "horns" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None",
							  "legs" = "Digitigrade", "taur" = "None", "deco_wings" = "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	gib_types = list(/obj/effect/gibspawner/lizard, /obj/effect/gibspawner/lizard/bodypartless)
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	exotic_bloodtype = "L"
	disliked_food = GRAIN | DAIRY
	liked_food = GROSS | MEAT
	inert_mutation = FIREBREATH

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
	return mutant_bodyparts["tail_lizard"] || mutant_bodyparts["waggingtail_lizard"]

/datum/species/lizard/is_wagging_tail(mob/living/carbon/human/H)
	return mutant_bodyparts["waggingtail_lizard"]

/datum/species/lizard/start_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["tail_lizard"])
		mutant_bodyparts["waggingtail_lizard"] = mutant_bodyparts["tail_lizard"]
		mutant_bodyparts["waggingspines"] = mutant_bodyparts["spines"]
		mutant_bodyparts -= "tail_lizard"
		mutant_bodyparts -= "spines"
	H.update_body()

/datum/species/lizard/stop_wagging_tail(mob/living/carbon/human/H)
	if(mutant_bodyparts["waggingtail_lizard"])
		mutant_bodyparts["tail_lizard"] = mutant_bodyparts["waggingtail_lizard"]
		mutant_bodyparts["spines"] = mutant_bodyparts["waggingspines"]
		mutant_bodyparts -= "waggingtail_lizard"
		mutant_bodyparts -= "waggingspines"
	H.update_body()

/*
 Lizard subspecies: ASHWALKERS
*/
/datum/species/lizard/ashwalker
	name = "Ash Walker"
	id = "ashlizard"
	limbs_id = "lizard"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,DIGITIGRADE)
	inherent_traits = list(TRAIT_CHUNKYFINGERS)
	mutantlungs = /obj/item/organ/lungs/ashwalker
	burnmod = 0.9
	brutemod = 0.9

/datum/species/lizard/ashwalker/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	if((C.dna.features["spines"] != "None" ) && (C.dna.features["tail_lizard"] == "None")) //tbh, it's kinda ugly for them not to have a tail yet have floating spines
		C.dna.features["tail_lizard"] = "Smooth"
		C.update_body()
	return ..()
