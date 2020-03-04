SUBSYSTEM_DEF(minimaps)
	name = "Minimaps"
	flags = SS_NO_FIRE
	var/list/station_minimaps = list()

/datum/controller/subsystem/minimaps/Initialize()
	if(!CONFIG_GET(flag/minimaps_enabled))
		to_chat(world, "<span class='boldwarning'>Minimaps disabled! Skipping init.</span>")
		return ..()
	build_minimaps()
	return ..()

/datum/controller/subsystem/minimaps/proc/build_minimaps()
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		var/datum/space_level/SL = SSmapping.get_level(z)
		station_minimaps[(SL.name == initial(SL.name))? "[z] - Station" : "[z] - [SL.name]"] = new /datum/minimap(z)
