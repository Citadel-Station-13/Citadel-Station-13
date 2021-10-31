/**
 * Instantiate a new planet on a new zlevel using a planet datum and registers it
 */
/datum/controller/subsystem/planets/proc/InstantiateFromScratch(datum/planet/P)

/**
 * Sets a planet to a zlevel set in place, filling in missing ones as it goes and registers it
 *
 * z_indices - list of indices to use. must match the planet's level type, etc etc, see level type for more. this is an advanced param.
 */
/datum/controller/subsystem/planets/proc/InstantiateInPlace(datum/planet/P, list/z_indices)

