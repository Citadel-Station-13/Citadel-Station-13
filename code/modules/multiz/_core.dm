/**
 * Does not take into account world structs.
 */
/proc/get_step_multiz(ref, dir)
	var/turf/target
	if(dir & UP)
		target = get_turf(ref).Above()
	if(dir & DOWN)
		target = get_turf(ref).Below()
	dir &= ~(UP|DOWN)
	return (target && get_step(target, dir)) || null

/**
 * Laggy proc, do not use this a lot until this is more optimized.
 */
/proc/get_dir_multiz(turf/A, turf/B)
	return SSmapping.GetVirtualDir(A, B)
