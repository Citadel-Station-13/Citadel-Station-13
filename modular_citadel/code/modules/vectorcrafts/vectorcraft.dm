#define SPEED_MOD 5
#define PX_OFFSET 16 //half of total px size of sprite
//Cars that drfit
//By Fermi!


/obj/vehicle/sealed/vectorcraft
	name = "all-terrain hovercraft"
	desc = "An all-terrain vehicle built for traversing rough terrain with ease. One of the few old-Earth technologies that are still relevant on most planet-bound outposts."
	icon_state = "zoomscoot"
	movedelay = 5
	//allow_diagonal_dir = TRUE - find fix for this later
	inertia_moving = FALSE
	animate_movement = 0
	max_integrity = 100
	//key_type = /obj/item/key
	var/obj/structure/trunk //Trunkspace of craft
	var/vector = list("x" = 0, "y" = 0) //vector math
	var/tile_loc = list("x" = 0, "y" = 0) //x y offset of tile
	var/max_acceleration = 5.25
	var/accel_step = 0.3
	var/acceleration = 0.4
	var/max_deceleration = 2
	var/max_velocity = 110
	var/boost_power = 15
	var/enginesound_delay = 0
	var/gear
	var/boost_cooldown

	//Changes for custom
	var/i_m_acell
	var/i_m_decell
	var/i_boost
	var/i_acell

	var/mob/living/carbon/human/driver

/obj/vehicle/sealed/vectorcraft/Initialize(mapload)
	. = ..()
	i_m_acell = max_acceleration
	i_m_decell = max_deceleration
	i_boost = boost_power
	i_acell = acceleration

/obj/vehicle/sealed/vectorcraft/mob_enter(mob/living/M)
	if(!driver)
		driver = M
		if(gear != "auto")
			gear = driver.a_intent
	start_engine()
	to_chat(M, "<span class='big notice'>How to drive:</span> \n<span class='notice'><i>Hold wasd to gain speed in a direction, c to enable/disable the clutch, 1 2 3 4 to change gears while holding a direction (make sure the clutch is enabled when you change gears, you should hear a sound when you've successfully changed gears), r to toggle handbrake, hold alt for brake and press shift for boost (the machine will beep when the boost is recharged)! If you hear an ebbing sound like \"brbrbrbrbr\" you need to gear down, the whining sound means you need to gear up. Hearing a pleasant \"whumwhumwhum\" is optimal gearage! It can be a lil slow to start, so make sure you're in the 1st gear.\n</i></span>")
	return ..()

/obj/vehicle/sealed/vectorcraft/mob_exit(mob/living/M)
	.=..()
	if(!driver)
		stop_engine()
		return
	if(driver.client)
		driver.client.pixel_x = 0
		driver.client.pixel_y = 0
	driver.pixel_x = 0
	driver.pixel_y = 0
	if(M == driver)
		driver = null
		gear = initial(gear)
	stop_engine()


//////////////////////////////////////////////////////////////
//					Main driving checks				    	//
//////////////////////////////////////////////////////////////

/obj/vehicle/sealed/vectorcraft/proc/start_engine()
	if(dead_check())
		return
	START_PROCESSING(SSvectorcraft, src)
	check_gears()
	if(!driver)
		stop_engine()


/obj/vehicle/sealed/vectorcraft/proc/stop_engine()
	STOP_PROCESSING(SSvectorcraft, src)
	vector = list("x" = 0, "y" = 0)
	acceleration = initial(acceleration)

/obj/vehicle/sealed/vectorcraft/proc/dead_check()
	if(driver.stat > 0)
		mob_exit(driver)
		stop_engine()
		return TRUE
	return FALSE



//Move the damn car
/obj/vehicle/sealed/vectorcraft/vehicle_move(cached_direction)
	if(!driver)
		stop_engine()
	if(driver.stat == DEAD)
		mob_exit(driver)
	dir = cached_direction
	check_gears()
	check_boost()
	calc_acceleration()
	calc_vector(cached_direction)
	/*
	var/direction = calc_angle()
	if(!direction)
		direction = cached_direction
	return
	*/

	/* depreciated
	//movespeed
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
	*/

//Passive hover drift
/obj/vehicle/sealed/vectorcraft/proc/hover_loop()
	check_boost()
	if(driver.m_intent == MOVE_INTENT_WALK)
		var/deceleration = max_deceleration
		if(driver.throw_mode)
			deceleration *= 1.5
		friction(deceleration, TRUE)
	else if(driver.throw_mode)
		friction(max_deceleration*1.2, TRUE)
	friction(max_deceleration/4)

	if(trailer)
		var/dir_to_move = get_dir(trailer.loc, loc)
		var/did_move = move_car()
		if(did_move)
			step(trailer, dir_to_move)
			trailer.pixel_x = tile_loc["x"]
			trailer.pixel_y = tile_loc["y"]
		after_move(did_move)
		return did_move
	else
		var/direction = move_car()
		after_move(direction)
		return direction

//I got over messy process procs
/obj/vehicle/sealed/vectorcraft/process()
	hover_loop()
	dead_check()

//////////////////////////////////////////////////////////////
//					Movement procs						   	//
//////////////////////////////////////////////////////////////

/obj/vehicle/sealed/vectorcraft/proc/move_car()


	if(GLOB.Debug2)
		message_admins("Pre_ Tile_loc: [tile_loc["x"]], [tile_loc["y"]] Vector: [vector["x"]],[vector["y"]]")

	var/cached_tile = tile_loc
	tile_loc["x"] += vector["x"]/SPEED_MOD
	tile_loc["y"] += vector["y"]/SPEED_MOD
	//range = -16 to 16
	var/x_move = 0
	if(tile_loc["x"] > PX_OFFSET)
		x_move = round((tile_loc["x"]+PX_OFFSET) / (PX_OFFSET*2), 1)
		tile_loc["x"] = ((tile_loc["x"]+PX_OFFSET) % (PX_OFFSET*2))-PX_OFFSET
	else if(tile_loc["x"] < -PX_OFFSET)
		x_move = round((tile_loc["x"]-PX_OFFSET) / (PX_OFFSET*2), 1)
		tile_loc["x"] = ((tile_loc["x"]-PX_OFFSET) % -(PX_OFFSET*2))+PX_OFFSET



	var/y_move = 0
	if(tile_loc["y"] > PX_OFFSET)
		y_move = round((tile_loc["y"]+PX_OFFSET) / (PX_OFFSET*2), 1)
		tile_loc["y"] = ((tile_loc["y"]+PX_OFFSET) % (PX_OFFSET*2))-PX_OFFSET
	else if(tile_loc["y"] < -PX_OFFSET)
		y_move = round((tile_loc["y"]-PX_OFFSET) / (PX_OFFSET*2), 1)
		tile_loc["y"] = ((tile_loc["y"]-PX_OFFSET) % -(PX_OFFSET*2))+PX_OFFSET

	if(!(x_move == 0 && y_move == 0))
		var/turf/T = get_offset_target_turf(src, x_move, y_move)
		for(var/atom/A in T.contents)
			Bump(A)
			if(A.density)
				ricochet()
				tile_loc = cached_tile
				return FALSE
		if(T.density)
			ricochet()
			tile_loc = cached_tile
			return FALSE

	x += x_move
	y += y_move
	pixel_x = round(tile_loc["x"], 1)
	pixel_y = round(tile_loc["y"], 1)
	if(driver && driver.client)
		driver.client.pixel_x = pixel_x
		driver.client.pixel_y = pixel_y


	if(GLOB.Debug2)
		message_admins("Post TileLoc:[tile_loc["x"]], [tile_loc["y"]] Movement: [x_move],[y_move]")
		message_admins("Pix:[pixel_x],[pixel_y] TileLoc:[tile_loc["x"]], [tile_loc["y"]]. [round(tile_loc["x"])], [round(tile_loc["y"])]")
	//no tile movement

	if(x_move == 0 && y_move == 0)
		return FALSE

	//var/direction = calc_step_angle(x_move, y_move)
	//if(direction) //If the movement is greater than 2
	//	step(src, direction)
	//	after_move(direction)




	return TRUE

//////////////////////////////////////////////////////////////
//					Check procs						    	//
//////////////////////////////////////////////////////////////

//check the cooldown on the boost
/obj/vehicle/sealed/vectorcraft/proc/check_boost()
	if(enginesound_delay < world.time)
		enginesound_delay = 0
	if(!boost_cooldown)
		return
	if(boost_cooldown < world.time)
		boost_cooldown = 0
		playsound(src.loc,'sound/vehicles/boost_ready.ogg', 65, 0)
	return

//Make sure the clutch is on while changing gears!!
/obj/vehicle/sealed/vectorcraft/proc/check_gears()
	if(!driver)
		for(var/i in contents)
			if(iscarbon(i))
				var/mob/living/carbon/C = i
				driver = C
				to_chat(driver, "<span class='notice'><b>You shuffle across to the driver's seat of the [src]</b></span>")
				start_engine()
				break
		if(!driver)
			stop_engine()
			return
	if(!gear)
		gear = driver.a_intent
	if(gear == "auto")
		return
	//USE THE CCLUUUTCHHH
	if(gear != driver.a_intent && SEND_SIGNAL(driver, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_INACTIVE))
		//playsound
		to_chat(driver, "<span class='warning'><b>The gearbox gives out a horrific sound!</b></span>")
		playsound(src.loc,'sound/vehicles/clutch_fail.ogg', 70, 0)
		apply_damage(5)
		acceleration = acceleration/2
	else if(gear != driver.a_intent && SEND_SIGNAL(driver, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_ACTIVE))
		playsound(src.loc,'sound/vehicles/clutch_win.ogg', 100, 0)
	gear = driver.a_intent

//Bounce the car off a wall
/obj/vehicle/sealed/vectorcraft/proc/bounce()
	vector["x"] = -vector["x"]/2
	vector["y"] = -vector["y"]/2
	acceleration /= 2

/obj/vehicle/sealed/vectorcraft/proc/ricochet(x_move, y_move)
	var/speed = calc_speed()
	apply_damage(speed/10)
	bounce()

//////////////////////////////////////////////////////////////
//					Damage procs							//
//////////////////////////////////////////////////////////////
//Repairing
/obj/vehicle/sealed/vectorcraft/attackby(obj/item/O, mob/user, params)
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


/obj/vehicle/sealed/vectorcraft/attack_hand(mob/user)
	remove_key(driver)
	..()

//Heals/damages the car
/obj/vehicle/sealed/vectorcraft/proc/apply_damage(damage)
	obj_integrity -= damage
	var/healthratio = ((obj_integrity/max_integrity)/4) + 0.75
	max_acceleration = initial(max_acceleration) * healthratio
	max_deceleration = initial(max_deceleration) * healthratio
	boost_power = initial(boost_power) * healthratio

	if(obj_integrity <= 0)
		mob_exit(driver)
		var/datum/effect_system/reagents_explosion/e = new()
		var/turf/T = get_turf(src)
		e.set_up(1, T, 1, 3)
		e.start()
		visible_message("The [src] explodes from taking too much damage!")
		qdel(src)
	if(obj_integrity > max_integrity)
		obj_integrity = max_integrity

//
/obj/vehicle/sealed/vectorcraft/Bump(atom/M)
	var/speed = calc_speed()
	if(isliving(M))
		var/mob/living/C = M
		if(!C.anchored)
			var/atom/throw_target = get_edge_target_turf(C, calc_angle())
			C.throw_at(throw_target, 10, 14)
		to_chat(C, "<span class='warning'><b>You are hit by the [src]!</b></span>")
		to_chat(driver, "<span class='warning'><b>You just ran into [C] you crazy lunatic!</b></span>")
		C.adjustBruteLoss(speed/10)
		return ..()
	//playsound
	if(istype(M, /obj/vehicle/sealed/vectorcraft))
		var/obj/vehicle/sealed/vectorcraft/Vc = M
		Vc.apply_damage(speed/5)
		Vc.vector["x"] += vector["x"]/2
		Vc.vector["y"] += vector["y"]/2
		apply_damage(speed/10)
		bounce()
		return ..()
	if(istype(M, /obj/))
		var/obj/O = M
		if(O.density)
			O.take_damage(speed*2.5)
	return ..()

//////////////////////////////////////////////////////////////
//					Calc procs						    	//
//////////////////////////////////////////////////////////////
/*Calc_step_angle calculates angle based off pixel x,y movement (x,y in)
Calc angle calcus angle based off vectors
calc_speed() returns the highest var of x or y relative
calc accel calculates the acceleration to be added to vector
calc vector updates the internal vector
friction reduces the vector by an ammount to both axis*/

//How fast the car is going atm
/obj/vehicle/sealed/vectorcraft/proc/calc_velocity() //Depreciated.
	var/speed = calc_speed()
	switch(speed)
		if(-INFINITY to 10)
			movedelay = 5
			inertia_move_delay = 5
		if(10 to 20)
			movedelay = 4
			inertia_move_delay = 4
		if(20 to 35)
			movedelay = 3
			inertia_move_delay = 3
		if(35 to 60)
			movedelay = 2
			inertia_move_delay = 2
		if(60 to 90)
			movedelay = 1
			inertia_move_delay = 1
		if(90 to INFINITY)
			movedelay = 0
			inertia_move_delay = 0
	return

/*
if(driver.sprinting && !(boost_cooldown))
	acceleration += boost_power //You got boost power!
	boost_cooldown = world.time + 150
	playsound(src.loc,'sound/vehicles/boost.ogg', 50, 0)
	//playsound
*/

/obj/vehicle/sealed/vectorcraft/proc/calc_step_angle(x, y)
	if((sqrt(x**2))>1 || (sqrt(y**2))>1) //Too large a movement for a step
		return FALSE
	if(x == 1)
		if (y == 1)
			return NORTHEAST
		else if (y == -1)
			return SOUTHEAST
		else if (y == 0)
			return EAST
		else
			message_admins("something went wrong; y = [y]")
	else if (x == -1)
		if (y == 1)
			return NORTHWEST
		else if (y == -1)
			return SOUTHWEST
		else if (y == 0)
			return WEST
		else
			message_admins("something went wrong; y = [y]")
	else if (x != 0)
		message_admins("something went wrong; x = [x]")

	if (y == 1)
		return NORTH
	else if (y == -1)
		return SOUTH
	else if (x != 0)
		message_admins("something went wrong; y = [y]")
	return FALSE

//Returns the angle to move towards
/obj/vehicle/sealed/vectorcraft/proc/calc_angle()
	var/x = round(vector["x"], 1)
	var/y = round(vector["y"], 1)
	if(y == 0)
		if(x > 0)
			return EAST
		else if(x < 0)
			return WEST
	if(x == 0)
		if(y > 0)
			return NORTH
		else if(y < 0)
			return SOUTH
	if(x == 0 || y == 0)
		return FALSE
	var/angle = (ATAN2(x,y))
	//if(angle < 0)
	//	angle += 360
	//message_admins("x:[x], y: [y], angle:[angle]")

	//I WISH I HAD RADIANSSSSSSSSSS
	if(angle > 0)
		switch(angle)
			if(0 to 22)
				return EAST
			if(22 to 67)
				return NORTHEAST
			if(67 to 112)
				return NORTH
			if(112 to 157)
				return NORTHWEST
			if(157 to 180)
				return WEST
	else
		switch(angle)
			if(-22 to 0)
				return EAST
			if(-67 to -22)
				return SOUTHEAST
			if(-112 to -67)
				return SOUTH
			if(-157 to -112)
				return SOUTHWEST
			if(-180 to -157)
				return WEST


//updates the internal speed of the car (used for crashing)
/obj/vehicle/sealed/vectorcraft/proc/calc_speed()
	var/speed = max(sqrt((vector["x"]**2)), sqrt((vector["y"]**2)))
	return speed

//Converts "gear" from intent to numerics
/obj/vehicle/sealed/vectorcraft/proc/convert_gear()
	switch(gear)
		if("help")
			return 1
		if("disarm")
			return 2
		if("grab")
			return 3
		if("harm")
			return 4

//Calculates the acceleration
/obj/vehicle/sealed/vectorcraft/proc/calc_acceleration() //Make speed 0 - 100 regardless of gear here
	if(SEND_SIGNAL(driver, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_ACTIVE))//clutch is on
		return FALSE
	if(gear == "auto")
		acceleration += accel_step
		acceleration = clamp(acceleration, initial(acceleration), max_acceleration)
		if(!enginesound_delay)
			playsound(src.loc,'sound/vehicles/norm_eng.ogg', 25, 0)
			enginesound_delay = world.time + 16
		return

	var/gear_val = convert_gear()
	var/min_accel = max_acceleration*( (((gear_val-1) * 20) + ((gear_val-1)*5)) /100)
	var/max_accel = max_acceleration*((gear_val * 25)/100) //1.25 - 5

	if(acceleration < min_accel)
		acceleration += accel_step/10
		if(!enginesound_delay)
			playsound(src.loc,'sound/vehicles/low_eng.ogg', 25, 0)
			enginesound_delay = world.time + 16
	else if (acceleration > max_accel)
		acceleration -= accel_step
		if(!enginesound_delay)
			playsound(src.loc,'sound/vehicles/high_eng.ogg', 25, 0)
			enginesound_delay = world.time + 16
	else
		if(gear_val == 1)
			acceleration += accel_step*3.5
		else
			acceleration += accel_step
		if(!enginesound_delay)
			playsound(src.loc,'sound/vehicles/norm_eng.ogg', 25, 0)
			enginesound_delay = world.time + 16

	if(acceleration > ((max_acceleration*calc_speed())/90) && acceleration > max_acceleration/5)
		acceleration -= accel_step*2
		if(!enginesound_delay)
			playsound(src.loc,'sound/vehicles/high_eng.ogg', 25, 0)
			enginesound_delay = world.time + 16
		return

	acceleration = clamp(acceleration, initial(acceleration), max_acceleration)

//calulate the vector change
/obj/vehicle/sealed/vectorcraft/proc/calc_vector(direction)
	if(SEND_SIGNAL(driver, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_ACTIVE))//clutch is on
		return FALSE
	var/cached_acceleration = acceleration
	var/boost_active = FALSE
	if((driver.combat_flags & COMBAT_FLAG_SPRINT_ACTIVE) && !(boost_cooldown))
		cached_acceleration += boost_power //You got boost power!
		boost_cooldown = world.time + 80
		playsound(src.loc,'sound/vehicles/boost.ogg', 100, 0)
		boost_active = TRUE
		//playsound

	var/result_vector = vector
	switch(direction)
		if(NORTH)
			result_vector["y"] += cached_acceleration
		if(NORTHEAST)
			result_vector["x"] += cached_acceleration/1.4
			result_vector["y"] += cached_acceleration/1.4
		if(EAST)
			result_vector["x"] += cached_acceleration
		if(SOUTHEAST)
			result_vector["x"] += cached_acceleration/1.4
			result_vector["y"] -= cached_acceleration/1.4
		if(SOUTH)
			result_vector["y"] -= cached_acceleration
		if(SOUTHWEST)
			result_vector["x"] -= cached_acceleration/1.4
			result_vector["y"] -= cached_acceleration/1.4
		if(WEST)
			result_vector["x"] -= cached_acceleration
		if(NORTHWEST)
			result_vector["y"] += cached_acceleration/1.4
			result_vector["x"] -= cached_acceleration/1.4

	if(boost_active)
		vector["x"] = result_vector["x"]
		vector["y"] = result_vector["y"]
	else
		vector["x"] = clamp(result_vector["x"], -max_velocity, max_velocity)
		vector["y"] = clamp(result_vector["y"], -max_velocity, max_velocity)

	if(vector["x"] > max_velocity || vector["x"] < -max_velocity)
		vector["x"] = vector["x"] - (vector["x"]/10)
		vector["x"] = clamp(vector["x"], -250, 250)
	if(vector["y"] > max_velocity || vector["y"] < -max_velocity)
		vector["y"] = vector["y"] - (vector["y"]/10)
		vector["y"] = clamp(vector["y"], -250, 250)

	return

//Reduces speed
/obj/vehicle/sealed/vectorcraft/proc/friction(change, sfx = FALSE)
	//decell X
	if(vector["x"] == 0 && vector["y"] == 0)
		return
	if(vector["x"] <= -change)
		vector["x"] += change
	else if(vector["x"] >= change)
		vector["x"] -= change
	else
		vector["x"] = 0
	//decell Y
	if(vector["y"] <= -change)
		vector["y"] += change
	else if(vector["y"] >= change)
		vector["y"] -= change
	else
		vector["y"] = 0

	if(sfx)
		playsound(src.loc,'sound/vehicles/skid.ogg', 50, 0)
