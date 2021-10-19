/**
 * Invalidate these flags
 */
/datum/inventory/proc/InvalidateCachedCalculations(flags)
	update_flags |= flags

/**
 * Gets a list of zones by inv_cover
 */
/datum/inventory/proc/GetCoveredZones(inv_cover)

/**
 * Gets a list of inv_cover flags for a zone
 */
/datum/inventory/proc/GetZoneCoverage(zone)

/**
 * Rebuilds our temperature protect
 */
/datum/inventory/proc/RebuildTemperatureProtect()

/**
 * Rebuilds our pressure protect
 */
/datum/inventory/proc/RebuildPressureProtect()

/**
 * Rebuilds our armor
 */
/datum/inventory/proc/RebuildArmor()

/**
 * Gets armor for a zone
 */
/datum/inventory/proc/ArmorByZone(zone)

/**
 * Gets pressure protection (0 = safe, + = too much, - = too little) for a zone
 */
/datum/inventory/proc/PressureByZone(zone)

/**
 * Gets thermal protection (0 = safe, + = too much, - = too little) for a zone
 */
/datum/inventory/proc/TemperatureByZone(zone)

/**
 * Gets all zones that would be damaged by a pressure, associated to amount difference
 */
/datum/inventory/proc/ZonesAfflictedByPressure(pressure)

/**
 * Gets all zones that would be damaged by a temperature, associated to amount difference
 */
/datum/inventory/proc/ZonesAfflictedByTemperature(temperature)
