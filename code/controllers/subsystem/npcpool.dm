SUBSYSTEM_DEF(npcpool)
	name = "NPC Pool"
	flags = SS_KEEP_TIMING | SS_NO_INIT
	priority = FIRE_PRIORITY_NPC
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	/// catches sleeping
	var/invoking = FALSE
	/// Invoke start time
	var/invoke_start = 0

/datum/controller/subsystem/npcpool/stat_entry(msg)
	var/list/activelist = GLOB.simple_animals[AI_ON]
	msg = "NPCS:[length(activelist)]"
	return ..()

/datum/controller/subsystem/npcpool/fire(resumed = FALSE)
	if (!resumed)
		var/list/activelist = GLOB.simple_animals[AI_ON]
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/living/simple_animal/SA = currentrun[currentrun.len]
		--currentrun.len

		invoking = TRUE
		invoke_start = world.time
		INVOKE_ASYNC(src, PROC_REF(invoke_process), SA)
		if(invoking)
			stack_trace("WARNING: [SA] ([SA.type]) slept during NPCPool processing.")
			invoking = FALSE

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/npcpool/proc/invoke_process(mob/living/simple_animal/SA)
	if(!SA.ckey && !SA.mob_transforming)
		if(SA.stat != DEAD)
			SA.handle_automated_movement()
		if(SA.stat != DEAD)
			SA.handle_automated_action()
		if(SA.stat != DEAD)
			SA.handle_automated_speech()
	invoking = FALSE
