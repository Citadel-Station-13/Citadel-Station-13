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
	var/obj/screen/hud_object

/datum/inventory_slot/New(mob/host, datum/inventory_slot_meta/parent)
	if(!host || !parent)
		return
	if(isnull(id))
		id = parent.id
	if(isnull(name))
		name = parent.name
	src.host = host

/datum/inventory_slot/Destroy()
	host?.inventory_slots -= id
	host?.inventory_slot_built_overlays -= id
	if(held)
		stack_trace("Warning: Inventory slot destroyed while an item was in it, [istype(host)? "with" : "without"] a valid host.")
		if(istype(host))
			held.forceMove(host.drop_location())
			held = null
		else
			QDEL_NULL(held)
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
