/datum/inventory
	/// inventory hide level
	var/slot_hide_mode = INVENTORY_HIDE_COMMON
	/// all screen objects currently shown to the user
	var/list/atom/movable/screen/inventory/showing
	/// all users currently viewing us
	var/mob/viewing
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
	for(var/i in AllItems(TRUE))
		qdel(i)
	items_by_slot = null
	holding = null
	screen_cram = null
	disabled_slots = null
	return ..()


