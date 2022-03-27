GLOBAL_LIST_EMPTY(inventory_slots)

/proc/get_inventory_slot_datum(id_or_type)
	RETURN_TYPE(/datum/inventory_slot)
	if(GLOB.inventory_slots[id_or_type])
		return GLOB.inventory_slots[id_or_type]
	if(ispath(id_or_type, /datum/inventory_slot))
		. = new id_or_type
		GLOB.inventory_slots[id_or_type] = .

/**
 * meta for inventory slots
 * can be created manually for overrides on mobs
 */
/datum/inventory_slot
	/// slot name
	var/name
	/// unique slot id
	var/id
	/// render key - the [_slot] in [worn_state][_slot][_bodytype].
	var/render_key
	/// is inventory? stuff like handcuffing/legcuffing isn't.
	var/is_inventory = TRUE
	/// is abstract? stuff lke "slot in backpack" obviously isn't.
	var/is_abstract = FALSE

/datum/inventory_slot/New(_id)
	id = _id || type
	if(isnull(name))
		name = "[id]"

#warn put in standard inv slots, /flagged, etc.

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
	render_key = "_lhand"

/datum/inventory_slot/virtual/hand/right
	name = "Right Hand"
	render_key = "_rhand"
