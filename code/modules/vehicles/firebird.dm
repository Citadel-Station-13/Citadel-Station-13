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
	var/boostactive = FALSE
	var/datum/action/firebird_boost/F

/datum/action/firebird_boost
	name = "Speed Boost"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_STUNNED
	button_icon_state = "firebird_boost"
	background_icon_state = "bg_spell"
	var/boosting = FALSE //whether boost is active
	var/cooldown = FALSE //whether cooldown is active

/datum/action/firebird_boost/Trigger(mob/living/carbon/human/H)
	if(!H.buckled)
		return
	var/obj/vehicle/firebird/buckled_obj
	buckled_obj = H.buckled
	if(cooldown = FALSE)
		boosting = TRUE
		cooldown = TRUE
		buckled_obj.boostactive = TRUE
		addtimer(src, "deactivate_boost", 20)
		addtimer(src, "reset_cooldown", 100)

/datum/action/firebird_boost/IsAvailable()
	if(cooldown = TRUE)
		return 0
	return ..()

/datum/action/firebird_boost/proc/deactivate_boost(mob/living/carbon/human/H)
	boosting = FALSE
	var/obj/vehicle/firebird/buckled_obj
	buckled_obj = H.buckled
	buckled_obj.boostactive = FALSE

/datum/action/firebird_boost/proc/reset_cooldown()
	cooldown = FALSE

/obj/vehicle/firebird/user_buckle_mob(mob/living/M, mob/user)
	..()
	F = new
	F.Grant(M)

/obj/vehicle/firebird/unbuckle_mob(mob/living/buckled_mob,force = 0)
	..()
	if(F)
		F.Remove(buckled_mob)

/obj/effect/overlay/temp/firebird_trail
	name = "exhaust fumes"
	icon_state = "smoke"
	layer = BELOW_MOB_LAYER
	duration = 10
	randomdir = 0

/obj/effect/overlay/temp/firebird_trail/New(loc,move_dir)
	..()
	setDir(move_dir)

/obj/effect/overlay/temp/firebird_firetrail
	icon_state = "nothing"
	layer = BELOW_MOB_LAYER
	duration = 5
	randomdir = 0

/obj/effect/overlay/temp/firebird_firetrail/proc/IgniteTile()
	new /obj/effect/hotspot(get_turf(src))

/obj/effect/overlay/temp/firebird_firetrail/New(loc,move_dir)
	..()
	setDir(move_dir)
	addtimer(src, "IgniteTile", 3)

/obj/effect/overlay/temp/firebird_firetrail/Destroy()
	..()
	for(var/obj/effect/hotspot/H in loc)
		qdel(H)
	return ..()

/obj/vehicle/firebird/Move(newloc,move_dir)
	var/turf/oldLoc = loc
	. = ..()
	if(has_buckled_mobs() && oldLoc != loc)
		PoolOrNew(/obj/effect/overlay/temp/firebird_trail,list(oldLoc,move_dir))
		if(boostactive)
			PoolOrNew(/obj/effect/overlay/temp/firebird_firetrail,list(oldLoc,move_dir))

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
