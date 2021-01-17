#define INIT_ANNOUNCE(X) to_chat(world, "<span class='boldannounce'>[X]</span>"); log_world(X)

SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/nuke_tiles = list()
	var/list/nuke_threats = list()

	var/datum/map_config/config
	var/datum/map_config/next_map_config

	var/list/map_templates = list()

	var/list/ruins_templates = list()
	var/list/space_ruins_templates = list()
	var/list/lava_ruins_templates = list()
	var/list/ice_ruins_templates = list()
	var/list/ice_ruins_underground_templates = list()
	var/list/station_ruins_templates = list()
	var/datum/space_level/isolated_ruins_z //Created on demand during ruin loading.

	var/list/shuttle_templates = list()
	var/list/shelter_templates = list()

	var/list/areas_in_z = list()

	var/loading_ruins = FALSE
	var/list/turf/unused_turfs = list()				//Not actually unused turfs they're unused but reserved for use for whatever requests them. "[zlevel_of_turf]" = list(turfs)
	var/list/datum/turf_reservations		//list of turf reservations
	var/list/used_turfs = list()				//list of turf = datum/turf_reservation

	var/list/reservation_ready = list()
	var/clearing_reserved_turfs = FALSE

	// Z-manager stuff
	var/station_start  // should only be used for maploading-related tasks
	var/space_levels_so_far = 0
	var/list/z_list
	var/datum/space_level/transit
	var/datum/space_level/empty_space
	var/num_of_res_levels = 1
	/// Lookup for zlevel to station z. text = num.
	var/list/z_to_station_z_index

	var/stat_map_name = "Loading..."

	/// Lookup list for random generated IDs.
	var/list/random_generated_ids_by_original = list()
	/// next id for separating obfuscated ids.
	var/obfuscation_next_id = 1
	/// "secret" key
	var/obfuscation_secret

//dlete dis once #39770 is resolved
/datum/controller/subsystem/mapping/proc/HACK_LoadMapConfig()
	if(!config)
#ifdef FORCE_MAP
		config = load_map_config(FORCE_MAP)
#else
		config = load_map_config(error_if_missing = FALSE)
#endif
	stat_map_name = config.map_name

/datum/controller/subsystem/mapping/PreInit()
	if(!obfuscation_secret)
		obfuscation_secret = md5(GUID())		//HAH! Guess this!

/datum/controller/subsystem/mapping/Initialize(timeofday)
	HACK_LoadMapConfig()
	if(initialized)
		return
	if(config.defaulted)
		var/old_config = config
		config = global.config.defaultmap
		if(!config || config.defaulted)
			to_chat(world, "<span class='boldannounce'>Unable to load next or default map config, defaulting to Box Station</span>")
			config = old_config
	GLOB.year_integer += config.year_offset
	GLOB.announcertype = (config.announcertype == "standard" ? (prob(1) ? "medibot" : "classic") : config.announcertype)
	loadWorld()
	repopulate_sorted_areas()
	process_teleport_locs()			//Sets up the wizard teleport locations
	preloadTemplates()
#ifndef LOWMEMORYMODE
	// Create space ruin levels
	while (space_levels_so_far < config.space_ruin_levels)
		++space_levels_so_far
		add_new_zlevel("Empty Area [space_levels_so_far]", ZTRAITS_SPACE)
	// and one level with no ruins
	for (var/i in 1 to config.space_empty_levels)
		++space_levels_so_far
		empty_space = add_new_zlevel("Empty Area [space_levels_so_far]", list(ZTRAIT_LINKAGE = CROSSLINKED))
	// and the transit level
	transit = add_new_zlevel("Transit/Reserved", list(ZTRAIT_RESERVED = TRUE))

	// Pick a random away mission.
	if(CONFIG_GET(flag/roundstart_away))
		createRandomZlevel()
	// Pick a random VR level.
	if(CONFIG_GET(flag/roundstart_vr))
		createRandomZlevel(VIRT_REALITY_NAME, list(ZTRAIT_AWAY = TRUE, ZTRAIT_VR = TRUE), GLOB.potential_vr_levels)

	// Generate mining ruins
	loading_ruins = TRUE
	var/list/lava_ruins = levels_by_trait(ZTRAIT_LAVA_RUINS)
	if (lava_ruins.len)
		seedRuins(lava_ruins, CONFIG_GET(number/lavaland_budget), list(/area/lavaland/surface/outdoors/unexplored), lava_ruins_templates)
		for (var/lava_z in lava_ruins)
			spawn_rivers(lava_z)

	var/list/ice_ruins = levels_by_trait(ZTRAIT_ICE_RUINS)
	if (ice_ruins.len)
		// needs to be whitelisted for underground too so place_below ruins work
		seedRuins(ice_ruins, CONFIG_GET(number/icemoon_budget), list(/area/icemoon/surface/outdoors/unexplored, /area/icemoon/underground/unexplored), ice_ruins_templates)
		for (var/ice_z in ice_ruins)
			spawn_rivers(ice_z, 4, /turf/open/transparent/openspace/icemoon, /area/icemoon/surface/outdoors/unexplored/rivers)

	var/list/ice_ruins_underground = levels_by_trait(ZTRAIT_ICE_RUINS_UNDERGROUND)
	if (ice_ruins_underground.len)
		seedRuins(ice_ruins_underground, CONFIG_GET(number/icemoon_budget), list(/area/icemoon/underground/unexplored), ice_ruins_underground_templates)
		for (var/ice_z in ice_ruins_underground)
			spawn_rivers(ice_z, 4, level_trait(ice_z, ZTRAIT_BASETURF), /area/icemoon/underground/unexplored/rivers)

	// Generate deep space ruins
	var/list/space_ruins = levels_by_trait(ZTRAIT_SPACE_RUINS)
	if (space_ruins.len)
		seedRuins(space_ruins, CONFIG_GET(number/space_budget), list(/area/space), space_ruins_templates)

	// Generate station space ruins
	var/list/station_ruins = levels_by_trait(ZTRAIT_STATION)
	if (station_ruins.len)
		seedRuins(station_ruins, (SSmapping.config.station_ruin_budget < 0) ? CONFIG_GET(number/station_space_budget) : SSmapping.config.station_ruin_budget, list(/area/space/station_ruins), station_ruins_templates)
	SSmapping.seedStation()
	loading_ruins = FALSE
#endif
	repopulate_sorted_areas()
	// Set up Z-level transitions.
	setup_map_transitions()
	generate_station_area_list()
	initialize_reserved_level(transit.z_value)
	return ..()

/* Nuke threats, for making the blue tiles on the station go RED
   Used by the AI doomsday and the self destruct nuke.
*/

/datum/controller/subsystem/mapping/proc/wipe_reservations(wipe_safety_delay = 100)
	if(clearing_reserved_turfs || !initialized)			//in either case this is just not needed.
		return
	clearing_reserved_turfs = TRUE
	SSshuttle.transit_requesters.Cut()
	message_admins("Clearing dynamic reservation space.")
	var/list/obj/docking_port/mobile/in_transit = list()
	for(var/i in SSshuttle.transit)
		var/obj/docking_port/stationary/transit/T = i
		if(!istype(T))
			continue
		in_transit[T] = T.get_docked()
	var/go_ahead = world.time + wipe_safety_delay
	if(in_transit.len)
		message_admins("Shuttles in transit detected. Attempting to fast travel. Timeout is [wipe_safety_delay/10] seconds.")
	var/list/cleared = list()
	for(var/i in in_transit)
		INVOKE_ASYNC(src, .proc/safety_clear_transit_dock, i, in_transit[i], cleared)
	UNTIL((go_ahead < world.time) || (cleared.len == in_transit.len))
	do_wipe_turf_reservations()
	clearing_reserved_turfs = FALSE

/datum/controller/subsystem/mapping/proc/safety_clear_transit_dock(obj/docking_port/stationary/transit/T, obj/docking_port/mobile/M, list/returning)
	M.setTimer(0)
	var/error = M.initiate_docking(M.destination, M.preferred_direction)
	if(!error)
		returning += M
		qdel(T, TRUE)

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
	map_templates = SSmapping.map_templates
	ruins_templates = SSmapping.ruins_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	lava_ruins_templates = SSmapping.lava_ruins_templates
	ice_ruins_templates = SSmapping.ice_ruins_templates
	ice_ruins_underground_templates = SSmapping.ice_ruins_underground_templates
	station_ruins_templates = SSmapping.station_ruins_templates
	shuttle_templates = SSmapping.shuttle_templates
	shelter_templates = SSmapping.shelter_templates
	unused_turfs = SSmapping.unused_turfs
	turf_reservations = SSmapping.turf_reservations
	used_turfs = SSmapping.used_turfs

	config = SSmapping.config
	next_map_config = SSmapping.next_map_config

	clearing_reserved_turfs = SSmapping.clearing_reserved_turfs

	z_list = SSmapping.z_list

/datum/controller/subsystem/mapping/proc/LoadGroup(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE, orientation = SOUTH)
	. = list()
	var/start_time = REALTIMEOFDAY

	if (!islist(files))  // handle single-level maps
		files = list(files)

	// check that the total z count of all maps matches the list of traits
	var/total_z = 0
	var/list/parsed_maps = list()
	for (var/file in files)
		var/full_path = "_maps/[path]/[file]"
		var/datum/parsed_map/pm = new(file(full_path))
		var/bounds = pm?.bounds
		if (!bounds)
			errorList |= full_path
			continue
		parsed_maps[pm] = total_z  // save the start Z of this file
		total_z += bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1

	if (!length(traits))  // null or empty - default
		for (var/i in 1 to total_z)
			traits += list(default_traits)
	else if (total_z != traits.len)  // mismatch
		INIT_ANNOUNCE("WARNING: [traits.len] trait sets specified for [total_z] z-levels in [path]!")
		if (total_z < traits.len)  // ignore extra traits
			traits.Cut(total_z + 1)
		while (total_z > traits.len)  // fall back to defaults on extra levels
			traits += list(default_traits)

	// preload the relevant space_level datums
	var/start_z = world.maxz + 1
	var/i = 0
	for (var/level in traits)
		add_new_zlevel("[name][i ? " [i + 1]" : ""]", level)
		++i

	// load the maps
	for (var/P in parsed_maps)
		var/datum/parsed_map/pm = P
		if (!pm.load(1, 1, start_z + parsed_maps[P], no_changeturf = TRUE, orientation = orientation))
			errorList |= pm.original_path
	if(!silent)
		INIT_ANNOUNCE("Loaded [name] in [(REALTIMEOFDAY - start_time)/10]s!")
	return parsed_maps

/datum/controller/subsystem/mapping/proc/setup_station_z_index()
	z_to_station_z_index = list()
	var/sz = 1
	var/cz = station_start
	if(islist(config.map_file))
		for(var/map in config.map_file)
			z_to_station_z_index["[cz++]"] = sz++
	else
		z_to_station_z_index["[station_start]"] = 1

/datum/controller/subsystem/mapping/proc/loadWorld()
	//if any of these fail, something has gone horribly, HORRIBLY, wrong
	var/list/FailedZs = list()

	// ensure we have space_level datums for compiled-in maps
	InitializeDefaultZLevels()

	// load the station
	station_start = world.maxz + 1
	INIT_ANNOUNCE("Loading [config.map_name]...")
	LoadGroup(FailedZs, "Station", config.map_path, config.map_file, config.traits, ZTRAITS_STATION, FALSE, config.orientation)

	setup_station_z_index()

	if(SSdbcore.Connect())
		var/datum/DBQuery/query_round_map_name = SSdbcore.NewQuery("UPDATE [format_table_name("round")] SET map_name = '[config.map_name]' WHERE id = [GLOB.round_id]")
		query_round_map_name.Execute()
		qdel(query_round_map_name)

#ifndef LOWMEMORYMODE
	// TODO: remove this when the DB is prepared for the z-levels getting reordered
	while (world.maxz < (5 - 1) && space_levels_so_far < config.space_ruin_levels)
		++space_levels_so_far
		add_new_zlevel("Empty Area [space_levels_so_far]", ZTRAITS_SPACE)

	// load mining
	if(config.minetype == "lavaland")
		LoadGroup(FailedZs, "Lavaland", "map_files/Mining", "Lavaland.dmm", default_traits = ZTRAITS_LAVALAND)
	else if (!isnull(config.minetype) && config.minetype != "none")
		INIT_ANNOUNCE("WARNING: An unknown minetype '[config.minetype]' was set! This is being ignored! Update the maploader code!")
#endif

	if(LAZYLEN(FailedZs))	//but seriously, unless the server's filesystem is messed up this will never happen
		var/msg = "RED ALERT! The following map files failed to load: [FailedZs[1]]"
		if(FailedZs.len > 1)
			for(var/I in 2 to FailedZs.len)
				msg += ", [FailedZs[I]]"
		msg += ". Yell at your server host!"
		INIT_ANNOUNCE(msg)

GLOBAL_LIST_EMPTY(the_station_areas)

/datum/controller/subsystem/mapping/proc/generate_station_area_list()
	var/list/station_areas_blacklist = typecacheof(list(/area/space, /area/mine, /area/ruin, /area/asteroid/nearstation))
	for(var/area/A in world)
		if (is_type_in_typecache(A, station_areas_blacklist))
			continue
		if (!A.contents.len || !A.unique)
			continue
		var/turf/picked = A.contents[1]
		if (is_station_level(picked.z))
			GLOB.the_station_areas += A.type

	if(!GLOB.the_station_areas.len)
		log_world("ERROR: Station areas list failed to generate!")

/datum/controller/subsystem/mapping/proc/maprotate()
	var/players = GLOB.clients.len
	var/list/mapvotes = list()
	//count votes
	var/amv = CONFIG_GET(flag/allow_map_voting)
	if(amv)
		for (var/client/c in GLOB.clients)
			var/vote = c.prefs.preferred_map
			if (!vote)
				if (global.config.defaultmap)
					mapvotes[global.config.defaultmap.map_name] += 1
				continue
			mapvotes[vote] += 1
	else
		for(var/M in global.config.maplist)
			mapvotes[M] = 1

	//filter votes
	for (var/map in mapvotes)
		if (!map)
			mapvotes.Remove(map)
			continue
		if (!(map in global.config.maplist))
			mapvotes.Remove(map)
			continue
		var/datum/map_config/VM = global.config.maplist[map]
		if (!VM)
			mapvotes.Remove(map)
			continue
		if (VM.voteweight <= 0)
			mapvotes.Remove(map)
			continue
		if (VM.config_min_users > 0 && players < VM.config_min_users)
			mapvotes.Remove(map)
			continue
		if (VM.config_max_users > 0 && players > VM.config_max_users)
			mapvotes.Remove(map)
			continue

		if(amv)
			mapvotes[map] = mapvotes[map]*VM.voteweight

	var/pickedmap = pickweight(mapvotes)
	if (!pickedmap)
		return
	var/datum/map_config/VM = global.config.maplist[pickedmap]
	message_admins("Randomly rotating map to [VM.map_name]")
	. = changemap(VM)
	if (. && VM.map_name != config.map_name)
		to_chat(world, "<span class='boldannounce'>Map rotation has chosen [VM.map_name] for next round!</span>")

/datum/controller/subsystem/mapping/proc/changemap(var/datum/map_config/VM)
	if(!VM.MakeNextMap())
		next_map_config = load_map_config(default_to_box = TRUE)
		message_admins("Failed to set new map with next_map.json for [VM.map_name]! Using default as backup!")
		return

	next_map_config = VM

	. = TRUE

	stat_map_name = "[config.map_name] (Next: [next_map_config.map_name])"

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "_maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T

	preloadRuinTemplates()
	preloadShuttleTemplates()
	preloadShelterTemplates()

/datum/controller/subsystem/mapping/proc/preloadRuinTemplates()
	// Still supporting bans by filename
	var/list/banned = generateMapList("[global.config.directory]/lavaruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/spaceruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/iceruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/stationruinblacklist.txt")

	for(var/item in sortList(subtypesof(/datum/map_template/ruin), /proc/cmp_ruincost_priority))
		var/datum/map_template/ruin/ruin_type = item
		// screen out the abstract subtypes
		if(!initial(ruin_type.id))
			continue
		var/datum/map_template/ruin/R = new ruin_type()

		if(banned.Find(R.mappath))
			continue

		map_templates[R.name] = R
		ruins_templates[R.name] = R

		if(istype(R, /datum/map_template/ruin/lavaland))
			lava_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/icemoon/underground))
			ice_ruins_underground_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/icemoon))
			ice_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/space))
			space_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/station))
			station_room_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/spacenearstation))
			station_ruins_templates[R.name] = R

/datum/controller/subsystem/mapping/proc/preloadShuttleTemplates()
	var/list/unbuyable = generateMapList("[global.config.directory]/unbuyableshuttles.txt")

	for(var/item in subtypesof(/datum/map_template/shuttle))
		var/datum/map_template/shuttle/shuttle_type = item
		if(!(initial(shuttle_type.suffix)))
			continue

		var/datum/map_template/shuttle/S = new shuttle_type()
		if(unbuyable.Find(S.mappath))
			S.can_be_bought = FALSE

		shuttle_templates[S.shuttle_id] = S
		map_templates[S.shuttle_id] = S

/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/item in subtypesof(/datum/map_template/shelter))
		var/datum/map_template/shelter/shelter_type = item
		if(!(initial(shelter_type.mappath)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S
		map_templates[S.shelter_id] = S

//Manual loading of away missions.
/client/proc/admin_away()
	set name = "Load Away Mission / Virtual Reality"
	set category = "Admin.Events"

	if(!holder ||!check_rights(R_FUN))
		return

	var/choice = alert(src, "What kind of level would you like to load?", "Load Away/VR", AWAY_MISSION_NAME, VIRT_REALITY_NAME, "Cancel")

	var/list/possible_options
	var/list/ztraits
	switch(choice)
		if(VIRT_REALITY_NAME)
			possible_options = GLOB.potential_vr_levels
			ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_VR = TRUE)
		if(AWAY_MISSION_NAME)
			if(!GLOB.the_gateway)
				if(alert("There's no home gateway on the station. You sure you want to continue ?", "Uh oh", "Yes", "No") != "Yes")
					return
			possible_options = GLOB.potential_away_levels
			ztraits = list(ZTRAIT_AWAY = TRUE)
		else
			return

	var/away_name
	var/datum/space_level/away_level

	var/answer = input("What kind ? ","Away/VR") as null|anything in list(possible_options + "Custom")
	switch(answer)
		if(null)
			return
		if("Custom")
			var/mapfile = input("Pick file:", "File") as null|file
			if(!mapfile)
				return
			away_name = "[mapfile] custom"
			to_chat(usr,"<span class='notice'>Loading [away_name]...</span>")
			var/datum/map_template/template = new(mapfile, choice, ztraits)
			away_level = template.load_new_z(ztraits)
		else
			away_name = answer
			to_chat(usr,"<span class='notice'>Loading [away_name]...</span>")
			var/datum/map_template/template = new(away_name, choice)
			away_level = template.load_new_z(ztraits)

	message_admins("Admin [key_name_admin(usr)] has loaded [away_name] away mission.")
	log_admin("Admin [key_name(usr)] has loaded [away_name] away mission.")
	if(!away_level)
		message_admins("Loading [away_name] failed!")
		return

/datum/controller/subsystem/mapping/proc/RequestBlockReservation(width, height, z, type = /datum/turf_reservation, turf_type_override, border_type_override)
	UNTIL((!z || reservation_ready["[z]"]) && !clearing_reserved_turfs)
	var/datum/turf_reservation/reserve = new type
	if(turf_type_override)
		reserve.turf_type = turf_type_override
	if(border_type_override)
		reserve.borderturf = border_type_override
	if(!z)
		for(var/i in levels_by_trait(ZTRAIT_RESERVED))
			if(reserve.Reserve(width, height, i))
				return reserve
		//If we didn't return at this point, theres a good chance we ran out of room on the exisiting reserved z levels, so lets try a new one
		num_of_res_levels += 1
		var/datum/space_level/newReserved = add_new_zlevel("Transit/Reserved [num_of_res_levels]", list(ZTRAIT_RESERVED = TRUE))
		initialize_reserved_level(newReserved.z_value)
		if(reserve.Reserve(width, height, newReserved.z_value))
			return reserve
	else
		if(!level_trait(z, ZTRAIT_RESERVED))
			qdel(reserve)
			return
		else
			if(reserve.Reserve(width, height, z))
				return reserve
	QDEL_NULL(reserve)

//This is not for wiping reserved levels, use wipe_reservations() for that.
/datum/controller/subsystem/mapping/proc/initialize_reserved_level(z)
	UNTIL(!clearing_reserved_turfs)				//regardless, lets add a check just in case.
	clearing_reserved_turfs = TRUE			//This operation will likely clear any existing reservations, so lets make sure nothing tries to make one while we're doing it.
	if(!level_trait(z,ZTRAIT_RESERVED))
		clearing_reserved_turfs = FALSE
		CRASH("Invalid z level prepared for reservations.")
	var/turf/A = get_turf(locate(SHUTTLE_TRANSIT_BORDER,SHUTTLE_TRANSIT_BORDER,z))
	var/turf/B = get_turf(locate(world.maxx - SHUTTLE_TRANSIT_BORDER,world.maxy - SHUTTLE_TRANSIT_BORDER,z))
	var/block = block(A, B)
	for(var/t in block)
		// No need to empty() these, because it's world init and they're
		// already /turf/open/space/basic.
		var/turf/T = t
		T.flags_1 |= UNUSED_RESERVATION_TURF_1
	unused_turfs["[z]"] = block
	reservation_ready["[z]"] = TRUE
	clearing_reserved_turfs = FALSE

/datum/controller/subsystem/mapping/proc/reserve_turfs(list/turfs)
	for(var/i in turfs)
		var/turf/T = i
		T.empty(RESERVED_TURF_TYPE, RESERVED_TURF_TYPE, null, TRUE)
		LAZYINITLIST(unused_turfs["[T.z]"])
		unused_turfs["[T.z]"] |= T
		T.flags_1 |= UNUSED_RESERVATION_TURF_1
		GLOB.areas_by_type[world.area].contents += T
		CHECK_TICK

//DO NOT CALL THIS PROC DIRECTLY, CALL wipe_reservations().
/datum/controller/subsystem/mapping/proc/do_wipe_turf_reservations()
	UNTIL(initialized)							//This proc is for AFTER init, before init turf reservations won't even exist and using this will likely break things.
	for(var/i in turf_reservations)
		var/datum/turf_reservation/TR = i
		if(!QDELETED(TR))
			qdel(TR, TRUE)
	UNSETEMPTY(turf_reservations)
	var/list/clearing = list()
	for(var/l in unused_turfs)			//unused_turfs is a assoc list by z = list(turfs)
		if(islist(unused_turfs[l]))
			clearing |= unused_turfs[l]
	clearing |= used_turfs		//used turfs is an associative list, BUT, reserve_turfs() can still handle it. If the code above works properly, this won't even be needed as the turfs would be freed already.
	unused_turfs.Cut()
	used_turfs.Cut()
	reserve_turfs(clearing)

/datum/controller/subsystem/mapping/proc/reg_in_areas_in_z(list/areas)
	for(var/B in areas)
		var/area/A = B
		A.reg_in_areas_in_z()

/datum/controller/subsystem/mapping/proc/get_isolated_ruin_z()
	if(!isolated_ruins_z)
		isolated_ruins_z = add_new_zlevel("Isolated Ruins/Reserved", list(ZTRAIT_RESERVED = TRUE, ZTRAIT_ISOLATED_RUINS = TRUE))
		initialize_reserved_level(isolated_ruins_z.z_value)
	return isolated_ruins_z.z_value

	// Station Ruins
/datum/controller/subsystem/mapping
	var/list/station_room_templates = list()

/datum/controller/subsystem/mapping/proc/seedStation()
	for(var/V in GLOB.stationroom_landmarks)
		var/obj/effect/landmark/stationroom/LM = V
		LM.load()
	if(GLOB.stationroom_landmarks.len)
		seedStation() //I'm sure we can trust everyone not to insert a 1x1 rooms which loads a landmark which loads a landmark which loads a la...

/**
  * Generates an obfuscated but constant id for an original id for cases where you don't want players codediving for an id.
  * WARNING: MAKE SURE PLAYERS ARE NOT ABLE TO ACCESS THIS. To save performance, it's just secret + an incrementing number. Very guessable if you know what the secret is.
  */
/datum/controller/subsystem/mapping/proc/get_obfuscated_id(original, id_type = "GENERAL")
	if(!original)
		return	//no.
	var/key = "[original]%[id_type]"
	if(random_generated_ids_by_original[key])
		return random_generated_ids_by_original[key]
	. = random_generated_ids_by_original[key] = "[obfuscation_secret]%[obfuscation_next_id++]"
