/mob/living/Moved()
	. = ..()
	update_turf_movespeed(loc)
	if(is_shifted)
		is_shifted = FALSE
		pixel_x = get_standard_pixel_x_offset(lying)
		pixel_y = get_standard_pixel_y_offset(lying)

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
	return (!density || (isliving(mover)? L.can_move_under_living(src) : !mover.density))

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

#define OPTIMAL_PULL_DISTANCE 16
#define MAX_PULL_SEPARATION_BREAK_MINIMUM 32
#define MAX_PULL_SEPARATION_BREAK_FACTOR 1.5

/mob/living/Move(atom/newloc, direct)
	if(buckled)
		return buckled.Move(newloc, direct)

	var/old_direction = dir
	var/turf/oldT = loc

	if(pulling)
		update_pull_movespeed()

	. = ..()

	if(. && pulling)
		var/distance = get_pixel_dist_euclidean(src, pulling)
		if(distance > max(MAX_PULL_SEPARATION_BREAK_MINIMUM, (MAX_PULL_SEPARATION_BREAK_FACTOR * step_size)))
			stop_pulling()
		else if(distance > OPTIMAL_PULL_DISTANCE)
			var/diff = distance - OPTIMAL_PULL_DISTANCE
			pulling.pixelMoveAngleSeekTowards(src, diff)

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

	if(pulledby && get_dist(src, pulledby) > 1)//separated from our puller and not in the middle of a diagonal move.
		pulledby.stop_pulling()

	if(active_storage && !(CanReach(active_storage.parent,view_only = TRUE)))
		active_storage.close(src)

	if(lying && !buckled && prob(getBruteLoss()*200/maxHealth))
		makeTrail(newloc, oldT, old_direction)

/mob/living/forceMove(atom/destination)
	stop_pulling()
	if(buckled)
		buckled.unbuckle_mob(src, force = TRUE)
	if(has_buckled_mobs())
		unbuckle_all_mobs(force = TRUE)
	. = ..()
	if(.)
		if(client)
			reset_perspective()
		update_mobility() //if the mob was asleep inside a container and then got forceMoved out we need to make them fall.

/mob/living/proc/update_z(new_z) // 1+ to register, null to unregister
	if(isnull(new_z) && audiovisual_redirect)
		return
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.clients_by_zlevel[registered_z] -= src
		if (client || audiovisual_redirect)
			if (new_z)
				SSmobs.clients_by_zlevel[new_z] += src
				for (var/I in length(SSidlenpcpool.idle_mobs_by_zlevel[new_z]) to 1 step -1) //Backwards loop because we're removing (guarantees optimal rather than worst-case performance), it's fine to use .len here but doesn't compile on 511
					var/mob/living/simple_animal/SA = SSidlenpcpool.idle_mobs_by_zlevel[new_z][I]
					if (SA)
						SA.toggle_ai(AI_ON) // Guarantees responsiveness for when appearing right next to mobs
					else
						SSidlenpcpool.idle_mobs_by_zlevel[new_z] -= SA

			registered_z = new_z
		else
			registered_z = null

/mob/living/onTransitZ(old_z,new_z)
	..()
	update_z(new_z)

/mob/living/canface()
	if(!CHECK_MOBILITY(src, MOBILITY_MOVE))
		return FALSE
	return ..()

/mob/living/pixelMovement(direction, pixels)
	var/ptrunc = pixels % 1
	var/otrunc = pixel_decimal_overflow % 1
	var/amt = clamp((pixels - ptrunc) + (pixel_decimal_overflow - otrunc), 0, MAX_PIXEL_MOVE_PER_MOVE)
	return pixelMove(direction, amt)

//Generic Bump(). Override MobBump() and ObjBump() instead of this.
/mob/living/Bump(atom/A)
	if(..()) //we are thrown onto something
		return
	if (buckled || now_pushing)
		return
	if(ismob(A))
		var/mob/M = A
		if(MobBump(M))
			return
	if(isobj(A))
		var/obj/O = A
		if(ObjBump(O))
			return
	if(ismovableatom(A))
		var/atom/movable/AM = A
		if(PushAM(AM, move_force))
			return

/mob/living/Bumped(atom/movable/AM)
	..()
	last_bumped = world.time

//Called when we bump onto a mob
/mob/living/proc/MobBump(mob/M)
	//Even if we don't push/swap places, we "touched" them, so spread fire
	spreadFire(M)

	if(now_pushing)
		return TRUE

	var/they_can_move = TRUE
	if(isliving(M))
		var/mob/living/L = M
		they_can_move = CHECK_MOBILITY(L, MOBILITY_MOVE)
		//Also spread diseases
		for(var/thing in diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				L.ContactContractDisease(D)

		for(var/thing in L.diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				ContactContractDisease(D)

		//Should stop you pushing a restrained person out of the way
		if(L.pulledby && L.pulledby != src && L.restrained())
			if(!(world.time % 5))
				to_chat(src, "<span class='warning'>[L] is restrained, you cannot push past.</span>")
			return 1

		if(L.pulling)
			if(ismob(L.pulling))
				var/mob/P = L.pulling
				if(P.restrained())
					if(!(world.time % 5))
						to_chat(src, "<span class='warning'>[L] is restraining [P], you cannot push past.</span>")
					return 1

	//CIT CHANGES START HERE - makes it so resting stops you from moving through standing folks without a short delay
		if(!CHECK_MOBILITY(src, MOBILITY_STAND) && CHECK_MOBILITY(L, MOBILITY_STAND))
			var/origtargetloc = L.loc
			if(!pulledby)
				if(attemptingcrawl)
					return TRUE
				if(getStaminaLoss() >= STAMINA_SOFTCRIT)
					to_chat(src, "<span class='warning'>You're too exhausted to crawl under [L].</span>")
					return TRUE
				attemptingcrawl = TRUE
				visible_message("<span class='notice'>[src] is attempting to crawl under [L].</span>", "<span class='notice'>You are now attempting to crawl under [L].</span>")
				if(!do_after(src, CRAWLUNDER_DELAY, target = src) || CHECK_MOBILITY(src, MOBILITY_STAND))
					attemptingcrawl = FALSE
					return TRUE
			var/src_passmob = (pass_flags & PASSMOB)
			pass_flags |= PASSMOB
			Move(origtargetloc)
			if(!src_passmob)
				pass_flags &= ~PASSMOB
			attemptingcrawl = FALSE
			return TRUE
	//END OF CIT CHANGES

	if(moving_diagonally)//no mob swap during diagonal moves.
		return 1

	if(!M.buckled && !M.has_buckled_mobs())
		var/mob_swap = FALSE
		var/too_strong = (M.move_resist > move_force) //can't swap with immovable objects unless they help us
		if(!they_can_move) //we have to physically move them
			if(!too_strong)
				mob_swap = TRUE
		else
			if(M.pulledby == src && a_intent == INTENT_GRAB)
				mob_swap = TRUE
			//restrained people act if they were on 'help' intent to prevent a person being pulled from being separated from their puller
			else if((M.restrained() || M.a_intent == INTENT_HELP) && (restrained() || a_intent == INTENT_HELP))
				mob_swap = TRUE
		if(mob_swap)
			//switch our position with M
			if(loc && !loc.Adjacent(M.loc))
				return 1
			now_pushing = 1
			var/oldloc = loc
			var/oldMloc = M.loc


			var/M_passmob = (M.pass_flags & PASSMOB) // we give PASSMOB to both mobs to avoid bumping other mobs during swap.
			var/src_passmob = (pass_flags & PASSMOB)
			M.pass_flags |= PASSMOB
			pass_flags |= PASSMOB

			var/move_failed = FALSE
			if(!M.Move(oldloc) || !Move(oldMloc))
				M.forceMove(oldMloc)
				forceMove(oldloc)
				move_failed = TRUE
			if(!src_passmob)
				pass_flags &= ~PASSMOB
			if(!M_passmob)
				M.pass_flags &= ~PASSMOB

			now_pushing = 0

			if(!move_failed)
				return 1

	//okay, so we didn't switch. but should we push?
	//not if he's not CANPUSH of course
	if(!(M.status_flags & CANPUSH))
		return 1
	if(isliving(M))
		var/mob/living/L = M
		if(HAS_TRAIT(L, TRAIT_PUSHIMMUNE))
			return 1
	//If they're a human, and they're not in help intent, block pushing
	if(ishuman(M) && (M.a_intent != INTENT_HELP))
		return TRUE
	//anti-riot equipment is also anti-push
	for(var/obj/item/I in M.held_items)
		if(!istype(M, /obj/item/clothing))
			if(prob(I.block_chance*2))
				return 1

//Called when we bump onto an obj
/mob/living/proc/ObjBump(obj/O)
	return

//Called when we want to push an atom/movable
/mob/living/proc/PushAM(atom/movable/AM, force = move_force)
	if(now_pushing)
		return TRUE
	if(moving_diagonally)// no pushing during diagonal moves.
		return TRUE
	if(!client && (mob_size < MOB_SIZE_SMALL))
		return
	now_pushing = TRUE
	var/t = get_dir(src, AM)
	var/push_anchored = FALSE
	if((AM.move_resist * MOVE_FORCE_CRUSH_RATIO) <= force)
		if(move_crush(AM, move_force, t))
			push_anchored = TRUE
	if((AM.move_resist * MOVE_FORCE_FORCEPUSH_RATIO) <= force)			//trigger move_crush and/or force_push regardless of if we can push it normally
		if(force_push(AM, move_force, t, push_anchored))
			push_anchored = TRUE
	if((AM.anchored && !push_anchored) || (force < (AM.move_resist * MOVE_FORCE_PUSH_RATIO)))
		now_pushing = FALSE
		return
	if (istype(AM, /obj/structure/window))
		var/obj/structure/window/W = AM
		if(W.fulltile)
			for(var/obj/structure/window/win in get_step(W,t))
				now_pushing = FALSE
				return
	if(pulling == AM)
		stop_pulling()
	var/current_dir
	if(isliving(AM))
		current_dir = AM.dir
	var/speed = movement_speed_pixels()
	if(AM.pixelMove(t, speed) && Process_Spacemove(t))
		pixelMove(t, speed)
	if(current_dir)
		AM.setDir(current_dir)
	now_pushing = FALSE
