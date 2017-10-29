/datum/species/mammal
	name = "Mammal"
	id = "mammal"
	default_color = "4B4B4B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	mutant_bodyparts = list("mam_tail", "mam_ears", "mam_body_markings", "snout", "taur")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "body_markings" = "None", "mam_tail" = "None", "mam_ears" = "None", "mam_body_markings" = "None", "taur" = "None")
	attack_verb = "claw"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = MEAT | FRIED
	disliked_food = TOXIC

/datum/species/mammal/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

/datum/species/mammal/qualifies_for_rank(rank, list/features)
	return TRUE

//AVIAN//
/datum/species/avian
	name = "Avian"
	id = "avian"
	say_mod = "chirps"
	default_color = "BCAC9B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	mutant_bodyparts = list("snout", "wings", "taur", "mam_tail", "mam_body_markings", "taur")
	default_features = list("snout" = "Sharp", "wings" = "None", "taur" = "None", "mam_body_markings" = "Hawk")
	attack_verb = "peck"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = MEAT | FRUIT
	disliked_food = TOXIC

/datum/species/avian/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

/datum/species/avian/qualifies_for_rank(rank, list/features)
	return TRUE

//AQUATIC//
/datum/species/aquatic
	name = "Aquatic"
	id = "aquatic"
	default_color = "BCAC9B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	mutant_bodyparts = list("mam_tail", "mam_body_markings", "mam_ears", "taur")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF","mam_tail" = "shark", "mam_body_markings" = "None", "mam_ears" = "None")
	attack_verb = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = MEAT
	disliked_food = TOXIC

/datum/species/aquatic/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

/datum/species/aquatic/qualifies_for_rank(rank, list/features)
	return TRUE

//INSECT//
/datum/species/insect
	name = "Insect"
	id = "insect"
	default_color = "BCAC9B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	mutant_bodyparts = list("mam_body_markings", "mam_ears", "mam_tail", "taur")
	default_features = list("mcolor" = "FFF","mcolor2" = "FFF","mcolor3" = "FFF", "mam_body_markings" = "moth", "mam_tail" = "None", "mam_ears" = "None")
	attack_verb = "flutter" //wat?
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = MEAT | FRUIT
	disliked_food = TOXIC

/datum/species/insect/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

/datum/species/insect/qualifies_for_rank(rank, list/features)
	return TRUE
//HERBIVOROUS//

//Alien//
/datum/species/xeno
	// A cloning mistake, crossing human and xenomorph DNA
	name = "xeno"
	id = "xeno"
	say_mod = "hisses"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,LIPS,DIGITIGRADE,PIERCEIMMUNE)
	mutant_bodyparts = list("xenotail", "xenohead", "xenodorsal", "taur","mam_body_markings")
	default_features = list("xenotail"="xeno","xenohead"="standard","xenodorsal"="standard","mcolor" = "0F0","mcolor2" = "0F0","mcolor3" = "0F0","taur" = "None","mam_body_markings" = "xeno")
	heatmod = 1.3
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/xeno
	skinned_type = /obj/item/stack/sheet/animalhide/xeno
	exotic_bloodtype = "L"
	damage_overlay_type = "xeno"
	liked_food = MEAT

//Praise the Omnissiah, A challange worthy of my skills - HS

//EXOTIC//
//These races will likely include lots of downsides and upsides. Keep them relatively balanced.//
/*
/datum/species/xeno
	name = "Xenomorph"
	id = "xeno"
	say_mod = "hisses"
	eyes = "none"
	species_traits = list()
	mutant_organs = list(/obj/item/organ/tongue/alien)
	mutant_bodyparts = list("xenohead",
							"xenodorsal",
							"xenotail")
	default_features = list("xenohead"="Hunter",
							"xenodorsal"="Dorsal Tubes",
							"xenotail"="Xenomorph Tail")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	burnmod = 1.75
	heatmod = 1.75
	darksight = 4 //Just above slimes
	exotic_blood = "xblood"
	damage_overlay_type = "xeno"
	no_equip = list(slot_glasses) //MY EYES, THEY'RE GONE
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/xeno
	skinned_type = /obj/item/stack/sheet/animalhide/xeno
//	safe_toxins_max = 32 //Too much of anything is bad.
//	whitelisted = 1
//	whitelist = list("talkingcactus") //testing whitelisting

/datum/species/xeno/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	var/obj/effect/decal/cleanable/xenoblood/xgibs/XG
	if(istype(C.gib_type, XG))
		return
	else
		C.gib_type = XG

/datum/species/xeno/on_species_loss(mob/living/carbon/C)
	..()
	var/obj/effect/decal/cleanable/xenoblood/xgibs/XG
	var/obj/effect/decal/cleanable/blood/gibs/HG
	if(istype(C.gib_type, XG))
		C.gib_type = HG
	else
		return

/datum/reagent/toxin/acid/xenoblood
	name = "acid blood"
	id = "xblood"
	description = "A highly corrosive substance, it is capable of burning through most natural or man-made materials in short order."
	color = "#66CC00"
	toxpwr = 0
	acidpwr = 12


/datum/species/yautja
	name = "Yautja"
	id = "pred"
	say_mod = "clicks"
	eyes = "predeyes"
	mutant_organs = list(/obj/item/organ/tongue/yautja)
	specflags = list(EYECOLOR)
	lang_spoken = YAUTJA
	lang_understood = HUMAN|YAUTJA|ALIEN
	no_equip = list(slot_head)
	punchdamagelow = 4
	punchdamagehigh = 14
	punchstunthreshold = 13
	blacklisted = 1
	whitelist = 1
	whitelist = list("talkingcactus")

/datum/outfit/yautja_basic
	name = "Yautja, Basic"
	uniform = /obj/item/clothing/under/mesh
	suit = /obj/item/clothing/suit/armor/yautja_fake
	shoes = /obj/item/clothing/shoes/yautja_fake
	mask = /obj/item/clothing/mask/gas/yautja_fake

/datum/species/yautja/before_equip_job(datum/job/J, mob/living/carbon/human/H, visualsOnly = FALSE)
	var/datum/outfit/yautja_basic/O = new /datum/outfit/yautja_basic//Just basic gear. Doesn't include anything that gives any meaningful advantage.
	H.equipOutfit(O, visualsOnly)
	return 0

/datum/species/octopus
	blacklisted = 1
/datum/species/carp
	blacklisted = 1
/datum/species/horse
	blacklisted = 1*/

///////////////////
//DONATOR SPECIES//
///////////////////

//ChronoFlux: Slimecoon
/*
/datum/species/jelly/slime/slimecoon
	name = "Slime Raccoon"
	id = "slimecoon"
	limbs_id = "slime"
	whitelisted = 1
	whitelist = list("chronoflux")
	blacklisted = 1
	mutant_bodyparts = list("slimecoontail", "slimecoonears", "slimecoonsnout")
	default_features = list("slimecoontail" = "Slimecoon Tail", "slimecoonears" = "Slimecoon Ears", "slimecoonsnout" = "Slimecoon Snout")*/

// Fat Shark <3

/datum/species/shark/datashark
	name = "DataShark"
	id = "datashark"
	default_color = "BCAC9B"
	species_traits = list(MUTCOLORS_PARTSONLY,EYECOLOR,LIPS,HAIR)
	mutant_bodyparts = list("mam_tail", "mam_body_markings")
	default_features = list("mam_tail" = "datashark", "mam_body_markings" = "None")
	attack_verb = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	whitelisted = 1
	whitelist = list("rubyflamewing")
	blacklisted = 0

/datum/species/guilmon
	name = "Guilmon"
	id = "guilmon"
	default_color = "4B4B4B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	mutant_bodyparts = list("mam_tail", "mam_ears", "mam_body_markings")
	default_features = list("mcolor" = "FFF", "mcolor2" = "FFF", "mcolor3" = "FFF", "mam_tail" = "guilmon", "mam_ears" = "guilmon", "mam_body_markings" = "guilmon")
	attack_verb = "claw"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
