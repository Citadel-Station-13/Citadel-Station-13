
// A place where tube pods stop, and people can get in or out.
// Mappers: use "Generate Instances from Directions" for this
//  one.
/obj/structure/transit_tube/station
	name = "station tube station"
	icon = 'icons/obj/atmospherics/pipes/transit_tube_station.dmi'
	icon_state = "closed"
	exit_delay = 1
	enter_delay = 2
	tube_construction = /obj/structure/c_transit_tube/station
	var/pod_moving = 0
	var/cooldown_delay = 50
	var/launch_cooldown = 0
	var/reverse_launch = 0

	var/const/OPEN_DURATION = 6
	var/const/CLOSE_DURATION = 6

/obj/structure/transit_tube/station/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/structure/transit_tube/station/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

// Stations which will send the tube in the opposite direction after their stop.
/obj/structure/transit_tube/station/reverse
	tube_construction = /obj/structure/c_transit_tube/station/reverse
	reverse_launch = 1

/obj/structure/transit_tube/station/should_stop_pod(pod, from_dir)
	return 1

/obj/structure/transit_tube/station/Bumped(mob/AM as mob|obj)
	if(!pod_moving && icon_state == "open" && istype(AM, /mob))
		for(var/obj/structure/transit_tube_pod/pod in loc)
			if(!pod.moving && pod.dir in directions())
				AM.loc = pod
				return


//pod insertion
/obj/structure/transit_tube/station/MouseDrop_T(obj/structure/c_transit_tube_pod/R, mob/user)
	if(!user.canmove || user.stat || user.restrained())
		return
	if (!istype(R) || get_dist(user, src) > 1 || get_dist(src,R) > 1)
		return
	for(var/obj/structure/transit_tube_pod/pod in loc)
		return //no fun allowed
	var/obj/structure/transit_tube_pod/T = new/obj/structure/transit_tube_pod(src)
	R.transfer_fingerprints_to(T)
	T.add_fingerprint(user)
	T.loc = src.loc
	T.setDir(turn(src.dir, -90))
	user.visible_message("[user] inserts the [R].", "<span class='notice'>You insert the [R].</span>")
	qdel(R)


/obj/structure/transit_tube/station/attack_hand(mob/user)
	if(!pod_moving)
		if(user.pulling && user.a_intent == "grab" && isliving(user.pulling))
			if(icon_state == "open")
				var/mob/living/GM = user.pulling
				if(user.grab_state >= GRAB_AGGRESSIVE)
					if(GM.buckled || GM.has_buckled_mobs())
						user << "<span class='warning'>[GM] is attached to something!</span>"
						return
					for(var/obj/structure/transit_tube_pod/pod in loc)
						pod.visible_message("<span class='warning'>[user] starts putting [GM] into the [pod]!</span>")
						if(do_after(user, 15, target = src))
							if(GM && user.grab_state >= GRAB_AGGRESSIVE && user.pulling == GM && !GM.buckled && !GM.has_buckled_mobs())
								GM.Weaken(5)
								src.Bumped(GM)
						break
		else
			for(var/obj/structure/transit_tube_pod/pod in loc)
				if(!pod.moving && pod.dir in directions())
					if(icon_state == "closed")
						open_animation()

					else if(icon_state == "open")
						if(pod.contents.len && user.loc != pod)
							user.visible_message("[user] starts emptying [pod]'s contents onto the floor.", "<span class='notice'>You start emptying [pod]'s contents onto the floor...</span>")
							if(do_after(user, 10, target = src)) //So it doesn't default to close_animation() on fail
								if(pod.loc == loc)
									for(var/atom/movable/AM in pod)
										AM.loc = get_turf(user)
										if(ismob(AM))
											var/mob/M = AM
											M.Weaken(5)

						else
							close_animation()
				break


/obj/structure/transit_tube/station/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/crowbar))
		for(var/obj/structure/transit_tube_pod/pod in loc)
			if(pod.contents)
				user << "<span class='warning'>Empty the pod first!</span>"
				return
			user.visible_message("[user] removes the [pod].", "<span class='notice'>You remove the [pod].</span>")
			var/obj/structure/c_transit_tube_pod/R = new/obj/structure/c_transit_tube_pod(src.loc)
			pod.transfer_fingerprints_to(R)
			R.add_fingerprint(user)
			qdel(pod)
	else
		return ..()

/obj/structure/transit_tube/station/proc/open_animation()
	if(icon_state == "closed")
		icon_state = "opening"
		spawn(OPEN_DURATION)
			if(icon_state == "opening")
				icon_state = "open"



/obj/structure/transit_tube/station/proc/close_animation()
	if(icon_state == "open")
		icon_state = "closing"
		spawn(CLOSE_DURATION)
			if(icon_state == "closing")
				icon_state = "closed"



/obj/structure/transit_tube/station/proc/launch_pod()
	if(launch_cooldown >= world.time)
		return
	for(var/obj/structure/transit_tube_pod/pod in loc)
		if(!pod.moving && turn(pod.dir, (reverse_launch ? 180 : 0)) in directions())
			pod_moving = 1
			close_animation()
			sleep(CLOSE_DURATION + 2)
			if(icon_state == "closed" && pod)
				pod.follow_tube(reverse_launch)
			pod_moving = 0
			return 1
	return 0

/obj/structure/transit_tube/station/process()
	if(!pod_moving)
		launch_pod()

/obj/structure/transit_tube/station/pod_stopped(obj/structure/transit_tube_pod/pod, from_dir)
	pod_moving = 1
	spawn(5)
		launch_cooldown = world.time + cooldown_delay
		open_animation()
		sleep(OPEN_DURATION + 2)
		pod_moving = 0
		pod.mix_air()

// Tube station directions are simply 90 to either side of
//  the exit.
/obj/structure/transit_tube/station/init_dirs()
	tube_dirs = list(turn(dir, 90), turn(dir, -90))