/datum/gear/mask
	category = LOADOUT_CATEGORY_MASK
	slot = SLOT_WEAR_MASK

/datum/gear/mask/balaclava
	name = "Balaclava"
	path = /obj/item/clothing/mask/balaclava

/datum/gear/mask/moustache
	name = "Fake moustache"
	path = /obj/item/clothing/mask/fakemoustache

/datum/gear/mask/joy
	name = "Joy mask"
	path = /obj/item/clothing/mask/joy
	cost = 3

/datum/gear/mask/gas
	name = "Gas Mask"
	path = /obj/item/clothing/mask/gas
	cost = 2
	restricted_roles = list("Chief Engineer", "Atmospheric Technician", "Station Engineer") //*shrug
