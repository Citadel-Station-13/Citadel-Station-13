//Cars that drfit
//By Fermi!


//todo:boost if(driver.sprinting)

/obj/vehicle/ridden/vectorcraft
	name = "all-terrain hovercraft"
	desc = "An all-terrain vehicle built for traversing rough terrain with ease. One of the few old-Earth technologies that are still relevant on most planet-bound outposts."
	icon_state = "atv"
	key_type = /obj/item/key
	movedelay = 5
	var/obj/structure/trunk //Trunkspace of craft
	var/vector = list("x" = 0, "y" = 0) //vector math
	var/max_acceleration = 5
	var/max_deceleration = 5
	var/boost_power = 2.5
	var/gear
	var/boost_cooldown
	var/datum/component/riding/carstats
	max_integrity = 100
	var/speed
	var/mob/living/carbon/human/driver

/obj/vehicle/ridden/vectorcraft/Initialize()
	.=..()
	carstats = GetComponent(/datum/component/riding)
	driver = return_drivers()
	gear = driver.a_intent


//////////////////////////////////////////////////////////////
//					Main driving checks				    	//
//////////////////////////////////////////////////////////////
/obj/vehicle/ridden/vectorcraft/vehicle_move(direction)
	check_gears()
	check_boost()
	calc_acceleration(direction)
	direction = calc_angle()
	if(!speed)
		return FALSE
	calc_velocity()
	//Hit the breaks!!
	if(driver.m_intent == MOVE_INTENT_WALK)
		var/deceleration = max_deceleration
		if(driver.in_throw_mode)
			deceleration *= 1.5
		friction(deceleration)
	else if(driver.in_throw_mode)
		friction(max_deceleration*1.2)
	else
		friction(max_deceleration/4)

	//speed
	if(lastmove + movedelay > world.time)
		return FALSE
	lastmove = world.time

	if(trailer)
		var/dir_to_move = get_dir(trailer.loc, loc)
		var/did_move = step(src, direction)
		if(did_move)
			step(trailer, dir_to_move)
		return did_move
	else
		after_move(direction)
		return step(src, direction)

//////////////////////////////////////////////////////////////
//					Check procs						    	//
//////////////////////////////////////////////////////////////

//check the cooldown on the boost
/obj/vehicle/ridden/vectorcraft/proc/check_boost()
	if(!boost_cooldown)
		return
	if(boost_cooldown < world.time)
		boost_cooldown = 0
	return

//Make sure the clutch is on while changing gears!!
/obj/vehicle/ridden/vectorcraft/proc/check_gears()
	if(!gear)
		gear = driver.a_intent
	//USE THE CCLUUUTCHHH
	if(gear != driver.a_intent && !driver.combatmode)
		//playsound
		to_chat(driver, "<span class='warning'><b>The gearbox gives out a horrific sound!</b></span>")
		apply_damage(5)
	gear = driver.a_intent

/obj/vehicle/ridden/vectorcraft/proc/bounce()
	vector["x"] = -vector["x"]/2
	vector["y"] = -vector["y"]/2


//////////////////////////////////////////////////////////////
//					Damage procs							//
//////////////////////////////////////////////////////////////
/obj/vehicle/ridden/vectorcraft/attackby(obj/item/O, mob/user, params)
	.=..()
	if(istype(O, /obj/item/weldingtool) && user.a_intent != INTENT_HARM)
		if(obj_integrity < max_integrity)
			if(!O.tool_start_check(user, amount=0))
				return

			user.visible_message("[user] begins repairing [src].", \
				"<span class='notice'>You begin repairing [src]...</span>", \
				"<span class='italics'>You hear welding.</span>")

			if(O.use_tool(src, user, 40, volume=50))
				to_chat(user, "<span class='notice'>You repair [src].</span>")
				apply_damage(-max_integrity)
		else
			to_chat(user, "<span class='notice'>[src] does not need repairs.</span>")

/obj/vehicle/ridden/vectorcraft/proc/apply_damage(damage)
	obj_integrity -= damage
	var/healthratio = ((obj_integrity/max_integrity)/2) + 0.5
	max_acceleration = initial(max_acceleration) * healthratio
	max_deceleration = initial(max_deceleration) * healthratio
	boost_power = initial(boost_power) * healthratio

	if(obj_integrity <= 0)
		var/datum/effect_system/reagents_explosion/e = new()
		var/turf/T = get_turf(src)
		e.set_up(1, T, 0, 0)
		e.start()
	if(obj_integrity > max_integrity)
		obj_integrity = max_integrity

//////////////////////////////////////////////////////////////
//					Calc procs						    	//
//////////////////////////////////////////////////////////////

/obj/vehicle/ridden/vectorcraft/proc/calc_velocity()
	switch(speed)
		if(-INFINITY to 10)
			carstats.vehicle_move_delay = 5
			movedelay = 5
		if(10 to 20)
			carstats.vehicle_move_delay = 4
			movedelay = 4
		if(20 to 35)
			carstats.vehicle_move_delay = 3
			movedelay = 3
		if(35 to 60)
			carstats.vehicle_move_delay = 2
			movedelay = 2
		if(60 to 90)
			carstats.vehicle_move_delay = 1
			movedelay = 1
		if(90 to INFINITY)
			carstats.vehicle_move_delay = 0
			movedelay = 0
	return


/obj/vehicle/ridden/vectorcraft/Bump(atom/movable/M)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/atom/throw_target = get_edge_target_turf(C, calc_angle())
		C.throw_at(throw_target, 10, 14, src)
		C.adjustBruteLoss(speed/10)
		to_chat(C, "<span class='warning'><b>You are hit by the [src]!</b></span>")
		to_chat(driver, "<span class='warning'><b>You just ran into [C] you crazy lunatic!</b></span>")
	//playsound
	apply_damage(speed/10)
	bounce()
	calc_speed()


/obj/vehicle/ridden/vectorcraft/proc/calc_angle()
	var/angle = 1/(TAN(vector["y"]/vector["x"]))
	switch(angle)
		if(337 to 360)
			return NORTH
		if(0 to 22)
			return NORTH
		if(22 to 67)
			return NORTHEAST
		if(67 to 112)
			return EAST
		if(112 to 157)
			return SOUTHEAST
		if(157 to 202)
			return SOUTH
		if(202 to 247)
			return SOUTHWEST
		if(247 to 292)
			return WEST
		if(292 to 337)
			return NORTHWEST

/obj/vehicle/ridden/vectorcraft/proc/calc_speed()
	var/magnitude = max(sqrt(vector["x"]**2), sqrt(vector["y"]**2))
	speed = (magnitude * gear) / 4

/obj/vehicle/ridden/vectorcraft/proc/calc_acceleration(direction)
	calc_speed()
	if(driver.combatmode)//clutch is on
		return FALSE
	var/acceleration = max_acceleration
	if(driver.sprinting && !(boost_cooldown))
		acceleration *= boost_power //You got boost power!
		boost_cooldown = world.time + 25
		//playsound
	if(speed > 25 && gear == "help")
		acceleration /= 2
		//playsound
	else if((speed > 50 || speed < 25) && gear == "grab")
		acceleration /= 2
	else if((speed > 75 || speed < 50) && gear == "disarm")
		acceleration /= 2
	else if(speed < 75 && gear == "harm")
		acceleration /= 2

	switch(direction)
		if(NORTH)
			vector["y"] += acceleration
		if(NORTHEAST)
			vector["x"] += acceleration/2
			vector["y"] += acceleration/2
		if(EAST)
			vector["x"] += acceleration
		if(SOUTHEAST)
			vector["x"] += acceleration/2
			vector["y"] -= acceleration/2
		if(SOUTH)
			vector["y"] -= acceleration
		if(SOUTHWEST)
			vector["x"] -= acceleration/2
			vector["y"] -= acceleration/2
		if(WEST)
			vector["x"] -= acceleration
		if(NORTHWEST)
			vector["y"] += acceleration/2
			vector["x"] -= acceleration/2

	vector["x"] = CLAMP(vector["x"], -100, 100)
	vector["y"] = CLAMP(vector["y"], -100, 100)
	calc_speed()
	return


/obj/vehicle/ridden/vectorcraft/proc/friction(acceleration)
	//decell X
	if(vector["x"] <= -acceleration)
		vector["x"] += acceleration
	else if(vector["x"] >= acceleration)
		vector["x"] -= acceleration
	else
		vector["x"] = 0
	//decell Y
	if(vector["y"] <= -acceleration)
		vector["y"] += acceleration
	else if(vector["y"] >= acceleration)
		vector["y"] -= acceleration
	else
		vector["y"] = 0
