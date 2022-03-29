/**
 * equivalent to SSzclear
 * prototype system to wipe a zlevel
 */
/datum/controller/subsystem/mapping
	// as of right now, zclear is the only time mapping needs to fire
	var/static/clearing_levels = FALSE
	// levels being cleared
	var/static/list/erasing_levels = list()
	// first stage - levels associated to the turf pointer of the last cleared turf
	var/static/list/erasing_first_wipe = list()
	// second stage - levels associated to list of things that remain
	var/static/list/erasing_second_wipe = list()
	// list of levels ready for reuse
	var/static/list/reusable_levels = list()
	// ignore typecache
	var/static/list/ignore_typecache = typecacheof(list(
		/atom/movable/lighting_object,
		/mob/dead/observer,
		/mob/dead/new_player
	))

/**
 * wipes a level
 */
/datum/controller/subsystem/mapping/proc/ZClear(z)
	if(z in erasing_levels)
		CRASH("attempted to erase a zlevel twice")
	message_admins("ZClear triggered for z[z].")
	subsystem_log("Beginning stage 0 ZClear for [z]")
	var/start = REALTIMEOFDAY
	erasing_levels |= z
	erasing_first_wipe["[z]"] = locate(1, 1, z)
	for(var/datum/controller/subsystem/S in Master.subsystems)
		S.BeginZClear(z)
	can_fire = TRUE
	// immediately wipe the level's associations
	// 1. world_structs - if this is in one, destroy it, if you delete a planetary level this is on you
	if(struct_by_z[z])
		struct_by_z[z].Deconstruct(FALSE)
	// 2. level
	var/datum/space_level/level = space_levels[z]
	level.SetDown(null)
	level.SetUp(null)
	level.SetEast(null)
	level.SetWest(null)
	level.SetNorth(null)
	level.SetSouth(null)
	// 3. rebuild
	RebuildTransitions()
	RebuildVerticality()
	// 4. ensure nothing gets in or out
	level.RebuildTransitions()
	level.RebuildTurfs()
	var/elapsed = round((REALTIMEOFDAY - start) * 0.1, 0.01)
	message_admins("ZClear: Stage 0 for [z] finished in [elapsed] seconds. Adding to subsystem and igniting...")
	subsystem_log("Stage 0 for [z] finished in [elapsed] seconds. Adding + igniting subsystem.")


/datum/controller/subsystem/mapping/fire(resumed)
	. = ..()
	// process from last stages to first
	for(var/z in erasing_second_wipe)
		var/list/survivors = erasing_second_wipe[z]
		var/i
		for(i in 1 to survivors.len)
			qdel(survivors[i], TRUE)
			if(MC_TICK_CHECK)
				survivors.Cut(1, i + 1)
				return
		survivors.Cut()
		message_admins("ZClear: Stage 2 for [z] finished. Adding [z] to reusable list.")
		subsystem_log("Stage 2 for [z] finished; Adding to reusable levels.")
		erasing_second_wipe -= z
		reusable_levels += text2num(z)
		erasing_levels -= text2num(z)
		for(var/datum/controller/subsystem/S in Master.subsystems)
			S.OnZClear(z)
		if(!length(erasing_levels))
			can_fire = FALSE

	for(var/z in erasing_first_wipe)
		var/turf/current = erasing_first_wipe[z]
		var/x = current.x
		var/y = current.y
		var/_z = text2num(z)
		while(current)
			current.empty(world.turf)
			++x
			if(x > world.maxx)
				++y
				x = 1
			if(y > world.maxy)
				// done
				break
			current = locate(x, y, _z)
			if(MC_TICK_CHECK)
				return
		// check completion
		if(y <= world.maxy)
			return	// not done yet
		message_admins("ZClear: Stage 1 for [z] finished. Priming stage 2...")
		subsystem_log("Stage 1 for [z] finished; Priming stage 2.")
		erasing_first_wipe -= z
		var/start = REALTIMEOFDAY
		var/list/survivors = list()
		// gather all survivors
		for(var/turf/T as anything in block(locate(1, 1, _z), locate(world.maxx, world.maxy, _z)))
			for(var/atom/movable/AM in T)
				if(ignore_typecache[AM.type])
					continue
				survivors += AM
		erasing_second_wipe[z] = survivors
		var/end = round((REALTIMEOFDAY - start), 0.01)
		message_admins("ZClear: Stage 2 priming for [z] finished in [end] seconds. There were [survivors.len] survivors.")
		subsystem_log("Stage 2 for [z] primed in [end] seconds. There were [survivors.len] survivors.")

/**
 * gets an reusable level, or increments world.maxz
 * WARNING: AFTER THIS, YOU NEED TO USE THE LEVEL, OR READD TO REUSABLE, OR THIS IS A MEMORY LEAK!
 */
/datum/controller/subsystem/mapping/proc/GetInstantiationLevel(baseturf = world.turf)
	#warn here's the shitty part where we changeturf an entire zlevel if it's used already
	#warn I FUCKING HATE MY LIFE
	if(islist(reusable_levels) && reusable_levels.len)
		. = reusable_levels[1]
		reusable_levels.Cut(1, 2)
		return .
	return ++world.maxz

/**
 * called when a zlevel is beginning to be cleared by SSmapping.
 */
/datum/controller/subsystem/proc/BeginZClear(z)
	return

/**
 * called when a zlevel is cleared entirely by SSmapping.
 */
/datum/controller/subsystem/proc/OnZClear(z)
	return
