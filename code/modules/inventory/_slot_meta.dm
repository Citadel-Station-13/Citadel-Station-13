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
	var/fallback_icon = 'icons/screen/midnight/inventory.dmi'
	/// themes - falls back to icon if not found
	var/static/list/theme_icons = list(
		UI_THEME_PLASMAFIRE = 'icons/screen/plasmafire/inventory.dmi',
		UI_THEME_MIDNIGHT = 'icons/screen/midnight/inventory.dmi',
		UI_THEME_SLIME = 'icons/screen/slimecore/inventory.dmi',
		UI_THEME_RETRO = 'icons/screen/retro/inventory.dmi',
		UI_THEME_SYNDICATE = 'icons/screen/syndicate/inventory.dmi',
		UI_THEME_CLOCKWORK = 'icons/screen/clockwork/inventory.dmi'
	)
	/// icon state
	var/icon_state = "generic"
	/// screen loc
	var/screen_loc
	/// screen object by theme
	var/list/screen_objects
	/// unequip by click rather than drag to hand
	var/unequip_on_click = TRUE
	/// If TRUE, we're considered "static" inventory and always show, rather than needing the inventory to be expanded.
	var/static_inventory = FALSE
	/// are we an "abstract" slot? These aren't ever shown to the player. Set to FALSE for those.
	var/is_inventory = TRUE

	// Rendering
	/// default icon for new rendering system - should realistically never be used because the whole point of the new system is items define this
	var/default_onmob_icon
	/// default icon for old rendering system - used for legacy behavior
	var/legacy_onmob_icon
	/// default relative layer on the mob - in terms of MOB LAYERS, not GAME LAYERS.
	var/onmob_layer

/datum/inventory_slot_meta/New(id)
	src.id = id
	if(isnull(src.id))
		src.id = "[type]"

/datum/inventory_slot_meta/proc/get_screen(theme = UI_THEME_DEFAULT)
	if(!is_inventory)
		return FALSE
	if(!screen_objects[theme])
		return instantiate_screen(theme)
	return screen_objects[theme]

/datum/inventory_slot_meta/proc/instantiate_screen(theme = UI_THEME_DEFAULT)
	if(screen_objects[theme])
		qdel(screen_objects[theme])
	screen_objects[theme] = new(null, src, name, get_icon(theme), icon_state, screen_loc)
	return screen_objects[theme]

/datum/inventory_slot_meta/proc/get_icon(theme = UI_THEME_DEFAULT)
	if(!theme_icons[theme])
		return fallback_icon
	var/list/states = icon_states(theme_icons[theme])
	if(icon_state in states)
		return theme_icons[theme]
	return fallback_icon

/**
 * Returns whether or not we can hold a certain item
 */
/datum/inventory_slot_meta/proc/can_hold(datum/inventory/inventory, obj/item/I)

/**
 * Returns whether or not a mob is allowed to insert an item
 */
/datum/inventory_slot_meta/proc/can_insert(datum/inventory/inventory, obj/item/I, mob/user)

/**
 * Returns whether or not a mob is allowed to remove an item
 */
/datum/inventory_slot_meta/proc/can_remove(datum/inventory/inventory, obj/item/I, mob/user)

/**
 * Called on item insertion
 */
/datum/inventory_slot_meta/proc/on_insert(datum/inventory/inventory, obj/item/I, mob/user)

/**
 * Called on item removal
 */
/datum/inventory_slot_meta/proc/on_removal(datum/inventory/inventory, obj/item/I, mob/user)

/**
 * called on examine, return list
 */
/datum/inventory_slot_meta/proc/on_examine(mob/user)
