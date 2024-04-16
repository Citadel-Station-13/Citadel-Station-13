/// doing nothing/orbiting idly
#define STATE_IDLE		0
/// performing reset animation
#define STATE_RESET		1
/// performing attack animation
#define STATE_ATTACK	2
/// performing animation between attacks
#define STATE_RECOVER	3

/**
 * Simple summon weapon code in this file
 *
 * tl;dr latch onto target, repeatedly proc attacks, animate using transforms,
 * no real hitboxes/collisions, think of /datum/component/orbit-adjacent
 */
/obj/item/summon
	name = "a horrifying mistake"
	desc = "Why does this exist?"
	/// datum type
	var/host_type
	/// number of summons
	var/summon_count = 6
	/// how long it takes for a "stack" to fall off by itself
	var/stack_duration = 5 SECONDS
	/// our summon weapon host
	var/datum/summon_weapon_host/host
	/// range summons will chase to
	var/range = 7
	/// are we a ranged weapon?
	var/melee_only = TRUE

/obj/item/summon/Initialize(mapload)
	. = ..()
	if(host_type)
		host = new host_type(src, summon_count, range)

/obj/item/summon/Destroy()
	QDEL_NULL(host)
	return ..()

/obj/item/summon/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!host)
		return
	if(!proximity_flag && melee_only)
		return
	Target(target)

/obj/item/summon/dropped(mob/user, silent)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(check_activation)), 0, TIMER_UNIQUE)

/obj/item/summon/equipped(mob/user, slot)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(check_activation)), 0, TIMER_UNIQUE)

/obj/item/summon/proc/check_activation()
	if(!host)
		return
	if(!isliving(loc))
		host.SetMaster(null)
	var/mob/living/L = loc
	if(!istype(L))
		return
	if(!L.is_holding(src))
		host.SetMaster(src)
		host.Suppress()
	host.SetMaster(L)
	host.Wake()

/obj/item/summon/proc/Target(atom/victim)
	if(!host?.CheckTarget(victim))
		return
	host.AutoTarget(victim, stack_duration)

/obj/item/summon/sword
	name = "spectral blade"
	desc = "An eldritch blade that summons phantasms to attack one's enemies."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "spectral"
	item_state = "spectral"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	host_type = /datum/summon_weapon_host/sword
	force = 15
	sharpness = SHARP_EDGED

/**
 * Serves as the master datum for summon weapons
 */
/datum/summon_weapon_host
	/// master atom
	var/atom/master
	/// suppressed?
	var/active = TRUE
	/// actual projectiles
	var/list/datum/summon_weapon/controlled
	/// active projectiles - refreshing a projectile reorders the list, so if they all have the same stack durations, you can trust the list to have last-refreshed at [1]
	var/list/datum/summon_weapon/attacking
	/// idle projectiles
	var/list/datum/summon_weapon/idle
	/// projectile type
	var/weapon_type
	/// default stack time
	var/stack_time = 5 SECONDS
	/// range
	var/range = 7

/datum/summon_weapon_host/New(atom/master, count, range)
	src.master = master
	src.range = range
	controlled = list()
	attacking = list()
	idle = list()
	Create(count)

/datum/summon_weapon_host/Destroy()
	QDEL_LIST(controlled)
	master = null
	return ..()

/datum/summon_weapon_host/proc/SetMaster(atom/master, reset_on_failure = TRUE)
	var/changed = src.master != master
	src.master = master
	if(changed)
		for(var/datum/summon_weapon/weapon as anything in idle)
			weapon.Reset()
	if(!master && reset_on_failure)
		for(var/datum/summon_weapon/weapon as anything in attacking)
			weapon.Reset()

/datum/summon_weapon_host/proc/Create(count)
	if(!weapon_type)
		return
	for(var/i in 1 to min(count, clamp(20 - controlled.len - count, 0, 20)))
		var/datum/summon_weapon/weapon = new weapon_type
		Associate(weapon)

/datum/summon_weapon_host/proc/Associate(datum/summon_weapon/linking)
	if(linking.host && linking.host != src)
		linking.host.Disassociate(linking)
	linking.host = src
	controlled |= linking
	linking.Reset()

/datum/summon_weapon_host/proc/Disassociate(datum/summon_weapon/unlinking, reset = TRUE, autodel)
	if(unlinking.host == src)
		unlinking.host = null
	controlled -= unlinking
	if(reset)
		unlinking.Reset(del_no_host = autodel)
	idle -= unlinking
	attacking -= unlinking

/datum/summon_weapon_host/proc/AutoTarget(atom/victim, duration = stack_time)
	if(!active)
		return
	var/datum/summon_weapon/weapon = (idle.len && idle[1]) || (attacking.len && attacking[1])
	if(!weapon)
		return
	if(!CheckTarget(victim))
		return
	weapon.Target(victim)
	if(duration)
		weapon.ResetIn(duration)

/datum/summon_weapon_host/proc/OnTarget(datum/summon_weapon/weapon, atom/victim)
	attacking -= weapon
	idle -= weapon
	attacking |= weapon

/datum/summon_weapon_host/proc/OnReset(datum/summon_weapon/weapon, atom/victim)
	attacking -= weapon
	idle |= weapon

/datum/summon_weapon_host/proc/CheckTarget(atom/victim)
	if(isitem(victim))
		return FALSE
	if(QDELETED(victim))
		return FALSE
	if(victim == master)
		return FALSE
	if(isliving(victim))
		var/mob/living/L = victim
		if(L.stat == DEAD)
			return FALSE
		return TRUE
	if(isobj(victim))
		var/obj/O = victim
		return (O.obj_flags & CAN_BE_HIT)
	return FALSE

/datum/summon_weapon_host/proc/Suppress()
	active = FALSE
	for(var/datum/summon_weapon/weapon as anything in controlled)
		weapon.Reset()

/datum/summon_weapon_host/proc/Wake()
	active = TRUE
	for(var/datum/summon_weapon/weapon as anything in controlled)
		weapon.Reset()

/datum/summon_weapon_host/sword
	weapon_type = /datum/summon_weapon/sword

/**
 * A singular summoned object
 *
 * How summon weapons work:
 *
 * Reset() - makes it go back to its master.
 * Target() - locks onto a target for a duration
 *
 * The biggest challenge is synchronizing animations.
 * Variables keep track of when things tick, but,
 * animations are client-timed, and not server-timed
 *
 * Animations:
 * The weapon can only track its "intended" angle and dist
 * "Current" pixel x/y are always calculated relative to a target from the current orbiting atom the physical effect is on
 * There's 3 animations,
 * MoveTo(location, angle, dist, rotation)
 * Orbit(location)
 * Rotate(degrees)
 *
 * And an non-animation that just snaps it to a location,
 * HardReset(location)
 */
/datum/summon_weapon
	/// name
	var/name = "summoned weapon"
	/// host
	var/datum/summon_weapon_host/host
	/// icon file
	var/icon = 'icons/effects/summon.dmi'
	/// icon state
	var/icon_state
	/// mutable_appearance to use, will skip making from icon/icon state if so
	var/mutable_appearance/appearance
	/// the actual effect
	var/atom/movable/summon_weapon_effect/atom
	/// currently locked attack target
	var/atom/victim
	/// current angle from victim - clockwise from 0. null if not attacking.
	var/angle
	/// current distance from victim - pixels
	var/dist
	/// current rotation - angles clockwise from north
	var/rotation
	/// rand dist to rotate during reattack phase
	var/angle_vary = 45
	/// orbit distance from victim - pixels
	var/orbit_dist = 72
	/// orbit distance variation from victim
	var/orbit_dist_vary = 24
	/// attack delay in deciseconds - this is time spent between attacks
	var/attack_speed = 1.5
	/// attack length in deciseconds - this is the attack animation speed in total
	var/attack_length = 1.5
	/// attack damage
	var/attack_damage = 5
	/// reset animation duration
	var/reset_speed = 2
	/// attack damtype
	var/attack_type = BRUTE
	/// attack sound
	var/attack_sound = list(
		'sound/weapons/bladeslice.ogg',
		'sound/weapons/bladesliceb.ogg'
	)
	/// attack verb
	var/attack_verb = list(
		"rended",
		"pierced",
		"penetrated",
		"sliced"
	)
	/// current state
	var/state = STATE_IDLE
	/// animation locked until
	var/animation_lock
	/// animation lock timer
	var/animation_timerid
	/// reset timerid
	var/reset_timerid

/datum/summon_weapon/New(mutable_appearance/appearance_override)
	if(appearance_override)
		appearance = appearance_override
	Setup()
	attack_verb = typelist(NAMEOF(src, attack_verb), attack_verb)
	attack_sound = typelist(NAMEOF(src, attack_sound), attack_sound)

/datum/summon_weapon/Destroy()
	host.Disassociate(src, autodel = FALSE)
	QDEL_NULL(atom)
	QDEL_NULL(appearance)
	return ..()

/datum/summon_weapon/proc/Setup()
	atom = new
	if(!appearance)
		GenerateAppearance()
	atom.appearance = appearance
	atom.moveToNullspace()
	if(host)
		Reset()

/datum/summon_weapon/proc/GenerateAppearance()
	if(!appearance)
		appearance = new
		appearance.icon = icon
		appearance.icon_state = icon_state
		appearance.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		appearance.opacity = FALSE
		appearance.plane = GAME_PLANE
		appearance.layer = ABOVE_MOB_LAYER
		appearance.appearance_flags = KEEP_TOGETHER
		appearance.overlays = list(
			emissive_appearance(icon, icon_state)
		)

/datum/summon_weapon/proc/Reset(immediate = FALSE, del_no_host = TRUE)
	angle = null
	victim = null
	if(reset_timerid)
		deltimer(reset_timerid)
		reset_timerid = null
	host?.OnReset(src)
	atom.Release()
	state = STATE_RESET
	if(!host)
		if(del_no_host)
			qdel(src)
			return
		if(animation_timerid)
			deltimer(animation_timerid)
		atom.transform = null
		atom.moveToNullspace()
		return
	if(immediate)
		if(animation_timerid)
			deltimer(animation_timerid)
		Act()
	else
		Wake()

/datum/summon_weapon/proc/ResetIn(ds)
	reset_timerid = addtimer(CALLBACK(src, PROC_REF(Reset)), ds, TIMER_STOPPABLE)

/datum/summon_weapon/proc/Target(atom/victim)
	if(!istype(victim) || !isturf(victim.loc) || (host && !host.CheckTarget(victim)))
		Reset()
		return
	src.victim = victim
	host.OnTarget(src, victim)
	state = STATE_ATTACK
	Wake()

/datum/summon_weapon/proc/Wake()
	if(!animation_timerid)
		Act()

/datum/summon_weapon/proc/AnimationLock(duration)
	if(animation_timerid)
		deltimer(animation_timerid)
	animation_timerid = addtimer(CALLBACK(src, PROC_REF(Act)), duration, TIMER_CLIENT_TIME | TIMER_STOPPABLE)

/datum/summon_weapon/proc/Act()
	animation_timerid = null
	switch(state)
		if(STATE_IDLE)
			return
		if(STATE_ATTACK)
			if(!isturf(victim.loc) || (host && !host.CheckTarget(victim)))
				Reset(TRUE)
				return
			state = STATE_RECOVER
			// register hit at the halfway mark
			// we can do better math to approximate when the attack will hit but i'm too tired to bother
			addtimer(CALLBACK(src, PROC_REF(Hit), victim), attack_length / 2, TIMER_CLIENT_TIME)
			// we need to approximate our incoming angle - again, better math exists but why bother
			var/incoming_angle = angle
			if(isturf(atom.loc) && (atom.loc != victim.loc))
				incoming_angle = Get_Angle(atom.loc, victim.loc)
			// pierce through target
			// we do not want to turn while doing this so we pierce through them visually
			incoming_angle += 180
			var/outgoing_angle = SIMPLIFY_DEGREES(incoming_angle)
			AnimationLock(MoveTo(victim, null, outgoing_angle, orbit_dist + rand(-orbit_dist_vary, orbit_dist_vary), outgoing_angle, attack_length))
		if(STATE_RESET)
			state = STATE_IDLE
			if(!host || !host.active || !get_turf(host.master))
				atom.moveToNullspace()
				src.angle = null
				src.dist = null
				src.rotation = null
				return
			var/reset_angle = rand(0, 360)
			AnimationLock(MoveTo(host.master, null, reset_angle, 30, 90, reset_speed))
			addtimer(CALLBACK(src, PROC_REF(Orbit), host.master, reset_angle, 30, 3 SECONDS), reset_speed, TIMER_CLIENT_TIME)
		if(STATE_RECOVER)
			state = STATE_ATTACK
			AnimationLock(Rotate(rand(-angle_vary, angle_vary), attack_speed, null))

/datum/summon_weapon/proc/Hit(atom/victim)
	if(!isobj(victim) && !isliving(victim))
		return FALSE
	if(isliving(victim))
		var/mob/living/L = victim
		L.apply_damage(attack_damage, attack_type)
		playsound(victim, pick(attack_sound), 75)
	else if(isobj(victim))
		var/obj/O = victim
		O.take_damage(attack_damage, attack_type)
	return TRUE

/**
 * relative to defaults to current location
 */
/datum/summon_weapon/proc/MoveTo(atom/destination, atom/relative_to, angle = 0, dist = 64, rotation = 180, time)
	. = time
	// construct final transform
	var/matrix/dest = ConstructMatrix(angle, dist, rotation)

	// move to
	atom.Lock(destination)

	// get relative first positions
	relative_to = get_turf(relative_to || atom.locked)
	destination = get_turf(destination)
	// if none, move to immediately and end
	if(!relative_to)
		atom.transform = dest
		src.angle = angle
		src.dist = dist
		src.rotation = rotation
		// end animations
		animate(atom, time = 0, flags = ANIMATION_END_NOW)
		return FALSE

	// grab source
	var/rel_x = (destination.x - relative_to.x) * world.icon_size + src.dist * sin(src.angle)
	var/rel_y = (destination.y - relative_to.y) * world.icon_size + src.dist * cos(src.angle)

	// construct source matrix
	var/matrix/source = new

	source.Turn((relative_to == get_turf(atom.locked))? src.rotation : Get_Angle(relative_to, destination))
	source.Translate(rel_x, rel_y)

	// set vars
	src.angle = angle
	src.dist = dist
	src.rotation = rotation

	// animate
	atom.transform = source
	animate(atom, transform = dest, time, FALSE, LINEAR_EASING, ANIMATION_LINEAR_TRANSFORM | ANIMATION_END_NOW)

/**
 * rotation defaults to facing towards locked atom
 */
/datum/summon_weapon/proc/Rotate(degrees, time, rotation)
	. = time
	if(!dist)
		return FALSE
	var/matrix/M = ConstructMatrix(angle + degrees, dist, rotation || src.rotation)
	if(rotation)
		src.rotation = rotation
	angle += degrees
	animate(atom, transform = M, time, FALSE, LINEAR_EASING, ANIMATION_END_NOW | ANIMATION_LINEAR_TRANSFORM)

/datum/summon_weapon/proc/Orbit(atom/destination, initial_degrees = rand(0, 360), dist, speed)
	. = 0
	atom.Lock(destination)
	animate(atom, 0, FALSE, flags = ANIMATION_END_NOW)
	atom.transform = ConstructMatrix(initial_degrees, dist, 90)
	atom.SpinAnimation(speed, parallel = FALSE, segments = 10)
	// we can't predict dist/angle anymre because clienttime vs servertime.
	// well, we can, but, let's not be bothered with timeofday math eh.
	dist = 0
	angle = 0

/datum/summon_weapon/proc/ConstructMatrix(angle = 0, dist = 64, rotation = 0)
	var/matrix/M = new
	M.Turn(rotation)
	M.Translate(0, dist)
	M.Turn(angle)
	return M

/datum/summon_weapon/proc/HardReset(atom/snap_to)
	if(animation_timerid)
		deltimer(animation_timerid)
	atom.Release()
	atom.forceMove(snap_to)
	atom.transform = null

/datum/summon_weapon/sword
	name = "spectral blade"
	icon_state = "sword"
	attack_damage = 5
	attack_speed = 1.5
	attack_length = 1.5

/atom/movable/summon_weapon_effect
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	opacity = FALSE
	density = FALSE
	/// locked atom
	var/atom/locked

/atom/movable/summon_weapon_effect/Destroy()
	Release()
	return ..()

/atom/movable/summon_weapon_effect/proc/Lock(atom/target)
	if(locked == target)
		return
	if(locked)
		Release()
	if(!target)
		return
	locked = target
	forceMove(locked.loc)
	if(ismovable(locked))
		RegisterSignal(locked, COMSIG_MOVABLE_MOVED, PROC_REF(Update))

/atom/movable/summon_weapon_effect/proc/Release()
	if(ismovable(locked))
		UnregisterSignal(locked, COMSIG_MOVABLE_MOVED)
	locked = null

/atom/movable/summon_weapon_effect/proc/Update()
	if(!locked)
		return
	if(loc != locked.loc)
		forceMove(locked.loc)

#undef STATE_IDLE
#undef STATE_ATTACK
#undef STATE_RECOVER
#undef STATE_RESET
