/**
 * Turf transition build/teardown proc
 */
/turf/proc/UpdateTransitions()
	// if we're not the edge, remove
	if(!IsTransitionTurf())
		qdel(GetComponent(/datum/component/transition_border))
		return
	var/datum/space_level/L = SSmapping.space_levels[z]
	var/dir = NONE
	var/EW = 0
	var/NS = 0
	// 1 for top border, -1 for bottom border, 1 for east border, -1 for west border, 0 for no border
	// we ignore the edge case of 1x1 or 1xn or nx1 zlevel because anyone who does that is probably insane
	if(x == 1)
		EW = -1
	else if(x == world.maxx)
		EW = 1
	if(y == 1)
		NS = -1
	else if(y == world.maxy)
		NS = 1
	if(!EW)
		if(NS == 1)
			dir = NORTH
		else if(NS == -1)
			dir = SOUTH
	else if(!NS)
		if(EW == 1)
			dir = EAST
		else if(EW == -1)
			dir = WEST
	// oh, diagonal
	if(!dir)
		if(NS == 1 && EW == 1)
			dir = NORTHEAST
		else if(NS == -1 && EW == 1)
			dir = SOUTHEAST
		else if(NS == 1 && EW == -1)
			dir = NORTHWEST
		else if(NS == -1 && EW == -1)
			dir = SOUTHWEST
	if(!dir)
		qdel(GetComponent(/datum/component/transition_border))
		return
	AddComponent(/datum/component/transition_border, TRANSITION_VISUAL_SIZE, dir)

/**
 * Returns if we're on the edge of a zlevel
 */
/turf/proc/IsTransitionTurf()
	return (x == 1 || x == world.maxx || y == 1 || y == world.maxy) && !!GetComponent(/datum/component/transition_border)
