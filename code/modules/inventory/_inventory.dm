/**
 * Inventory Datum
 *
 * Holds all data and procs used to operate a mob inventory.
 * Use procs in here and mob accessor procs.
 *
 * WARNING:
 * **DO NOT** touch variables in here without using the procs.
 * To optimize for speed and memory, lists are **ORDERED**. This means that illegal or unchecked modifications **WILL** cause near-undebuggable bugs that will give everyone a headache.
 *
 * As such, every sensitive var is marked privae. Only one type of thsi datum should ever exist, and only this datum should ever touch them, using its own procs.
 */
/datum/inventory
	/// inventory hide level
	var/slot_hide_mode = INVENTORY_HIDE_COMMON
	/// all screen objects currently shown to the user
	var/list/atom/movable/screen/inventory/showing
	/// all users currently viewing us
	var/mob/viewing
	/// mob that owns us
	var/mob/owner
	/// ordered inventory slots
	VAR_PRIVATE/list/slots
	/// list of all items in us
	VAR_PRIVATE/list/obj/item/holding
	/// dynamic inventory screen cramming - slots without screen_loc are put here
	var/list/screen_cram
	/// disabled slots - these exist but are grayed out. associated by id to the reason they're disabled. managed by the mob.
	var/list/disabled_slots

/datum/inventory/New(list/slots)
	src.slots = list()
	src.holding = list()
	for(var/i in slots)
		AddSlot(i)

/datum/inventory/Destroy()
	for(var/i in AllItems(TRUE))
		qdel(i)	// this handles removal
	for(var/i in slots)
		DeleteSlot(i)
	items_by_slot = null
	holding = null
	screen_cram = null
	disabled_slots = null
	return ..()


