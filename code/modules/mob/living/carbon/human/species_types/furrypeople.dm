/datum/species/mammal
	name = "Anthromorph"
	id = "mammal"
	default_color = "4B4B4B"
	should_draw_citadel = TRUE
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR,HORNCOLOR,WINGCOLOR)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	randomized_features = list(FEAT_TAIL_MAM, FEAT_MAM_EARS, FEAT_MAM_MARKINGS, FEAT_MAM_SNOUT, FEAT_MUTCOLOR, FEAT_MUTCOLOR2, FEAT_MUTCOLOR3)
	mutant_bodyparts = list(FEAT_TAIL_MAM, FEAT_MAM_EARS, FEAT_MAM_MARKINGS, FEAT_MAM_SNOUT, FEAT_DECO_WINGS, FEAT_TAUR, FEAT_HORNS, FEAT_LEGS)
	default_features = list(FEAT_MUTCOLOR = "FFF",FEAT_MUTCOLOR2 = "FFF",FEAT_MUTCOLOR3 = "FFF", FEAT_MAM_SNOUT = "Husky", FEAT_TAIL_MAM = "Husky", FEAT_MAM_EARS = "Husky", FEAT_DECO_WINGS = "None",
						 FEAT_MAM_MARKINGS = "Husky", FEAT_TAUR = "None", FEAT_HORNS = "None", FEAT_LEGS = "Plantigrade", "meat_type" = "Mammalian")
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
	return (FEAT_TAIL_MAM in mutant_bodyparts) || (FEAT_TAIL_MAM_WAG in mutant_bodyparts)

/datum/species/mammal/is_wagging_tail(mob/living/carbon/human/H)
	return (FEAT_TAIL_MAM_WAG in mutant_bodyparts)

/datum/species/mammal/start_wagging_tail(mob/living/carbon/human/H)
	if(FEAT_TAIL_MAM in mutant_bodyparts)
		mutant_bodyparts -= FEAT_TAIL_MAM
		mutant_bodyparts |= FEAT_TAIL_MAM_WAG
	H.update_body()

/datum/species/mammal/stop_wagging_tail(mob/living/carbon/human/H)
	if(FEAT_TAIL_MAM_WAG in mutant_bodyparts)
		mutant_bodyparts -= FEAT_TAIL_MAM_WAG
		mutant_bodyparts |= FEAT_TAIL_MAM
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
	should_draw_citadel = TRUE
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	randomized_features = list(FEAT_XENO_TAIL, FEAT_XENO_HEAD, FEAT_XENO_DORSAL, FEAT_MUTCOLOR)
	mutant_bodyparts = list(FEAT_XENO_TAIL, FEAT_XENO_HEAD, FEAT_XENO_DORSAL, FEAT_MAM_MARKINGS, FEAT_TAUR, FEAT_LEGS)
	default_features = list(FEAT_XENO_TAIL="Xenomorph Tail",FEAT_XENO_HEAD="Standard",FEAT_XENO_DORSAL="Standard", FEAT_MAM_MARKINGS = "Xeno",FEAT_MUTCOLOR = "0F0",FEAT_MUTCOLOR2 = "0F0",FEAT_MUTCOLOR3 = "0F0",FEAT_TAUR = "None", FEAT_LEGS = "Digitigrade")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/xeno
	gib_types = list(/obj/effect/gibspawner/xeno/xenoperson, /obj/effect/gibspawner/xeno/xenoperson/bodypartless)
	skinned_type = /obj/item/stack/sheet/animalhide/xeno
	exotic_bloodtype = "X*"
	damage_overlay_type = "xeno"
	liked_food = MEAT

/datum/species/xeno/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	if((FEAT_LEGS in C.dna.species.mutant_bodyparts) && (C.dna.features[FEAT_LEGS] == "Digitigrade" || C.dna.features[FEAT_LEGS] == "Avian"))
		species_traits += DIGITIGRADE
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(FALSE)
	. = ..()

/datum/species/xeno/on_species_loss(mob/living/carbon/human/C, datum/species/new_species)
	if((FEAT_LEGS in C.dna.species.mutant_bodyparts) && C.dna.features[FEAT_LEGS] == "Plantigrade")
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
	digestable = TRUE
	feeding = TRUE
