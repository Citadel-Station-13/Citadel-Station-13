GLOBAL_LIST_INIT(inventory_slot_meta, inventory_slot_meta())

/proc/inventory_slot_meta()
	. = list()
	for(var/path in subtypesof(/datum/inventory_slot_meta))
		var/datum/inventory_slot_meta/slot = new path
		.[slot.id] = slot

/**
  * Gets inventory slot meta of a slot
  */
/proc/get_inventory_slot_meta(id)
	return GLOB.inventory_slot_meta[id]

/**
  * Datum for storing data about a certain inventory slot.
  */
/datum/inventory_slot_meta
	/// Slot name
	var/name = "ERROR"
	/// ID (__DEFINES/inventory/inventory_slots.dm)
	var/id = "ERROR"
	/// Virtual slot? If it is we aren't a "real" slot and we should be specially handled. See: INVENTORY_SLOT_PUT_IN_HANDS where you want to put stuff into hands rather than a specific slot
	var/virtual = FALSE
	/// Typepath to /datum/inventory_slot
	var/slot_datum_path
	/// Default spritesheet. Either a single file or a list of CLOTHING_ASSET_SET_DEFINE = file
	var/default_spritesheet

/datum/inventory_slot_meta/back
	name = "Back"
	id = INVENTORY_SLOT_BACK
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/back

/datum/inventory_slot_meta/back
	name = "Back"
	id = INVENTORY_SLOT_BACK
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/back

/datum/inventory_slot_meta/mask
	name = "Mask"
	id = INVENTORY_SLOT_MASK
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/mask

/datum/inventory_slot_meta/handcuffed
	name = "Handcuffed"
	id = INVENTORY_SLOT_HANDCUFFED
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/handcuffed

/datum/inventory_slot_meta/put_in_hands
	name = "Put Into Hands"
	id = INVENTORY_SLOT_PUT_IN_HANDS
	virtual = TRUE

/datum/inventory_slot_meta/belt
	name = "Belt"
	id = INVENTORY_SLOT_BELT
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/belt

/datum/inventory_slot_meta/id_card
	name = "ID Card"
	id = INVENTORY_SLOT_ID_CARD
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/id_card

/datum/inventory_slot_meta/ears
	name = "Ears"
	id = INVENTORY_SLOT_EARS
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/ears

/datum/inventory_slot_meta/glasses
	name = "Glasses"
	id = INVENTORY_SLOT_GLASSES
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/glasses

/datum/inventory_slot_meta/gloves
	name = "Gloves"
	id = INVENTORY_SLOT_GLOVES
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/gloves

/datum/inventory_slot_meta/neck
	name = "Neck"
	id = INVENTORY_SLOT_NECK
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/neck

/datum/inventory_slot_meta/head
	name = "Head"
	id = INVENTORY_SLOT_HEAD
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/head

/datum/inventory_slot_meta/shoes
	name = "Shoes"
	id = INVENTORY_SLOT_SHOES
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/shoes

/datum/inventory_slot_meta/outerwear
	name = "Outerwear"
	id = INVENTORY_SLOT_OUTERWEAR
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/outerwear

/datum/inventory_slot_meta/uniform
	name = "Uniform"
	id = INVENTORY_SLOT_UNIFORM
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/uniform

/datum/inventory_slot_meta/left_pocket
	name = "Left Pocket"
	id = INVENTORY_SLOT_L_STORE
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/left_pocket

/datum/inventory_slot_meta/right_pocket
	name = "Right Pocket"
	id = INVENTORY_SLOT_R_STORE
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/right_pocket

/datum/inventory_slot_meta/suit_storage
	name = "Suit Storage"
	id = INVENTORY_SLOT_S_STORE
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/suit_storage

/datum/inventory_slot_meta/put_in_backpack
	name = "Put In Backpack"
	id = INVENTORY_SLOT_PUT_IN_BACKPACK
	virtual = TRUE

/datum/inventory_slot_meta/legcuffed
	name = "Legcuffed"
	id = INVENTORY_SLOT_LEGCUFFED
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/legcuffed

/datum/inventory_slot_meta/generic_dextrous_storage
	name = "Generic Dextrous Storage"
	id = INVENTORY_SLOT_GENERIC_DEXTROUS_STORAGE
	virtual = FALSE
	slot_datum_path = /datum/inventory_slot/generic_dextrous_storage
