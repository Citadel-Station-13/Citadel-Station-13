/obj/item
	/// what slot is holding us currently - holds ID
	var/inventory_slot
	/// reference to the inventory holding us - holds reference
	var/datum/inventory/inventory
	/// inventory hide flags - what we hide when in inventory. hand/held items are NOT inventory! List for overrides.
	var/inv_hide
	/// inventory flags - determines behavior when in inventory. hand/held items are NOT inventory! List for overrides.
	var/inv_flags
	/// body parts covered - determines what bodyparts we cover when in inventory. hand/held items are NOT inventory! List for overrides.
	var/inv_cover
	/// a single icon file or a list of icon files to use for onmob rendering by slot
	var/list/inv_spritesheets
	/// a single layer or a list of layers by slot for onmob rendering
	var/list/inv_render_layers

/obj/item/Initialize()
	if(islist(inv_hide))
		inv_hide = typelist(NAMEOF(src, inv_hide), inv_hide)
	if(islist(inv_flags))
		inv_flags = typelist(NAMEOF(src, inv_flags), inv_flags)
	if(islist(inv_cover))
		inv_cover = typelist(NAMEOF(src, inv_cover), inv_cover)
	return ..()

/**
 * Gets the current slot ID we're in
 */
/obj/item/proc/GetInventorySlot()
	return inventory_slot

/**
 * Gets the slot meta datum of the slot id we're in
 */
/obj/item/proc/GetInventorySlotDatum()
	RETURN_TYPE(/datum/inventory_slot_meta)
	return get_inventory_slot_datum(inventory_slot)

/**
 * Gets our inv_hide flags. Required for multi slot support
 */
/obj/item/proc/get_inv_hide(slot)
	if(islist(inv_hide))
		return isnull(inv_hide[slot])? inv_hide[INV_SLOT_ANY] : inv_hide[slot]
	return inv_hide

/**
 * Gets our inv_flags. Required for multi slot support
 */
/obj/item/proc/get_inv_flags(slot)
	if(islist(inv_flags))
		return isnull(inv_flags[slot])? inv_flags[INV_SLOT_ANY] : inv_flags[slot]
	return inv_flags

/**
 * gets our inv_cover. Required for multi slot support
 */
/obj/item/proc/get_inv_cover(slot)
	if(islist(inv_cover))
		return isnull(inv_cover[slot])? inv_cover[INV_SLOT_ANY] : inv_cover[slot]
	return inv_cover

/**
 * Builds our inventory worn icon. NOT inhand icons.
 */

/**
 * Updates our max/min temperature/pressure protects, as well as armor for inventory.
 */
/obj/item/proc/update_inventory_protections()
	if(!inventory)
		return
	var/flags = NONE
	if(flags_inv & INV_FLAG_PRESSURE_AFFECTING)
		flags |= INVENTORY_UPDATE_PRESSURE
	if(flags_inv & INV_FLAG_TEMPERATURE_AFFECTING)
		flags |= INVENTORY_UPDATE_TEMPERATURE
	if(flags_inv & INV_FLAG_ARMOR_AFFECTING)
		flags |= INVENTORY_UPDATE_ARMOR
	inventory.InvalidateCachedCalculations(flags)
