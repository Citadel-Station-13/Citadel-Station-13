//used for holding information about unique properties of maps
//feed it json files that match the datum layout
//defaults to box
//  -Cyberboss

/datum/map_config
	// Metadata
	var/config_filename = "_maps/boxstation.json"
	var/defaulted = TRUE  // set to FALSE by LoadConfig() succeeding
	// Config from maps.txt
	var/config_max_users = 0
	var/config_min_users = 0
	var/voteweight = 1
	var/max_round_search_span = 0 //If this is nonzero, then if the map has been played more than max_rounds_played within the search span (max determined by define in persistence.dm), this map won't be available.
	var/max_rounds_played = 0

	// Config actually from the JSON - should default to Box
	var/map_name = "Box Station"
	var/map_path = "map_files/BoxStation"
	var/map_file = "BoxStation.dmm"
	/// Persistence key: Defaults to ckey(map_name). If set to "NO_PERSIST", this map will have NO persistence.
	var/persistence_key

	var/traits = null
	var/space_ruin_levels = 4
	var/space_empty_levels = 1
	var/station_ruin_budget = -1 // can be set to manually override the station ruins budget on maps that don't support station ruins, stopping the error from being unable to place the ruins.

	var/minetype = "lavaland"

	var/maptype = MAP_TYPE_STATION //This should be used to adjust ingame behavior depending on the specific type of map being played. For instance, if an overmap were added, it'd be appropriate for it to only generate with a MAP_TYPE_SHIP

	var/allow_custom_shuttles = TRUE
	var/shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"whiteship" = "whiteship_box",
		"emergency" = "emergency_box")

	var/year_offset = 540 //The offset of ingame year from the actual IRL year. You know you want to make a map that takes place in the 90's. Don't lie.

	// "fun things"
	/// Orientation to load in by default.
	var/orientation = SOUTH		//byond defaults to placing everyting SOUTH.

	/// Jobs whitelist - if this is not empty, ONLY these jobs are allowed. Overrides blacklist.
	var/list/job_whitelist
	/// Jobs blacklist - if this is not empty, jobs in this aren't allowed.
	var/list/job_blacklist
	/// Job spawn position mod - type = number
	var/list/job_override_spawn_positions
	/// Job total position mod - type = number
	var/list/job_override_total_positions
	/// Add these accesses to jobs - type = list()
	var/list/job_access_add
	/// Remove these accesses from jobs - type = list()
	var/list/job_access_remove
	/// Override job accesses - type = list() - overrides everything else
	var/list/job_access_override

/proc/load_map_config(filename = "data/next_map.json", default_to_box, delete_after, error_if_missing = TRUE)
	var/datum/map_config/config = new
	if (default_to_box)
		return config
	if (!config.LoadConfig(filename, error_if_missing))
		qdel(config)
		config = new /datum/map_config  // Fall back to Box
	if (delete_after)
		fdel(filename)
	return config

#define CHECK_EXISTS(X) if(!istext(json[X])) { log_world("[##X] missing from json!"); return; }
/datum/map_config/proc/LoadConfig(filename, error_if_missing)
	if(!fexists(filename))
		if(error_if_missing)
			log_world("map_config not found: [filename]")
		return

	var/json = file(filename)
	if(!json)
		log_world("Could not open map_config: [filename]")
		return

	json = file2text(json)
	if(!json)
		log_world("map_config is not text: [filename]")
		return

	json = json_decode(json)
	if(!json)
		log_world("map_config is not json: [filename]")
		return

	config_filename = filename

	CHECK_EXISTS("map_name")
	map_name = json["map_name"]
	CHECK_EXISTS("map_path")
	map_path = json["map_path"]

	map_file = json["map_file"]

	persistence_key = ckey(map_name)

	var/json_persistence_key = json["persistence_key"]
	if(json_persistence_key)
		if(json_persistence_key == "NO_PERSIST")
			persistence_key = null
		else
			persistence_key = json_persistence_key

	// "map_file": "BoxStation.dmm"
	if (istext(map_file))
		if (!fexists("_maps/[map_path]/[map_file]"))
			log_world("Map file ([map_path]/[map_file]) does not exist!")
			return
	// "map_file": ["Lower.dmm", "Upper.dmm"]
	else if (islist(map_file))
		for (var/file in map_file)
			if (!fexists("_maps/[map_path]/[file]"))
				log_world("Map file ([map_path]/[file]) does not exist!")
				return
	else
		log_world("map_file missing from json!")
		return

	if (islist(json["shuttles"]))
		var/list/L = json["shuttles"]
		for(var/key in L)
			var/value = L[key]
			shuttles[key] = value
	else if ("shuttles" in json)
		log_world("map_config shuttles is not a list!")
		return

	traits = json["traits"]
	// "traits": [{"Linkage": "Cross"}, {"Space Ruins": true}]
	if (islist(traits))
		// "Station" is set by default, but it's assumed if you're setting
		// traits you want to customize which level is cross-linked
		for (var/level in traits)
			if (!(ZTRAIT_STATION in level))
				level[ZTRAIT_STATION] = TRUE
	// "traits": null or absent -> default
	else if (!isnull(traits))
		log_world("map_config traits is not a list!")
		return

	var/temp = json["space_ruin_levels"]
	if (isnum(temp))
		space_ruin_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_ruin_levels is not a number!")
		return

	temp = json["space_empty_levels"]
	if (isnum(temp))
		space_empty_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_empty_levels is not a number!")
		return

	if("station_ruin_budget" in json)
		station_ruin_budget = json["station_ruin_budget"]

	temp = json["year_offset"]
	if (isnum(temp))
		year_offset = temp
	else if (!isnull(temp))
		log_world("map_config year_offset is not a number!")
		return

	if ("minetype" in json)
		minetype = json["minetype"]

	if ("maptype" in json)
		maptype = json["maptype"]

	if ("orientation" in json)
		orientation = json["orientation"]
		if(!(orientation in GLOB.cardinals))
			orientation = SOUTH

	allow_custom_shuttles = json["allow_custom_shuttles"] != FALSE

	if("job_whitelist" in json)
		job_whitelist = list()
		for(var/path in json["job_whitelist"])
			var/type = text2path(path)
			if(!path)
				log_config("map datum [config_filename] failed to validate path [path] in job overrides.")
				continue
			job_whitelist += type

	if("job_blacklist" in json)
		job_blacklist = list()
		for(var/path in json["job_blacklist"])
			var/type = text2path(path)
			if(!path)
				log_config("map datum [config_filename] failed to validate path [path] in job overrides.")
				continue
			job_blacklist += type

	if("job_override_spawn_positions" in json)
		job_override_spawn_positions = list()
		for(var/path in json["job_override_spawn_positions"])
			var/type = text2path(path)
			if(!path)
				log_config("map datum [config_filename] failed to validate path [path] in job overrides.")
				continue
			job_override_spawn_positions += type

	if("job_override_total_positions" in json)
		job_override_total_positions = list()
		for(var/path in json["job_override_total_positions"])
			var/type = text2path(path)
			if(!path)
				log_config("map datum [config_filename] failed to validate path [path] in job overrides.")
				continue
			job_override_total_positions += type

	if("job_access_add" in json)
		job_access_add = list()
		for(var/path in json["job_acces_add"])
			var/type = text2path(path)
			if(!path)
				log_config("map datum [config_filename] failed to validate path [path] in job overrides.")
				continue
			job_access_add[type] = json["job_access_add"]

	if("job_access_remove" in json)
		job_access_remove = list()
		for(var/path in json["job_acces_add"])
			var/type = text2path(path)
			if(!path)
				log_config("map datum [config_filename] failed to validate path [path] in job overrides.")
				continue
			job_access_remove[type] = json["job_access_remove"]

	if("job_access_override" in json)
		job_access_override = list()
		for(var/path in json["job_acces_add"])
			var/type = text2path(path)
			if(!path)
				log_config("map datum [config_filename] failed to validate path [path] in job overrides.")
				continue
			job_access_override[type] = json["job_access_override"]

	defaulted = FALSE
	return TRUE
#undef CHECK_EXISTS

/datum/map_config/proc/GetFullMapPaths()
	if (istext(map_file))
		return list("_maps/[map_path]/[map_file]")
	. = list()
	for (var/file in map_file)
		. += "_maps/[map_path]/[file]"

/datum/map_config/proc/MakeNextMap()
	return config_filename == "data/next_map.json" || fcopy(config_filename, "data/next_map.json")

/// badmin moments. Keep up to date with LoadConfig()!
/datum/map_config/proc/WriteNextMap()
	var/list/jsonlist = list()
	jsonlist["map_name"] = map_name
	jsonlist["map_path"] = map_path
	jsonlist["map_file"] = map_file
	jsonlist["shuttles"] = shuttles
	jsonlist["traits"] = traits
	jsonlist["space_ruin_levels"] = space_ruin_levels
	jsonlist["year_offset"] = year_offset
	jsonlist["minetype"] = minetype
	jsonlist["maptype"] = maptype
	jsonlist["orientation"] = orientation
	jsonlist["allow_custom_shuttles"] = allow_custom_shuttles
	jsonlist["job_whitelist"] = job_whitelist
	jsonlist["job_blacklist"] = job_blacklist
	jsonlist["job_override_spawn_positions"] = job_override_spawn_positions
	jsonlist["job_override_total_positions"] = job_override_total_positions
	jsonlist["job_access_add"] = job_access_add
	jsonlist["job_access_remove"] = job_access_remove
	jsonlist["job_access_override"] = job_access_override
	if(fexists("data/next_map.json"))
		fdel("data/next_map.json")
	var/F = file("data/next_map.json")
	WRITE_FILE(F, json_encode(jsonlist))
