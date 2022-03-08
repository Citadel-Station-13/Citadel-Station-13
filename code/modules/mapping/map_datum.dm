#warn oh boy, convert all the .jsons lmfao :/

/**
 * Map datums
 *
 * Holds all the data necessary to load, instantiate, and use a map.
 */
/datum/map_config
	// Basic data
	/// Unique ID
	var/id
	/// Player facing OOC name
	var/name
	/// Loaded correctly?
	var/errored = TRUE
	/// JSON loaded data - we will need this later, as we don't immediately instantiate
	var/list/original_datalist
	/// originally loaded from this path
	var/original_path
	/// Width
	var/width = 255
	/// Height
	var/height = 255
	/// Zlevel count
	var/z_count = 1
	/// Center this map?
	var/center = TRUE
	/// did instantiation happen on us? levels can still be instantiated without us being specifically instantiated!
	var/instantiated = FALSE
	/// zlevel datums - ordered list
	var/list/datum/space_level/levels
	/// world_structs to set up - list(struct z_grid, struct z_grid 2, etc)
	var/list/world_structs
	/// Orientation to load in by default.
	var/orientation = SOUTH		//byond defaults to placing everyting SOUTH.
	/*
	* job ids/typepaths to enable for level-specific jobs - if loaded midround, the jobs will be instantiated on the spot if it's not already there
	 * if this is present roundstart, it'll make the job instantiate as normal in normal job instantiation
	 * note: there's no job slot override system other than on the station itself. this is intentional,
	 * because if you're making a job specifically for one map level, the job itself should just have the vars set correctly,
	 * not the map datum!
	 */
	var/list/enable_jobs

/datum/map_config/New(file_jsonstr_list, path)
	if(file_jsonstr_list)
		var/list/data = file_jsonstr_list
		if(!istype(data))
			if(isfile(data))
				data = safe_json_decode(file2text(data))
			else if(istext(data))
				data = safe_json_decode(data)
		ParseJSONList(data, path)
	original_path = path

/datum/map_config/Destroy(force)
	if(instantiated && !force)
		. = QDEL_HINT_LETMELIVE
		CRASH("Attempted to qdel an instantiated map config. This is going to cause problems - SSmapping will cache all loaded levels for data retrieval.")
	QDEL_LIST(levels)
	return ..()

/datum/map_config/proc/ParseJSONList(list/data, path)
	original_datalist = data
	ASSERT(istext(data["id"]) && length(data["id"]))
	id = data["id"]
	width = data["width"]
	ASSERT(isnum(width) && width > 0)
	height = data["height"]
	ASSERT(isnum(height) && height > 0)
	center = data["center"]? TRUE : FALSE
	levels = list()
	var/pathroot = path && (copytext_char(path, 1, findlasttext_char(path, "/")) + "/")
	for(var/L in data["levels"])
		var/list/level_data = L
		var/datum/space_level/L = new
		L.ParseJSONList(level_data, pathroot)
		levels += L
	z_count = levels.len
	ASSERT(z_count > 0)
	orientation = data["orientation"] || SOUTH
	name = data["name"] || id
	world_structs = data["world_structs"] || list()
	enable_jobs = data["enable_jobs"]
	if(islist(enable_jobs))
		for(var/id_or_path in enable_jobs)
			var/path = text2path(id_or_path)
			if(!path)
				stack_trace("non typepath found in enable_jobs for [src] ([original_path]) - non typepath jobs are not yet supported")
				continue
			enable_jobs -= id_or_path
			enable_jobs += path
		if(enable_jobs.len)
			SSjob.EnableMapJobs(enable_jobs)
			#warn the above needs job refactor

/**
 * Called after loading with a list of z indices corrosponding to each level in the map.
 */
/datum/map_config/proc/PostLoad(list/ordered_z)
	for(var/list/data in world_structs)
		var/datum/world_struct/S = new
		S.Construct(data)

/**
 * Represents map configs that are loaded as the primary station map.
 * Called a station map config, but this doesn't have to be a station.
 */
/datum/map_config/station
	// Config from maps.txt
	var/config_max_users = 0
	var/config_min_users = 0
	var/voteweight = 1
	/// Enabled? Map is on maps.txt if so
	var/enabled = FALSE
	/// Votable?
	var/votable = TRUE

	// Actual JSON options start
	/// This should be used to adjust ingame behavior depending on the specific type of map being played. For instance, if an overmap were added, it'd be appropriate for it to only generate with a MAP_TYPE_SHIP
	var/maptype = MAP_TYPE_STATION
	/// Persistence key: Defaults to ckey(map_name). If set to "NO_PERSIST", this map will have NO persistence.
	var/persistence_key

	/// Extra map levels to load. Should be {"integral" = ["centcom", "lavaland"], "planet" = ["blah"]}, etc.
	var/list/lateload

	/// The offset of ingame year from the actual IRL year. You know you want to make a map that takes place in the 90's. Don't lie.
	var/year_offset = 540
	// Job overrides - these process on job datum creation!
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
	// Job overrides end
	/// do we allow custom shuttle creation?
	var/allow_custom_shuttles = TRUE
	/// Determines the announcer the map uses. standard uses the default announcer, classic, but has a random chance to use other similarly-themed announcers, like medibot
	var/announcertype = "standard"

	// Map type - Standard
	var/space_ruin_levels = 4
	var/space_empty_levels = 1
	var/station_ruin_budget = -1 // can be set to manually override the station ruins budget on maps that don't support station ruins, stopping the error from being unable to place the ruins.
	var/shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"whiteship" = "whiteship_box",
		"emergency" = "emergency_box")

/datum/map_config/station/ParseJSONList(list/data)
	. = ..()
	maptype = data["maptype"]
	if("persistence_key" in data)
		persistence_key = data["persistence_key"] || id
	if("year_offset" in data)
		year_offset = data["year_offset"]
	job_whitelist = data["job_whitelist"]
	job_blacklist = data["job_blacklist"]
	job_override_spawn_positions = data["job_override_spawn_positions"]
	job_override_total_positions = data["job_override_total_positions"]
	job_access_add = data["job_access_add"]
	job_access_remove = data["job_access_remove"]
	job_access_override = data["job_access_override"]
	if("allow_custom_shuttles" in data)
		allow_custom_shuttles = data["allow_custom_shuttles"]? TRUE : FALSE
	if("announcertype" in data)
		announcertype = data["announcertype"]
	if("space_ruin_levels" in data)
		space_ruin_levels = data["space_ruin_levels"]
	if("space_empty_levels" in data)
		space_empty_levels = data["space_empty_levels"]
	if("station_ruin_budget" in data && data["station_ruin_budget"] != -1)
		station_ruin_budget = data["station_ruin_budget"]
	if("shutles" in data)
		shuttles = data["shuttles"]
	if("lateload" in data)
		lateload = data["lateload"]

/**
 * Represents a miscellaneous level to be loaded at will
 */
/datum/map_config/level
	/// Group
	var/group

/datum/map_config/level/ParseJSONList(list/data)
	. = ..()
	if(!istext(data["group"]) || !length(data["group"]))
		errored = TRUE
	else
		group = data["group"]
