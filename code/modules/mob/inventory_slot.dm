/**
  * Inventory slot datum
  */
/datum/inventory_slot
	// These variables are automatically filled in by slot meta if null
	/// ID (__DEFINES/inventory/inventory_slots.dm)
	var/id
	/// Name
	var/name
	/// The mob we're the slot of
	var/mob/host
	/// The item we contain
	var/obj/item/held
	/// Spritesheet overrides: List of CLOTHING_ASSET_SET_DEFINE = file, or if not a list, just a single file.
	var/override_spritesheet
	/// Our generated HUD object
	var/obj/screen/inventory/hud_object
	/// Override screen location
	var/hud_screen_loc_override
	/// Override icon state for hud icon
	var/hud_icon_state_override

/datum/inventory_slot/New(mob/host, datum/inventory_slot_meta/parent)
	if(!host || !parent)
		return
	if(isnull(id))
		id = parent.id
	if(isnull(name))
		name = parent.name
	src.host = host
	if(host.inventory_slots_screen_loc_overrides[id])
		hud_screen_loc_override = host.inventory_slots_screen_loc_overrides[id]

/datum/inventory_slot/Destroy()
	host?.inventory_slots -= id
	host?.inventory_slot_built_overlays -= id
	if(held)
		stack_trace("Warning: Inventory slot destroyed while an item was in it, [istype(host)? "with" : "without"] a valid host.")
		if(istype(host))
			held.forceMove(host.drop_location())
		else
			qdel(held)
		unregister_item()		// this can be safely called even after qdel at the time of writing
	if(hud_object)
		QDEL_NULL(hud_object)
	host = null
	return ..()

/**
  * Get the item in us
  */
/datum/inventory_slot/proc/get_item()
	RETURN_TYPE(/obj/item)
	return held

/**
  * Get our inventory hide flags
  */
/datum/inventory_slot/proc/inventory_hide_flags()
	var/obj/item/I = get_item()
	return I && I.inventory_hide_flags

/**
  * Registers an item to us.
  */
/datum/inventory_slot/proc/register_item(obj/item/I)
	if(held)
		CRASH("Attempted to register new item [I] while [held] is already in slot. This should NEVER happen.")
	held = I
	inventory_box.set_item(I)

/**
  * Unregisters our item
  */
/datum/inventory_slot/proc/unregister_item()
	held = null
	inventory_box.clear_item()

/**
  * Gets our hud screen loc
  */
/datum/inventory_slot/proc/hud_screen_loc()
	return hud_screen_loc_override || get_inventory_slot_meta(id).default_screen_loc

/**
  * Gets our hud icon state
  */
/datum/inventory_slot/proc/hud_icon_state()
	return hud_icon_state_override || get_inventory_slot_meta(id).default_icon_state

// Subtypes
/datum/inventory_slot/back

/datum/inventory_slot/mask

/datum/inventory_slot/handcuffed

/datum/inventory_slot/belt

/datum/inventory_slot/id_card

/datum/inventory_slot/ears

/datum/inventory_slot/glasses

/datum/inventory_slot/gloves

/datum/inventory_slot/neck

/datum/inventory_slot/head

/datum/inventory_slot/shoes

/datum/inventory_slot/outerwear

/datum/inventory_slot/uniform

/datum/inventory_slot/left_pocket

/datum/inventory_slot/right_pocket

/datum/inventory_slot/suit_storage

/datum/inventory_slot/legcuffed

/datum/inventory_slot/generic_dextrous_storage
