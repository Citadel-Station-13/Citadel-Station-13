/**
 * Equips an item
 */
/datum/inventory/proc/EquipToSlot(obj/item/I, slot, mob/user, force, delete_old_item, list/warnings)

/**
 * Unequips an item
 */
/datum/inventory/proc/UnequipFromSlot(slot, mob/user, force, atom/new_location, list/warnings)

/**
 * Does a slot exist?
 */
/datum/inventory/proc/SlotExists(slot)
	return (slot in items_by_slot)

/**
 * Can we equip an item?
 */
/datum/inventory/proc/CanEquip(obj/item/I, slot, mob/user, list/warnings)

/**
 * Can we unequip an item?
 */
/datum/inventory/proc/CanUnequip(obj/item/I, mob/user, list/warnings)
	if(!(I in holding))
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
