//WHAT IF WE TAKE THE ACTIVE TURF PROCESSING AND PUSH IT SOMEWHERE ELSE!!!

SUBSYSTEM_DEF(air_turfs)
	name = "Atmospherics - Turfs"
	init_order = INIT_ORDER_AIR_TURFS
	priority = FIRE_PRIORITY_AIR_TURFS
	wait = 2
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/cost_turfs = 0
	var/cost_post_turfs = 0
	var/cost_groups = 0
	var/cost_equalize = 0

	var/currentpart = SSAIR_ACTIVETURFS

/datum/controller/subsystem/air_turfs/stat_entry(msg)
	var/active_turf_len = SSair.active_turfs_length()
	msg += "C:{"
	msg += "EQ:[round(cost_equalize,1)]|"
	msg += "AT:[round(cost_turfs,1)]|"
	msg += "PT:[round(cost_post_turfs,1)]|"
	msg += "EG:[round(cost_groups,1)]|"
	msg += "}"
	msg += "AT:[active_turf_len]|"
	msg += "CPP:[SSair.cpp_currentrun_length()]|"
	msg += "TP:[SSair.processing_length()]|"
	msg += "PT:[SSair.post_processing_length()]|"
	msg += "EG:[SSair.get_amt_excited_groups()]|"
	msg += "AT/MS:[round((cost ? active_turf_len/cost : 0),0.1)]"
	..(msg)

/datum/controller/subsystem/air_turfs/fire(resumed = 0)
	var/timer = TICK_USAGE_REAL
	// "why is it post process if it comes before" because in C++ it only happens after the thread does the process
	if(currentpart == SSAIR_POST_PROCESS)
		timer = TICK_USAGE_REAL
		SSair.post_process_turfs(resumed)
		cost_post_turfs = MC_AVERAGE(cost_post_turfs, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSair.monstermos_enabled ? SSAIR_EQUALIZE : SSAIR_ACTIVETURFS

	if(currentpart == SSAIR_EXCITEDGROUPS)
		timer = TICK_USAGE_REAL
		SSair.process_excited_groups(resumed)
		cost_groups = MC_AVERAGE(cost_groups, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSAIR_EQUALIZE

	if(currentpart == SSAIR_EQUALIZE)
		timer = TICK_USAGE_REAL
		SSair.process_turf_equalize(resumed)
		cost_equalize = MC_AVERAGE(cost_equalize, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSAIR_ACTIVETURFS

	if(currentpart == SSAIR_ACTIVETURFS)
		timer = TICK_USAGE_REAL
		SSair.process_active_turfs(resumed)
		cost_turfs = MC_AVERAGE(cost_turfs, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0

	currentpart = SSAIR_POST_PROCESS
