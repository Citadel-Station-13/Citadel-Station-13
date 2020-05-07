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

	var/traits = null
	var/space_ruin_levels = 2
	var/space_empty_levels = 1
	var/station_ruin_budget = -1 // can be set to manually override the station ruins budget on maps that don't support station ruins, stopping the error from being unable to place the ruins.

	var/minetype = "lavaland"

	var/maptype = MAP_TYPE_STATION //This should be used to adjust ingame behavior depending on the specific type of map being played. For instance, if an overmap were added, it'd be appropriate for it to only generate with a MAP_TYPE_SHIP

	var/announcertype = "standard" //Determines the announcer the map uses. standard uses the default announcer, classic, but has a random chance to use other similarly-themed announcers, like medibot

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

	if ("announcertype" in json)
		announcertype = json["announcertype"]

	if ("orientation" in json)
		orientation = json["orientation"]
		if(!(orientation in GLOB.cardinals))
			orientation = SOUTH

	allow_custom_shuttles = json["allow_custom_shuttles"] != FALSE

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
	jsonlist["announcertype"] = announcertype
	jsonlist["orientation"] = orientation
	jsonlist["allow_custom_shuttles"] = allow_custom_shuttles
	if(fexists("data/next_map.json"))
		fdel("data/next_map.json")
	var/F = file("data/next_map.json")
	WRITE_FILE(F, json_encode(jsonlist))
