/obj/item
	/// what slot is holding us currently - holds ID
	var/inventory_slot
	/// reference to the inventory holding us - holds reference
	var/datum/inventory/inventory

/obj/item/proc/get_current_inventory_slot()
	return inventory_slot

/obj/item/proc/get_current_inventory_slot_datum()
	RETURN_TYPE(/datum/inventory_slot_meta)
	return get_inventory_slot_datum(inventory_slot)
