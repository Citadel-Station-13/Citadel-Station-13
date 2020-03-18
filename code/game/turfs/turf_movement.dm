/// Stuff like enter and exit and such ///

/turf/CanPass(atom/movable/mover, turf/target)
	if(!target)
		return FALSE

	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !(density && mover.density)

	stack_trace("Non movable passed to turf CanPass : [mover]")
	return FALSE

/*
/turf/Enter(atom/movable/mover, atom/oldloc)
	// Do not call ..()
	// Byond's default turf/Enter() doesn't have the behaviour we want with Bump()
	// By default byond will call Bump() on the first dense object in contents
	// Here's hoping it doesn't stay like this for years before we finish conversion to step_
	var/atom/firstbump
	if(!CanPass(mover, src))
		firstbump = src
	else
		for(var/i in contents)
			if(i == mover || i == mover.loc) // Multi tile objects and moving out of other objects
				continue
			if(QDELETED(mover))
				break
			var/atom/movable/thing = i
			if(!thing.Cross(mover))
				if(CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE))
					mover.Bump(thing)
					continue
				else
					if(!firstbump || ((thing.layer > firstbump.layer || thing.flags_1 & ON_BORDER_1) && !(firstbump.flags_1 & ON_BORDER_1)))
						firstbump = thing
	if(firstbump)
		if(!QDELETED(mover))
			mover.Bump(firstbump)
		return CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE)
	return TRUE
*/

/turf/Enter(atom/movable/mover, atom/oldLoc)
	if(!CanPass(mover, src))
		return FALSE
	return ..()

/turf/Exit(atom/movable/mover, atom/newloc)
	. = ..()
	if(!.)
		return FALSE
	for(var/i in contents)
		if(QDELETED(mover))
			break
		if(i == mover)
			continue
		var/atom/movable/thing = i
		if(!thing.Uncross(mover, newloc))
			if(thing.flags_1 & ON_BORDER_1)
				mover.Bump(thing)
			if(!CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE))
				return FALSE

/turf/Entered(atom/movable/AM)
	..()
	if(explosion_level && AM.ex_check(explosion_id))
		AM.ex_act(explosion_level)

	// If an opaque movable atom moves around we need to potentially update visibility.
	if (AM.opacity)
		has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
		reconsider_lights()

