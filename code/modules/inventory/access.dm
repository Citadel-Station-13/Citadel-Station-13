/**
 * Equips an item
 *
 * Returns TRUE or FALSE
 */
/datum/inventory/proc/EquipToSlot(obj/item/I, slot, mob/user, force, delete_old_item, list/warnings, move_item = TRUE)
	slot = "[slot]"

/**
 * Unequips an item
 *
 * Returns item that was unequipped if successful
 */
/datum/inventory/proc/UnequipFromSlot(slot, mob/user, force, atom/new_location, list/warnings, move_item = TRUE)
	slot = "[slot]"

/**
 * Unequips an item
 *
 * Returns slot it was in if successful
 */
/datum/inventory/proc/UnequipItem(obj/item/I, mob/user, force, atom/new_location, list/warnings, move_item = TRUE)

/**
 * Does a slot exist?
 */
/datum/inventory/proc/SlotExists(slot)
	return ("[slot]" in slots)

/**
 * Can we equip an item?
 */
/datum/inventory/proc/CanEquip(obj/item/I, slot, mob/user, list/warnings)

/**
 * Can we unequip an item?
 */
/datum/inventory/proc/CanUnequip(obj/item/I, mob/user, list/warnings)
	var/index = IndexItem(I)
	if(!index)
		CRASH("Asked if we can unequip an item we don't have")

/**
 * Drop everything
 */
/datum/inventory/proc/DropEverything(force, include_abstract, atom/new_location = owner.drop_location())
	for(var/i in items_by_slot)
		var/datum/inventory_slot_meta/slot = get_inventory_slot_datum(i)
		if(!include_abstract && !slot.is_inventory)
			continue
		UnequipFromSlot(i, null, force, new_location)

/**
 * Do we have an item?
 */
/datum/inventory/proc/HasItem(obj/item/I)
	return (I in holding)

/**
 * Find index of item
 */
/datum/inventory/proc/IndexItem(obj/item/I)
	return holding.Find(I)

/**
 * Gets all items
 */
/datum/inventory/proc/AllItems(include_abstract = FALSE)
	if(!include_abstract)
		. = list()
		for(var/index in 1 to slots.len)
			var/id = slots[index]
			var/datum/inventory_slot_meta/SM = get_inventory_slot_datum(id)
			if(SM && SM.abstract)
				continue
			if(holding[index])
				. += holding[index]
	else
		. = list()
		for(var/i in holding)
			if(i)
				. += i
