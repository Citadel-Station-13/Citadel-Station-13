/obj/vehicle/sealed/vectorcraft/rideable/Initialize()
	. = ..()
	LoadComponent(/datum/component/riding)

/obj/vehicle/sealed/vectorcraft/rideable/post_unbuckle_mob(mob/living/M)
	remove_occupant(M)
	M.pixel_x = 0
	M.pixel_y = 0
	return ..()

/obj/vehicle/sealed/vectorcraft/rideable/post_buckle_mob(mob/living/M)
	add_occupant(M)
	return ..()

/obj/vehicle/sealed/vectorcraft/rideable/move_car()
	.=..()
	driver.pixel_x = pixel_x
	driver.pixel_y = pixel_y
	var/datum/component/riding/R = GetComponent(/datum/component/riding)
	R.handle_ride(driver, calc_angle())


/obj/vehicle/sealed/vectorcraft/rideable/mob_enter(mob/living/M)
	.=..()
	driver.pixel_x = pixel_x
	driver.pixel_y = pixel_y

/obj/vehicle/sealed/vectorcraft/rideable/mob_exit(mob/living/M)
	.=..()
	driver.pixel_x = 0
	driver.pixel_y = 0

/obj/vehicle/sealed/vectorcraft/rideable/wheelchair
	name = "Hoverchair"
	desc = "A chair with big hoverpads. It looks like you can move in this on your own."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "wheelchair"
	layer = OBJ_LAYER
	max_integrity = 100
	armor = list("melee" = 10, "bullet" = 10, "laser" = 10, "energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 30)	//Wheelchairs aren't super tough yo
	canmove = TRUE
	density = FALSE		//Thought I couldn't fix this one easily, phew


	max_acceleration = 1.5
	accel_step = 0.5
	acceleration = 0.35
	max_deceleration = 1
	max_velocity = 20
	boost_power = 15
	gear = "auto"

/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/Initialize()
	. = ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.vehicle_move_delay = 0
	D.set_vehicle_dir_layer(SOUTH, OBJ_LAYER)
	D.set_vehicle_dir_layer(NORTH, ABOVE_MOB_LAYER)
	D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
	D.set_vehicle_dir_layer(WEST, OBJ_LAYER)

/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/ComponentInitialize()	//Since it's technically a chair I want it to have chair properties
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE, CALLBACK(src, .proc/can_user_rotate),CALLBACK(src, .proc/can_be_rotated),null)


/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/Destroy()
	if(has_buckled_mobs())
		var/mob/living/carbon/H = buckled_mobs[1]
		unbuckle_mob(H)
	return ..()

/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/move_car()
	. = ..()
	cut_overlays()
	playsound(src, 'sound/effects/roll.ogg', 75, 1)
	if(has_buckled_mobs())
		handle_rotation_overlayed()

/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/post_buckle_mob(mob/living/user)
	. = ..()
	handle_rotation_overlayed()

/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/post_unbuckle_mob()
	. = ..()
	cut_overlays()

/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/setDir(newdir)
	..()
	handle_rotation(newdir)

/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/proc/handle_rotation(direction)
	if(has_buckled_mobs())
		handle_rotation_overlayed()
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.setDir(direction)

/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/proc/handle_rotation_overlayed()
	cut_overlays()
	var/image/V = image(icon = icon, icon_state = "wheelchair_overlay", layer = FLY_LAYER, dir = src.dir)
	add_overlay(V)


/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/proc/can_be_rotated(mob/living/user)
	return TRUE

/obj/vehicle/sealed/vectorcraft/rideable/wheelchair/proc/can_user_rotate(mob/living/user)
	var/mob/living/L = driver
	if(istype(L))
		if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
			return FALSE
	if(isobserver(user) && CONFIG_GET(flag/ghost_interaction))
		return TRUE
	return FALSE
