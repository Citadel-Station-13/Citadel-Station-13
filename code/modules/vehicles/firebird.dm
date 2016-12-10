/obj/item/key/firebird
    name = "\improper Firebird key"
    desc = "A keyring with a small steel key, and a fancy blue and gold fob."
    icon_state = "magic_keys"

/obj/vehicle/firebird
	name = "Firebird"
	desc = "A Pontiac Firebird Trans Am with skulls and crossbones on the hood, dark blue paint, and gold trim. No magic required for this baby."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "wizmobile"
	keytype = /obj/item/key/firebird
	vehicle_move_delay = 0
	layer = LYING_MOB_LAYER
	spacemove = TRUE
	var/playingrunningsound = FALSE //for engine loop

/obj/effect/overlay/temp/firebird_trail
	name = "exhaust fumes"
	icon_state = "smoke"
	layer = BELOW_MOB_LAYER
	duration = 10
	randomdir = 0

/obj/effect/overlay/temp/firebird_trail/New(loc,move_dir)
	..()
	setDir(move_dir)

/obj/vehicle/firebird/Move(newloc,move_dir)
	if(has_buckled_mobs())
		PoolOrNew(/obj/effect/overlay/temp/firebird_trail,list(loc,move_dir))
	. = ..()

/obj/vehicle/firebird/handle_vehicle_offsets()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.setDir(dir)
			switch(dir)
				if(NORTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 6
				if(SOUTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 2
				if(EAST)
					buckled_mob.pixel_x = -2
					buckled_mob.pixel_y = 3
				if(WEST)
					buckled_mob.pixel_x = 2
					buckled_mob.pixel_y = 3


/obj/vehicle/firebird/proc/start_engine_sound() //starts the loop
    if(vehiclerunning == TRUE && !playingrunningsound) //playingrunningsound is so we don't get more than one loop going
        playingrunningsound = TRUE
        playsound(src, 'sound/machines/enginestart.ogg', 50, 0)
        addtimer(src, "play_engine_sound", 27.6, FALSE)
        return TRUE
    else
        return FALSE

/obj/vehicle/firebird/proc/play_engine_sound() // loop
    if(vehiclerunning == TRUE && playingrunningsound) //will only continue the loop if there's an occupant with the key and the start_engine_sound() was run
        playsound(src, 'sound/machines/engine.ogg', 50, 0)
        addtimer(src, "play_engine_sound", 18.8, FALSE)
        return TRUE
    else
        playingrunningsound = FALSE
        return FALSE

/obj/vehicle/firebird/relaymove(mob/user, direction)
    ..()
    start_engine_sound()

/obj/vehicle/firebird/Bump(atom/movable/M)
	..()
	if(has_buckled_mobs())
		if(istype(M, /obj/structure/table))
			M.Destroy()
		else if(istype(M, /obj/structure/rack))
			M.Destroy()
