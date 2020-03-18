// File for movement procs for atom/movable
#define OPTIMAL_PULL_DISTANCE 16
#define MAX_PULL_SEPARATION_BREAK_MINIMUM world.icon_size * 1.5
#define MAX_PULL_SEPARATION_BREAK_FACTOR 2

/atom/movable/Move(atom/newloc, direct, step_x = 0, step_y = 0)

/*
	var/atom/movable/pullee = pulling
	var/turf/T = loc
	if(pulling)
		if(pullee && get_dist(src, pullee) > 1)
			stop_pulling()

		if(pullee && pullee.loc != loc && !isturf(pullee.loc) ) //to be removed once all code that changes an object's loc uses forceMove().
			log_game("DEBUG:[src]'s pull on [pullee] wasn't broken despite [pullee] being in [pullee.loc]. Pull stopped manually.")
			stop_pulling()
*/

/*
	if(pulling && !handle_pulled_premove(newloc, direct, _step_x, _step_y))
		handle_pulled_movement()
		return FALSE
*/

	if(!loc || !newloc || anchored)
		return FALSE

	var/pullee = pulling
	var/diagonal = (direct & (direct - 1))

/*
	var/atom/oldloc = loc

	if(loc != newloc)
		if (!(direct & (direct - 1))) //Cardinal move
			. = ..()
		else //Diagonal move, split it into cardinal moves
			moving_diagonally = FIRST_DIAG_STEP
			var/first_step_dir
			// The `&& moving_diagonally` checks are so that a forceMove taking
			// place due to a Crossed, Bumped, etc. call will interrupt
			// the second half of the diagonal movement, or the second attempt
			// at a first half if step() fails because we hit something.
			if (direct & NORTH)
				if (direct & EAST)
					if (step(src, NORTH) && moving_diagonally)
						first_step_dir = NORTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, EAST)
					else if (moving_diagonally && step(src, EAST))
						first_step_dir = EAST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, NORTH)
				else if (direct & WEST)
					if (step(src, NORTH) && moving_diagonally)
						first_step_dir = NORTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, WEST)
					else if (moving_diagonally && step(src, WEST))
						first_step_dir = WEST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, NORTH)
			else if (direct & SOUTH)
				if (direct & EAST)
					if (step(src, SOUTH) && moving_diagonally)
						first_step_dir = SOUTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, EAST)
					else if (moving_diagonally && step(src, EAST))
						first_step_dir = EAST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, SOUTH)
				else if (direct & WEST)
					if (step(src, SOUTH) && moving_diagonally)
						first_step_dir = SOUTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, WEST)
					else if (moving_diagonally && step(src, WEST))
						first_step_dir = WEST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, SOUTH)
			if(moving_diagonally == SECOND_DIAG_STEP)
				if(!.)
					setDir(first_step_dir)
				else if (!inertia_moving)
					inertia_next_move = world.time + inertia_move_delay
					newtonian_move(direct)
			moving_diagonally = 0
			return
*/

	var/atom/oldLoc = loc

	. = ..()

/*
	// Diagonal sliding
	#warn This is janky as shit and double bumps, get rid of this ASAP.
	if(!. && diagonal)
		var/first
		var/second
		if(direct & NORTH)
			first = NORTH
			if(direct & EAST)
				second = EAST
			else if(direct & WEST)
				second = WEST
		if(direct & SOUTH)
			first = SOUTH
			if(direct & EAST)
				second = EAST
			else if(direct & WEST)
				second = WEST
		if(first && second)
			if(!(. = step(src, first)))
				. = step(src, second)
				if(.)
					return
*/

		/*
			else
				var/turf/ft = get_step(src, first)
				var/turf/st = get_step(src, second)
				if(ft.Enter(src))
					return step(src, first)
				else if(st.Enter(src))
					return step(src, second)
		*/

	last_move = direct
	setDir(direct)
	Moved(oldLoc, direct)

	if(. && pulling)
		var/distance = get_pixel_dist_euclidean(src, pulling)
		if(distance > max(MAX_PULL_SEPARATION_BREAK_MINIMUM, (MAX_PULL_SEPARATION_BREAK_FACTOR * step_size)))
			stop_pulling()
		else if(distance > OPTIMAL_PULL_DISTANCE)
			var/diff = distance - OPTIMAL_PULL_DISTANCE
			pulling.pixelMoveAngleSeekTowards(src, diff)

/*
	if(!loc || (loc == oldloc && oldloc != newloc))
		last_move = NONE
		return

	if(.)
		last_move = direct
		setDir(direct)

		if(has_buckled_mobs() && !handle_buckled_mob_movement(loc,direct)) //movement failed due to buckled mob(s)
			return FALSE

		if(pulling && pulling == pullee) //we were pulling a thing and didn't lose it during our move.
			if(pulling.anchored)
				stop_pulling()
			else
				var/pull_dir = get_dir(src, pulling)
				//puller and pullee more than one tile away or in diagonal position
				if(get_dist(src, pulling) > 1 || (moving_diagonally != SECOND_DIAG_STEP && ((pull_dir - 1) & pull_dir)))
					pulling.Move(T, get_dir(pulling, T)) //the pullee tries to reach our previous position
					if(pulling && get_dist(src, pulling) > 1) //the pullee couldn't keep up
						stop_pulling()
				if(pulledby && moving_diagonally != FIRST_DIAG_STEP && get_dist(src, pulledby) > 1)//separated from our puller and not in the middle of a diagonal move.
					pulledby.stop_pulling()

		Moved(oldloc, direct)
*/


/*
		var/distance = bounds_dist(src, pulling)
		if(pulling.anchored)
			stop_pulling()
		else if(distance > 16) // If we could move something in an angle this would be so much easier
			step_towards(pulling, src, distance-16)
			var/turf/myT = get_turf(src)
			var/turf/theirT = get_turf(pulling)
			var/x_dist = ((theirT.x - myT.x) * 32) - step_x + pulling.step_x
			var/y_dist = ((theirT.y - myT.y) * 32) - step_y + pulling.step_y

			var/pull_dir = get_dir(src, pulling)
			var/move_dir
			if(!(pull_dir in GLOB.diagonals)) // We want to slowly move it to the same axis of movement as us
				if(pull_dir & (NORTH | SOUTH))
					switch(x_dist)
						if(-INFINITY to -1)
							move_dir = EAST
						if(1 to INFINITY)
							move_dir = WEST
				else if(pull_dir & (EAST | WEST))
					switch(y_dist)
						if(-INFINITY to -1)
							move_dir = NORTH
						if(1 to INFINITY)
							move_dir = SOUTH
			if(move_dir)
				var/old_pulling_dir = pulling.dir
				step(pulling, move_dir, 1)
				pulling.dir = old_pulling_dir
*/

/*
#define ANGLE_ADJUST 10
/atom/movable/proc/handle_pulled_movement()
	if(!pulling)
		return FALSE
	if(pulling.anchored)
		return FALSE
	if(pulling.move_resist > move_force)
		return FALSE
	var/distance = bounds_dist(src, pulling)
	if(distance < 8)
		return FALSE
	var/angle = get_deg(pulling, src)
	if((angle % 45) > 1) // We arent directly on a cardinal from the thing
		var/tempA = WRAP(angle, 0, 45)
		if(tempA >= 22.5)
			angle += min(ANGLE_ADJUST, 45-tempA)
		else
			angle -= min(ANGLE_ADJUST, tempA)
	angle = SIMPLIFY_DEGREES(angle)

	if(!degstep(pulling, angle, distance-8))
		return step_to(pulling, src, 0, step_size)
	return TRUE
#undef ANGLE_ADJUST

/atom/movable/proc/handle_pulled_premove(atom/newloc, direct, _step_x, _step_y)
	if((bounds_dist(src, pulling) > 16 + step_size) && !(direct & get_pixeldir(src, pulling)))
		return FALSE
	return TRUE
*/

/atom/movable/proc/pixelMove(direction, pixels)
	var/old_step_size = step_size
	step_size = pixels
	. = step(src, direction, pixels)
	if(step_size != pixels)
		var/static/list/warned = list()
		if(!warned[type])
			warned[type] = TRUE
			stack_trace("WARNING - step_size was changed during a move in /atom/movable/pixelMove(). This probably means that the laziness behind this system is catching up to it and it's time to standaridze how step_size changes are done.")
	step_size = old_step_size

/atom/movable/proc/pixelMoveAngle(angle, pixels)
	var/sx = step_x + cos(angle) * pixels
	var/sy = step_y + cos(angle) * pixels
	var/old_step_size = step_size
	var/ss = max(sx, sy, 1)
	. = Move(loc, get_dir(loc, loc), sx, sy)
	if(step_size != ss)
		var/static/list/warned = list()
		if(!warned[type])
			warned[type] = TRUE
			stack_trace("WARNING - step_size was changed during a move in /atom/movable/pixelMove(). This probably means that the laziness behind this system is catching up to it and it's time to standaridze how step_size changes are done.")
	step_size = old_step_size

	/*
	var/dx = cos(angle) * pixels + step_x
	var/dy = cos(angle) * pixels + step_y
	var/tx = FLOOR(dx, world.icon_size)
	var/ty = FLOOR(dy, world.icon_size)
	var/turf/destination = locate(x + tx, y + ty, z)
	return Move(destination, get_dir(src, destination), MODULUS(dx, world.icon_size), MODULUS(dy, world.icon_size))
	*/

/atom/movable/proc/pixelMoveAngleSeekTowards(atom/target, pixels)
	return pixelMoveAngle(get_angle(src, target), pixels)

/atom/movable/proc/handle_buckled_mob_movement(newloc,direct)
	for(var/m in buckled_mobs)
		var/mob/living/buckled_mob = m
		if(!buckled_mob.Move(newloc, direct))
			forceMove(buckled_mob.loc)
			last_move = buckled_mob.last_move
			inertia_dir = last_move
			buckled_mob.inertia_dir = last_move
			return FALSE
	return TRUE

//Called after a successful Move(). By this point, we've already moved
/atom/movable/proc/Moved(atom/OldLoc, Dir, Forced = FALSE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, OldLoc, Dir, Forced)
	if (!inertia_moving)
		inertia_next_move = world.time + inertia_move_delay
		newtonian_move(Dir)
	if (length(client_mobs_in_contents))
		update_parallax_contents()
	return TRUE

// Make sure you know what you're doing if you call this, this is intended to only be called by byond directly.
// You probably want CanPass()
/atom/movable/Cross(atom/movable/AM)
	. = TRUE
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSS, AM)
	return CanPass(AM, AM.loc, TRUE)

//oldloc = old location on atom, inserted when forceMove is called and ONLY when forceMove is called!
/atom/movable/Crossed(atom/movable/AM, oldloc)
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSSED, AM, oldloc)

/atom/movable/Uncross(atom/movable/AM, atom/newloc)
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_UNCROSS, AM) & COMPONENT_MOVABLE_BLOCK_UNCROSS)
		return FALSE
	if(isturf(newloc) && !CheckExit(AM, newloc))
		return FALSE

/atom/movable/Uncrossed(atom/movable/AM)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UNCROSSED, AM)

/atom/movable/Bump(atom/A)
	if(!A)
		CRASH("Bump was called with no argument.")
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, A)
	if(!QDELETED(throwing))
		throwing.hit_atom(A)
		. = TRUE
		if(QDELETED(A))
			return
	A.Bumped(src)

/atom/movable/proc/onTransitZ(old_z,new_z)
	SEND_SIGNAL(src, COMSIG_MOVABLE_Z_CHANGED, old_z, new_z)
	for (var/item in src) // Notify contents of Z-transition. This can be overridden IF we know the items contents do not care.
		var/atom/movable/AM = item
		AM.onTransitZ(old_z,new_z)

/atom/movable/proc/setMovetype(newval)
	movement_type = newval

///////////// FORCED MOVEMENT /////////////

/**
  * Moves this to the target destination and step x/y values, no matter what, while invoking the usual crosses/uncrosses.
  *
  * Params
  * * atom/destination - Where to move to
  * * sx - new step_x
  * * sy - new step_y
  */
/atom/movable/proc/forceMove(atom/destination, sx = 0, sy = 0)
	. = FALSE
	if(destination)
		. = doMove(destination, sx, sy)
	else
		CRASH("No valid destination passed into forceMove")

/**
  * Moves this to nullspace, that's about it.
  */
/atom/movable/proc/moveToNullspace()
	return doMove(null, 0, 0)

/atom/movable/proc/doMove(atom/destination, _step_x=0, _step_y=0)
	. = FALSE

	NORMALIZE_STEP(destination, _step_x, _step_y)

	if(destination == loc && _step_x == step_x && _step_y == step_y) // Force move in place?
		Moved(loc, NONE, TRUE)
		return TRUE

	var/atom/oldloc = loc
	var/area/oldarea = get_area(oldloc)
	var/area/destarea = get_area(destination)
	var/list/old_bounds = obounds()

	loc = destination
	step_x = _step_x
	step_y = _step_y

	if(oldloc && oldloc != loc)
		oldloc.Exited(src, destination)
		if(oldarea && oldarea != destarea)
			oldarea.Exited(src, destination)

	var/list/new_bounds = obounds()

	for(var/i in old_bounds)
		if(i in new_bounds)
			continue
		var/atom/thing = i
		thing.Uncrossed(src)

	if(!loc) // I hope you know what you're doing
		return TRUE

	var/turf/oldturf = get_turf(oldloc)
	var/turf/destturf = get_turf(destination)
	var/oldz = (oldturf ? oldturf.z : null)
	var/newz = (destturf ? destturf.z : null)
	if(oldz != newz)
		onTransitZ(oldz, newz)

	destination.Entered(src, oldloc)
	if(destarea && oldarea != destarea)
		destarea.Entered(src, oldloc)

	for(var/i in new_bounds)
		if(i in old_bounds)
			continue
		var/atom/thing = i
		thing.Crossed(src, oldloc)

	Moved(oldloc, NONE, TRUE)
	return TRUE

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

	if(throwing)
		return 1

	if(!isturf(loc))
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
	inertia_last_loc = loc
	SSspacedrift.processing[src] = src
	return 1

/**
  * Resets our step_x/y values to target.
  */
/atom/movable/proc/reset_pixel_step(x = 0, y = 0)
	step_x = x
	step_y = y

/atom/Entered(atom/movable/AM, atom/oldLoc)
	SEND_SIGNAL(src, COMSIG_ATOM_ENTERED, AM, oldLoc)

/atom/Exit(atom/movable/AM, atom/newLoc)
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_ATOM_EXIT, AM, newLoc) & COMPONENT_ATOM_BLOCK_EXIT)
		return FALSE

/atom/Exited(atom/movable/AM, atom/newLoc)
	SEND_SIGNAL(src, COMSIG_ATOM_EXITED, AM, newLoc)

/atom/movable/setDir(direct)
	var/old_dir = dir
	. = ..()
	update_bounds(olddir=old_dir, newdir=direct)

// Unless you have some really weird rotation try to implement a generic version of your rotation here and make a flag for it
/atom/movable/proc/update_bounds(olddir, newdir)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UPDATE_BOUNDS, args)

	if(newdir == olddir) // the direction hasn't changed
		return
	if(bound_width == bound_height && !bound_x && !bound_y) // We're a square and have no offset
		return

	if(bounds_rotation_mode & BOUNDS_SIMPLE_ROTATE)
		var/rot = SIMPLIFY_DEGREES(dir2angle(newdir) - dir2angle(olddir))
		for(var/i in 90 to rot step 90)
			var/tempwidth = bound_width
			var/eastgap = CEILING(bound_width, 32) - bound_width - bound_x

			bound_width = bound_height
			bound_height = tempwidth

			bound_x = bound_y
			bound_y = eastgap
