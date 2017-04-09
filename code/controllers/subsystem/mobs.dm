SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	init_order = 4
	priority = 100
	flags = SS_KEEP_TIMING|SS_NO_INIT

	var/list/currentrun = list()

/datum/controller/subsystem/mobs/stat_entry()
	..("P:[GLOB.mob_list.len]")


/datum/controller/subsystem/mobs/fire(resumed = 0)
	var/seconds = wait * 0.1
	if (!resumed)
		src.currentrun = GLOB.mob_list.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--
		if(M)
			M.Life(seconds)
		else
			GLOB.mob_list.Remove(M)
		if (MC_TICK_CHECK)
			return