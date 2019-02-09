/datum/species/alternian
	// ra�a original
	name = "Alternian Troll"
	id = "alternian"
	say_mod = "quirks"
	blacklisted = 0
	sexes = 1
	hair_color = "2e2e2e"
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/moth
	species_traits = list(HAIR,FACEHAIR,LIPS)
	inherent_traits = list(TRAIT_NOBREATH)
	inherent_biotypes = list(MOB_HUMANOID, MOB_ORGANIC)
	mutant_bodyparts = list("alternian_horns")
	default_features = list("alternian_horns" = "simple")
	disliked_food = NONE
	liked_food = GROSS | MEAT | RAW
	//limbs_id = "alternian"
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'

	//Troll Shit
	var/sign = ""

	has_castes = TRUE

/datum/species/alternian/on_species_gain(mob/living/carbon/C)
	. = ..()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(!H.dna.features["alternian_horns"])
			H.dna.features["alternian_horns"] = "[(H.client && H.client.prefs && LAZYLEN(H.client.prefs.features) && H.client.prefs.features["alternian_horns"]) ? H.client.prefs.features["alternian_horns"] : "simple"]"
			handle_mutant_bodyparts(H)

/datum/species/alternian/check_roundstart_eligible()
	return TRUE

/datum/species/alternian/qualifies_for_rank(rank, list/features)
	return TRUE