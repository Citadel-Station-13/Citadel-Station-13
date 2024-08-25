#define Z_DIST 500
#define CUSTOM_ENGINES_START_TIME 65
#define CALCULATE_STATS_COOLDOWN 2

/obj/machinery/computer/custom_shuttle
	name = "nanotrasen shuttle flight controller"
	desc = "A terminal used to fly shuttles defined by the Shuttle Zoning Designator"
	circuit = /obj/item/circuitboard/computer/shuttle/flight_control
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	light_color = LIGHT_COLOR_CYAN
	req_access = list( )
	var/shuttleId
	var/possible_destinations = "whiteship_home"
	var/admin_controlled
	var/no_destination_swap = 0
	var/calculated_mass = 0
	var/calculated_dforce = 0
	var/calculated_speed = 0
	var/calculated_engine_count = 0
	var/calculated_consumption = 0
	var/calculated_cooldown = 0
	var/calculated_non_operational_thrusters = 0
	var/calculated_fuel_less_thrusters = 0
	var/target_fuel_cost = 0
	var/targetLocation
	var/datum/browser/popup

	var/stat_calc_cooldown = 0

	//Upgrades
	var/distance_multiplier = 1

/obj/machinery/computer/custom_shuttle/examine(mob/user)
	. = ..()
	. += distance_multiplier < 1 ? "Bluespace shortcut module installed. Route is [distance_multiplier]x the original length." : ""

/obj/machinery/computer/custom_shuttle/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CustomShuttleConsole", name)
		ui.open()

/obj/machinery/computer/custom_shuttle/ui_data(mob/user)
	var/list/data = list()
	var/list/options = params2list(possible_destinations)
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	data["docked_location"] = M ? M.get_status_text_tgui() : null
	if(M)
		calculateStats(FALSE, 0, TRUE)
		data["ship_name"] = M.area_type ? M.area_type:name : "ERROR"
		data["shuttle_mass"] = calculated_mass/10
		data["engine_force"] = calculated_dforce
		data["engines"] = calculated_engine_count
		data["calculated_speed"] = calculated_speed
		data["damaged_engines"] = calculated_non_operational_thrusters
		data["calculated_consumption"] = calculated_consumption
		data["calculated_cooldown"] = calculated_cooldown
		data["locations"] = list()
		for(var/obj/docking_port/stationary/S in SSshuttle.stationary)
			if(!options.Find(S.shuttle_id))
				continue
			if(!M.check_dock(S, silent = TRUE))
				continue
			var/list/location_data = list(
				id = S.shuttle_id,
				name = S.name,
				dist = round(calculateDistance(S))
			)
			data["locations"] += list(location_data)
		data["destination"] = targetLocation
	return data

/obj/machinery/computer/custom_shuttle/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!allowed(usr))
		to_chat(usr, "<span class='danger'>Access denied.</span>")
		return

	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	if(!M)
		to_chat(usr, "<span class='danger'>Shuttle Link Required.</span>")
		return
	if(M.launch_status == ENDGAME_LAUNCHED)
		return

	switch(action)
		if("setloc")
			SetTargetLocation(params["setloc"])
		if("fly")
			Fly()
	return

/obj/machinery/computer/custom_shuttle/proc/calculateDistance(var/obj/docking_port/stationary/port)
	var/deltaX = port.x - x
	var/deltaY = port.y - y
	var/deltaZ = (port.z - z) * Z_DIST
	return sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ) * distance_multiplier

/obj/machinery/computer/custom_shuttle/proc/linkShuttle(var/new_id)
	shuttleId = new_id
	possible_destinations = "whiteship_home;shuttle[new_id]_custom"

/obj/machinery/computer/custom_shuttle/proc/calculateStats(var/useFuel = FALSE, var/dist = 0, var/ignore_cooldown = FALSE)
	if(!ignore_cooldown && stat_calc_cooldown >= world.time)
		to_chat(usr, "<span>You are using this too fast, please slow down</span>")
		return
	stat_calc_cooldown = world.time + CALCULATE_STATS_COOLDOWN
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	if(!M)
		return FALSE
	//Reset data
	calculated_mass = 0
	calculated_dforce = 0
	calculated_speed = 0
	calculated_engine_count = 0
	calculated_consumption = 0
	calculated_cooldown = 0
	calculated_fuel_less_thrusters = 0
	calculated_non_operational_thrusters = 0
	//Calculate all the data
	var/list/areas = M.shuttle_areas
	for(var/shuttleArea in areas)
		calculated_mass += length(get_area_turfs(shuttleArea))
		for(var/obj/machinery/shuttle/engine/E in shuttleArea)
			E.check_setup()
			if(!E.thruster_active)	//Skipover thrusters with no valid heater
				calculated_non_operational_thrusters ++
				continue
			if(E.attached_heater)
				var/obj/machinery/atmospherics/components/unary/shuttle/heater/resolvedHeater = E.attached_heater.resolve()
				if(resolvedHeater && !resolvedHeater.hasFuel(dist * E.fuel_use) && useFuel)
					calculated_fuel_less_thrusters ++
					continue
			calculated_engine_count++
			calculated_dforce += E.thrust
			calculated_consumption += E.fuel_use
			calculated_cooldown = max(calculated_cooldown, E.cooldown)
	//This should really be accelleration, but its a 2d spessman game so who cares
	if(calculated_mass == 0)
		return FALSE
	calculated_speed = (calculated_dforce*1000) / (calculated_mass*100)
	return TRUE

/obj/machinery/computer/custom_shuttle/proc/consumeFuel(var/dist)
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	if(!M)
		return FALSE
	//Calculate all the data
	for(var/obj/machinery/shuttle/engine/shuttle_machine in GLOB.custom_shuttle_machines)
		shuttle_machine.check_setup()
		if(!shuttle_machine.thruster_active)
			continue
		if(get_area(M) != get_area(shuttle_machine))
			continue
		if(shuttle_machine.attached_heater)
			var/obj/machinery/atmospherics/components/unary/shuttle/heater/resolvedHeater = shuttle_machine.attached_heater.resolve()
			if(resolvedHeater && !resolvedHeater.hasFuel(dist * shuttle_machine.fuel_use))
				continue
			resolvedHeater?.consumeFuel(dist * shuttle_machine.fuel_use)
		shuttle_machine.fireEngine()

/obj/machinery/computer/custom_shuttle/proc/SetTargetLocation(var/newTarget)
	if(!(newTarget in params2list(possible_destinations)))
		log_admin("[usr] attempted to href dock exploit on [src] with target location \"[newTarget]\"")
		message_admins("[usr] just attempted to href dock exploit on [src] with target location \"[newTarget]\"")
		return
	targetLocation = newTarget
	say("Shuttle route calculated.")
	return

/obj/machinery/computer/custom_shuttle/proc/Fly()
	if(!targetLocation)
		return
	var/obj/docking_port/mobile/linkedShuttle = SSshuttle.getShuttle(shuttleId)
	if(!linkedShuttle)
		return
	if(linkedShuttle.mode != SHUTTLE_IDLE)
		return
	if(!calculateStats(TRUE, 0, TRUE))
		return
	if(calculated_fuel_less_thrusters > 0)
		say("Warning, [calculated_fuel_less_thrusters] do not have enough fuel for this journey, engine output may be limitted.")
	if(calculated_speed < 1)
		say("Insufficient engine power, shuttle requires [calculated_mass / 10]kN of thrust.")
		return
	var/obj/docking_port/stationary/targetPort = SSshuttle.getDock(targetLocation)
	if(!targetPort)
		return
	var/dist = calculateDistance(targetPort)
	var/time = min(max(round(dist / calculated_speed), 10), 90)
	linkedShuttle.callTime = time * 10
	linkedShuttle.rechargeTime = calculated_cooldown
	//We need to find the direction of this console to the port
	linkedShuttle.port_direction = angle2dir(dir2angle(dir) - (dir2angle(linkedShuttle.dir)) + 180)
	linkedShuttle.preferred_direction = NORTH
	linkedShuttle.ignitionTime = CUSTOM_ENGINES_START_TIME
	linkedShuttle.count_engines()
	linkedShuttle.hyperspace_sound(HYPERSPACE_WARMUP)
	var/throwForce = clamp((calculated_speed / 2) - 5, 0, 10)
	linkedShuttle.movement_force = list("KNOCKDOWN" = calculated_speed > 5 ? 3 : 0, "THROW" = throwForce)
	if(!(targetLocation in params2list(possible_destinations)))
		log_admin("[usr] attempted to launch a shuttle that has been affected by href dock exploit on [src] with target location \"[targetLocation]\"")
		message_admins("[usr] attempted to launch a shuttle that has been affected by href dock exploit on [src] with target location \"[targetLocation]\"")
		return
	switch(SSshuttle.moveShuttle(shuttleId, targetLocation, 1))
		if(0)
			consumeFuel(dist)
			say("Shuttle departing. Please stand away from the doors.")
		if(1)
			to_chat(usr, "<span class='warning'>Invalid shuttle requested.</span>")
		else
			to_chat(usr, "<span class='notice'>Unable to comply.</span>")
	return

/obj/machinery/computer/custom_shuttle/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	if(port && (shuttleId == initial(shuttleId) || override))
		linkShuttle(port.shuttle_id)

//Custom shuttle docker locations
/obj/machinery/computer/camera_advanced/shuttle_docker/custom
	name = "Shuttle Navigation Computer"
	desc = "Used to designate a precise transit location for private ships."
	lock_override = NONE
	whitelist_turfs = list(/turf/open/space,
		/turf/open/lava,
		/turf/open/floor/plating/beach,
		/turf/open/floor/plating/ashplanet,
		/turf/open/floor/plating/asteroid,
		/turf/open/floor/plating/lavaland_baseturf)
	jump_to_ports = list("whiteship_home" = 1)
	view_range = 12
	designate_time = 100
	circuit = /obj/item/circuitboard/computer/shuttle/docker

/obj/machinery/computer/camera_advanced/shuttle_docker/custom/Initialize(mapload)
	. = ..()
	GLOB.jam_on_wardec += src

/obj/machinery/computer/camera_advanced/shuttle_docker/custom/Destroy()
	GLOB.jam_on_wardec -= src
	return ..()

/obj/machinery/computer/camera_advanced/shuttle_docker/custom/placeLandingSpot()
	if(!shuttleId)
		return	//Only way this would happen is if someone else delinks the console while in use somehow
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	if(M?.mode != SHUTTLE_IDLE)
		to_chat(usr, "<span class='warning'>You cannot target locations while in transit.</span>")
		return
	..()

/obj/machinery/computer/camera_advanced/shuttle_docker/custom/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	// This may look ugly (it does), but nowadays this docker already gains an id, so we forbid interactions until correctly linked.
	if(shuttlePortId != "shuttle[shuttleId]_custom")
		to_chat(user, "<span class='warning'>You must link the console to a shuttle first.</span>")
		return
	return ..()

/obj/machinery/computer/camera_advanced/shuttle_docker/custom/proc/linkShuttle(new_id)
	shuttleId = new_id
	shuttlePortId = "shuttle[new_id]_custom"
