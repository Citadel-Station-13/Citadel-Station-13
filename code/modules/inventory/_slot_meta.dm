/**
 * Holds data for each inventory slot
 * We don't need to make slot datums at the moment
 * These are singletons
 */
GLOBAL_LIST_EMPTY(inventory_slot_meta)

/proc/get_inventory_slot_datum(id)
	if(ispath(id))
		id = "[id]"
		return inventory_slot_meta[id] || (((inventory_slot_meta[id] = new text2path(id))) && inventory_slot_meta[id])
	if(istype(id, /datum/inventory_slot_meta))
		return id
	return inventory_slot_meta[id]

/datum/inventory_slot_meta
	/// slot name
	var/name
	/// slot id
	var/id
	/// icon used for screen objects
	var/icon = 'icons/core/inventory/screen.dmi'
	/// icon state
	var/icon_state = "generic"
	/// screen loc
	var/screen_loc
	/// screen object
	var/obj/screen/inventory/screen

/datum/inventory_slot_meta/New()

/datum/inventory_slot_meta/proc/get_screen()
	if(!screen)
		return instantiate_screen()
	return screen

/datum/inventory_slot_meta/proc/instantiate_screen()
	screen = new(null, src, name, icon, icon_state)
	return screen

/**
 * Returns whether or not we can hold a certain item
 */
/datum/inventory_slot_meta/proc/can_hold(obj/item/I)
