/datum/controller/subsystem/mapping
	/// List of map datums by id, made at world start.
	var/list/map_datums
	/// Currently loaded map datum
	var/static/datum/map_config/station/map
	/// World loaded?
	var/static/world_loaded = FALSE
	/// map datums initialized?
	var/static/map_datums_loaded = FALSE

/datum/controller/subsystem/mapping/proc/InitMapDatums()
	if(map_datums_loaded)
		return
	map_datums_loaded = TRUE
	// wipe old map datums
	for(var/id in map_datums)
		var/datum/map_config/config = map_datums[id]
		if(!istype(config))
			continue
		if(config == map)
			// we need this one, dereference without qdel
			map_datums -= id
			continue
		// otherwise, delete it
		qdel(config)
		map_datums -= id
	map_datums = list()
	var/list/json_paths = directory_walk_exts(list("maps/map_files", "config/map_files"), list("json"))
	for(var/path in json_paths)
		var/datum/map_config/station/map = new(file(path), path)
		if(map.errored)
			qdel(map)
			init_error("Failed to load [map.id] ([path]).")
			continue
		if(map_datums[map.id])
			qdel(map)
			init_fatal("Discarding duplicate map [map.id] ([path]).")
			continue
		map_datums[map.id] = map

/datum/controller/subsystem/mapping/proc/LoadWorld(id, default = "boxstation")
	if(map)
		CRASH("Tried to load the world datum while a datum was already set.")
	if(!map_datums)
		InitMapDatums()
	if(!map_datums[id])
		if(id == default)
			init_fatal("[default] was unable to be loaded, even though it is the default map. The server will not be playable. Please contact an admin or coder IMMEDIATELY.")
			return
		init_error("Failed to load map config [id]. Defaulting to [default].")
		return LoadWorld(default, default)
	map = map_datums[id]
	init_log("Chosen station map - [map.name].")

/datum/controller/subsystem/mapping/proc/InstantiateWorld()
	if(world_loaded)
		CRASH("Tried to load the world when world was already loaded.")
	var/start_time = REALTIMEOFDAY
	init_log("Loading [map.name]...")
	station_start = world.maxz + 1
	InstantiateMapDatum(map)
	if(islist(map.lateload))
		for(var/group in map.lateload)
			if(!islist(map.lateload[group]))
				init_fatal("[map.id] didn't have a properly formatted lateload section ([group]).")
				continue
			for(var/id in map.lateload[group])
				LoadLevel(group, id)
	world_loaded = TRUE
	init_log("Loaded [map.name] in [(REALTIMEOFDAY - start_time) / 10]s.")

/**
 * Gets the current persistence key of the loaded station map.
 */
/datum/controller/subsystem/mapping/proc/getPersistenceKey()
	return map?.persistence_key

/**
 * Gets the current map OOC name, or the name of a map ID
 */
/datum/controller/subsystem/mapping/proc/getMapName(id)
	if(id)
		var/datum/map_config/config = map_datums[config]
		return config?.name || "ERROR"
	return map?.name || "UNKNOWN"

/**
 * Gets the map datum of an ID
 */
/datum/controller/subsystem/mapping/proc/getMapDatum(id)
	RETURN_TYPE(/datum/map_config/station)
	return map_datums[id]

/**
 * Gets all possible map IDs
 */
/datum/controller/subsystem/mapping/proc/getAllMapIDs()
	. = list()
	for(var/i in map_datums)
		. += i

/**
 * Gets the current map ID, used for things like databases and persistence saves.
 */
/datum/controller/subsystem/mapping/proc/getMapID()
	return map?.id || "UNKNOWN"

/datum/controller/subsystem/mapping/OnConfigLoad()
	. = ..()
	map_datums_loaded = FALSE
	InitMapDatums()
