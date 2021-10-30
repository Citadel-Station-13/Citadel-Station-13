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
	update_flags &= ~INVENTORY_UPDATE_TEMPERATURE

/**
 * Rebuilds our pressure protect
 */
/datum/inventory/proc/RebuildPressureProtect()
	update_flags &= ~INVENTORY_UPDATE_PRESSURE

/**
 * Rebuilds our armor
 */
/datum/inventory/proc/RebuildArmor()
	update_flags &= ~INVENTORY_UPDATE_ARMOR

/**
 * Rebuilds our inv_hide
 */
/datum/inventory/proc/RebuildHide()
	update_flags &= ~INVENTORY_UPDATE_HIDE
	for(var/obj/item/I as anything in AllItems(TRUE))
		inv_hide |= I.inv_hide

/**
 * Gets armor for a zone
 */
/datum/inventory/proc/ArmorByZone(zone)
	if(update_flags & INVENTORY_UPDATE_ARMOR)
		RebuildArmor()
	return armor[body_zones.Find(zone)]

/**
 * Gets pressure protection (0 = safe, + = too much, - = too little) for a zone
 */
/datum/inventory/proc/PressureByZone(zone, pressure)
	if(update_flags & INVENTORY_UPDATE_PRESSURE)
		RebuildPressureProtect()
	if(pressure > low_pressure_threshold && pressure < high_pressure_threshold)
		return 0
	var/index = body_zones.Find(zone)
	var/min = min_pressure[index]
	var/max = max_pressure[index]
	if(pressure < min)
		return pressure - min
	if(pressure > max)
		return pressure - max
	return 0

/**
 * Gets thermal protection (0 = safe, + = too much, - = too little) for a zone
 */
/datum/inventory/proc/TemperatureByZone(zone, temperature)
	if(update_flags & INVENTORY_UPDATE_TEMPERATURE)
		RebuildTemperatureProtect()
	if(temperature > low_temperature_threshold && temperature < high_temperature_threshold)
		return 0
	var/index = body_zones.Find(zone)
	var/min = min_temperature[zone]
	var/max = max_temperature[zone]
	if(temperature < min)
		return temperature - min
	if(temperature > max)
		return temperature - max
	return 0

/**
 * Gets all zones that would be damaged by a pressure, associated to amount difference
 */
/datum/inventory/proc/ZonesAfflictedByPressure(pressure)
	if(update_flags & INVENTORY_UPDATE_PRESSURE)
		RebuildPressureProtect()
	if(pressure > low_pressure_threshold && pressure < high_pressure_threshold)
		return list()
	. = list()
	for(var/index in 1 to body_zones.len)
		var/zone = body_zones[index]
		if(pressure < min_pressure[zone])
			.[zone] = pressure - min_pressure[zone]
		if(pressure > max_pressure[zone])
			.[zone] = pressure - max_pressure[zone]

/**
 * Gets all zones that would be damaged by a temperature, associated to amount difference
 */
/datum/inventory/proc/ZonesAfflictedByTemperature(temperature)
	if(update_flags & INVENTORY_UPDATE_TEMPERATURE)
		RebuildPressureProtect()
	if(temperature > low_temperature_threshold && temperature < high_temperature_threshold)
		return list()
	. = list()
	for(var/index in 1 to body_zones.len)
		var/zone = body_zones[index]
		if(temperature < min_temperature[zone])
			.[zone] = temperature - min_temperature[zone]
		if(temperature > max_temperature[zone])
			.[zone] = temperature - min_temperature[zone]

/**
 * Gets effective inv_hide flags
 */
/datum/inventory/proc/InvHide()
	if(update_flags & INVENTORY_UPDATE_HIDE)
		RebuildHide()
	return inv_hide
