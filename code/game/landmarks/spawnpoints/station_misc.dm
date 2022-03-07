/atom/movable/landmark/spawnpoint/latejoin/station
	faction = JOB_FACTION_STATION

/atom/movable/landmark/spawnpoint/latejoin/station/arrivals_shuttle
	method = LATEJOIN_METHOD_ARRIVALS_SHUTTLE

/atom/movable/landmark/spawnpoint/latejoin/station/arrivals_shuttle/OnSpawn(mob/M, client/C)
	. = ..()
	var/obj/structure/chair/_C = locate() in GetSpawnLoc()
	if(C && !length(_C.buckled_mobs))
		_C.buckle_mob(M, FALSE, FALSE)
	if(SSshuttle.arrivals.mode == SHUTTLE_CALL)
		var/atom/movable/screen/splash/Spl = new(C, TRUE)
		Spl.Fade(TRUE)
		M.playsound_local(get_turf(M), 'sound/voice/ApproachingTG.ogg', 25)

/atom/movable/landmark/spawnpoint/overflow/station
	faction = JOB_FACTION_STATION
