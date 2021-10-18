/datum/inventory
	/// inventory hide level
	var/slot_hide_mode = INVENTORY_HIDE_COMMON
	/// all screen objects currently shown to the user
	var/list/obj/screen/inventory/showing
	/// mob that owns us
	var/mob/owner
	/// list of IDs associated to what is in them
	var/list/items_by_slot
	/// list of all items in us
	var/list/obj/item/holding

/datum/inventory/Destroy()
	delete_inventory()
	return ..()
