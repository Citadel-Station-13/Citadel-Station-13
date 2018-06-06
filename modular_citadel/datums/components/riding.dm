/datum/component/riding
	var/last_vehicle_move = 0

/datum/component/riding/handle_ride(mob/user, direction)
	var/atom/movable/AM = parent
	if(user.incapacitated())
		Unbuckle(user)
		return

	if(world.time < last_vehicle_move + vehicle_move_delay)
		return
	last_vehicle_move = world.time

	if(keycheck(user))
		var/turf/next = get_step(AM, direction)
		var/turf/current = get_turf(AM)
		if(!istype(next) || !istype(current))
			return	//not happening.
		if(!turf_check(next, current))
			to_chat(user, "Your \the [AM] can not go onto [next]!")
			return
		if(!Process_Spacemove(direction) || !isturf(AM.loc))
			return
		step(AM, direction)

		handle_vehicle_layer()
		handle_vehicle_offsets()
	else
		to_chat(user, "<span class='notice'>You'll need the keys in one of your hands to [drive_verb] [AM].</span>")
