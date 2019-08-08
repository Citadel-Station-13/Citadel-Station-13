//Holder/maker of vortex effects.
/datum/component/vortex_magic
	var/user			//the current user, usually a mob.
	var/list/obj/effect/temp_visual/vortex_magic/effects
	var/friendly_fire = TRUE
	var/damage_objects = FALSE			//this is a very bad idea.

/datum/component/vortex_magic/Initialize(user)
	if(user)
		set_user(user)
	effects = list()
	return ..()

/datum/component/vortex_magic/Destroy()
	cleanup(TRUE)
	return ..()

/datum/component/vortex_magic/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_VORTEXMAGIC_BLAST, .proc/blast_dirs)
	RegisterSignal(parent, COMSIG_VORTEXMAGIC_BURST, .proc/burst)

/datum/component/vortex_magic/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_VORTEXMAGIC_BLAST)
	UnregisterSignal(parent, COMSIG_VORTEXMAGIC_BURST)

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

/datum/component/vortex_magic/proc/on_effect_del(obj/effect/temp_visual/vortex_magic/E)
	effects -= E

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
	set waitfor = FALSE
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
