/datum/round_event_control/starfurybc
	name = "Starfury Battle Cruiser"
	typepath = /datum/round_event/ghost_role/starfurybc
	weight = 0
	max_occurrences = 1
	min_players = 40
	earliest_start = 60 MINUTES
	gamemode_blacklist = list("nuclear")

/datum/round_event_control/starfurybc/preRunEvent()
	if (!SSmapping.empty_space)
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/ghost_role/starfurybc
	minimum_required = 1
	var/shuttle_spawned = FALSE
	var/started = FALSE
	var/preptime = 1 MINUTES
	var/announcetime = 4 MINUTES

/datum/round_event/ghost_role/starfurybc/start()
	started = TRUE
	priority_announce("Syndicate Battle Cruiser detected on long range scanners. ETA [(preptime / 10 / 60)] minutes.")
	addtimer(CALLBACK(src, .proc/spawn_shuttle), preptime)
	spawn_shuttle()

/*
/datum/round_event/ghost_role/starfurybc/process()
	if((SSshuttle.emergency.mode == SHUTTLE_CALL) && started)
		started = FALSE
		var/delaytime = 8400
		var/timer = SSshuttle.emergency.timeLeft(1) + delaytime
		var/security_num = seclevel2num(get_security_level())
		var/set_coefficient = 1
		switch(security_num)
			if(SEC_LEVEL_GREEN)
				set_coefficient = 2
			if(SEC_LEVEL_BLUE)
				set_coefficient = 1
			else
				set_coefficient = 0.5
		var/recalld = timer - (SSshuttle.emergencyCallTime * set_coefficient)
		SSshuttle.emergency.setTimer(timer)
		if(recalld > 0)
			SSshuttle.block_recall(recalld)
*/

/datum/round_event/ghost_role/starfurybc/proc/spawn_shuttle()
	shuttle_spawned = TRUE

	var/list/candidates = pollGhostCandidates("Do you wish to be considered for syndicate battlecruiser crew?", ROLE_OPERATIVE)
	shuffle_inplace(candidates)
	if(candidates.len < minimum_required)
		deadchat_broadcast(span_deadsay("The Starfury Battle Cruiser event did not get the minimum [minimum_required] candidates needed for it to spawn."))
		priority_announce("Our sensors indicate that the Syndicate Cruiser has flown past [GLOB.station_name].")
		return NOT_ENOUGH_PLAYERS

	var/datum/map_template/shuttle/syndifury/starfury/ship = new
	var/x = rand(TRANSITIONEDGE,world.maxx - TRANSITIONEDGE - ship.width)
	var/y = rand(TRANSITIONEDGE,world.maxy - TRANSITIONEDGE - ship.height)
	var/z = SSmapping.empty_space.z_value
	var/turf/T = locate(x,y,z)
	if(!T)
		CRASH("SBC Starfury event found no turf to load in")

	if(!ship.load(T))
		CRASH("Loading SBC Starfury cruiser failed!")

	for(var/turf/A in ship.get_affected_turfs(T))
		for(var/obj/docking_port/stationary/S in A)
			SSshuttle.action_load(S.roundstart_template, S)

		for(var/obj/effect/mob_spawn/human/syndicate/battlecruiser/captain/C in A)
			SpawnCrew(candidates) //We want the captain to spawn first

		for(var/obj/effect/mob_spawn/human/syndicate/spawner in A)
			SpawnCrew(spawner, candidates)

	addtimer(CALLBACK(src, WarnTheCrew(), announcetime)

/datum/round_event/ghost_role/starfurybc/proc/WarnTheCrew()
	priority_announce("A Syndicate Battle Cruiser has been found near the station's sector, brace for impact.", sound = 'sound/machines/alarm.ogg')

/datum/round_event/ghost_role/starfurybc/proc/SpawnCrew(obj/effect/mob_spawn/human/syndicate/spawner, list/candidates = list())
	if(candidates.len > 0)
		var/mob/M = candidates[1]
		spawner.create(M.ckey)
		announce_to_ghosts(M)
		candidates -= candidates[1]
	else
		announce_to_ghosts(spawner)

/obj/machinery/computer/shuttle/starfurybc
	name = "battle cruiser console"
	shuttleId = "starfury"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = LIGHT_COLOR_RED
	req_access = list(ACCESS_SYNDICATE)
	possible_destinations = "starfury_home;starfury_custom"

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/starfurybc
	name = "battle cruiser navigation computer"
	desc = "Used to designate a precise transit location for the battle cruiser."
	shuttleId = "starfury"
	jumpto_ports = list("starfury_home" = 1, "syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1)
	shuttlePortId = "starfury_custom"
	view_range = 140
	x_offset = -14
	y_offset = 22
