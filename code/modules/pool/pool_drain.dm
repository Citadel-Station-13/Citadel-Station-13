/obj/machinery/pool/drain
	name = "drain"
	icon_state = "drain"
	desc = "A suction system to remove the contents of the pool, and sometimes small objects. Do not insert fingers."
	anchored = TRUE
	/// Active/on?
	var/active = FALSE
	/// Filling or draining
	var/filling = FALSE
	/// Drain item suction range
	var/item_suction_range = 2
	/// Fill mode knock away range
	var/fill_push_range = 6
	/// Drain mode suction range
	var/drain_suck_range = 6
	/// Parent controller
	var/obj/machinery/pool/controller/controller
	/// Cycles left for fill/drain while active
	var/cycles_left = 0
	/// Mobs we are swirling around
	var/list/whirling_mobs
	/// Suck in once per x ticks
	var/suck_in_once_per = 3

	var/cooldown

/obj/machinery/pool/drain/Initialize(mapload)
	START_PROCESSING(SSfastprocess, src)
	whirling_mobs = list()
	return ..()

/obj/machinery/pool/drain/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(controller)
		controller.linked_drain = null
		controller = null
	whirling_mobs = null
	return ..()

/obj/machinery/pool/drain/proc/is_in_our_pool(atom/A)
	. = FALSE
	if(istype(A.loc, /turf/open/pool))
		var/turf/open/pool/P = A.loc
		if(P.controller == controller)
			. = TRUE

// This should probably start using move force sometime in the future but I'm lazy.
/obj/machinery/pool/drain/process()
	if(!filling)
		for(var/obj/item/I in range(min(item_suction_range, 10), src))
			if(!I.anchored && (I.w_class <= WEIGHT_CLASS_SMALL))
				step_towards(I, src)
				if((I.w_class <= WEIGHT_CLASS_TINY) && (get_dist(I, src) == 0))
					I.forceMove(controller.linked_filter)
	if(active)
		if(filling)
			if(cycles_left-- > 0)
				playsound(src, 'sound/effects/fillingwatter.ogg', 100, TRUE)
				for(var/obj/O in orange(min(fill_push_range, 10), src))
					if(!O.anchored && is_in_our_pool(O))
						step_away(O, src)
				for(var/mob/M in orange(min(fill_push_range, 10), src))		//compiler fastpath apparently?
					if(!M.anchored && isliving(M) && is_in_our_pool(M))
						step_away(M, src)
			else
				for(var/turf/open/pool/P in controller.linked_turfs)
					P.filled = TRUE
					P.update_icon()
				for(var/obj/effect/waterspout/S in range(1, src))
					qdel(S)
				controller.drained = FALSE
				if(controller.bloody < 1000)
					controller.bloody /= 2
				else
					controller.bloody /= 4
				controller.update_color()
				filling = FALSE
				active = FALSE
		else
			if(cycles_left-- > 0)
				playsound(src, 'sound/effects/pooldrain.ogg', 100, TRUE)
				playsound(src, "water_wade", 60, TRUE)
				for(var/obj/O in orange(min(drain_suck_range, 10), src))
					if(!O.anchored && is_in_our_pool(O))
						step_towards(O, src)
				for(var/mob/M in orange(min(drain_suck_range, 10), src))
					if(isliving(M) && !M.anchored && is_in_our_pool(M))
						if(!(cycles_left % suck_in_once_per))
							step_towards(M, src)
						whirl_mob(M)
						if(ishuman(M) && (get_dist(M, src) <= 1))
							var/mob/living/carbon/human/H = M
							playsound(src, pick('sound/misc/crack.ogg','sound/misc/crunch.ogg'), 50, TRUE)
							if(H.lying)			//down for any reason
								H.adjustBruteLoss(2)
								to_chat(H, "<span class='danger'>You're caught in the drain!</span>")
							else
								H.apply_damage(2.5, BRUTE, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)) //drain should only target the legs
								to_chat(H, "<span class='danger'>Your legs are caught in the drain!</span>")
			else
				for(var/turf/open/pool/P in controller.linked_turfs)
					P.filled = FALSE
					P.update_icon()
				for(var/obj/effect/whirlpool/W in range(1, src))
					qdel(W)
				controller.drained = TRUE
				controller.mist_off()
				active = FALSE
				filling = TRUE

/// dangerous proc don't fuck with, admins
/obj/machinery/pool/drain/proc/whirl_mob(mob/living/L, duration = 8, delay = 1)
	set waitfor = FALSE
	if(whirling_mobs[L])
		return
	whirling_mobs[L] = TRUE
	for(var/i in 1 to min(duration, 100))
		L.setDir(turn(L.dir, 90))
		sleep(delay)
		if(QDELETED(L))
			break
		if(QDELETED(src))
			return
	whirling_mobs -= L

/obj/machinery/pool/filter
	name = "Filter"
	icon_state = "filter"
	desc = "The part of the pool where all the IDs, ATV keys, and pens, and other dangerous things get trapped."
	var/obj/machinery/pool/controller/controller

/obj/machinery/pool/filter/Destroy()
	if(controller)
		controller.linked_filter = null
		controller = null
	return ..()

/obj/machinery/pool/filter/emag_act(mob/living/user)
	. = ..()
	if(!(obj_flags & EMAGGED))
		to_chat(user, "<span class='warning'>You disable the [src]'s shark filter! Run!</span>")
		obj_flags |= EMAGGED
		do_sparks(5, TRUE, src)
		icon_state = "filter_b"
		addtimer(CALLBACK(src, /obj/machinery/pool/filter/proc/spawn_shark), 50)
		var/msg = "[key_name(user)] emagged the pool filter and spawned a shark"
		log_game(msg)
		message_admins(msg)

/obj/machinery/pool/filter/proc/spawn_shark()
	if(prob(50))
		new /mob/living/simple_animal/hostile/shark(loc)
	else
		if(prob(50))
			new /mob/living/simple_animal/hostile/shark/kawaii(loc)
		else
			new /mob/living/simple_animal/hostile/shark/laser(loc)

/obj/machinery/pool/filter/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	to_chat(user, "You search the filter.")
	for(var/obj/O in contents)
		O.forceMove(loc)
