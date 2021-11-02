/mob
	/// inventory - starts out as a list of ids or typepaths, made into datum on init. Hand items/held items are NOT in this!
	var/datum/inventory/inventory

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
/mob/proc/ItemBySlot(id)
	return inventory?.ItemBySlot(id)

/**
 * gets all items in inventory, not including hands
 */
/mob/proc/GetAllInventoryItems(include_abstract)
	return inventory?.AllItems(include_abstract)

/**
 * Equips an item to a slot
 *
 * Returns TRUE or FALSE.
 *
 * @param
 * - I - item
 * - user - who's doing this - can be null
 * - slot - slot ID
 * - force - ignore can equip checks
 * - delete_old_item - delete old item instead of drop
 * - warnings - list of reasons why it didn't work if we're not forcing it
 */
/mob/proc/EquipToSlot(obj/item/I, mob/user, slot, force = FALSE, delete_old_item = FALSE, list/warnings)
	switch(slot)
		if(INV_VIRTUALSLOT_IN_BACKPACK)

		if(INV_VIRTUALSLOT_IN_BELT)

		if(INV_VIRTUALSLOT_IN_HANDS)

		if(INV_VIRTUALSLOT_IN_POCKETS)
	EnsureInventory()
	inventory?.EquipToSlot(I, user, slot, force, delete_old_item, warnings)

/**
 * Grabs an item from slot
 *
 * Returns the item unequipped if successful.
 *
 * @param
 * - slot - slot
 * - user - who's doing this - can be null
 * - force - ignore can unequip checks
 * - new_location - where to put it
 * - warnings - list of reasons why it didn't work if we're not forcing it
 * - move_item - do we actually move the item? new_location ignored if so
 */
/mob/proc/UnequipFromSlot(slot, mob/user, force = FALSE, atom/new_location = drop_location(), list/warnings, move_item = TRUE)
	return inventory?.UnequipFromSlot(slot, user, force, new_location, warnings, move_item)

/**
 * Unequips an item from a slot
 *
 * Returns the slot it was in if successful.
 *
 * @param
 * - I - item
 * - user - who's doing this - can be null
 * - force - ignore can unequip checks
 * - new_location - where to put it
 * - warnings - list of reasons why it didn't work if we're not forcing it
 * - move_item - do we actually move the item? new_location ignored if so
 */
/mob/proc/UnequipItem(obj/item/I, mob/user, force = FALSE, atom/new_location = drop_location(), list/warnings, move_item = TRUE)
	return inventory?.UnequipItem(I, force, user, new_location, warnings, move_item)

/**
 * drops all inventory items
 *
 * @param
 * - force - forcefully unequips things that don't want to be/can't be
 * - include_abstract - includes slots that aren't considered player inventory slots
 * - new_location - where to put the items
 */
/mob/proc/DropAllInventoryItems(force = TRUE, include_abstract = TRUE, atom/new_location = drop_location())
	return inventory?.DropEverything(force, include_abstract, new_location)

/**
 * Checks if a slot exists
 */
/mob/proc/InventorySlotExists(slot)
	EnsureInventory()
	return inventory?.SlotExists(slot)

/**
 * Returns the slot if an item is equipped, null otherwise
 */
/mob/proc/IsEquipped(obj/item/I)
	return inventory?.HasItem(I)

/**
 * Checks if we can put an item in a slot
 */
/mob/proc/CanEquip(obj/item/I, slot, mob/user, list/warnings)
	SHOULD_NOT_OVERRIDE(TRUE)
	EnsureInventory()
	return inventory?.CanEquip(I, slot, user, warnings)

/**
 * Checks if we can unequip an item from a slot
 */
/mob/proc/CanUnequip(obj/item/I, mob/user, list/warnings)
	SHOULD_NOT_OVERRIDE(TRUE)
	EnsureInventory()
	return inventory?.CanUnequip(I, user, warnings)

/**
 * proc that can be overridden:
 * can we use a certain slot?
 */
/mob/proc/CheckItemEquip(obj/item/I, datum/inventory_slot_meta/slot, mob/user, list/warnings)
	return TRUE

/**
 * proc that can be overridden:
 * can we take an item out of a certain slot?
 */
/mob/proc/CheckItemUnequip(obj/item/I, datum/inventory_slot_meta/slot, mob/user, list/warnings)
	return TRUE

/**
 * update slots:
 * override by mob
 * used to enable/disable slots.
 */
/mob/proc/UpdateInventorySlots()
	return

/**
 * Wraps Exited to ensure grabbing items out of mobs removes from inventory
 */
/mob/Exited(atom/movable/AM, atom/newLoc)
	if(IsEquipped(AM))
		UnequipItem(AM, force = TRUE, move_item = FALSE)
	return ..()

