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
	/// dynamic inventory screen cramming - slots without screen_loc are put here
	var/list/screen_cram
	/// disabled slots - these exist but are grayed out. associated by id to the reason they're disabled. managed by the mob.
	var/list/disabled_slots

/datum/inventory/Destroy()
	delete_inventory()
	return ..()


