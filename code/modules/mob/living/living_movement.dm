/mob/living/Moved()
	. = ..()
	update_turf_movespeed(loc)

/mob/living/CanPass(atom/movable/mover, turf/target)
	if((mover.pass_flags & PASSMOB))
		return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		return !P.can_hit_target(src, P.permutated, src == P.original, TRUE)
	if(mover.throwing)
		return (!density || lying)
	if(buckled == mover)
		return TRUE
	if(!ismob(mover))
		if(mover.throwing?.thrower == src)
			return TRUE
	if(ismob(mover))
		if(mover in buckled_mobs)
			return TRUE
	var/mob/living/L = mover		//typecast first, check isliving and only check this if living using short circuit
	return (!density || (isliving(mover) && !mover.density && L.can_move_under_living(src)))

/mob/living/toggle_move_intent()
	. = ..()
	update_move_intent_slowdown()

/mob/living/update_config_movespeed()
	update_move_intent_slowdown()
	return ..()

/// whether or not we can slide under another living mob. defaults to if we're not dense. CanPass should check "overriding circumstances" like buckled mobs/having PASSMOB flag, etc.
/mob/living/proc/can_move_under_living(mob/living/other)
	return !density

/mob/living/proc/update_move_intent_slowdown()
	var/mod = 0
	if(m_intent == MOVE_INTENT_WALK)
		mod = CONFIG_GET(number/movedelay/walk_delay)
	else
		mod = CONFIG_GET(number/movedelay/run_delay)
	if(!isnum(mod))
		mod = 1
	add_movespeed_modifier(MOVESPEED_ID_MOB_WALK_RUN_CONFIG_SPEED, TRUE, 100, override = TRUE, multiplicative_slowdown = mod)

/mob/living/proc/update_turf_movespeed(turf/open/T)
	if(isopenturf(T) && !is_flying())
		add_movespeed_modifier(MOVESPEED_ID_LIVING_TURF_SPEEDMOD, TRUE, 100, override = TRUE, multiplicative_slowdown = T.slowdown)
	else
		remove_movespeed_modifier(MOVESPEED_ID_LIVING_TURF_SPEEDMOD)

/mob/living/proc/update_pull_movespeed()
	if(pulling && isliving(pulling))
		var/mob/living/L = pulling
		if(drag_slowdown && L.lying && !L.buckled && grab_state < GRAB_AGGRESSIVE)
			add_movespeed_modifier(MOVESPEED_ID_PRONE_DRAGGING, multiplicative_slowdown = PULL_PRONE_SLOWDOWN)
			return
	remove_movespeed_modifier(MOVESPEED_ID_PRONE_DRAGGING)

/mob/living/canZMove(dir, turf/target)
	return can_zTravel(target, dir) && (movement_type & FLYING)