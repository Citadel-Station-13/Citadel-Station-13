/datum/species/vox // shitbirds
	name = "Vox"
	id = "vox"
	limbs_id= "swamp"
	say_mod = "shrieks"
	sexes = 0
	species_traits = list(HAS_FLESH,HAS_BONE,NOEYES,NO_UNDERWEAR,NOGENITALS,NOAROUSAL)
	inherent_traits = list(TRAIT_VOXYGEN)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mutant_bodyparts = list("quills" = "None")
	meat = /obj/item/reagent_containers/food/snacks/nugget // lmao
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	disliked_food =  DAIRY | VEGETABLES
	liked_food = MEAT | FRUIT
	mutantlungs = /obj/item/organ/lungs/vox
	mutantliver = /obj/item/organ/liver/vox
	mutantstomach = /obj/item/organ/liver/vox
	mutant_heart = /obj/item/organ/heart/vox
	mutant_brain = /obj/item/organ/brain/vox

	species_language_holder = /datum/language_holder/vox
	exotic_bloodtype = "VOX"
	exotic_blood_color = BLOOD_COLOR_VOX
	damage_overlay_type = ""
	attack_verb = "scratch"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	coldmod = 0.6
	brutemod = 1.2

	exotic_bloodtype = "VOX"
	exotic_blood_color = BLOOD_COLOR_VOX

	allowed_limb_ids = list("swamp","azure","rot","emerald","grassland","midnight")

/obj/item/organ/brain/vox
	name = "vox brain"
	desc = "A mass of foul-smelling head-meat in a shade of patented Vox blue; the sheer odor this thing emanates as it writhes upon exposure to open air sours your senses."
	icon_state = "brain-vox"
