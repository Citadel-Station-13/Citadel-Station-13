/datum/species/vox // shitbirds
	name = "Vox"
	id = "vox"
	say_mod = "shrieks"
	sexes = 0
	species_traits = list(HAS_FLESH,HAS_BONE,NOEYES,NO_UNDERWEAR,NOGENITALS,NOAROUSAL)
	inherent_traits = list(TRAIT_VOXYGEN)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	meat = /obj/item/reagent_containers/food/snacks/nugget // lmao
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	disliked_food =  DAIRY | VEGETABLES
	liked_food = MEAT | FRUIT
	mutantlungs = /obj/item/organ/lungs/vox
	species_language_holder = /datum/language_holder/vox
	exotic_bloodtype = "VOX"
	exotic_blood_color = BLOOD_COLOR_VOX
	attack_verb = "scratch"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	coldmod = 0.6
	brutemod = 1.2

	exotic_bloodtype = "VOX"
	exotic_blood_color = BLOOD_COLOR_VOX
