SUBSYSTEM_DEF(air)
	name = "Atmospherics"
	init_order = INIT_ORDER_AIR
	priority = FIRE_PRIORITY_AIR
	wait = 5
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/cost_turf_reactions = 0
	var/cost_groups = 0
	var/cost_highpressure = 0
	var/cost_hotspots = 0
	var/cost_superconductivity = 0
	var/cost_pipenets = 0
	var/cost_rebuilds = 0
	var/cost_atmos_machinery = 0

	var/list/excited_groups = list()
	var/list/active_turfs = list()
	var/list/turf_react_queue = list()
	var/list/hotspots = list()
	var/list/networks = list()
	var/list/pipenets_needing_rebuilt = list()
	var/list/obj/machinery/atmos_machinery = list()
	var/list/pipe_init_dirs_cache = list()

	//atmos singletons
	var/list/gas_reactions = list()

	//Special functions lists
	var/list/turf/active_super_conductivity = list()
	var/list/turf/open/high_pressure_delta = list()


	var/list/currentrun = list()
	var/currentpart = SSAIR_REBUILD_PIPENETS

	var/map_loading = TRUE
	var/list/queued_for_activation

/datum/controller/subsystem/air/stat_entry(msg)
	msg += "C:{"
	msg += "RQ:[round(cost_turf_reactions,1)]|"
	msg += "EG:[round(cost_groups,1)]|"
	msg += "HP:[round(cost_highpressure,1)]|"
	msg += "HS:[round(cost_hotspots,1)]|"
	msg += "SC:[round(cost_superconductivity,1)]|"
	msg += "PN:[round(cost_pipenets,1)]|"
	msg += "RB:[round(cost_rebuilds,1)]|"
	msg += "AM:[round(cost_atmos_machinery,1)]"
	msg += "} "
	msg += "AT:[active_turfs.len]|"
	msg += "RQ:[turf_react_queue.len]|"
	msg += "EG:[excited_groups.len]|"
	msg += "HS:[hotspots.len]|"
	msg += "PN:[networks.len]|"
	msg += "HP:[high_pressure_delta.len]|"
	msg += "AS:[active_super_conductivity.len]|"
	msg += "AT/MS:[round((cost ? active_turfs.len/cost : 0),0.1)]"
	..(msg)


/datum/controller/subsystem/air/Initialize(timeofday)
	map_loading = FALSE
	setup_allturfs()
	setup_atmos_machinery()
	setup_pipenets()
	gas_reactions = init_gas_reactions()
	return ..()


/datum/controller/subsystem/air/fire(resumed = 0)
	var/timer = TICK_USAGE_REAL

	if(currentpart == SSAIR_REBUILD_PIPENETS)
		var/list/pipenet_rebuilds = pipenets_needing_rebuilt
		for(var/thing in pipenet_rebuilds)
			var/obj/machinery/atmospherics/AT = thing
			AT.build_network()
		cost_rebuilds = MC_AVERAGE(cost_rebuilds, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		pipenets_needing_rebuilt.Cut()
		if(state != SS_RUNNING)
			return
		resumed = FALSE
		currentpart = SSAIR_PIPENETS

	if(currentpart == SSAIR_PIPENETS || !resumed)
		process_pipenets(resumed)
		cost_pipenets = MC_AVERAGE(cost_pipenets, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSAIR_ATMOSMACHINERY

	if(currentpart == SSAIR_ATMOSMACHINERY)
		timer = TICK_USAGE_REAL
		process_atmos_machinery(resumed)
		cost_atmos_machinery = MC_AVERAGE(cost_atmos_machinery, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSAIR_REACTQUEUE

	if(currentpart == SSAIR_REACTQUEUE)
		timer = TICK_USAGE_REAL
		process_react_queue(resumed)
		cost_turf_reactions = MC_AVERAGE(cost_turf_reactions, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSAIR_EXCITEDGROUPS

	if(currentpart == SSAIR_EXCITEDGROUPS)
		timer = TICK_USAGE_REAL
		process_excited_groups(resumed)
		cost_groups = MC_AVERAGE(cost_groups, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSAIR_HIGHPRESSURE

	if(currentpart == SSAIR_HIGHPRESSURE)
		timer = TICK_USAGE_REAL
		process_high_pressure_delta(resumed)
		cost_highpressure = MC_AVERAGE(cost_highpressure, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSAIR_HOTSPOTS

	if(currentpart == SSAIR_HOTSPOTS)
		timer = TICK_USAGE_REAL
		process_hotspots(resumed)
		cost_hotspots = MC_AVERAGE(cost_hotspots, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSAIR_SUPERCONDUCTIVITY

	if(currentpart == SSAIR_SUPERCONDUCTIVITY)
		timer = TICK_USAGE_REAL
		process_super_conductivity(resumed)
		cost_superconductivity = MC_AVERAGE(cost_superconductivity, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
	currentpart = SSAIR_REBUILD_PIPENETS

/datum/controller/subsystem/air/proc/process_pipenets(resumed = 0)
	if (!resumed)
		src.currentrun = networks.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/thing = currentrun[currentrun.len]
		currentrun.len--
		if(thing)
			thing.process()
		else
			networks.Remove(thing)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/air/proc/add_to_rebuild_queue(atmos_machine)
	if(istype(atmos_machine, /obj/machinery/atmospherics))
		pipenets_needing_rebuilt += atmos_machine

/datum/controller/subsystem/air/proc/process_atmos_machinery(resumed = 0)
	var/seconds = wait * 0.1
	if (!resumed)
		src.currentrun = atmos_machinery.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/obj/machinery/M = currentrun[currentrun.len]
		currentrun.len--
		if(!M || (M.process_atmos(seconds) == PROCESS_KILL))
			atmos_machinery.Remove(M)
		if(MC_TICK_CHECK)
			return


/datum/controller/subsystem/air/proc/process_react_queue(resumed = 0)
	if(!resumed)
		src.currentrun = turf_react_queue.Copy()
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/turf/open/T = currentrun[currentrun.len]
		currentrun.len--
		if(T)
			T.process_cell_reaction()
		if(MC_TICK_CHECK)
			return


/datum/controller/subsystem/air/proc/process_super_conductivity(resumed = 0)
	if (!resumed)
		src.currentrun = active_super_conductivity.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/turf/T = currentrun[currentrun.len]
		currentrun.len--
		T.super_conduct()
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/air/proc/process_hotspots(resumed = 0)
	if (!resumed)
		src.currentrun = hotspots.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/obj/effect/hotspot/H = currentrun[currentrun.len]
		currentrun.len--
		if (H)
			H.process()
		else
			hotspots -= H
		if(MC_TICK_CHECK)
			return


/datum/controller/subsystem/air/proc/process_high_pressure_delta(resumed = 0)
	while (high_pressure_delta.len)
		var/turf/open/T = high_pressure_delta[high_pressure_delta.len]
		high_pressure_delta.len--
		T.high_pressure_movements()
		T.pressure_difference = 0
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/air/proc/process_excited_groups(resumed = 0)
	if (!resumed)
		src.currentrun = excited_groups.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/excited_group/EG = currentrun[currentrun.len]
		currentrun.len--
		EG.breakdown_cooldown++
		EG.dismantle_cooldown++
		if(EG.breakdown_cooldown >= EXCITED_GROUP_BREAKDOWN_CYCLES)
			EG.self_breakdown()
		else if(EG.dismantle_cooldown >= EXCITED_GROUP_DISMANTLE_CYCLES)
			EG.dismantle()
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/air/proc/remove_from_active(turf/open/T)
	active_turfs -= T
	SSair_turfs.currentrun -= T
	#ifdef VISUALIZE_ACTIVE_TURFS
	T.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, "#00ff00")
	#endif
	if(istype(T))
		T.excited = 0
		if(T.excited_group)
			T.excited_group.garbage_collect()
	remove_from_react_queue(T)

/datum/controller/subsystem/air/proc/add_to_active(turf/open/T, blockchanges = 1)
	if(istype(T) && T.air)
		#ifdef VISUALIZE_ACTIVE_TURFS
		T.add_atom_colour("#00ff00", TEMPORARY_COLOUR_PRIORITY)
		#endif
		T.excited = TRUE
		active_turfs[T] = SSair_turfs.currentrun[T] = TRUE
		if(blockchanges && T.excited_group)
			T.excited_group.garbage_collect()
		add_to_react_queue(T)
	else if(T.flags_1 & INITIALIZED_1)
		for(var/turf/S in T.atmos_adjacent_turfs)
			add_to_active(S)
	else if(map_loading)
		if(queued_for_activation)
			queued_for_activation[T] = T
		return
	else
		T.requires_activation = TRUE

/datum/controller/subsystem/air/proc/add_to_react_queue(turf/open/T)
	if(istype(T) && T.air)
		turf_react_queue[T] = TRUE
		if(currentpart == SSAIR_REACTQUEUE)
			currentrun[T] = TRUE

/datum/controller/subsystem/air/proc/remove_from_react_queue(turf/open/T)
	turf_react_queue -= T
	if(currentpart == SSAIR_REACTQUEUE)
		currentrun -= T

/datum/controller/subsystem/air/StartLoadingMap()
	LAZYINITLIST(queued_for_activation)
	map_loading = TRUE

/datum/controller/subsystem/air/StopLoadingMap()
	map_loading = FALSE
	for(var/T in queued_for_activation)
		add_to_active(T)
	queued_for_activation.Cut()

/datum/controller/subsystem/air/proc/setup_allturfs()
	var/list/turfs_to_init = block(locate(1, 1, 1), locate(world.maxx, world.maxy, world.maxz))
	var/list/active_turfs = src.active_turfs
	var/times_fired = ++src.times_fired

	// Clear active turfs - faster than removing every single turf in the world
	// one-by-one, and Initalize_Atmos only ever adds `src` back in.
	active_turfs.Cut()

	for(var/thing in turfs_to_init)
		var/turf/T = thing
		if (T.blocks_air)
			continue
		T.Initalize_Atmos(times_fired)
		CHECK_TICK

	if(active_turfs.len)
		var/starting_ats = active_turfs.len
		sleep(world.tick_lag)
		var/timer = world.timeofday
		log_mapping("There are [starting_ats] active turfs at roundstart caused by a difference of the air between the adjacent turfs. You can see its coordinates using \"Mapping -> Show roundstart AT list\" verb (debug verbs required).")
		for(var/turf/T in active_turfs)
			GLOB.active_turfs_startlist += T

		//now lets clear out these active turfs
		var/list/turfs_to_check = active_turfs.Copy()
		do
			var/list/new_turfs_to_check = list()
			for(var/turf/open/T in turfs_to_check)
				new_turfs_to_check += T.resolve_active_graph()
			CHECK_TICK

			active_turfs += new_turfs_to_check
			turfs_to_check = new_turfs_to_check

		while (turfs_to_check.len)
		var/ending_ats = active_turfs.len
		for(var/thing in excited_groups)
			var/datum/excited_group/EG = thing
			EG.self_breakdown(space_is_all_consuming = 1)
			EG.dismantle()
			CHECK_TICK

		var/msg = "HEY! LISTEN! [DisplayTimeText(world.timeofday - timer)] were wasted processing [starting_ats] turf(s) (connected to [ending_ats] other turfs) with atmos differences at round start."
		to_chat(world, "<span class='boldannounce'>[msg]</span>")
		warning(msg)

/turf/open/proc/resolve_active_graph()
	. = list()
	var/datum/excited_group/EG = excited_group
	if (blocks_air || !air)
		return
	if (!EG)
		EG = new
		EG.add_turf(src)

	for (var/turf/open/ET in atmos_adjacent_turfs)
		if ( ET.blocks_air || !ET.air)
			continue

		var/ET_EG = ET.excited_group
		if (ET_EG)
			if (ET_EG != EG)
				EG.merge_groups(ET_EG)
				EG = excited_group //merge_groups() may decide to replace our current EG
		else
			EG.add_turf(ET)
		if (!ET.excited)
			ET.excited = 1
			. += ET
/turf/open/space/resolve_active_graph()
	return list()

/datum/controller/subsystem/air/proc/setup_atmos_machinery()
	for (var/obj/machinery/atmospherics/AM in atmos_machinery)
		AM.atmosinit()
		CHECK_TICK

//this can't be done with setup_atmos_machinery() because
//	all atmos machinery has to initalize before the first
//	pipenet can be built.
/datum/controller/subsystem/air/proc/setup_pipenets()
	for (var/obj/machinery/atmospherics/AM in atmos_machinery)
		AM.build_network()
		CHECK_TICK

/datum/controller/subsystem/air/proc/setup_template_machinery(list/atmos_machines)
	if(!initialized)
		return

	for(var/A in atmos_machines)
		var/obj/machinery/atmospherics/AM = A
		AM.atmosinit()
		CHECK_TICK

	for(var/A in atmos_machines)
		var/obj/machinery/atmospherics/AM = A
		AM.build_network()
		CHECK_TICK

/datum/controller/subsystem/air/proc/get_init_dirs(type, dir)
	if(!pipe_init_dirs_cache[type])
		pipe_init_dirs_cache[type] = list()

	if(!pipe_init_dirs_cache[type]["[dir]"])
		var/obj/machinery/atmospherics/temp = new type(null, FALSE, dir)
		pipe_init_dirs_cache[type]["[dir]"] = temp.GetInitDirections()
		qdel(temp)

	return pipe_init_dirs_cache[type]["[dir]"]

#undef SSAIR_PIPENETS
#undef SSAIR_ATMOSMACHINERY
#undef SSAIR_EXCITEDGROUPS
#undef SSAIR_HIGHPRESSURE
#undef SSAIR_HOTSPOTS
#undef SSAIR_SUPERCONDUCTIVITY
