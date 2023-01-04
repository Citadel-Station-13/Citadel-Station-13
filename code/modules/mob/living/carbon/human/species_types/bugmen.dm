/datum/species/insect
	name = "Anthropomorphic Insect"
	id = SPECIES_INSECT
	say_mod = "chitters"
	default_color = "00FF00"
	species_traits = list(LIPS,EYECOLOR,HAIR,FACEHAIR,MUTCOLORS,HORNCOLOR,WINGCOLOR,HAS_FLESH,HAS_BONE)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutant_bodyparts = list("mcolor" = "FFFFFF","mcolor2" = "FFFFFF","mcolor3" = "FFFFFF", "mam_tail" = "None", "mam_ears" = "None",
							"insect_wings" = "None", "insect_fluff" = "None", "mam_snouts" = "None", "taur" = "None", "insect_markings" = "None", "mam_body_markings" = list())
	attack_verb = "claw"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/insect
	liked_food = MEAT | FRUIT
	disliked_food = TOXIC
	exotic_bloodtype = "BUG"
	exotic_blood_color = BLOOD_COLOR_BUG

	tail_type = "mam_tail"
	wagging_type = "mam_waggingtail"
	species_category = SPECIES_CATEGORY_INSECT
	wings_icons = SPECIES_WINGS_INSECT

	allowed_limb_ids = list("insect","apid","moth","moth_not_greyscale")

	eye_type = "insect"
	
	family_heirlooms = list(
		/obj/item/flashlight/lantern/heirloom_moth
	)
