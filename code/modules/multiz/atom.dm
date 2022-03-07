/**
 * Returns if an atom can enter our tile from a multiz move
 *
 * @param
 * AM - mover, null if doing a blank check
 * direction - direction of enter, e.g. if it's above us, then it'll be **UP**
 * oldloc - old turf
 */
/atom/proc/zPassIn(atom/movable/AM, direction, turf/oldloc)
	return !AM || Cross(AM)

/**
 * Returns if an atom can exit our tile in an multiz move
 *
 * @param
 * AM - mover, null if doing a blank check
 * direction - direction of exit, e.g. if it's going above us, then it'll be **UP**
 * newloc - new turf
 */
/atom/proc/zPassOut(atom/movable/AM, direction, turf/newloc)
	return !(flags_1 & ON_BORDER_1) || !AM || Uncross(AM)

/**
 * Full check - returns if an atom can go in up or down from our loc.
 */
/atom/proc/CanZPass(atom/movable/AM, dir)
	ASSERT(dir == UP || dir == DOWN)
	return FALSE

/**
 * Can be used as a climbing target by something directly underneath us.
 *
 * Anything implementing this should probably implement PreventZFall or the climber falls right back down.
 *
 * @params
 * - AM - climber
 */
/atom/proc/AllowZClimb(atom/movable/AM)
	return FALSE
