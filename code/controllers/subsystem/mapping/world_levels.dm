/datum/controller/subsystem/mapping
	/// nested list - group = list(id = map datum)
	var/list/level_datums
	/// listed of loaded level datums
	var/static/list/loaded_levels = list()
	/// Away mission loaded?
	var/static/away_loaded = FALSE
	/// VR loaded?
	var/static/vr_loaded = FALSE
	/// loaded map levels from disk?
	var/map_levels_loaded = FALSE

/datum/controller/subsystem/mapping/proc/InitMapLevels()
	if(map_levels_loaded)
		return
	// wipe old map datums
	if(islist(level_datums))
		for(var/id in level_datums)
			var/datum/map_config/level/config = map_datums[id]
			if(!istype(config))
				continue
			if(config in loaded_levels)
				// we need this one, dereference without qdel
				level_datums -= id
				continue
			// otherwise, delete it
			qdel(config)
			level_datums -= id
	level_datums = list()
	var/list/json_paths = directory_walk_exts(list("maps/space_levels", "config/space_levels"), list("json"))
	for(var/path in json_paths)
		var/datum/map_config/level/map = new(file(path), path)
		if(map.errored)
			qdel(map)
			init_error("Failed to load [map.id] ([path]).")
			continue
		LAZYINITLIST(level_datums[map.group])
		if(level_datums[map.group][map.id])
			init_fatal("Discarding duplicate map [map.group]:[map.id] ([path]).")
			qdel(map)
			continue
		level_datums[map.group][map.id] = map
	map_levels_loaded = TRUE

/datum/controller/subsystem/mapping/proc/LoadLevel(group, id)
	if(!level_datums[group])
		CRASH("Failed to find [group]")
	if(!level_datums[group][id])
		CRASH("Failed to find [id]")
	var/datum/map_config/level/level = level_datums[group][id]
	if(level in loaded_levels)
		CRASH("Tried to load [level] twice.")
	. = InstantiateMapDatum(level)
	if(isnull(.))
		CRASH("Failed to load [group] - [id]")
	loaded_levels += level

/datum/controller/subsystem/mapping/proc/IsLevelLoaded(group, id)
	. = FALSE
	for(var/datum/map_config/level/L in loaded_levels)
		if(L.group == group && L.id == id)
			return TRUE

/datum/controller/subsystem/mapping/proc/LoadVR(level_override)
	if(!length(level_datums["vr"]))
		return
	var/list/potential = level_datums["vr"]
	potential = potential & config.vr_data
	if(!length(potential))
		return
	var/id = pick(potential)
	LoadLevel("vr", id)

/datum/controller/subsystem/mapping/proc/LoadAway(level_override)
	if(!length(level_datums["away"]))
		return
	var/list/potential = level_datums["away"]
	potential = potential & config.away_data
	if(!length(potential))
		return
	var/id = pick(potential)
	LoadLevel("away", id)

//Manual loading of away missions.
/client/proc/admin_load_map_level()
	set name = "Load Map Level"
	set category = "Admin.Events"

	if(!holder ||!check_rights(R_FUN))
		return

	var/list/choices = SSmapping.level_datums + "!Upload .dmm!"

	var/group = input(src, "Choose a group.", "Load Map Level") as null|anything in choices

	if(group == "!Upload .dmm!")
		var/F = input(src, "Choose a .dmm", "Upload .dmm") as file|null
		if(!F)
			return
		var/datum/space_level/L = new
		L.datum_flags |= DF_VAR_EDITED
		L.map_path = F		// direct file ref

		message_admins("Admin [key_name_admin(src)] is loading map file [F] ([length(F)] bytes).")
		log_admin("Admin [key_name_admin(src)] is loading map file [F] ([length(F)] bytes).")

		var/start = REALTIMEOFDAY
		var/list/loaded_indices = SSmapping.InstantiateMapLevel(L)
		if(!loaded_indices)
			message_admins("[F] loading failed or runtimed.")
			log_admin("Custom load of [F] failed.")
		else
			var/seconds = round((REALTIMEOFDAY - start) / 0.1, 0.01)
			to_chat(usr, "<span class='danger'>Loaded [F] on[loaded_indices.len == 1? "z-[loaded_indices[1]]]" : "Z-levels [english_list(loaded_indices)]"] in [seconds] seconds.</span>")

	else if(group)
		var/list/levels
		var/id = input(src, "Choose a map.", "Load Map Level") as null|anything in levels[group]
		var/datum/map_config/L = levels[id]
		if(!istype(L))
			to_chat(usr, "<span class='danger'>Invalid level datum.</span>")
			return
		if(SSmapping.IsLevelLoaded(group, id))
			to_chat(usr, "<span class='danger'>[group]:[id] is already loaded.</span>")
			return
		to_chat(usr, "<span class='danger'>Loading [group]:[id]...</span>")
		message_admins("Admin [key_name_admin(usr)] has loaded map level [group]:[id].")
		log_admin("Admin [key_name(usr)] has loaded map level [group]:[id].")
		var/start = REALTIMEOFDAY
		var/list/loaded_indices = SSmapping.LoadLevel(group, id)
		if(!loaded_indices)
			message_admins("[group]:[id] loading failed or runtimed.")
			log_admin("Custom load of [group]:[id] failed.")
		else
			var/seconds = round((REALTIMEOFDAY - start) / 0.1, 0.01)
			to_chat(usr, "<span class='danger'>Loaded [group]:[id] on [loaded_indices.len == 1? "z-[loaded_indices[1]]]" : "Z-levels [english_list(loaded_indices)]"] in [seconds] seconds.</span>")

/datum/controller/subsystem/mapping/OnConfigLoad()
	. = ..()
	map_levels_loaded = FALSE
	InitMapLevels()
