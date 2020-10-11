/**
  * Gets our HUD object
  */
/datum/inventory_slot/proc/get_hud_object(datum/hud/holder)
	return no_hud_object? null : (hud_object || generate_hud_object(holder))

/**
  * Regenerates our HUD object
  */
/datum/inventory_slot/proc/regenerate_hud_object(datum/hud/holder)
	if(hud_object)
		QDEL_NULL(hud_object)
	return get_hud_object(holder)

/**
  * Generates our hud object with a specific hud for a holder
  */
/datum/inventory_slot/proc/generate_hud_object(datum/hud/holder)
