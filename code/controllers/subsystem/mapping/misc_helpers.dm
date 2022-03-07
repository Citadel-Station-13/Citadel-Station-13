/**
 * Picks a random space turf from crosslinked levels
 */
/datum/controller/subsystem/mapping/proc/RandomCrosslinkedSpaceTurf()
	var/list/levels = GetCrosslinked()
	levels = shuffle(levels)
	for(var/z in levels)
		var/list/potential = list()
		for(var/turf/open/space/S in block(locate(2, 2, z), locate(world.maxx - 1, world.maxy - 1, z)))
			potential += S
		. = safepick(potential)
		if(.)
			break

/**
 * Picks a random space turf from station levels
 */
/datum/controller/subsystem/mapping/proc/RandomStationSpaceTurf()
	var/list/levels = LevelsByTrait(ZTRAIT_STATION)
	levels = shuffle(levels)
	for(var/z in levels)
		var/list/potential = list()
		for(var/turf/open/space/S in block(locate(2, 2, z), locate(world.maxx - 1, world.maxy - 1, z)))
			potential += S
		. = safepick(potential)
		if(.)
			break

/**
 * Finds the center turf of the "first" (UNSORTED, SO MIGHT BE RANDOM) station leve.
 */
/datum/controller/subsystem/mapping/proc/GetStationCenter()
	var/list/station_z = LevelsByTrait(ZTRAIT_STATION)
	if(!station_z.len)		// wtf...
		return
	return locate(round(world.maxx * 0.5, 1), round(world.maxy * 0.5, 1), station_z[1])
