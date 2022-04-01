GLOBAL_LIST_EMPTY(inventory_slots)

/proc/get_inventory_slot_datum(id_or_type)
	RETURN_TYPE(/datum/inventory_slot)
	if(istype(id_or_type, /datum/inventory_slot))
		return id_or_type
	if(GLOB.inventory_slots[id_or_type])
		return GLOB.inventory_slots[id_or_type]
	if(ispath(id_or_type, /datum/inventory_slot))
		. = new id_or_type
		GLOB.inventory_slots[id_or_type] = .

/**
 * meta for inventory slots
 * can be created manually for overrides on mobs, but otherwise
 * should be cached.
 */
/datum/inventory_slot
	/// slot name
	var/name
	/// unique slot id
	var/id
	/// is inventory? stuff like handcuffing/legcuffing isn't.
	var/is_inventory = TRUE
	/// is abstract? stuff lke "slot in backpack" obviously isn't.
	var/is_abstract = FALSE
	/// render layer
	var/render_layer
	#warn put in render layers

/datum/inventory_slot/New(_id)
	id = _id || type
	if(isnull(name))
		name = "[id]"

/**
 * worn clothes - these have render keys.
 */
/datum/inventory_slot/equipment
	is_inventory = TRUE
	is_abstract = FALSE
	/// render key - the [_slot] in [worn_state][_slot][_bodytype].
	var/render_key

/**
 * standard "item slot flag fits in" inventory slots
 */
/datum/inventory_slot/equipment/flag
	/// flag to use
	var/slot_flag

/datum/inventory_slot/equipment/flag/head
	name = "Head"
	slot_flag = ITEM_SLOT_HEAD
	render_key = "head"

/datum/inventory_slot/equipment/flag/ears
	name = "Ears"
	slot_flag = ITEM_SLOT_EARS
	render_key = "ears"

/datum/inventory_slot/equipment/flag/neck
	name = "Neck"
	slot_flag = ITEM_SLOT_NECK
	render_key = "neck"

/datum/inventory_slot/equipment/flag/back
	name = "Back"
	slot_flag = ITEM_SLOT_BACK
	render_key = "back"

/datum/inventory_slot/equipment/flag/suit
	name = "Oversuit"
	slot_flag = ITEM_SLOT_OCLOTHING
	render_key = "suit"

/datum/inventory_slot/equipment/flag/uniform
	name = "Uniform"
	slot_flag = ITEM_SLOT_ICLOTHING
	render_key = "uniform"

/datum/inventory_slot/equipment/flag/suit_store
	name = "Suit Storage"
	slot_flag = ITEM_SLOT_SUITSTORE
	render_key = "suitstore"

/datum/inventory_slot/equipment/flag/mask
	name = "Mask"
	slot_flag = ITEM_SLOT_MASK
	render_key = "mask"

/datum/inventory_slot/equipment/flag/gloves
	name = "Gloves"
	slot_flag = ITEM_SLOT_GLOVES
	render_key = "hands"

/datum/inventory_slot/equipment/flag/shoes
	name = "Shoes"
	slot_flag = ITEM_SLOT_FEET
	render_key = "feet"

/datum/inventory_slot/equipment/flag/eyes
	name = "Glasses"
	slot_flag = ITEM_SLOT_EYES
	render_key = "eyes"

/datum/inventory_slot/equipment/flag/belt
	name = "Belt"
	slot_flag = ITEM_SLOT_BELT
	render_key = "belt"

/datum/inventory_slot/equipment/flag/id
	name = "ID"
	slot_flag = ITEM_SLOT_ID
	render_key = "id"

/datum/inventory_slot/equipment/pocket

/datum/inventory_slot/equipment/pocket/left
	name = "Left Pocket"

/datum/inventory_slot/equipment/pocket/right
	name = "Right Pocket"

/**
 * abstract slots - marks certain behaviors so we don't need to use define values.
 */
/datum/inventory_slot/abstract
	is_inventory = FALSE
	is_abstract = TRUE

/**
 * slot something into something on the player
 */
/datum/inventory_slot/abstract/slot_in

/**
 * slot something in backpack
 */
/datum/inventory_slot/abstract/slot_in/backpack
	name = "Slot in Backpack"

/**
 * slot something in belt
 */
/datum/inventory_slot/abstract/slot_in/belt
	name = "Slot in Belt"

/**
 * put into character's hands
 */
/datum/inventory_slot/abstract/put_in_hands
	name = "Put in Hands"

/**
 * virtual slots - not inventory, but not abstract (actually exists)
 */
/datum/inventory_slot/virtual
	is_inventory = FALSE
	is_abstract = FALSE

/datum/inventory_slot/virtual/hand

/datum/inventory_slot/virtual/hand/left
	name = "Left Hand"

/datum/inventory_slot/virtual/hand/right
	name = "Right Hand"
