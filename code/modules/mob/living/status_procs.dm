//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness,
// eye damage, eye_blind, eye_blurry, druggy, BLIND disability, and NEARSIGHT disability.


////////////////////////////// STUN ////////////////////////////////////

/mob/living/IsStun() //If we're stunned
	return has_status_effect(STATUS_EFFECT_STUN)

/mob/living/proc/AmountStun() //How many deciseconds remain in our stun
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(S)
		return S.duration - world.time
	return 0

/mob/living/proc/Stun(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if((status_flags & CANSTUN) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/stun/S = IsStun()
		if(S)
			S.duration = max(world.time + amount, S.duration)
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_STUN, amount, updating)
		return S

/mob/living/proc/SetStun(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if((status_flags & CANSTUN) || ignore_canstun)
		var/datum/status_effect/incapacitating/stun/S = IsStun()
		if(amount <= 0)
			if(S)
				qdel(S)
		else
			if(absorb_stun(amount, ignore_canstun))
				return
			if(S)
				S.duration = world.time + amount
			else
				S = apply_status_effect(STATUS_EFFECT_STUN, amount, updating)
		return S

/mob/living/proc/AdjustStun(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if((status_flags & CANSTUN) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/stun/S = IsStun()
		if(S)
			S.duration += amount
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_STUN, amount, updating)
		return S

///////////////////////////////// KNOCKDOWN /////////////////////////////////////

/mob/living/IsKnockdown() //If we're knocked down
	return has_status_effect(STATUS_EFFECT_KNOCKDOWN)

/mob/living/proc/AmountKnockdown() //How many deciseconds remain in our knockdown
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		return K.duration - world.time
	return 0

/mob/living/proc/Knockdown(amount, updating = TRUE, ignore_canknockdown = FALSE) //Can't go below remaining duration
	if((status_flags & CANKNOCKDOWN) || ignore_canknockdown)
		if(absorb_stun(amount, ignore_canknockdown))
			return
		var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
		if(K)
			K.duration = max(world.time + amount, K.duration)
		else if(amount > 0)
			K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount, updating)
		return K

/mob/living/proc/SetKnockdown(amount, updating = TRUE, ignore_canknockdown = FALSE) //Sets remaining duration
	if((status_flags & CANKNOCKDOWN) || ignore_canknockdown)
		var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
		if(amount <= 0)
			if(K)
				qdel(K)
		else
			if(absorb_stun(amount, ignore_canknockdown))
				return
			if(K)
				K.duration = world.time + amount
			else
				K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount, updating)
		return K

/mob/living/proc/AdjustKnockdown(amount, updating = TRUE, ignore_canknockdown = FALSE) //Adds to remaining duration
	if((status_flags & CANKNOCKDOWN) || ignore_canknockdown)
		if(absorb_stun(amount, ignore_canknockdown))
			return
		var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
		if(K)
			K.duration += amount
		else if(amount > 0)
			K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount, updating)
		return K

///////////////////////////////// FROZEN /////////////////////////////////////

/mob/living/proc/IsFrozen()
	return has_status_effect(/datum/status_effect/freon)

///////////////////////////////////// STUN ABSORPTION /////////////////////////////////////

/mob/living/proc/add_stun_absorption(key, duration, priority, message, self_message, examine_message)
//adds a stun absorption with a key, a duration in deciseconds, its priority, and the messages it makes when you're stun/examined, if any
	if(!islist(stun_absorption))
		stun_absorption = list()
	if(stun_absorption[key])
		stun_absorption[key]["end_time"] = world.time + duration
		stun_absorption[key]["priority"] = priority
		stun_absorption[key]["stuns_absorbed"] = 0
	else
		stun_absorption[key] = list("end_time" = world.time + duration, "priority" = priority, "stuns_absorbed" = 0, \
		"visible_message" = message, "self_message" = self_message, "examine_message" = examine_message)

/mob/living/proc/absorb_stun(amount, ignoring_flag_presence)
	if(!amount || amount <= 0 || stat || ignoring_flag_presence || !islist(stun_absorption))
		return FALSE
	var/priority_absorb_key
	var/highest_priority
	for(var/i in stun_absorption)
		if(stun_absorption[i]["end_time"] > world.time && (!priority_absorb_key || stun_absorption[i]["priority"] > highest_priority))
			priority_absorb_key = stun_absorption[i]
			highest_priority = priority_absorb_key["priority"]
	if(priority_absorb_key)
		if(priority_absorb_key["visible_message"] || priority_absorb_key["self_message"])
			if(priority_absorb_key["visible_message"] && priority_absorb_key["self_message"])
				visible_message("<span class='warning'>[src][priority_absorb_key["visible_message"]]</span>", "<span class='boldwarning'>[priority_absorb_key["self_message"]]</span>")
			else if(priority_absorb_key["visible_message"])
				visible_message("<span class='warning'>[src][priority_absorb_key["visible_message"]]</span>")
			else if(priority_absorb_key["self_message"])
				to_chat(src, "<span class='boldwarning'>[priority_absorb_key["self_message"]]</span>")
		priority_absorb_key["stuns_absorbed"] += amount
		return TRUE

/////////////////////////////////// DISABILITIES ////////////////////////////////////

/mob/living/proc/add_disability(disability, source)
	if(!disabilities[disability])
		disabilities[disability] = list(source)
	else
		disabilities[disability] |= list(source)

/mob/living/proc/remove_disability(disability, list/sources)
	if(!disabilities[disability])
		return

	if(!islist(sources))
		sources = list(sources)

	if(LAZYLEN(sources))
		for(var/S in sources)
			if(S in disabilities[disability])
				disabilities[disability] -= S
	else
		disabilities[disability] = list()

	if(!LAZYLEN(disabilities[disability]))
		disabilities -= disability

/mob/living/proc/has_disability(disability, list/sources)
	if(!disabilities[disability])
		return FALSE

	. = FALSE

	if(LAZYLEN(sources))
		for(var/S in sources)
			if(S in disabilities[disability])
				return TRUE
	else
		if(LAZYLEN(disabilities[disability]))
			return TRUE

/mob/living/proc/remove_all_disabilities()
	disabilities = list()

/////////////////////////////////// DISABILITY PROCS ////////////////////////////////////

/mob/living/proc/cure_blind(list/sources)
	remove_disability(BLIND, sources)
	if(!has_disability(BLIND))
		adjust_blindness(-1)

/mob/living/proc/become_blind(source)
	if(!has_disability(BLIND))
		blind_eyes(1)
	add_disability(BLIND, source)

/mob/living/proc/cure_nearsighted(list/sources)
	remove_disability(NEARSIGHT, sources)
	if(!has_disability(NEARSIGHT))
		clear_fullscreen("nearsighted")

/mob/living/proc/become_nearsighted(source)
	if(!has_disability(NEARSIGHT))
		overlay_fullscreen("nearsighted", /obj/screen/fullscreen/impaired, 1)
	add_disability(NEARSIGHT, source)

/mob/living/proc/cure_husk(list/sources)
	remove_disability(HUSK, sources)
	if(!has_disability(HUSK))
		status_flags &= ~DISFIGURED
		update_body()

/mob/living/proc/become_husk(source)
	if(!has_disability(HUSK))
		status_flags |= DISFIGURED	//makes them unknown
		update_body()
	add_disability(HUSK, source)