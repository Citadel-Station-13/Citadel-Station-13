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
	if(CONFIG_GET(flag/persistent_debris_only))
		wipe_existing_debris()
	var/list/allowed_turf_typecache = typecacheof(/turf/open) - typecacheof(/turf/open/space)
	var/list/allowed_z_cache = list()
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		allowed_z_cache[num2text(z)] = TRUE
	var/list/data = json_decode(file2text("[get_map_persistence_path()]/debris.json"))
	var/list/z_lookup = list()
	/// reverse it
	for(var/z in SSmapping.z_to_station_z_index)
		var/sz = SSmapping.z_to_station_z_index[z]
		z_lookup[num2text(sz)] = z
	for(var/z in data)
		var/actual_z = z_lookup[z]
		var/list/L1 = data[z]
		for(var/x in L1)
			var/list/L2 = data[z][x]
			for(var/y in L2)
				var/turf/tile = locate(x, y, z)
				if(!tile)
					continue
				var/list/objects = data[z][x][y]
				for(var/_L in objects)
					var/list/data
					var/path
					if(islist(_L))
						data = _L
						path = data["__PATH__"]
					else
						path = _L
						data = objects[_L]
					if(!IsValidDebrisLocation(tile, allowed_turf_typecache, allowed_z_cache, path, TRUE))
						continue
					var/path = data["__PATH__"]
					if(!path)
						continue
					var/obj/effect/cleanable/instantiated = new path(tile)
					if(data)
						instantiated.LoadPersistence(data)

/datum/controller/subsystem/persistence/proc/SaveMapDebris()
	if(fexists("[get_map_persistence_path()]/debris.json"))
		fdel("[get_map_persistence_path()]/debris.json")
	var/list/data = list()
	var/list/z_lookup = SSmapping.z_to_station_z_index
	var/list/debris = RelevantPersistentDebris()
	var/obj/effect/cleanable/saving
	var/global_max = CONFIG_GET(number/persistent_debris_global_max)
	var/type_max = CONFIG_GET(number/persistent_debris_type_max)
	var/stored = 0
	var/list/stored_by_type = list()
	for(var/i in debris)
		saving = i
		var/list/serializing = list()
		var/path = saving.PersistenceSave(serializing)
		if(!path)
			continue
		if(stored_by_type[path] > type_max)
			continue
		var/text_z = num2text(saving.z)
		var/text_y = num2text(saving.y)
		var/text_x = num2text(saving.x)
		LAZYINITLIST(data[text_z])
		LAZYINITLIST(data[text_z][text_x])
		LAZYINITLIST(data[text_z][text_x][text_y])
		if(storing.persistence_allow_stacking)
			serializing["__PATH__"] = path
			data[text_z][text_x][text_y] += serializing
		else
			data[text_z][text_x][text_y][path] = serializing
		stored++
		if(stored > global_max)
			var/w = "Persistent debris saving globally aborted due to global max >= [global_max]. Either janitors never do their jobs or something is wrong."
			message_admins(w)
			subsystem_log(w))
			return
		stored_by_type[path] = stored_by_type[path]? stored_by_type[path] + 1 : 1
		if(stored_by_type[path] > type_max)
			var/w = "Persistent debris saving aborted for type [path] due to type max >= [global_max]. Either janitors never do their jobs or something is wrong."
			message_admins(w)
			subsystem_log(w))

	subsystem_log({"
	Debris saving completed:
	Total: [global_max]
	By type: [english_list(stored_by_type)]
	"})
	WRITE_FILE("[get_map_persistence_path()]/debris.json", json_encode(data))

/datum/controller/subsystem/persistence/proc/IsValidDebrisLocation(turf/tile, list/allowed_typecache, list/allowed_zcache, type, loading = FALSE)
	if(!allowed_typecache[tile.type])
		return FALSE
	var/area/A = tile.loc
	if(!A.persistent_debris_allowed)
		return FALSE
	if(!allowed_zcache[num2text(tile.z)])
		return FALSE
	if(loading)
		if(!initial(type.persistence_allow_stacking))
			var/obj/effect/cleanable/C = locate(type) in tile
			if(!QDELETED(C))
				return FALSE
	// Saving verifies allow stacking in the save proc.
	for(var/obj/structure/window/W in tile)
		if(W.fulltile)
			return FALSE
	return TRUE

/datum/controller/subsystem/persistence/proc/wipe_existing_debris()
	var/list/existing = RelevantPersistentDebris()
	QDEL_LIST(existing)

/datum/controller/subsystem/persistence/proc/RelevantPersistentDebris()
	var/list/allowed_turf_typecache = typecacheof(/turf/open) - typecacheof(/turf/open/space)
	var/list/allowed_z_cache = list()
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		allowed_z_cache[num2text(z)] = TRUE
	. = list()
	for(var/obj/effect/cleanable/C in world)
		if(!C.loc || QDELETED(C))
			continue
		if(!C.persistent)
			continue
		if(!IsValidDebrisLocation(C.loc, allowed_turf_typecache, allowed_z_cache, C.type, FALSE))
			continue
		. += C
