/mob/living/simple_animal/hostile/megafauna/dragon/hard
	name = "enraged ash drake"
	desc = "A very enraged guardian of the necropolis. Better run."
	threat = 30
	health = 3000
	maxHealth = 3000
	armour_penetration = 60 //Trying to fight it will be a BAD idea
	melee_damage_lower = 45
	melee_damage_upper = 45
	speed = 0.5 //Faster
	crusher_loot = list(/obj/structure/closet/crate/necropolis/dragon/hard/crusher)
	loot = list(/obj/structure/closet/crate/necropolis/dragon/hard)
	abyss_born = FALSE

/mob/living/simple_animal/hostile/megafauna/dragon/hard/OpenFire()
	if(swooping)
		return

	anger_modifier = clamp(((maxHealth - health)/50),0,20)
	ranged_cooldown = world.time + ranged_cooldown_time

	if(prob(15 + anger_modifier))
		lava_swoop()

	else if(prob(10+anger_modifier))
		shoot_fire_attack()
	else
		fire_cone()

/mob/living/simple_animal/hostile/megafauna/dragon/hard/proc/lava_pools(amount, delay = 0.8)
	if(!target)
		return
	target.visible_message("<span class='boldwarning'>Lava starts to pool up around you!</span>")

	while(amount > 0)
		if(QDELETED(target))
			break
		var/turf/TT = get_turf(target)
		var/turf/T = pick(RANGE_TURFS(1,TT))
		new /obj/effect/temp_visual/lava_warning(T, 60) // longer reset time for the lava
		amount--
		SLEEP_CHECK_DEATH(delay)

/mob/living/simple_animal/hostile/megafauna/dragon/hard/proc/shoot_fire_attack()
	if(health < maxHealth*0.5)
		mass_fire()
	else
		fire_cone()

/mob/living/simple_animal/hostile/megafauna/dragon/hard/proc/lava_swoop(amount = 30)
	if(health < maxHealth * 0.5)
		return swoop_attack_high(lava_arena = TRUE, swoop_cooldown = 60)
	INVOKE_ASYNC(src, .proc/lava_pools, amount)
	swoop_attack_high(FALSE, target, 1000) // longer cooldown until it gets reset below
	SLEEP_CHECK_DEATH(0)
	fire_cone()
	if(health < maxHealth*0.5)
		SLEEP_CHECK_DEATH(10)
		fire_cone()
		SLEEP_CHECK_DEATH(10)
		fire_cone()
	SetRecoveryTime(40)

/mob/living/simple_animal/hostile/megafauna/dragon/hard/proc/mass_fire(spiral_count = 12, range = 15, times = 3)
	SLEEP_CHECK_DEATH(0)
	for(var/i = 1 to times)
		SetRecoveryTime(50)
		playsound(get_turf(src),'sound/magic/fireball.ogg', 200, TRUE)
		var/increment = 360 / spiral_count
		for(var/j = 1 to spiral_count)
			var/list/turfs = line_target(j * increment + i * increment / 2, range, src)
			INVOKE_ASYNC(src, .proc/fire_line, turfs)
		SLEEP_CHECK_DEATH(25)
	SetRecoveryTime(30)

/obj/effect/temp_visual/drakewall
	desc = "An ash drakes true flame."
	name = "Fire Barrier"
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	anchored = TRUE
	opacity = 0
	density = TRUE
	CanAtmosPass = ATMOS_PASS_DENSITY
	duration = 82
	color = COLOR_DARK_ORANGE

/obj/effect/temp_visual/lava_safe
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "trap-earth"
	layer = BELOW_MOB_LAYER
	light_range = 2
	duration = 13

/obj/effect/temp_visual/lava_warning
	icon_state = "lavastaff_warn"
	layer = BELOW_MOB_LAYER
	light_range = 2
	duration = 13

/obj/effect/temp_visual/lava_warning/ex_act()
	return

/obj/effect/temp_visual/lava_warning/Initialize(mapload, reset_time = 10)
	. = ..()
	INVOKE_ASYNC(src, .proc/fall, reset_time)
	src.alpha = 63.75
	animate(src, alpha = 255, time = duration)

/obj/effect/temp_visual/lava_warning/proc/fall(var/reset_time)
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/fleshtostone.ogg', 80, TRUE)
	sleep(duration)
	playsound(T,'sound/magic/fireball.ogg', 200, TRUE)

	for(var/mob/living/L in T.contents)
		if(istype(L, /mob/living/simple_animal/hostile/megafauna/dragon))
			continue
		L.adjustFireLoss(10)
		to_chat(L, "<span class='userdanger'>You fall directly into the pool of lava!</span>")

	// deals damage to mechs
	for(var/obj/mecha/M in T.contents)
		M.take_damage(45, BRUTE, "melee", 1)

	// changes turf to lava temporarily
	if(!istype(T, /turf/closed) && !istype(T, /turf/open/lava))
		var/lava_turf = /turf/open/lava/smooth
		var/reset_turf = T.type
		T.ChangeTurf(lava_turf, flags = CHANGETURF_INHERIT_AIR)
		addtimer(CALLBACK(T, /turf.proc/ChangeTurf, reset_turf, null, CHANGETURF_INHERIT_AIR), reset_time, TIMER_OVERRIDE|TIMER_UNIQUE)

/mob/living/simple_animal/hostile/megafauna/dragon/hard/proc/swoop_attack_high(lava_arena = FALSE, atom/movable/manual_target, swoop_cooldown = 30)
	if(stat || swooping)
		return
	if(manual_target)
		target = manual_target
	if(!target)
		return
	stop_automated_movement = TRUE
	swooping |= SWOOP_DAMAGEABLE
	density = FALSE
	icon_state = "shadow"
	visible_message("<span class='boldwarning'>[src] swoops up high!</span>")

	var/negative
	var/initial_x = x
	if(target.x < initial_x) //if the target's x is lower than ours, swoop to the left
		negative = TRUE
	else if(target.x > initial_x)
		negative = FALSE
	else if(target.x == initial_x) //if their x is the same, pick a direction
		negative = prob(50)
	var/obj/effect/temp_visual/dragon_flight/F = new /obj/effect/temp_visual/dragon_flight(loc, negative)

	negative = !negative //invert it for the swoop down later

	var/oldtransform = transform
	alpha = 255
	animate(src, alpha = 204, transform = matrix()*0.9, time = 3, easing = BOUNCE_EASING)
	for(var/i in 1 to 3)
		sleep(1)
		if(QDELETED(src) || stat == DEAD) //we got hit and died, rip us
			qdel(F)
			if(stat == DEAD)
				swooping &= ~SWOOP_DAMAGEABLE
				animate(src, alpha = 255, transform = oldtransform, time = 0, flags = ANIMATION_END_NOW) //reset immediately
			return
	animate(src, alpha = 100, transform = matrix()*0.7, time = 7)
	swooping |= SWOOP_INVULNERABLE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SLEEP_CHECK_DEATH(7)

	while(target && loc != get_turf(target))
		forceMove(get_step(src, get_dir(src, target)))
		SLEEP_CHECK_DEATH(0.5)

	// Ash drake flies onto its target and rains fire down upon them
	var/descentTime = 10
	var/lava_success = TRUE
	if(lava_arena)
		lava_success = lava_arena()

	//ensure swoop direction continuity.
	if(negative)
		if(ISINRANGE(x, initial_x + 1, initial_x + DRAKE_SWOOP_DIRECTION_CHANGE_RANGE))
			negative = FALSE
	else
		if(ISINRANGE(x, initial_x - DRAKE_SWOOP_DIRECTION_CHANGE_RANGE, initial_x - 1))
			negative = TRUE
	new /obj/effect/temp_visual/dragon_flight/end(loc, negative)
	new /obj/effect/temp_visual/dragon_swoop(loc)
	animate(src, alpha = 255, transform = oldtransform, descentTime)
	SLEEP_CHECK_DEATH(descentTime)
	swooping &= ~SWOOP_INVULNERABLE
	mouse_opacity = initial(mouse_opacity)
	icon_state = "dragon"
	playsound(loc, 'sound/effects/meteorimpact.ogg', 200, TRUE)
	for(var/mob/living/L in orange(1, src))
		if(L.stat)
			visible_message("<span class='warning'>[src] slams down on [L], crushing [L.p_them()]!</span>")
			L.gib()
		else
			L.adjustBruteLoss(75)
			if(L && !QDELETED(L)) // Some mobs are deleted on death
				var/throw_dir = get_dir(src, L)
				if(L.loc == loc)
					throw_dir = pick(GLOB.alldirs)
				var/throwtarget = get_edge_target_turf(src, throw_dir)
				L.throw_at(throwtarget, 3)
				visible_message("<span class='warning'>[L] is thrown clear of [src]!</span>")
	for(var/obj/mecha/M in orange(1, src))
		M.take_damage(75, BRUTE, "melee", 1)

	for(var/mob/M in range(7, src))
		shake_camera(M, 15, 1)

	density = TRUE
	SLEEP_CHECK_DEATH(1)
	swooping &= ~SWOOP_DAMAGEABLE
	SetRecoveryTime(swoop_cooldown)
	if(!lava_success)
		arena_escape_enrage()

/mob/living/simple_animal/hostile/megafauna/dragon/hard/proc/arena_escape_enrage() // you ran somehow / teleported away from my arena attack now i'm mad fucker
	SLEEP_CHECK_DEATH(0)
	SetRecoveryTime(80)
	visible_message("<span class='boldwarning'>[src] starts to glow vibrantly as its wounds close up!</span>")
	adjustBruteLoss(-250) // yeah you're gonna pay for that, don't run nerd
	add_atom_colour(rgb(255, 255, 0), TEMPORARY_COLOUR_PRIORITY)
	move_to_delay = move_to_delay / 2
	light_range = 10
	SLEEP_CHECK_DEATH(10) // run.
	mass_fire(20, 15, 3)
	move_to_delay = initial(move_to_delay)
	remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)
	light_range = initial(light_range)

/mob/living/simple_animal/hostile/megafauna/dragon/hard/proc/fire_cone(atom/at = target, meteors = TRUE)
	playsound(get_turf(src),'sound/magic/fireball.ogg', 200, TRUE)
	SLEEP_CHECK_DEATH(0)
	if(prob(50) && meteors)
		INVOKE_ASYNC(src, .proc/fire_rain)
	var/range = 15
	var/list/turfs = list()
	turfs = line_target(-40, range, at)
	INVOKE_ASYNC(src, .proc/fire_line, turfs)
	turfs = line_target(0, range, at)
	INVOKE_ASYNC(src, .proc/fire_line, turfs)
	turfs = line_target(40, range, at)
	INVOKE_ASYNC(src, .proc/fire_line, turfs)

/mob/living/simple_animal/hostile/megafauna/dragon/hard/proc/line_target(offset, range, atom/at = target)
	if(!at)
		return
	var/turf/T = get_ranged_target_turf_direct(src, at, range, offset)
	return (getline(src, T) - get_turf(src))

/mob/living/simple_animal/hostile/megafauna/dragon/hard/proc/fire_line(var/list/turfs)
	SLEEP_CHECK_DEATH(0)
	dragon_fire_line_hard(src, turfs)

//fire line keeps going even if dragon is deleted
/proc/dragon_fire_line_hard(atom/source, list/turfs)
	var/list/hit_list = list()
	for(var/turf/T in turfs)
		if(istype(T, /turf/closed))
			break
		new /obj/effect/hotspot(T)
		T.hotspot_expose(DRAKE_FIRE_TEMP,DRAKE_FIRE_EXPOSURE,1)
		for(var/mob/living/L in T.contents)
			if(L in hit_list || istype(L, source.type))
				continue
			hit_list += L
			L.adjustFireLoss(20)
			to_chat(L, "<span class='userdanger'>You're hit by [source]'s fire breath!</span>")

		// deals damage to mechs
		for(var/obj/mecha/M in T.contents)
			if(M in hit_list)
				continue
			hit_list += M
			M.take_damage(45, BRUTE, "melee", 1)
		sleep(1.5)

/mob/living/simple_animal/hostile/megafauna/dragon/hard/proc/lava_arena()
	if(!target)
		return
	target.visible_message("<span class='boldwarning'>[src] encases you in an arena of fire!</span>")
	var/amount = 3
	var/turf/center = get_turf(target)
	var/list/walled = RANGE_TURFS(3, center) - RANGE_TURFS(2, center)
	var/list/drakewalls = list()
	for(var/turf/T in walled)
		drakewalls += new /obj/effect/temp_visual/drakewall(T) // no people with lava immunity can just run away from the attack for free
	var/list/indestructible_turfs = list()
	for(var/turf/T in RANGE_TURFS(2, center))
		if(istype(T, /turf/open/indestructible))
			continue
		if(!istype(T, /turf/closed/indestructible))
			T.ChangeTurf(/turf/open/floor/plating/asteroid/basalt/lava_land_surface, flags = CHANGETURF_INHERIT_AIR)
		else
			indestructible_turfs += T
	SLEEP_CHECK_DEATH(10) // give them a bit of time to realize what attack is actually happening

	var/list/turfs = RANGE_TURFS(2, center)
	while(amount > 0)
		var/list/empty = indestructible_turfs.Copy() // can't place safe turfs on turfs that weren't changed to be open
		var/any_attack = 0
		for(var/turf/T in turfs)
			for(var/mob/living/L in T.contents)
				if(L.client)
					empty += pick(((RANGE_TURFS(2, L) - RANGE_TURFS(1, L)) & turfs) - empty) // picks a turf within 2 of the creature not outside or in the shield
					any_attack = 1
			for(var/obj/mecha/M in T.contents)
				empty += pick(((RANGE_TURFS(2, M) - RANGE_TURFS(1, M)) & turfs) - empty)
				any_attack = 1
		if(!any_attack)
			for(var/obj/effect/temp_visual/drakewall/D in drakewalls)
				qdel(D)
			return 0 // nothing to attack in the arena time for enraged attack if we still have a target
		for(var/turf/T in turfs)
			if(!(T in empty))
				new /obj/effect/temp_visual/lava_warning(T)
			else if(!istype(T, /turf/closed/indestructible))
				new /obj/effect/temp_visual/lava_safe(T)
		amount--
		SLEEP_CHECK_DEATH(24)
	return 1
