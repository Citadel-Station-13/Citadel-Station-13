/datum/species/insect
	name = "Anthromorphic Insect"
	id = "insect"
	say_mod = "flutters"
	default_color = "00FF00"
	species_traits = list(LIPS,NOEYES,HAIR,FACEHAIR,MUTCOLORS,HORNCOLOR,WINGCOLOR)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID, MOB_BUG)
	mutant_bodyparts = list("mam_ears", "mam_snout", "mam_tail", "taur", "insect_wings", "mam_snouts", "insect_fluff","horns")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "mam_tail" = "None", "mam_ears" = "None",
							"insect_wings" = "None", "insect_fluff" = "None", "mam_snouts" = "None", "taur" = "None","horns" = "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/insect
	liked_food = VEGETABLES | DAIRY
	disliked_food = FRUIT | GROSS
	toxic_food = MEAT | RAW
	mutanteyes = /obj/item/organ/eyes/insect
	should_draw_citadel = TRUE
	exotic_bloodtype = "BUG"

/datum/species/insect/on_species_gain(mob/living/carbon/C)
	. = ..()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(!H.dna.features["insect_wings"])
			H.dna.features["insect_wings"] = "[(H.client && H.client.prefs && LAZYLEN(H.client.prefs.features) && H.client.prefs.features["insect_wings"]) ? H.client.prefs.features["insect_wings"] : "None"]"
			handle_mutant_bodyparts(H)

/datum/species/insect/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_moth_name()

	var/randname = moth_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/insect/handle_fire(mob/living/carbon/human/H, no_protection = FALSE)
	..()
	if(H.dna.features["insect_wings"] != "Burnt Off" && H.dna.features["insect_wings"] != "None" && H.bodytemperature >= 800 && H.fire_stacks > 0) //do not go into the extremely hot light. you will not survive
		to_chat(H, "<span class='danger'>Your precious wings burn to a crisp!</span>")
		if(H.dna.features["insect_wings"] != "None")
			H.dna.features["insect_wings"] = "Burnt Off"
		handle_mutant_bodyparts(H)

/datum/species/insect/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	. = ..()
	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)

/datum/species/insect/check_weakness(obj/item/weapon, mob/living/attacker)
	if(istype(weapon, /obj/item/melee/flyswatter))
		return 9 //flyswatters deal 10x damage to insects
	return 0

/datum/species/insect/space_move(mob/living/carbon/human/H)
	. = ..()
	if(H.loc && !isspaceturf(H.loc) && (H.dna.features["insect_wings"] != "Burnt Off" && H.dna.features["insect_wings"] != "None"))
		var/datum/gas_mixture/current = H.loc.return_air()
		if(current && (current.return_pressure() >= ONE_ATMOSPHERE*0.85)) //as long as there's reasonable pressure and no gravity, flight is possible
			return TRUE
