#define INIT_ANNOUNCE(X) to_chat(world, "<span class='boldannounce'>[X]</span>"); log_world(X)

SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = NONE
	can_fire = FALSE
	wait = 20

	var/list/nuke_tiles = list()
	var/list/nuke_threats = list()

	var/static/list/map_templates = list()

	var/static/list/ruins_templates = list()
	var/static/list/space_ruins_templates = list()
	var/static/list/lava_ruins_templates = list()
	var/static/list/ice_ruins_templates = list()
	var/static/list/ice_ruins_underground_templates = list()
	var/static/list/station_ruins_templates = list()
	var/static/list/station_room_templates = list()

	var/list/shuttle_templates = list()
	var/list/shelter_templates = list()

	var/list/areas_in_z = list()

	var/loading_ruins = FALSE

	///All possible biomes in assoc list as type || instance
	var/list/biomes = list()

	// old Z-manager stuff
	var/station_start  // should only be used for maploading-related tasks
	var/space_levels_so_far = 0
	var/datum/space_level/empty_space
	/// Lookup for zlevel to station z. text = num.
	var/list/z_to_station_z_index

	var/stat_map_name = "Loading..."

/datum/controller/subsystem/mapping/Initialize(timeofday)
	// Make sure we're not being reran
	if(initialized)
		return

	// init all datums
	InitMapDatums()
	InitMapLevels()

	// set map config
	EnsureConfigLoaded()

	// Init map levels for compiled in maps
	InitializeDefaultZLevels()
	if(!reserved_level_count)
		CreateReservedLevel()

	// load world
	InstantiateWorld()

	// init vr/away
	if(CONFIG_GET(flag/roundstart_away))
		LoadAway()
	if(CONFIG_GET(flag/roundstart_vr))
		LoadVR()

	// finalize
	var/rebuild_start = REALTIMEOFDAY
	RebuildCrosslinking()		// THIS GOES FIRST
	RebuildVerticality()
	RebuildTransitions()
	RebuildMapLevelTurfs(null, TRUE, TRUE)
	repopulate_sorted_areas()
	init_log("Zlevels rebuilt in [(REALTIMEOFDAY - rebuild_start) / 10]s.")

	setup_station_z_index()

	initialize_biomes()

	PerformMapGeneration()

	GLOB.year_integer += map.year_offset
	GLOB.announcertype = (map.announcertype == "standard" ? (prob(1) ? "medibot" : "classic") : map.announcertype)

	repopulate_sorted_areas()
	process_teleport_locs()			//Sets up the wizard teleport locations
	preloadTemplates()

	repopulate_sorted_areas()
	// Set up Z-level transitions.
	generate_station_area_list()
	Feedback()
	return ..()

/* Nuke threats, for making the blue tiles on the station go RED
   Used by the AI doomsday and the self destruct nuke.
*/

/datum/controller/subsystem/mapping/proc/add_nuke_threat(datum/nuke)
	nuke_threats[nuke] = TRUE
	check_nuke_threats()

/datum/controller/subsystem/mapping/proc/remove_nuke_threat(datum/nuke)
	nuke_threats -= nuke
	check_nuke_threats()

/datum/controller/subsystem/mapping/proc/check_nuke_threats()
	for(var/datum/d in nuke_threats)
		if(!istype(d) || QDELETED(d))
			nuke_threats -= d

	for(var/N in nuke_tiles)
		var/turf/open/floor/circuit/C = N
		C.update_icon()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	initialized = SSmapping.initialized
	map_datums = SSmapping.map_datums
	level_datums = SSmapping.level_datums
	map_datums_loaded = SSmapping.map_datums_loaded
	map_levels_loaded = SSmapping.map_levels_loaded
	can_fire = SSmapping.can_fire

	RebuildVerticality()
	RebuildTransitions()

/datum/controller/subsystem/mapping/proc/setup_station_z_index()
	z_to_station_z_index = list()
	var/cz = 0
	for(var/i in 1 to world.maxz)
		if(HasTrait(i, ZTRAIT_STATION))
			z_to_station_z_index["[i]"] = ++cz

/datum/controller/subsystem/mapping/proc/Feedback()
	if(SSdbcore.Connect())
		var/datum/db_query/query_round_map_name = SSdbcore.NewQuery({"
			UPDATE [format_table_name("round")] SET map_name = :map_name WHERE id = :round_id
		"}, list("map_name" = map.name, "round_id" = GLOB.round_id))
		query_round_map_name.Execute()
		qdel(query_round_map_name)

GLOBAL_LIST_EMPTY(the_station_areas)

/datum/controller/subsystem/mapping/proc/generate_station_area_list()
	var/list/station_areas_blacklist = typecacheof(list(/area/space, /area/mine, /area/ruin, /area/asteroid/nearstation))
	for(var/area/A in world)
		if (is_type_in_typecache(A, station_areas_blacklist))
			continue
		if (!A.contents.len || !(A.area_flags & UNIQUE_AREA))
			continue
		var/turf/picked = A.contents[1]
		if (is_station_level(picked.z))
			GLOB.the_station_areas += A.type

	if(!GLOB.the_station_areas.len)
		log_world("ERROR: Station areas list failed to generate!")

/datum/controller/subsystem/mapping/proc/reg_in_areas_in_z(list/areas)
	for(var/B in areas)
		var/area/A = B
		A.reg_in_areas_in_z()
