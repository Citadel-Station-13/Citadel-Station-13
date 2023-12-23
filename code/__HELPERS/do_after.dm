/proc/do_mob(mob/user, mob/target, time = 3 SECONDS, timed_action_flags = NONE, progress = TRUE, datum/callback/extra_checks, resume_time = 0 SECONDS)
	if(!user || !target)
		return FALSE
	var/user_loc = user.loc

	var/drifting = 0
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = 1

	var/target_loc = target.loc

	LAZYADD(user.do_afters, target)
	LAZYADD(target.targeted_by, user)

	var/holding = user.get_active_held_item()
	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, time, target)

	var/endtime = world.time+time
	var/starttime = world.time
	. = TRUE
	while (world.time + resume_time < endtime)
		stoplag(1)
		if (progress)
			if(!QDELETED(progbar))
				progbar.update(world.time - starttime + resume_time)

		if(drifting && !user.inertia_dir)
			drifting = FALSE
			user_loc = user.loc

		if(
			QDELETED(user) || QDELETED(target) \
			|| (!(timed_action_flags & IGNORE_TARGET_IN_DOAFTERS) && !(target in user.do_afters)) \
			|| (!(timed_action_flags & IGNORE_USER_LOC_CHANGE) && !drifting && user.loc != user_loc) \
			|| (!(timed_action_flags & IGNORE_TARGET_LOC_CHANGE) && target.loc != target_loc) \
			|| (!(timed_action_flags & IGNORE_HELD_ITEM) && user.get_active_held_item() != holding) \
			|| (!(timed_action_flags & IGNORE_INCAPACITATED) && user.incapacitated()) \
			|| (extra_checks && !extra_checks.Invoke()) \
			)
			. = FALSE
			break

	if(!QDELETED(progbar))
		progbar.end_progress()

	if(!QDELETED(target))
		LAZYREMOVE(user.do_afters, target)
		LAZYREMOVE(target.targeted_by, user)

//some additional checks as a callback for for do_afters that want to break on losing health or on the mob taking action
/mob/proc/break_do_after_checks(list/checked_health, check_clicks)
	if(check_clicks && !CheckActionCooldown())
		return FALSE
	return TRUE

//pass a list in the format list("health" = mob's health var) to check health during this
/mob/living/break_do_after_checks(list/checked_health, check_clicks)
	if(islist(checked_health))
		if(health < checked_health["health"])
			return FALSE
		checked_health["health"] = health
	return ..()

/proc/do_after(mob/user, delay, atom/target, timed_action_flags = NONE, progress = TRUE, datum/callback/extra_checks, resume_time = 0 SECONDS)
	if(!user)
		return FALSE
	var/atom/target_loc = null
	if(target && !isturf(target))
		target_loc = target.loc

	if(target)
		LAZYADD(user.do_afters, target)
		LAZYADD(target.targeted_by, user)

	var/atom/user_loc = user.loc

	var/drifting = FALSE
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = TRUE

	var/holding = user.get_active_held_item()

	delay *= user.cached_multiplicative_actions_slowdown

	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, delay, target)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = TRUE
	while (world.time + resume_time < endtime)
		stoplag(1)
		if (progress)
			if(!QDELETED(progbar))
				progbar.update(world.time - starttime + resume_time)

		if(drifting && !user.inertia_dir)
			drifting = FALSE
			user_loc = user.loc

		if(
			QDELETED(user) \
			|| (!(timed_action_flags & IGNORE_USER_LOC_CHANGE) && !drifting && user.loc != user_loc) \
			|| (!(timed_action_flags & IGNORE_HELD_ITEM) && user.get_active_held_item() != holding) \
			|| (!(timed_action_flags & IGNORE_INCAPACITATED) && user.incapacitated()) \
			|| (extra_checks && !extra_checks.Invoke()) \
		)
			. = FALSE
			break

		if(
			!(timed_action_flags & IGNORE_TARGET_LOC_CHANGE) \
			&& !drifting \
			&& !QDELETED(target_loc) \
			&& (QDELETED(target) || target_loc != target.loc) \
			&& ((user_loc != target_loc || target_loc != user)) \
			)
			. = FALSE
			break

		if(target && !(timed_action_flags & IGNORE_TARGET_IN_DOAFTERS) && !(target in user.do_afters))
			. = FALSE
			break

	if(!QDELETED(progbar))
		progbar.end_progress()

	if(!QDELETED(target))
		LAZYREMOVE(user.do_afters, target)

	if(!QDELETED(target))
		LAZYREMOVE(user.do_afters, target)
		LAZYREMOVE(target.targeted_by, user)

/proc/do_after_mob(mob/user, list/targets, time = 3 SECONDS, timed_action_flags = NONE, progress = TRUE, datum/callback/extra_checks)
	if(!user || !targets)
		return FALSE
	if(!islist(targets))
		targets = list(targets)
	var/user_loc = user.loc

	var/drifting = FALSE
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = TRUE

	var/list/originalloc = list()
	for(var/atom/target in targets)
		originalloc[target] = target.loc
		LAZYADD(user.do_afters, target)
		LAZYADD(target.targeted_by, user)

	var/holding = user.get_active_held_item()
	var/datum/progressbar/progbar
	if(progress)
		progbar = new(user, time, targets[1])

	time *= user.cached_multiplicative_actions_slowdown

	var/endtime = world.time + time
	var/starttime = world.time
	. = 1
	while(world.time < endtime)
		stoplag(1)

		if(!QDELETED(progbar))
			progbar.update(world.time - starttime)
		if(QDELETED(user) || !length(targets))
			. = FALSE
			break

		if(drifting && !user.inertia_dir)
			drifting = FALSE
			user_loc = user.loc

		if(
			!((timed_action_flags & IGNORE_USER_LOC_CHANGE) && !drifting && user_loc != user.loc) \
			|| (!(timed_action_flags & IGNORE_HELD_ITEM) && user.get_active_held_item() != holding) \
			|| (!(timed_action_flags & IGNORE_INCAPACITATED) && user.incapacitated()) \
			|| (extra_checks && !extra_checks.Invoke()) \
			)
			. = FALSE
			break

		for(var/t in targets)
			var/atom/target = t
			if(
				(QDELETED(target)) \
				|| (!(timed_action_flags & IGNORE_TARGET_LOC_CHANGE) && originalloc[target] != target.loc) \
				)
				. = FALSE
				break

		if(!.) // In case the for-loop found a reason to break out of the while.
			break

	if(!QDELETED(progbar))
		progbar.end_progress()

	for(var/thing in targets)
		var/atom/target = thing
		if(!QDELETED(target))
			LAZYREMOVE(user.do_afters, target)
			LAZYREMOVE(target.targeted_by, user)
