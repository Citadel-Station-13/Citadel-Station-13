//// Reach stuff for pixel movement

/// Check if source can "reach" the target. Both source and target must be on turfs or this will fail!
/proc/defaultReachCheck(atom/source, atom/target, pixels, checker_size = 8)
	if(!isturf(source.loc) || !isturf(target.loc))
		return FALSE
	if(bounds_dist(source, target) > pixels)
		return FALSE
	var/atom/movable/checker = new(source.loc)
	checker.density = FALSE
	checker.bound_width = checker.bound_height = checker_size
	checker.bound_x = checker.bound_y = FLOOR((world.icon_size - checker_size) / 2, 1)
	var/dist = get_dist(source, target)
	for(var/i in 1 to (dist - 1))
		step_to(checker, target)
	return checker.loc.Adjacent(target.loc)

/mob/proc/checkDefaultReach(atom/target)
	return FALSE

/mob/living/checkDefaultReach(atom/target)
	return defaultReachCheck(src, target, base_reach)

/mob/proc/checkPickupReach(atom/target)
	return checkDefaultReach(target)
