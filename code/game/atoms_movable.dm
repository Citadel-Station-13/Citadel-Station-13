/atom/movable
	layer = OBJ_LAYER
	var/last_move = null
	var/anchored = 0
	var/throwing = 0
	var/throw_speed = 2
	var/throw_range = 7
	var/mob/pulledby = null
	var/languages_spoken = 0 //For say() and Hear()
	var/languages_understood = 0
	var/verb_say = "says"
	var/verb_ask = "asks"
	var/verb_exclaim = "exclaims"
	var/verb_yell = "yells"
	var/inertia_dir = 0
	var/pass_flags = 0
	var/moving_diagonally = 0 //0: not doing a diagonal move. 1 and 2: doing the first/second step of the diagonal move
	glide_size = 8
	appearance_flags = TILE_BOUND



/atom/movable/Move(atom/newloc, direct = 0)
	if(!loc || !newloc) return 0
	var/atom/oldloc = loc

	if(loc != newloc)
		if (!(direct & (direct - 1))) //Cardinal move
			. = ..()
		else //Diagonal move, split it into cardinal moves
			moving_diagonally = FIRST_DIAG_STEP
			if (direct & 1)
				if (direct & 4)
					if (step(src, NORTH))
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, EAST)
					else if (step(src, EAST))
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, NORTH)
				else if (direct & 8)
					if (step(src, NORTH))
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, WEST)
					else if (step(src, WEST))
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, NORTH)
			else if (direct & 2)
				if (direct & 4)
					if (step(src, SOUTH))
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, EAST)
					else if (step(src, EAST))
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, SOUTH)
				else if (direct & 8)
					if (step(src, SOUTH))
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, WEST)
					else if (step(src, WEST))
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, SOUTH)
			moving_diagonally = 0

	if(!loc || (loc == oldloc && oldloc != newloc))
		last_move = 0
		return

	if(.)
		Moved(oldloc, direct)

	last_move = direct
	setDir(direct)

	spawn(5)	// Causes space drifting. /tg/station has no concept of speed, we just use 5
		if(loc && direct && last_move == direct)
			if(loc == newloc) //Remove this check and people can accelerate. Not opening that can of worms just yet.
				newtonian_move(last_move)

	if(. && has_buckled_mobs() && !handle_buckled_mob_movement(loc,direct)) //movement failed due to buckled mob(s)
		. = 0

//Called after a successful Move(). By this point, we've already moved
/atom/movable/proc/Moved(atom/OldLoc, Dir)
	return 1


/atom/movable/Destroy()
	. = ..()
	if(loc)
		loc.handle_atom_del(src)
	if(reagents)
		qdel(reagents)
	for(var/atom/movable/AM in contents)
		qdel(AM)
	loc = null
	invisibility = INVISIBILITY_ABSTRACT
	if(pulledby)
		pulledby.stop_pulling()


// Previously known as HasEntered()
// This is automatically called when something enters your square
/atom/movable/Crossed(atom/movable/AM)
	return

/atom/movable/Bump(atom/A, yes) //the "yes" arg is to differentiate our Bump proc from byond's, without it every Bump() call would become a double Bump().
	if((A && yes))
		if(throwing)
			throwing = 0
			throw_impact(A)
			. = 1
			if(!A || qdeleted(A))
				return
		A.Bumped(src)


/atom/movable/proc/forceMove(atom/destination)
	if(destination)
		if(pulledby)
			pulledby.stop_pulling()
		var/atom/oldloc = loc
		if(oldloc)
			oldloc.Exited(src, destination)
		loc = destination
		destination.Entered(src, oldloc)
		var/area/old_area = get_area(oldloc)
		var/area/destarea = get_area(destination)
		if(old_area != destarea)
			destarea.Entered(src)
		for(var/atom/movable/AM in destination)
			if(AM == src)
				continue
			AM.Crossed(src)
		Moved(oldloc, 0)
		return 1
	return 0

/mob/living/forceMove(atom/destination)
	stop_pulling()
	if(buckled)
		buckled.unbuckle_mob(src,force=1)
	if(has_buckled_mobs())
		unbuckle_all_mobs(force=1)
	. = ..()
	if(client)
		reset_perspective(destination)
	update_canmove() //if the mob was asleep inside a container and then got forceMoved out we need to make them fall.

/mob/living/carbon/brain/forceMove(atom/destination)
	if(container)
		container.forceMove(destination)
	else //something went very wrong.
		CRASH("Brainmob without container.")


/mob/living/silicon/pai/forceMove(atom/destination)
	if(card)
		card.forceMove(destination)
	else //something went very wrong.
		CRASH("pAI without card")


//Called whenever an object moves and by mobs when they attempt to move themselves through space
//And when an object or action applies a force on src, see newtonian_move() below
//Return 0 to have src start/keep drifting in a no-grav area and 1 to stop/not start drifting
//Mobs should return 1 if they should be able to move of their own volition, see client/Move() in mob_movement.dm
//movement_dir == 0 when stopping or any dir when trying to move
/atom/movable/proc/Process_Spacemove(movement_dir = 0)
	if(has_gravity(src))
		return 1

	if(pulledby)
		return 1

	if(locate(/obj/structure/lattice) in range(1, get_turf(src))) //Not realistic but makes pushing things in space easier
		return 1

	return 0

/atom/movable/proc/newtonian_move(direction) //Only moves the object if it's under no gravity

	if(!loc || Process_Spacemove(0))
		inertia_dir = 0
		return 0

	inertia_dir = direction
	if(!direction)
		return 1

	var/old_dir = dir
	. = step(src, direction)
	setDir(old_dir)

/atom/movable/proc/checkpass(passflag)
	return pass_flags&passflag

/atom/movable/proc/throw_impact(atom/hit_atom)
	return hit_atom.hitby(src)

/atom/movable/hitby(atom/movable/AM, skipcatch, hitpush = 1, blocked)
	if(!anchored && hitpush)
		step(src, AM.dir)
	..()

/atom/movable/proc/throw_at_fast(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0)
	set waitfor = 0
	throw_at(target, range, speed, thrower, spin, diagonals_first)

/atom/movable/proc/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0)
	if(!target || !src || (flags & NODROP))
		return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target

	if(pulledby)
		pulledby.stop_pulling()

	throwing = 1
	if(spin) //if we don't want the /atom/movable to spin.
		SpinAnimation(5, 1)

	var/dist_travelled = 0
	var/next_sleep = 0

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)
	var/dx = (target.x > src.x) ? EAST : WEST
	var/dy = (target.y > src.y) ? NORTH : SOUTH

	var/pure_diagonal = 0
	if(dist_x == dist_y)
		pure_diagonal = 1

	if(dist_x <= dist_y)
		var/olddist_x = dist_x
		var/olddx = dx
		dist_x = dist_y
		dist_y = olddist_x
		dx = dy
		dy = olddx

	var/error = dist_x/2 - dist_y //used to decide whether our next move should be forward or diagonal.
	var/atom/finalturf = get_turf(target)
	var/hit = 0
	var/init_dir = get_dir(src, target)

	while(target && ((dist_travelled < range && loc != finalturf)  || !has_gravity(src))) //stop if we reached our destination (or max range) and aren't floating
		var/slept = 0
		if(!istype(loc, /turf))
			hit = 1
			break

		var/atom/step
		if(dist_travelled < max(dist_x, dist_y)) //if we haven't reached the target yet we home in on it, otherwise we use the initial direction
			step = get_step(src, get_dir(src, finalturf))
		else
			step = get_step(src, init_dir)

		if(!pure_diagonal && !diagonals_first) // not a purely diagonal trajectory and we don't want all diagonal moves to be done first
			if(error >= 0 && max(dist_x,dist_y) - dist_travelled != 1) //we do a step forward unless we're right before the target
				step = get_step(src, dx)
			error += (error < 0) ? dist_x/2 : -dist_y
		if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			break
		Move(step, get_dir(loc, step))
		if(!throwing) // we hit something during our move
			hit = 1
			break
		dist_travelled++

		if(dist_travelled > 600) //safety to prevent infinite while loop.
			break
		if(dist_travelled >= next_sleep)
			slept = 1
			next_sleep += speed
			sleep(1)
		if(!slept)
			var/ticks_slept = TICK_CHECK
			if(ticks_slept)
				slept = 1
				next_sleep += speed*(ticks_slept*world.tick_lag) //delay the next normal sleep

		if(slept && hitcheck()) //to catch sneaky things moving on our tile while we slept
			hit = 1
			break


	//done throwing, either because it hit something or it finished moving
	throwing = 0
	if(!hit)
		for(var/atom/A in get_turf(src)) //looking for our target on the turf we land on.
			if(A == target)
				hit = 1
				throw_impact(A)
				return 1

		throw_impact(get_turf(src))  // we haven't hit something yet and we still must, let's hit the ground.
	return 1

/atom/movable/proc/hitcheck()
	for(var/atom/movable/AM in get_turf(src))
		if(AM == src)
			continue
		if(AM.density && !(AM.pass_flags & LETPASSTHROW) && !(AM.flags & ON_BORDER))
			throwing = 0
			throw_impact(AM)
			return 1

//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/movable/overlay/New()
	verbs.Cut()

/atom/movable/overlay/attackby(a, b, c)
	if (src.master)
		return src.master.attackby(a, b, c)

/atom/movable/overlay/attack_paw(a, b, c)
	if (src.master)
		return src.master.attack_paw(a, b, c)

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)

/atom/movable/proc/handle_buckled_mob_movement(newloc,direct)
	for(var/m in buckled_mobs)
		var/mob/living/buckled_mob = m
		if(!buckled_mob.Move(newloc, direct))
			loc = buckled_mob.loc
			last_move = buckled_mob.last_move
			inertia_dir = last_move
			buckled_mob.inertia_dir = last_move
			return 0
	return 1

/atom/movable/CanPass(atom/movable/mover, turf/target, height=1.5)
	if(mover in buckled_mobs)
		return 1
	return ..()


/atom/movable/proc/get_spacemove_backup()
	var/atom/movable/dense_object_backup
	for(var/A in orange(1, get_turf(src)))
		if(isarea(A))
			continue
		else if(isturf(A))
			var/turf/turf = A
			if(!turf.density)
				continue
			return turf
		else
			var/atom/movable/AM = A
			if(!AM.CanPass(src) || AM.density)
				if(AM.anchored)
					return AM
				dense_object_backup = AM
				break
	. = dense_object_backup

//called when a mob resists while inside a container that is itself inside something.
/atom/movable/proc/relay_container_resist(mob/living/user, obj/O)
	return
