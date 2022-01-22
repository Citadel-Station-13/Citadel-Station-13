SUBSYSTEM_DEF(parallax)
	name = "Parallax"
	wait = 2
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND
	priority = FIRE_PRIORITY_PARALLAX
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun

/datum/controller/subsystem/parallax/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = GLOB.clients.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	if(times_fired % 5)		// lazy tick
		while(length(currentrun))
			var/client/processing_client = currentrun[currentrun.len]
			currentrun.len--
			if (QDELETED(processing_client) || !processing_client.eye)
				if (MC_TICK_CHECK)
					return
				continue
			processing_client.parallax_holder?.Update()
			if (MC_TICK_CHECK)
				return
	else	// full tick
		while(length(currentrun))
			var/client/processing_client = currentrun[currentrun.len]
			currentrun.len--
			if (QDELETED(processing_client) || !processing_client.eye)
				if (MC_TICK_CHECK)
					return
				continue
			processing_client.parallax_holder?.Update(TRUE)
			if (MC_TICK_CHECK)
				return

	currentrun = null

/**
 * Gets parallax for zlevel.
 */
/datum/controller/subsystem/parallax/proc/get_parallax_type(z)
	return /datum/parallax/space

/**
 * Gets parallax added vis contents for zlevel
 */
/datum/controller/subsystem/parallax/proc/get_parallax_vis_contents(z)
	return list()

/**
 * Gets parallax motion for a zlevel
 *
 * Returns null or list(speed, dir deg clockwise from north)
 *
 * Area motion will override this.
 */
/datum/controller/subsystem/parallax/proc/get_parallax_motion(z)
	return null

/**
 * updates all parallax for clients on a z
 */
/datum/controller/subsystem/parallax/proc/update_clients_on_z(z)
	for(var/client/C in GLOB.clients)
		if(C.mob.z == z)
			C.parallax_holder?.Update()

/**
 * resets all parallax for clients on a z
 */
/datum/controller/subsystem/parallax/proc/reset_clients_on_z(z)
	for(var/client/C in GLOB.clients)
		if(C.mob.z == z)
			C.parallax_holder?.Reset()
