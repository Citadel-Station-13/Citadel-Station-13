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
	/// all users currently viewing us
	var/mob/viewing
	/// mob that owns us
	var/mob/owner
	/// Do we need the inventory hide button?
	var/requires_hide_button = FALSE
	/// ordered inventory slots
	VAR_PRIVATE/list/slots
	/// ordered list of all items in us
	VAR_PRIVATE/list/obj/item/holding
	/// backup - list of items by slot, used for rebuild when someone's being a stupid
	VAR_PRIVATE/list/items_by_slot
	/// dynamic inventory screen cramming - slots without screen_loc are put here
	var/list/screen_cram
	/// disabled slots - these exist but are grayed out. associated by id to the reason they're disabled. managed by the mob.
	var/list/disabled_slots
	/// ordered list cache of mutable_appearance datums needed to render.
	VAR_PRIVATE/list/appearances
	/// ordered list of max temperatures by body zone
	VAR_PRIVATE/list/max_temperature
	/// ordered list of min temperatures by body zonew
	VAR_PRIVATE/list/min_temperature
	/// ordered list of max pressures by body zone
	VAR_PRIVATE/list/max_pressure
	/// ordered list of min pressures by body zone
	VAR_PRIVATE/list/min_pressure
	/// ordered list of armor by body zone
	VAR_PRIVATE/list/armor
	/// Cached max temperature threshold - we know we don't need to check zones at all if something is below this
	VAR_PRIVATE/high_temperature_threshold
	/// Cached min temperature threshold - we know we don't need to check zones at all if something is above this
	VAR_PRIVATE/low_temperature_threshold
	/// Cached min pressure threshold - we don't need to check at all if above this
	VAR_PRIVATE/low_pressure_threshold
	/// Cached max pressure threshold - we don't need to check at all if below this
	VAR_PRIVATE/high_pressure_threshold
	/// Cached inv_hide
	VAR_PRIVATE/inv_hide = NONE
	/// update flags
	var/update_flags = NONE
	/// all body zones we care about. we calculate temperature, pressure, and armor for these
	var/static/list/body_zones = list(
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG
	)

/datum/inventory/New(list/slots)
	src.slots = list()
	src.holding = list()
	for(var/i in slots)
		AddSlot(i)

/datum/inventory/Destroy()
	HideFromAll()
	for(var/i in AllItems(TRUE))
		qdel(i)	// this handles removal
	for(var/i in slots)
		DeleteSlot(i)
	items_by_slot = null
	holding = null
	screen_cram = null
	disabled_slots = null
	return ..()

/**
 * Rebuilds everything
 * Used if an unmanaged slot addition/deletion happens (such as admin VV fuckery)
 */
/datum/inventory/proc/Rebuild()
	var/list/viewing = src.viewing? src.viewing.Copy() : list()
	for(var/i in viewing)
		HideFrom(i)
	holding = list()
	LAZYINITLIST(slots)
	for(var/i in items_by_slot)
		var/index = slots.Find(i)
		holding[index] = items_by_slot[i]
	for(var/i in viewing)
		ShowTo(i)
	InvalidateCachedCalculations(ALL)
	RebuildAllAppearances()

/**
 * Adds a slot
 */
/datum/inventory/proc/AddSlot(id)
	id = "[id]"
	if(id in slots)
		return FALSE
	var/datum/inventory_slot_meta/meta = get_inventory_slot_datum(id)
	if(!meta)
		return FALSE
	slots += id
	holding.len++
	items_by_slot[slot] = null
	appearances.len++
	if(!requires_hide_button && !meta.static_inventory)
		RecalcHideable()
	RecalcScreen()
	return TRUE

/**
 * Removes a slot
 */
/datum/inventory/proc/RemoveSlot(id)
	id = "[id]"
	if(!(id in slots))
		return FALSE
	RecalcHideable()
	RecalcScreen()
