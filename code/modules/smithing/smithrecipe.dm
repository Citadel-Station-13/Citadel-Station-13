GLOBAL_LIST_INIT_TYPED(smith_recipes, /datum/smith_recipe, subtypesof(/datum/smith_recipe))

/datum/smith_recipe
	var/displayname = "base smithing recipe type"
	var/list/planlaststeps = list(null, null, null)
	var/laststepsneeded = 3
	var/target_height_min = 72
	var/target_height_perfect = 76
	var/target_height_max = 82
	var/obj/item/smithing/output_type


//sords

/datum/smith_recipe/scimitar
	displayname = "scimitar blade"
	planlaststeps = list(STEP_BEND, STEP_HIT_MODERATE, STEP_HIT_MODERATE)
	laststepsneeded = 2
	target_height_min = 10
	target_height_perfect = 12
	target_height_max = 16
	output_type = /obj/item/smithing/scimitarblade

/datum/smith_recipe/rapier
	displayname = "rapier blade"
	planlaststeps = list(STEP_DRAW, STEP_UPSET, STEP_FOLD)
	target_height_min = 8
	target_height_perfect = 12
	target_height_max = 12
	output_type = /obj/item/smithing/rapierblade

/datum/smith_recipe/broadsword
	displayname = "broadsword blade"
	planlaststeps = list(STEP_HIT_LIGHT, STEP_BEND, STEP_BEND)
	target_height_min = 14
	target_height_perfect = 18
	target_height_max = 20
	output_type = /obj/item/smithing/broadblade

/datum/smith_recipe/katana
	displayname = "katana blade"
	planlaststeps = list(STEP_FOLD, STEP_FOLD, STEP_FOLD)
	target_height_min = 72
	target_height_perfect = 74
	target_height_max = 84
	output_type = /obj/item/smithing/katanablade








//spears

/datum/smith_recipe/javelin
	displayname = "javelin head"
	planlaststeps = list(STEP_HIT_LIGHT, STEP_HIT_LIGHT, STEP_DRAW)
	target_height_min = 24
	target_height_perfect = 26
	target_height_max = 30
	output_type = /obj/item/smithing/javelinhead

/datum/smith_recipe/pike
	displayname = "pike head"
	planlaststeps = list(STEP_HIT_HEAVY, STEP_DRAW, STEP_DRAW)
	target_height_min = 24
	target_height_perfect = 26
	target_height_max = 30
	output_type = /obj/item/smithing/pikehead






//mining

/datum/smith_recipe/mining
	displayname = "pickaxe head"
	planlaststeps = list(STEP_PUNCH, STEP_BEND, STEP_DRAW)
	target_height_min = 48
	target_height_perfect = 56
	target_height_max = 56
	output_type = /obj/item/smithing/pickaxehead

/datum/smith_recipe/miningscanner
	displayname = "prospector's pickaxe head"
	planlaststeps = list(STEP_PUNCH, STEP_DRAW, STEP_BEND)
	laststepsneeded = 2
	target_height_min = 24
	target_height_perfect = 26
	target_height_max = 28
	output_type = /obj/item/smithing/prospectingpickhead

//misc

/datum/smith_recipe/cogheadclub
	displayname = "coghead club head"
	planlaststeps = list(STEP_PUNCH, STEP_HIT_HEAVY, STEP_UPSET)
	target_height_min = 84
	target_height_perfect = 90
	target_height_max = 92
	output_type = /obj/item/smithing/cogheadclubhead


/datum/smith_recipe/scytheblade
	displayname = "scythe blade"
	planlaststeps = list(STEP_HIT_MODERATE, STEP_BEND, STEP_BEND)
	target_height_min = 38
	target_height_perfect = 42
	target_height_max = 46
	output_type = /obj/item/smithing/scytheblade

/datum/smith_recipe/hammerhead
	displayname = "hammer head"
	planlaststeps = list(STEP_PUNCH, STEP_UPSET, STEP_UPSET)
	target_height_min = 60
	target_height_perfect = 64
	target_height_max = 68
	output_type = /obj/item/smithing/hammerhead
