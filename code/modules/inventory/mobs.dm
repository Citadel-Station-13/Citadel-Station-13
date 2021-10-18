/mob
	/// inventory - starts out as a list of ids or typepaths, made into datum on init. Hand items/held items are NOT in this!
	var/datum/inventory

/mob/Initialize()
	if(islist(inventory))
		inventory = typelist("inv_slots_initial", inventory)
	return ..()

/mob/Destroy()
	DestroyInventory()
	return ..()

/mob/Login()
	EnsureInventory()
	inventory?.OwnerLogin()
	return ..()

/mob/Logout()
	inventory?.OwnerLogout()
	return ..()

/**
 * ensures our inventory is made, if it should be made
 * if it shouldn't be, null it out
 */
/mob/proc/EnsureInventory()
	if(istype(inventory))
		return TRUE
	if(isnull(inventory))
		return FALSE
	if(islist(inventory) && length(inventory))
		CreateInventory()
		return TRUE
	inventory = null
	return FALSE

/mob/proc/CreateInventory()
	inventory = new /datum/inventory(src, inventory)

/**
 * destroys inventory
 * 3
 * @params
 * - drop - if FALSE, deletes everything instead of dropping
 * - destination - drop destination, defaults to drop_location()
 */
/mob/proc/DestroyInventory(drop = FALSE, atom/destination = drop_location())
	if(islist(inventory))			// DO NOT destroy the typelist
		inventory = null
		return
	if(drop)
		#warn finish
	QDEL_NULL(inventory)

/**
 * gets item by slot id
 */
/mob/proc/get_item_by_slot(id)
	return inventory?.ItemBySlot(id)

/**
 * gets all items in inventory, not including hands
 */
/mob/proc/get_all_inventory_items()
	return inventory?.AllItems()

/**
 * Equips an item to a slot
 *
 * @param
 * - I - item
 * - slot - slot ID
 * - force - ignore can equip checks
 * - delete_old_item - delete old item instead of drop
 */
/mob/proc/equip_to_slot(obj/item/I, slot, force = FALSE, delete_old_item = FALSE)
	EnsureInventory()
	inventory?.EquipToSlot(I, slot, force, delete_old_item)

/**
 * drops all inventory items
 */
/mob/proc/drop_all_inventory_items()
	return inventory?.DropEverything()
