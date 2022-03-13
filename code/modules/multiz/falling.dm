// Falling isn't normal multiz movement, it's uncontrolled downwards motion.
// For example, a lattice would block falling, but wouldn't block climbing/motion.

/atom/movable
	/// Are we falling through zlevels right now?
	var/zfalling = FALSE

/turf/Entered(atom/movable/thing, turf/oldLoc)
	. = ..()
	if((z_flags & Z_OPEN_DOWN) && !(thing.CanZFall() & FALL_BLOCKED))
		addtimer(CALLBACK(thing, /atom/movable/proc/ZFall), 0, TIMER_UNIQUE)

/**
 * Checks if we're able to fall from our current location.
 * Returns fall flags.
 *
 * **If we are already falling, returning only FALL_BLOCKED will cause an impact.**
 */
/atom/movable/proc/CanZFall(levels, fall_flags)
	. = FALL_BLOCKED		// most atoms really shouldn't fall
	. |= SEND_SIGNAL(src, COMSIG_MOVABLE_CAN_ZFALL, levels, .)

// overrides for mob/obj because those *can* fall

/obj/CanZFall(levels, fall_flags)
	. |= SEND_SIGNAL(src, COMSIG_MOVABLE_CAN_ZFALL, levels, .)
	// logic implemented here and in mob.

/mob/CanZFall(levels, fall_flags)
	. |= SEND_SIGNAL(src, COMSIG_MOVABLE_CAN_ZFALL, levels, .)
	// logic implemented here and in obj.

/**
 * Attempts to fall.
 *
 * If calling this from a movement proc, you should callback(timer 0) to not stop any movement effects from happening.
 *
 * @params
 * - fall_flags - fall flags, see code/__DEFINES/maps/multiz.dm
 */
/atom/movable/proc/ZFall(fall_flags)
	if(zfalling)
		return FALSE
	if(throwing)
		return FALSE
	. = TRUE
	_ZFall(fall_flags, 0)

/**
 * Internal "loop" for falling
 */
/atom/movable/proc/_ZFall(fall_flags = NONE, levels = 0)
	if(!zfalling)
		return
	var/turf/T = loc
	if(!istype(T))
		zfalling = FALSE
		// moved out of turf, don't even bother with impacts, immediately end
		return
	if(!levels)
		// just beginning to fall
		fall_flags = CanZFall(levels, fall_flags)
		if(fall_flags & (FALL_BLOCKED | FALL_RECOVERED | FALL_TERMINATED))
			zfalling = FALSE
			return
		for(var/atom/movable/AM as anything in loc)
			if((fall_flags = AM.PreventZFall(src, 0, fall_flags)) & (FALL_BLOCKED | FALL_RECOVERED | FALL_TERMINATED))
				zfalling = FALSE
				return
		if((fall_flags = T.PreventZFall(src, 0, fall_flags)) & (FALL_BLOCKED | FALL_RECOVERED | FALL_TERMINATED))
			zfalling = FALSE
			return
		if(!ZMove(DOWN))
			zfalling = FALSE
			return
		else
			for(var/atom/movable/AM as anything in loc)
				fall_flags = AM.ZFellThrough(src, 0, fall_flags)
				fall_flags = ZFallThrough(AM, 0, fall_flags)
			fall_flags = loc.ZFellThrough(src, 0, fall_flags)
			fall_flags = ZFallThrough(loc, 0, fall_flags)
		addtimer(CALLBACK(src, .proc/_ZFall, fall_flags, levels + 1), 0)
	else		// now the fun begins
		fall_flags = CanZFall(levels, fall_flags)
		if(fall_flags & (FALL_BLOCKED | FALL_RECOVERED | FALL_TERMINATED))
			_ZImpact(levels, fall_flags)
			zfalling = FALSE
			return
		for(var/atom/movable/AM as anything in loc)
			fall_flags = AM.PreventZFall(src, levels, fall_flags)
			if(fall_flags & (FALL_BLOCKED | FALL_RECOVERED | FALL_TERMINATED))
				_ZImpact(levels, fall_flags)
				zfalling = FALSE
				return
		fall_flags = loc.PreventZFall(src, levels, fall_flags)
		if(fall_flags & (FALL_BLOCKED | FALL_RECOVERED | FALL_TERMINATED))
			_ZImpact(levels, fall_flags)
			zfalling = FALSE
			return
		if(!ZMove(DOWN))
			_ZImpact(levels, fall_flags)
			zfalling = FALSE
			return
		// we're still going
		for(var/atom/movable/AM as anything in loc)
			fall_flags = AM.ZFellThrough(src, levels, fall_flags)
			fall_flags = ZFallThrough(AM, levels, fall_flags)
		fall_flags = loc.ZFellThrough(src, levels, fall_flags)
		fall_flags = ZFallThrough(loc, levels, fall_flags)
		// another fall
		addtimer(CALLBACK(src, .proc/_ZFall, fall_flags, levels + 1), 0)

/**
 * Run impact code
 */
/atom/movable/proc/_ZImpact(levels, fall_flags)
	if(!isturf(loc))
		return
	if(fall_flags & FALL_TERMINATED)
		return
	if(fall_flags & FALL_RECOVERED)
		ZFallRecover(levels, fall_flags)
	// hit everyone
	for(var/atom/movable/AM in loc)
		fall_flags = AM.ZImpacted(src, levels, fall_flags)
	// hit floor
	loc.ZImpacted(src, levels, fall_flags)
	// ourselves have hit the ground
	ZImpact(loc, levels, fall_flags)

/**
 * Stops a thing from falling through this
 *
 * If said thing is asking while falling, the first thing to return this will be what gets ZImpact'd.
 *
 * @params
 * - victim - thing trying to fall through us
 * - levels - levels fallen so far, preventing a fall in the first place has this at 0, breaking a falling object from z2 to z1's floor would be 1, etc.
 * - fall_flags - see __DEFINES/mapping/multiz.dm
 */
/atom/proc/PreventZFall(atom/movable/victim, levels = 0, fall_flags)
	return fall_flags

/**
 * What happens when something falls onto us
 *
 * Can add flags to fall_flags using return value.
 *
 * @params
 * - victim - thing trying to fall through us
 * - levels - levels fallen so far, so going from, say, z2 to z1 would be a 1 level fall.
 * - fall_flags - see __DEFINES/mapping/multiz.dm
 */
/atom/proc/ZImpacted(atom/movable/AM, levels = 1, fall_flags)
	#warn only hit one thing?
	if(!(fall_flags & FALL_SILENT))
		AM.visible_message(span_danger("[AM] crashes into [src]!"), span_warning("You hear something crashing down near you."), span_danger("You crash into [victim]!"))
	if(!(fall_flags & FALL_CUSHIONED_FALLER))
		TakeFallDamage(GetSelfFallDamage(victim, levels, fall_flags))
	return fall_flags

/**
 * What happens when we fall onto something else
 *
 * Can add flags to fall_flags using return value.
 *
 * @params
 * - ground - thing we just fell on
 * - levels - levels fallen so far, so going from, say, z2 to z1 would be a 1 level fall.
 * - fall_flags - see __DEFINES/mapping/multiz.dm
 */
/atom/movable/proc/ZImpact(atom/victim, levels = 1, fall_flags)
	return fall_flags

/**
 * Called when we fall through an atom
 *
 * Can add flags to fall_flags using return value.
 */
/atom/movable/proc/ZFallThrough(atom/passing, levels = 1, fall_flags)
	return fall_flags

/**
 * Called when an atom falls through us, aka we didn't block them
 *
 * Can add flags to fall_flags using return value.
 */
/atom/proc/ZFellThrough(atom/movable/passing, levels = 1, fall_flags)
	return fall_flags

/**
 * Called when fall is broken by something other than an impact
 */
/atom/movable/proc/ZFallRecover(levels = 1, fall_flags)
	return

/**
 * Amount of fall damage we do to something we hit
 */
/atom/movable/proc/GetFallDamage(atom/impacting, levels = 1, fall_flags)
	return 0

/**
 * Amount of fall damage to do to ourselves when hitting something
 */
/atom/movbale/proc/GetSelfFallDamage(atom/impacting, levels = 1, fall_flags)
	return 0
