//WHAT IF WE TAKE THE ACTIVE TURF PROCESSING AND PUSH IT SOMEWHERE ELSE!!!

SUBSYSTEM_DEF(air_turfs)
	name = "Atmospherics - Turfs"
	init_order = INIT_ORDER_AIR_TURFS
	priority = FIRE_PRIORITY_AIR_TURFS
	wait = 1
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/cost_thread_wake = 0
	var/cost_post_turfs = 0
	var/cost_post_equalize = 0

	var/currentpart = SSAIR_POST_PROCESS

/datum/controller/subsystem/air_turfs/stat_entry(msg)
	var/active_turf_len = SSair.active_turfs_length()
	msg += "C:{"
	msg += "TH:[round(cost_thread_wake,1)]|"
	msg += "EQ:[round(cost_post_equalize,1)]|"
	msg += "AT:[round(cost_post_turfs,1)]|"
	msg += "}"
	msg += "AT:[active_turf_len]|"
	msg += "EQ:[SSair.post_equalize_turf_length()]"
	msg += "PT:[SSair.post_processing_length()]|"
	msg += "EG:[SSair.get_amt_excited_groups()]|"
	msg += "AT/MS:[round((cost ? active_turf_len/cost : 0),0.1)]|"
	..(msg)

/datum/controller/subsystem/air_turfs/Initialize(timeofday)
	extools_update_ssair_turfs()
	return ..()

/datum/controller/subsystem/air_turfs/proc/wake_thread()

/datum/controller/subsystem/air_turfs/proc/extools_update_ssair_turfs()

/datum/controller/subsystem/air_turfs/fire(resumed = 0)
	var/timer = TICK_USAGE_REAL
	wake_thread()
	cost_thread_wake = MC_AVERAGE_FAST(cost_thread_wake, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
	if(currentpart == SSAIR_POST_PROCESS)
		timer = TICK_USAGE_REAL
		SSair.post_process_turfs(resumed)
		cost_post_turfs = MC_AVERAGE_FAST(cost_post_turfs, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSair.monstermos_enabled ? SSAIR_EQUALIZE : SSAIR_POST_PROCESS

	if(currentpart == SSAIR_EQUALIZE)
		timer = TICK_USAGE_REAL
		SSair.post_process_turf_equalize(resumed)
		cost_post_equalize = MC_AVERAGE_FAST(cost_post_equalize, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSAIR_POST_PROCESS
	if(cost && SSair.active_turfs_length()/cost > 10000000) // it's PROBABLY broken, just kick it
		restart_extools_atmos_thread()
	currentpart = SSAIR_POST_PROCESS
