/mob
	/// inventory - starts out as a list of ids or typepaths, made into datum on init
	var/datum/inventory

/mob/Initialize()
	if(islist(inventory))
		inventory = typelist("inv_slots_initial", inventory)
	return ..()

/**
 * ensures our inventory is made, if it should be made
 * if it shouldn't be, null it out
 */
/mob/proc/ensure_inventory_instantiated()
	if(istype(inventory))
		return TRUE
	if(isnull(inventory))
		return FALSE
	if(islist(inventory) && length(inventory))
		initialize_inventory()
		return TRUE
	inventory = null
	return FALSE

/mob/proc/initialize_inventory()
	create_inventory()

/mob/proc/create_inventory()
	inventory = new /datum/inventory(src, inventory)

/**
 * destroys inventory
 * 3
 * @params
 * - drop - if FALSE, deletes everything instead of dropping
 * - destination - drop destination, defaults to drop_location()
 */
/mob/proc/destroy_inventory(drop = FALSE, atom/destination = drop_location())
