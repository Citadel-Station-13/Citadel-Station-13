GLOBAL_LIST_EMPTY(lighting_update_lights) // List of lighting sources  queued for update.
GLOBAL_LIST_EMPTY(init_lights) // List of lighting sources queued up for roundstart initialization

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 1
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER

	var/list/currentrun_lights
	var/resuming = 0

/datum/controller/subsystem/lighting/stat_entry()
	..("L:[GLOB.lighting_update_lights.len] queued")


/datum/controller/subsystem/lighting/Initialize(timeofday)
	for(var/atom/movable/light/L in GLOB.init_lights)
		if(L && !QDELETED(L))
			L.cast_light()
	GLOB.init_lights = null
	initialized = TRUE

	..()


/datum/controller/subsystem/lighting/fire(resumed=FALSE)
	if (!resuming)
		currentrun_lights = GLOB.lighting_update_lights
		GLOB.lighting_update_lights = list()

	resuming = 1

	while (currentrun_lights.len)
		var/atom/movable/light/L = currentrun_lights[currentrun_lights.len]
		currentrun_lights.len--

		if(L && !QDELETED(L))
			L.cast_light()

		if (MC_TICK_CHECK)
			return

	resuming = 0

/datum/controller/subsystem/lighting/Recover()
	initialized = SSlighting.initialized
	..()
