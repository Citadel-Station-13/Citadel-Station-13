// This file MUST match what's in _mapload/basemap.dm for what .dmms are compiled in.

/**
 * Initializes the map levels for the base, compiled in maps. This MUST match with what's actually compiled in.
 */
/datum/controller/subsystem/mapping/proc/InitializeDefaultZLevels()
	CreateReservedLevel()

/**
 * since init order is fixed and things that go before this subsystem may require map config to be set we have to do this stupid proc :/
 */
/datum/controller/subsystem/mapping/proc/EnsureConfigLoaded()
	if(!map)
#ifdef FORCE_MAP
		LoadWorld(FORCE_MAP)
#else
		LoadWorld(GetNextMap())
#endif
	stat_map_name = getMapName()
