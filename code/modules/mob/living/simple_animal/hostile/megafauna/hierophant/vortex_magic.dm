//Holder/maker of vortex effects.
/datum/component/vortex_magic
	var/mob/living/user			//the current user, usually a mob.
	var/list/obj/effect/temp_visual/vortex_magic/effects
	var/list/obj/effect/temp_visual/vortex_magic/chaser/chasers
	var/obj/effect/vortex_beacon/current_beacon

	var/blinking = FALSE		//currently blinking
	var/damage_objects = FALSE			//this is a very bad idea.

	//"Usermode" variables - when this is being controlled by a player rather than using component signals
	var/energy = 1000
	var/max_energy = 1000
	var/energy_regen_ds = 5

	var/bonus_animal_damage = 30

	var/abilities_allowed = ALL		//see __DEFINES/components.dm Vortex Magic section.

	var/chaser_cost = 100
	var/chaser_cooldown = 5
	var/chaser_damage = 10
	var/chaser_speed = 1
	var/chaser_duration = 100
	var/chaser_diagonals = FALSE
	var/chaser_tiles_per_step = 1
	var/chaser_tiles_before_recalculation = 4

	var/blast_cost = 100
	var/blast_cooldown = 10
	var/blast_damage = 10

	var/barrage_cost = 50
	var/barrage_cooldown = 4
	var/barrage_damage = 5

	var/blink_cost = 250
	var/blink_cooldown = 150
	var/blink_damage = 30

	var/burst_cost = 250
	var/burst_cooldown = 50
	var/burst_damage = 20

	var/recall_cost = 500
	var/recall_delay = 50
	var/recall_damage = 30

	//User options
	var/friendly_fire = TRUE			//whether or not we hit people in the same faction
	var/click_intercepting = TRUE		//For mobs, this means we intercept clicks they send out. For items, this means we intercept things like afterattack(). Required for targeted abilities to work
	var/chaser_lockon = TRUE			//While click intercepting, try to lock onto nearby targets for chasers, rather than requiring direct clicks.

/datum/component/vortex_magic/Initialize(user)
	if(user)
		set_user(user)
	effects = list()
	chasers = list()
	return ..()

/datum/component/vortex_magic/Destroy()
	cleanup(TRUE)
	return ..()

/datum/component/vortex_magic/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_VORTEXMAGIC_BLAST, .proc/blast_dirs)
	RegisterSignal(parent, COMSIG_VORTEXMAGIC_BURST, .proc/burst)
	RegisterSignal(parent, COMSIG_VORTEXMAGIC_BLINK, .proc/blink)
	RegisterSignal(parent, COMSIG_VORTEXMAGIC_CHASER, .proc/chaser)
	RegisterSignal(parent, COMSIG_VORTEXMAGIC_USERBLINK, .proc/blink_user)

/datum/component/vortex_magic/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_VORTEXMAGIC_BLAST)
	UnregisterSignal(parent, COMSIG_VORTEXMAGIC_BURST)
	UnregisterSignal(parent, COMSIG_VORTEXMAGIC_BLINK)
	UnregisterSignal(parent, COMSIG_VORTEXMAGIC_CHASER)
	UnregisterSignal(parent, OCMSIG_VORTEXMAGIC_USERBLINK)

/datum/component/vortex_magic/proc/is_blast_immune(atom/A)
	var/mob/living/mob_user = isliving(user) && user
	if(isobj(A))
		if(ismecha(A))
			if(!friendly_fire && mob_user?.faction_check_mob(A.occupant))
				return TRUE
			return FALSE
		if(damage_objects == FALSE)
			return TRUE
		if(isitem(A))
			return TRUE
		return (A.level <= 1 || !A.invisibility)			//rough check for if it's not below the floor haha this is a bad idea.
	if(ismob(A))
		return mob_user?.faction_check_mob(A)
	return TRUE

/datum/component/vortex_magic/proc/can_pass_walls(atom/movable/AM)
	if(QDELETED(caster))
		return FALSE
	if(AM == caster.pulledby)
		return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		if(P.firer == caster)
			return TRUE
	if(mover == caster)
		return TRUE
	return FALSE

/datum/component/vortex_magic/proc/effect_multiplier(atom/A)
	return 1

/datum/component/vortex_magic/proc/on_blast_hit(obj/effect/temp_visual/vortex_magic/blast/B, atom/target, damage_done)
	log_combat(caster, target, "struck with a vortex blast with damage [damage_done]")

/datum/component/vortex_magic/proc/on_effect_new(obj/effect/temp_visual/vortex_magic/E)
	effects += E
	if(istype(E, /obj/effect/temp_visual/vortex_magic/chaser))
		chasers += E

/datum/component/vortex_magic/proc/on_effect_del(obj/effect/temp_visual/vortex_magic/E)
	effects -= E
	if(istype(E, /obj/effect/temp_visual/vortex_magic/chaser))
		chasers -= E

/datum/component/vortex_magic/proc/cleanup(immediate)
	if(immediate)
		for(var/i in effects)
			qdel(i)
		effects.Cut()
	else
		for(var/i in effects)
			var/obj/effect/temp_visual/vortex_magic/E = i
			E.graceful_stop()

/datum/component/vortex_magic/proc/set_user(new_user)
	cleanup(FALSE)
	user = new_user

/datum/component/vortex_magic/proc/make_blast(turf/target, damage, bonus_mob_damage, list/hit_once, list/hit_count, max_hit_count)
	new /obj/effect/temp_visual/vortex_magic/blast(target, src, damage, bonus_mob_damage, hit_once, hit_count, max_hit_count)

/datum/component/vortex_magic/proc/blast_dir(turf/source, dir, distance = 5, damage = 10, bonus_mob_damage = 10, list/hit_once = list(), list/hit_count, max_hit_count, hit_center = TRUE)
	if(hit_center)
		make_blast(source, damage, bonus_mob_damage, hit_once, hit_count, max_hit_count)
	var/turf/T = source
	for(var/i in 1 to distance)
		T = get_step(T, dir)
		if(!T)
			return
		make_blast(T, damage, bonus_mob_damage, hit_once, hit_count, max_hit_count)

//dirs is a flag
/datum/component/vortex_magic/proc/blast_dirs(turf/source, dirs, distance, damage, bonus_mob_damage, list/hit_once = list(), list/hit_count, max_hit_count)
	. = VORTEXMAGIC_SUCCESS
	make_blast(source, damage, bonus_mob_damage, hit_once, hit_count, max_hit_count)
	for(var/i in GLOB.alldirs)
		if(dirs & i)
			blast_dir(source, i, distance, damage, bonus_mob_damage, hit_once, hit_count, max_hit_count, FALSE)

/datum/component/vortex_magic/proc/diagonal_blasts(turf/source, distance, damage, bonus_mob_damage, list/hit_once, list/hit_count, max_hit_count)
	blast_dirs(source, NORTHWEST|NORTHEAST|SOUTHWEST|SOUTHEAST, distance, damage, bonus_mob_damage, hit_once, hit_count, max_hit_count)

/datum/component/vortex_magic/proc/cardinal_blasts(turf/source, distance, damage, bonus_mob_damage, list/hit_once, list/hit_count, max_hit_count)
	blast_dirs(source, NORTH|SOUTH|EAST|WEST, distance, damage, bonus_mob_damage, hit_once, hit_count, max_hit_count)

/datum/component/vortex_magic/proc/alldir_blasts(turf/source, distance, damage, bonus_mob_damage, list/hit_once, list/hit_count, max_hit_count)
	blast_dirs(source, NORTH|SOUTH|EAST|WEST|NORTHEWST|NORTHEAST|SOUTHWEST|SOUTHEAST, distance, damage, bonus_mob_damage, hit_once, hit_count, max_hit_count)

/datum/component/vortex_magic/proc/burst(turf/source, burst_range = 5, base_speed = 1, min_spread_speed = 12, spread_acceleration_mult = 0.5, damage = 10, bonus_mob_damage = 10, silent = FALSE, multi_hit = FALSE, list/hit_count, max_hit_count)
	if(!source)
		return
	. = VORTEXMAGIC_SUCCESS
	var/list/hit_things
	var/last_dist = 0
	if(!multi_hit)
		hit_things = list()
	if(!silent)
		playsound(source, 'sound/machines/airlockopen.ogg', 200, 1)
	for(var/i in spiral_range_turfs(5, source))
		var/turf/T = i
		if(!T || QDELETED(src))
			continue
		var/dist = get_dist(source, T)
		if(dist > last_dist)
			last_dist = dist
			var/diff = burst_range - last_dist
			sleep(min(50, base_speed + min(diff * spread_acceleration_mult, min_spread_speed)))
		make_blast(T, damage, bonus_mob_damage, hit_things, hit_count, max_hit_count)

/datum/component/vortex_magic/proc/blink(turf/destination, atom/movable/object, do_blast = TRUE, blast_range = 1, silent = FALSE, initial_delay = 0, damage = 30, bonus_mob_damage = damage, datum/callback/on_finish)
	if(blinking || !object || !destination)
		return
	. = VORTEXMAGIC_SUCCESS
	blinking = TRUE
	var/turf/source = get_turf(object)
	sleep(initial_delay) //short delay before we start...
	new /obj/effect/temp_visual/hierophant/telegraph(destination, src)
	new /obj/effect/temp_visual/hierophant/telegraph(source, src)
	if(!silent)
		playsound(T,'sound/magic/wand_teleport.ogg', 200, 1)
		playsound(source,'sound/machines/airlockopen.ogg', 200, 1)
	if(do_blast)
		var/list/hit_mobs = list()
		for(var/t in RANGE_TURFS(blast_range, T))
			make_blast(t, damage, bonus_mob_damage, hit_mobs)
		hit_mobs = list()
		for(var/t in RANGE_TURFS(blast_range, source))
			make_blast(t, damage, bonus_mob_damage, hit_mobs)
	animate(object, alpha = 0, time = 2, easing = EASE_OUT) //fade out
	sleep(1)
	object.visible_message("<span class='hierophant_warning'>[object] fades out!</span>")
	var/initial_density = object.density
	object.density = FALSE
	sleep(2)
	object.forceMove(T)
	sleep(1)
	animate(object, alpha = 255, time = 2, easing = EASE_IN) //fade IN
	sleep(1)
	object.density = initial_density
	object.visible_message("<span class='hierophant_warning'>[object] fades in!</span>")
	sleep(1) //at this point the blasts we made detonate
	blinking = FALSE
	on_finish.InvokeAsync()

/datum/component/vortex_magic/proc/blink_user(turf/destination, do_blast, blast_range, silent, initial_delay, damage, bonus_mob_damage, datum/callback/on_finish)
	return blink(destination, user, do_blast, blast_range, silent, initial_delay, damage, bonus_mob_damage, on_finish)

/datum/component/vortex_magic/proc/chaser(turf/source, atom/target, duration = 100, damage = 10, bonus_mob_damage = 10, speed = 2, diagonals = FALSE, tiles_before_recalculation = 4, tiles_per_step = 1, initial_dir = pick(GLOB.cardinals), initial_move_dist)
	source = get_turf(source) || get_turf(user)
	if(!source)
		return
	. = VORTEXMAGIC_SUCCESS
	new /obj/effect/temp_visual/vortex_magic/chaser(source, src, target, duration, damage, bonus_mob_damage, speed, tiles_per_step, diagonals, tiles_before_recalculation, initial_dir, initial_move_dist)
