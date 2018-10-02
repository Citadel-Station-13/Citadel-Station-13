/datum/species/mammal
	name = "Mammal"
	id = "mammal"
	default_color = "4B4B4B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	mutant_bodyparts = list("mam_tail", "mam_ears", "mam_body_markings", "snout", "taur", "legs")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "snout" = "Husky", "mam_tail" = "Husky", "mam_ears" = "Husky", "mam_body_markings" = "Husky", "taur" = "None", "legs" = "Normal Legs")
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
	return ("mam_tail" in mutant_bodyparts) || ("mam_waggingtail" in mutant_bodyparts)

/datum/species/mammal/is_wagging_tail(mob/living/carbon/human/H)
	return ("mam_waggingtail" in mutant_bodyparts)

/datum/species/mammal/start_wagging_tail(mob/living/carbon/human/H)
	if("mam_tail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_tail"
		mutant_bodyparts |= "mam_waggingtail"
	H.update_body()

/datum/species/mammal/stop_wagging_tail(mob/living/carbon/human/H)
	if("mam_waggingtail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_waggingtail"
		mutant_bodyparts |= "mam_tail"
	H.update_body()


/datum/species/mammal/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/mammal/on_species_gain(mob/living/carbon/human/C)
	C.draw_citadel_parts()
	. = ..()

/datum/species/mammal/on_species_loss(mob/living/carbon/human/C)
	C.draw_citadel_parts(TRUE)
	. = ..()

//AVIAN//
/datum/species/avian
	name = "Avian"
	id = "avian"
	say_mod = "chirps"
	default_color = "BCAC9B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	mutant_bodyparts = list("snout", "wings", "taur", "mam_tail", "mam_body_markings", "taur")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "snout" = "Beak", "wings" = "None", "taur" = "None", "mam_body_markings" = "Hawk", "mam_tail" = "Hawk")
	attack_verb = "peck"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = MEAT | FRUIT
	disliked_food = TOXIC

/datum/species/avian/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/avian/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/avian/can_wag_tail(mob/living/carbon/human/H)
	return ("mam_tail" in mutant_bodyparts) || ("mam_waggingtail" in mutant_bodyparts)

/datum/species/avian/is_wagging_tail(mob/living/carbon/human/H)
	return ("mam_waggingtail" in mutant_bodyparts)

/datum/species/avian/start_wagging_tail(mob/living/carbon/human/H)
	if("mam_tail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_tail"
		mutant_bodyparts |= "mam_waggingtail"
	H.update_body()

/datum/species/avian/stop_wagging_tail(mob/living/carbon/human/H)
	if("mam_waggingtail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_waggingtail"
		mutant_bodyparts |= "mam_tail"
	H.update_body()

/datum/species/avian/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/avian/on_species_gain(mob/living/carbon/human/C)
	C.draw_citadel_parts()
	. = ..()

/datum/species/avian/on_species_loss(mob/living/carbon/human/C)
	C.draw_citadel_parts(TRUE)
	. = ..()

//AQUATIC//
/datum/species/aquatic
	name = "Aquatic"
	id = "aquatic"
	default_color = "BCAC9B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	mutant_bodyparts = list("mam_tail", "mam_body_markings", "mam_ears", "taur", "legs")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "mam_tail" = "Shark", "mam_body_markings" = "Shark", "mam_ears" = "None", "snout" = "Round", "taur" = "None", "legs" = "Normal Legs")
	attack_verb = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = MEAT
	disliked_food = TOXIC
	meat = /obj/item/reagent_containers/food/snacks/carpmeat/aquatic

/datum/species/aquatic/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/aquatic/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/aquatic/can_wag_tail(mob/living/carbon/human/H)
	return ("mam_tail" in mutant_bodyparts) || ("mam_waggingtail" in mutant_bodyparts)

/datum/species/aquatic/is_wagging_tail(mob/living/carbon/human/H)
	return ("mam_waggingtail" in mutant_bodyparts)

/datum/species/aquatic/start_wagging_tail(mob/living/carbon/human/H)
	if("mam_tail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_tail"
		mutant_bodyparts |= "mam_waggingtail"
	H.update_body()

/datum/species/aquatic/stop_wagging_tail(mob/living/carbon/human/H)
	if("mam_waggingtail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_waggingtail"
		mutant_bodyparts |= "mam_tail"
	H.update_body()

/datum/species/aquatic/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/aquatic/on_species_gain(mob/living/carbon/human/C)
	C.draw_citadel_parts()
	. = ..()

/datum/species/aquatic/on_species_loss(mob/living/carbon/human/C)
	C.draw_citadel_parts(TRUE)
	. = ..()

//INSECT//
/datum/species/insect
	name = "Insect"
	id = "insect"
	default_color = "BCAC9B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID, MOB_BUG)
	mutant_bodyparts = list("mam_body_markings", "mam_ears", "mam_tail", "taur", "moth_wings")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "mam_body_markings" = "Moth", "mam_tail" = "None", "mam_ears" = "None", "moth_wings" = "Plain", "snout" = "None", "taur" = "None")
	attack_verb = "flutter" //wat?
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = MEAT | FRUIT
	disliked_food = TOXIC

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

/datum/species/insect/on_species_gain(mob/living/carbon/human/C)
	C.draw_citadel_parts()
	. = ..()

/datum/species/insect/on_species_loss(mob/living/carbon/human/C)
	C.draw_citadel_parts(TRUE)
	. = ..()

//Alien//
/datum/species/xeno
	// A cloning mistake, crossing human and xenomorph DNA
	name = "Xeno Hybrid"
	id = "xeno"
	say_mod = "hisses"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,DIGITIGRADE)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	mutant_bodyparts = list("xenotail", "xenohead", "xenodorsal", "taur", "mam_body_markings")
	default_features = list("xenotail"="Xenomorph Tail","xenohead"="Standard","xenodorsal"="Standard","mcolor" = "0F0","mcolor2" = "0F0","mcolor3" = "0F0","taur" = "None","mam_body_markings" = "Xeno")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/xeno
	skinned_type = /obj/item/stack/sheet/animalhide/xeno
	exotic_bloodtype = "L"
	damage_overlay_type = "xeno"
	liked_food = MEAT

/datum/species/xeno/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	C.draw_citadel_parts()
	if(("legs" in C.dna.species.mutant_bodyparts) && C.dna.features["legs"] == "Digitigrade Legs")
		species_traits += DIGITIGRADE
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(FALSE)
	. = ..()

/datum/species/xeno/on_species_loss(mob/living/carbon/human/C, datum/species/new_species)
	C.draw_citadel_parts(TRUE)
	if(("legs" in C.dna.species.mutant_bodyparts) && C.dna.features["legs"] == "Normal Legs")
		species_traits -= DIGITIGRADE
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(TRUE)
	. = ..()

//Praise the Omnissiah, A challange worthy of my skills - HS

//EXOTIC//
//These races will likely include lots of downsides and upsides. Keep them relatively balanced.//

//misc
/mob/living/carbon/human/dummy
	no_vore = TRUE

/mob/living/carbon/human/vore
	devourable = TRUE
