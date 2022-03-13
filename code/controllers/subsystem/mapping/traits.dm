/datum/controller/subsystem/mapping
	// Can add a trait caching system for fast access later.

/datum/controller/subsystem/mapping/proc/OnTraitAdd(datum/space_level/level, trait)
	return

/datum/controller/subsystem/mapping/proc/OnTraitDel(datum/space_level/level, trait)
	return

/datum/controller/subsystem/mapping/proc/OnAttributeSet(datum/space_level/level, attribute, value)
	return

/**
 * Checks if a z level has a trait
 */
/datum/controller/subsystem/mapping/proc/HasTrait(z, trait)
	if(z < 1 || z > world.maxz)
		CRASH("Invalid z")
	var/datum/space_level/L = space_levels[z]
	return !!L.traits.Find(trait)

/**
 * Checks if a z level has any of these traits
 */
/datum/controller/subsystem/mapping/proc/HasAnyTrait(z, list/traits)
	if(z < 1 || z > world.maxz)
		CRASH("Invalid z")
	var/datum/space_level/L = space_levels[z]
	return !!length(L.traits & traits)

/**
 * Checks if a z level has all of these traits
 */
/datum/controller/subsystem/mapping/proc/HasAllTraits(z, list/traits)
	if(z < 1 || z > world.maxz)
		CRASH("Invalid z")
	var/datum/space_level/L = space_levels[z]
	return !length(L.traits - traits)

/**
 * Returns a list of z indices with a trait
 */
/datum/controller/subsystem/mapping/proc/LevelsByTrait(trait)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in space_levels)
		if(L.traits.Find(trait))
			. += L.z_value

/**
 * Returns a list of z indices with any of these traits
 */
/datum/controller/subsystem/mapping/proc/LevelsByAnyTrait(list/traits)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in space_levels)
		if(length(L.traits & traits))
			. += L.z_value

/**
 * Returns a list of z indices with any of these traits
 */
/datum/controller/subsystem/mapping/proc/LevelsByAllTraits(list/traits)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in space_levels)
		if(!length(L.traits - traits))
			. += L.z_value

/**
 * Returns an attribute of a zlevel
 */
/datum/controller/subsystem/mapping/proc/GetAttribute(z, key)
	if(z < 1 || z > world.maxz)
		CRASH("Invalid z")
	var/datum/space_level/L = space_levels[z]
	return L.attributes[key]

/**
 * Returns the z indices of levels with a certain attribute set to a certain value
 */
/datum/controller/subsystem/mapping/proc/LevelsByAttribute(key, value)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in space_levels)
		if(L.attributes[key] == value)
			. += L.z_value

/**
 * Returns all crosslinked z indices
 */
/datum/controller/subsystem/mapping/proc/GetCrosslinked()
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in space_levels)
		if(L.linkage_mode == Z_LINKAGE_CROSSLINKED)
			. += L.z_value

/**
 * Gets baseturf type of a zlevel
 */
/datum/controller/subsystem/mapping/proc/GetBaseturf(z)
	var/datum/space_level/L = space_levels[z]
	return L.baseturf || world.turf

/**
 * Gets deault air of a zlevel
 */
/datum/controller/subsystem/mapping/proc/GetDefaultAir(z)
	return GetAttribute(z, ZATTRIBUTE_GAS_STRING) || AIRLESS_ATMOS
