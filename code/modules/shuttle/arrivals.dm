/obj/docking_port/mobile/arrivals
	name = "arrivals shuttle"
	id = "arrivals"

	dwidth = 3
	width = 7
	height = 15
	dir = WEST
	port_angle = 180

	callTime = INFINITY
	ignitionTime = 50

	roundstart_move = TRUE	//force a call to dockRoundstart

	var/sound_played
	var/damaged	//too damaged to undock?
	var/list/areas	//areas in our shuttle
	var/list/queued_announces	//people coming in that we have to announce
	var/obj/machinery/requests_console/console
	var/force_depart = FALSE
	var/perma_docked = FALSE	//highlander with RESPAWN??? OH GOD!!!

/obj/docking_port/mobile/arrivals/Initialize(mapload)
	if(mapload)
		return TRUE	//late initialize to make sure the latejoin list is populated

	preferred_direction = dir

	if(SSshuttle.arrivals)
		WARNING("More than one arrivals docking_port placed on map!")
		qdel(src)
		return

	SSshuttle.arrivals = src

	..()

	areas = list()

	var/list/new_latejoin = list()
	for(var/area/shuttle/arrival/A in GLOB.sortedAreas)
		for(var/obj/structure/chair/C in A)
			new_latejoin += C
		if(!console)
			console = locate(/obj/machinery/requests_console) in A
		areas += A

	if(GLOB.latejoin.len)
		WARNING("Map contains predefined latejoin spawn points and an arrivals shuttle. Using the arrivals shuttle.")

	if(!new_latejoin.len)
		WARNING("Arrivals shuttle contains no chairs for spawn points. Reverting to latejoin landmarks.")
		if(!GLOB.latejoin.len)
			WARNING("No latejoin landmarks exist. Players will spawn unbuckled on the shuttle.")
		return

	GLOB.latejoin = new_latejoin

/obj/docking_port/mobile/arrivals/dockRoundstart()
	SSshuttle.generate_transit_dock(src)
	Launch()
	timer = world.time
	check()
	return TRUE

/obj/docking_port/mobile/arrivals/check()
	. = ..()

	if(perma_docked)
		if(mode != SHUTTLE_CALL)
			sound_played = FALSE
			mode = SHUTTLE_IDLE
		else
			SendToStation()
		return

	if(damaged)
		if(!CheckTurfsPressure())
			damaged = FALSE
			if(console)
				console.say("Repairs complete, launching soon.")
		return

//If this proc is high on the profiler add a cooldown to the stuff after this line

	else if(CheckTurfsPressure())
		damaged = TRUE
		if(console)
			console.say("Alert, hull breach detected!")
		var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
		announcer.announce("ARRIVALS_BROKEN", channels = list())
		if(mode != SHUTTLE_CALL)
			sound_played = FALSE
			mode = SHUTTLE_IDLE
		else
			SendToStation()
		return

	var/found_awake = PersonCheck()
	if(mode == SHUTTLE_CALL)
		if(found_awake)
			SendToStation()
	else if(mode == SHUTTLE_IGNITING)
		if(found_awake && !force_depart)
			mode = SHUTTLE_IDLE
			sound_played = FALSE
		else if(!sound_played)
			hyperspace_sound(HYPERSPACE_WARMUP, areas)
			sound_played = TRUE
	else if(!found_awake)
		Launch(FALSE)

/obj/docking_port/mobile/arrivals/proc/CheckTurfsPressure()
	for(var/I in GLOB.latejoin)
		var/turf/open/T = get_turf(I)
		var/pressure = T.air.return_pressure()
		if(pressure < HAZARD_LOW_PRESSURE || pressure > HAZARD_HIGH_PRESSURE)	//simple safety check
			return TRUE
	return FALSE

/obj/docking_port/mobile/arrivals/proc/PersonCheck()
	for(var/M in (GLOB.living_mob_list & GLOB.player_list))
		var/mob/living/L = M
		if((get_area(M) in areas) && L.stat != DEAD)
			return TRUE
	return FALSE

/obj/docking_port/mobile/arrivals/proc/SendToStation()
	var/dockTime = config.arrivals_shuttle_dock_window
	if(mode == SHUTTLE_CALL && timeLeft(1) > dockTime)
		if(console)
			console.say(damaged ? "Initiating emergency docking for repairs!" : "Now approaching: [station_name()].")
		hyperspace_sound(HYPERSPACE_LAUNCH, areas)	//for the new guy
		setTimer(dockTime)

/obj/docking_port/mobile/arrivals/dock(obj/docking_port/stationary/S1, force=FALSE)
	var/docked = S1 == assigned_transit
	sound_played = FALSE
	if(docked)	//about to launch
		if(!force_depart && PersonCheck())
			mode = SHUTTLE_IDLE
			if(console)
				console.say("Launch cancelled, lifeform dectected on board.")
			return
		force_depart = FALSE
	. = ..()
	if(!. && !docked && !damaged)
		console.say("Welcome to your new life, employees!")
		for(var/L in queued_announces)
			var/datum/callback/C = L
			C.Invoke()
		LAZYCLEARLIST(queued_announces)

/obj/docking_port/mobile/arrivals/check_effects()
	..()
	if(mode == SHUTTLE_CALL && !sound_played && timeLeft(1) <= HYPERSPACE_END_TIME)
		sound_played = TRUE
		hyperspace_sound(HYPERSPACE_END, areas)

/obj/docking_port/mobile/arrivals/canDock(obj/docking_port/stationary/S)
	. = ..()
	if(. == SHUTTLE_ALREADY_DOCKED)
		. = SHUTTLE_CAN_DOCK

/obj/docking_port/mobile/arrivals/proc/Launch(pickingup)
	if(pickingup)
		force_depart = TRUE
	if(mode == SHUTTLE_IDLE)
		if(console)
			console.say(pickingup ? "Departing immediately for new employee pickup." : "Shuttle departing.")
		request(SSshuttle.getDock("arrivals_stationary"))		//we will intentionally never return SHUTTLE_ALREADY_DOCKED

/obj/docking_port/mobile/arrivals/proc/RequireUndocked(mob/user)
	if(mode == SHUTTLE_CALL || damaged)
		return

	Launch(TRUE)

	user << "<span class='notice'>Calling your shuttle. One moment...</span>"
	while(mode != SHUTTLE_CALL && !damaged)
		stoplag()

/obj/docking_port/mobile/arrivals/proc/QueueAnnounce(mob, rank)
	if(mode != SHUTTLE_CALL)
		AnnounceArrival(mob, rank)
	else
		LAZYADD(queued_announces, CALLBACK(GLOBAL_PROC, .proc/AnnounceArrival, mob, rank))

/obj/docking_port/mobile/arrivals/vv_edit_var(var_name, var_value)
	switch(var_name)
		if("perma_docked")
			feedback_add_details("admin_secrets_fun_used","ShA[var_value ? "s" : "g"]")
	return ..()
