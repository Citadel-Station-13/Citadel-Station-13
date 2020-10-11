//Most of these are defined at this level to reduce on checks elsewhere in the code.
//Having them here also makes for a nice reference list of the various overlay-updating procs available

/**
  * Updates the worn icon of a certain slot.
  */
/mob/proc/update_worn_overlay_for_slot(slot, update_overlays = TRUE)

	if(update_overlays)
		update_overlays()

/**
  * Updates all inventory worn icons
  * Should not be used unless absolutely necessary
  */
/mob/proc/update_worn_overlays()
	inventory_slots_built_overlays = list()
	for(var/slot in inventory_slots)
		update_worn_overlay_for_slot(slot, FALSE)
	update_overlays()

/**
  * Updates worn icons for the argument slots
  */
/mob/proc/update_worn_overlays_for_slots(...)
	for(var/slot in args)
		update_worn_overlay_for_slot(slot, FALSE)
	update_overlays()

/**
  * Update held item overlay for index
  */
/mob/proc/update_held_overlay_for_hand(index, update_overlays = TRUE)

	if(update_overlays)
		update_overlays()

/**
  * Update held item overlays
  * Should not be used unless absolutely necessary
  */
/mob/proc/update_held_overlays()
	held_item_built_overlays = list()
	for(var/i in 1 to length(held_items))
		update_held_overlay_for_hand(i, FALSE)
	update_overlays()

/**
  * Fully rebuilds our overlays.
  * Should almost never be used in code.
  */
/mob/proc/regenerate_overlays()
	update_worn_overlays()
	update_held_overlays()

/mob/proc/update_icons()
	return

/mob/proc/update_transform()
	return

/mob/proc/update_body()
	return

/mob/proc/update_hair()
	return

/mob/proc/update_fire()
	return

/**
  * Gets the pixel offset of a certain slot.
  */
/mob/proc/slot_pixel_offsets(slot_id, obj/item/held)
	RETURN_TYPE(/list)
	return list(0, 0)
