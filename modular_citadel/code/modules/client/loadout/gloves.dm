/datum/gear/gloves
	category = LOADOUT_CATEGORY_GLOVES
	slot = ITEM_SLOT_GLOVES

/datum/gear/gloves/fingerless
	name = "Fingerless Gloves"
	path = /obj/item/clothing/gloves/fingerless

/datum/gear/gloves/evening
	name = "Evening gloves"
	path = /obj/item/clothing/gloves/evening

/datum/gear/gloves/midnight
	name = "Midnight gloves"
	path = /obj/item/clothing/gloves/evening/black

/datum/gear/gloves/maidpoly // WHAT DO YOU EVEN CALL THEM
	name = "Polychromic maid gloves"
	path = /obj/item/clothing/gloves/polymaid
	loadout_flags = LOADOUT_CAN_NAME | LOADOUT_CAN_DESCRIPTION | LOADOUT_CAN_COLOR_POLYCHROMIC
	loadout_initial_colors = list("#333333", "#FFFFFF")

/datum/gear/gloves/goldring
	name = "A gold ring"
	path = /obj/item/clothing/gloves/ring
	cost = 2

/datum/gear/gloves/silverring
	name = "A silver ring"
	path = /obj/item/clothing/gloves/ring/silver
	cost = 2

/datum/gear/gloves/diamondring
	name = "A diamond ring"
	path = /obj/item/clothing/gloves/ring/diamond
	cost = 4

/datum/gear/gloves/customring
	name = "A ring, renameable"
	path = /obj/item/clothing/gloves/ring/custom
