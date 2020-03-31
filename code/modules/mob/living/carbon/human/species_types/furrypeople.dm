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

//Curiosity killed the cat's wagging tail.
/datum/species/mammal/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/mammal/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

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


/datum/species/mammal/qualifies_for_rank(rank, list/features)
	return TRUE


//Alien//
/datum/species/xeno
	// A cloning mistake, crossing human and xenomorph DNA
	name = "Xenomorph Hybrid"
	id = "xeno"
	say_mod = "hisses"
	default_color = "00FF00"
	icon_limbs = DEFAULT_BODYPART_ICON_CITADEL
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS)
	mutant_bodyparts = list("xenotail"="Xenomorph Tail","xenohead"="Standard","xenodorsal"="Standard", "mam_body_markings" = "Xeno","mcolor" = "0F0","mcolor2" = "0F0","mcolor3" = "0F0","taur" = "None", "legs" = "Digitigrade")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/xeno
	gib_types = list(/obj/effect/gibspawner/xeno/xenoperson, /obj/effect/gibspawner/xeno/xenoperson/bodypartless)
	skinned_type = /obj/item/stack/sheet/animalhide/xeno
	exotic_bloodtype = "X*"
	damage_overlay_type = "xeno"
	liked_food = MEAT

//Praise the Omnissiah, A challange worthy of my skills - HS

//EXOTIC//
//These races will likely include lots of downsides and upsides. Keep them relatively balanced.//

//misc
/mob/living/carbon/human/dummy
	no_vore = TRUE

/mob/living/carbon/human/vore
	devourable = TRUE
	digestable = TRUE
	feeding = TRUE
