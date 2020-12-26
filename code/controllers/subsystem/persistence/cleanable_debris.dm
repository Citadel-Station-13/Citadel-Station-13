/**
 * Persistence for cleanable debris.
 */
/datum/controller/subsystem/persistence
	/// tracks if we already loaded debris. Unlike everything else, this can actually be a major problem if some badmin procs it twice.
	var/loaded_debris = FALSE

/datum/controller/subsystem/persistence/LoadMapPersistence()
	. = ..()
	if(CONFIG_GET(flag/persistent_debris))
		LoadMapDebris()

/datum/controller/subsystem/persistence/SaveMapPersistence()
	. = ..()
	if(CONFIG_GET(flag/persistent_debris))
		SaveMapDebris()

/datum/controller/subsystem/persistence/proc/LoadMapDebris()
	if(!fexists("[get_map_persistence_path()]/debris.json"))
		return
	if(loaded_debris)
		return
	loaded_debris = TRUE
	var/list/data = json_decode(file2text("[get_map_persistence_path()]/debris.json"))
	var/list/z_lookup = list()
	/// reverse it
	for(var/z in SSmapping.z_to_station_z_index)
		var/sz = SSmapping.z_to_station_z_index[z]
		z_lookup[num2text(sz)] = z

/datum/controller/subsystem/persistence/proc/SaveMapDebris()
	if(fexists("[get_map_persistence_path()]/debris.json"))
		fdel("[get_map_persistence_path()]/debris.json")
	var/list/allowed_turf_typecache = typecacheof(/turf/open) - typecacheof(/turf/open/space)
	var/list/allowed_z_cache = list()
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		allowed_z_cache[num2text(z)] = TRUE
	var/list/data = list()
	var/list/z_lookup = SSmapping.z_to_station_z_index

	WRITE_FILE("[get_map_persistence_path()]/debris.json", json_encode(data))


/datum/controller/subsystem/persistence/proc/IsValidDebrisLocation(turf/tile, list/allowed_typecache, list/allowed_zcache)
	if(!allowed_typecache[tile.type])
		return FALSE
	if(!tile.loc.persistent_debris_allowed)
		return FALSE
	if(!allowed_zcache[num2text(tile.z)])
		return FALSE
	for(var/obj/structure/window/W in tile)
		if(W.fulltile)
			return FALSE
	return TRUE
