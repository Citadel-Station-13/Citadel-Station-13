/datum/gear/accessory
	category = LOADOUT_CATEGORY_ACCESSORY
	slot = ITEM_SLOT_ACCESSORY
	handle_post_equip = TRUE

/datum/gear/accessory/necklace
	name = "A renameable necklace"
	path = /obj/item/clothing/accessory/necklace

/datum/gear/accessory/polymaidapron
	name = "Polychromic maid apron"
	path = /obj/item/clothing/accessory/maidapron/polychromic
	loadout_flags = LOADOUT_CAN_NAME | LOADOUT_CAN_DESCRIPTION | LOADOUT_CAN_COLOR_POLYCHROMIC
	loadout_initial_colors = list("#333333", "#FFFFFF")

/datum/gear/accessory/pridepin
	name = "Pride pin"
	path = /obj/item/clothing/accessory/pride
	loadout_flags = LOADOUT_CAN_NAME | LOADOUT_CAN_DESCRIPTION
	cost = 0
