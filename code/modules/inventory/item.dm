/obj/item
	/// what slot is holding us currently - holds ID
	var/inventory_slot
	/// reference to the inventory holding us - holds reference
	var/datum/inventory/inventory

/**
 * Gets the current slot ID we're in
 */
/obj/item/proc/GetInventorySlot()
	return inventory_slot

/**
 * Gets the slot meta datum of the slot id we're in
 */
/obj/item/proc/GetInventorySlotDatum()
	RETURN_TYPE(/datum/inventory_slot_meta)
	return get_inventory_slot_datum(inventory_slot)
