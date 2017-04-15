SUBSYSTEM_DEF(assets)
	name = "Assets"
	init_order = -3
	flags = SS_NO_FIRE
	var/list/cache = list()

/datum/controller/subsystem/assets/Initialize(timeofday)
	for(var/type in typesof(/datum/asset) - list(/datum/asset, /datum/asset/simple))
		var/datum/asset/A = new type()
		A.register()

	for(var/client/C in GLOB.clients)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/getFilesSlow, C, cache, FALSE), 10)
	..()