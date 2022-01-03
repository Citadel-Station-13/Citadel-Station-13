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

/obj/item/summon/Initialize()
	. = ..()
	if(host_type)
		host = new host_type(summon_count, range)

/obj/item/summon/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!host)
		return
	if(!proximity_flag && melee_only)
		return
	Target(victim)

/obj/item/summon/dropped(mob/user, silent)
	. = ..()
	addtimer(CALLBACK(src, .proc/check_activation), 0, TIMER_UNIQUE)

/obj/item/summon/equipped(mob/user, slot)
	. = ..()
	addtimer(CALLBACK(src, .proc/check_activation), 0, TIMER_UNIQUE)

/obj/item/summon/proc/check_activation()
	if(!host)
		return
	if(!isliving(loc))
		host.SetMaster(null)
	var/mob/living/L = loc
	if(!L.is_holding(src))
		host.SetMaster(null)
	host.SetMaster(L)

/obj/item/summon/proc/Target(atom/victim)
	if(!host?.CheckTarget(victim))
		return
	host.AutoTarget(victim, stack_duration)

/obj/item/summon/sword
	name = "spectral blade"
	desc = "An eldritch blade that summons phantasms to attack one's enemies."
	#warn icons
	host_type = /datum/summon_weapon_host/sword

/**
 * Serves as the master datum for summon weapons
 */
/datum/summon_weapon_host
	/// master atom
	var/atom/master
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

/datum/summon_weapon_host/proc/SetMaster(atom/master)
	src.master = master
	if(!master)
		return

/datum/summon_weapon_host/proc/Create(count)
	if(!weapon_type)
		return
	for(var/i in 1 to min(count, clamp(controlled.len - count, 0, 20)))
		var/datum/summon_weapon/weapon = new weapon_type(src)
		Associate(weapon)

/datum/summon_weapon_host/proc/Associate(datum/summon_weapon/linking)
	if(linking.host && linking.host != src)
		linking.host.Disassociate(linking)
	linking.host = src
	controlled |= linking
	linking.Reset()

/datum/summon_weapon_host/proc/Disassociate(datum/summon_weapon/unlinking, reset = TRUE)
	if(unlinking.host == src)
		unlinking.host = null
	controlled -= unlinking
	if(reset)
		unlinking.Reset()
	idle -= unlinking
	active -= unlinking

/datum/summon_wepaon_host/proc/AutoTarget(atom/victim)
	var/datum/summon_weapon/weapon = (idle.len && idle[1]) || (active.len && active[1])
	if(!weapon)
		return
	if(!CheckTarget(victim))
		return
	weapon.Target(victim)

/datum/summon_weapon_host/proc/OnTarget(datum/summon_weapon/weapon, atom/victim)
	attacking -= weapon
	idle -= weapon
	attacking += weapon

/datum/summon_weapon_host/proc/OnReset(datum/summon_weapon/weapon, atom/victim)
	attacking -= weapon
	idle += weapon

/datum/summon_weapon_host/proc/CheckTarget(atom/victim)
	if(!isobj(victim) && !ismob(victim))
		return FALSE
	if(QDELETED(victim))
		return FALSE
	if(victim == master)
		return FALSE
	return TRUE

/datum/summon_weapon_host/sword
	weapon_type = /datum/summon_weapon/sword

/**
 * A singular summoned object
 */
/datum/summon_weapon
	/// host
	var/datum/summon_weapon_host/host
	/// icon file
	var/icon = 'icons/effects/summon.dmi'
	/// icon state
	var/icon_state
	/// mutable_appearance to use, will skip making from icon/icon state if so
	var/mutable_appearance/appearance
	/// can rotate at all
	var/can_rotate = TRUE
	/// rotate to face target during attacks
	var/rotate_during_attack = TRUE
	/// the actual effect
	var/atom/movable/summon_weapon_effect/atom
	/// currently locked attack target
	var/atom/victim
	/// current angle from victim - clockwise from 0. null if not attacking.
	var/angle
	/// current distance from victim - pixels
	var/dist
	/// orbit distance from victim - pixels
	var/orbit_dist = 30
	/// orbit distance variation from victim
	var/orbit_dist_vary = 5
	/// attack delay in deciseconds - this is time spent between attacks
	var/attack_speed = 2
	/// attack length in deciseconds - this is the attack animation speed in total
	var/attack_length = 2
	/// attack damage
	var/attack_damage = 5
	/// attack damtype
	var/attack_type = BRUTE
	/// attack sound
	var/attack_sound = list(
		'sound/weapons/bladeslice.ogg',
		'sound/weapons/bladesliceb.ogg'
	)
	/// reset timerid
	var/reset_timerid
	/// attack timerid
	var/attack_timerid

/datum/summon_weapon/New(datum/summon_weapon_host/host, mutable_appearance/appearance_override)
	if(host)
		src.host = host
	if(appearance_override)
		appearance = appearance_override
	Setup()

/datum/summon_weapon/Destroy()
	Reset()
	QDEL_NULL(atom)
	QDEL_NULL(appearance)
	host.Disassociate(src)
	return ..()

/datum/summon_weapon/proc/Setup()
	summon_weapon_effect = new
	if(!appearance)
		GenerateAppearance()
	summon_weapon_effect.appearance = appearance
	summon_weapon_effect.moveToNullspace()
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
		appearance.overlays = list(
			emissive_appearance(icon, icon_state)
		)

/datum/summon_weapon/proc/Reset(del_no_host = TRUE)
	angle = null
	victim = null
	if(reset_timerid)
		deltimer(reset_timerid)
		reset_timerid = null
	if(attack_timerid)
		deltimer(attack_timerid)
		attack_timerid = null
	host?.OnReset(src)



/datum/summon_weapon/proc/ResetIn(ds)
	addtimer(CALLBACK(src, .proc/Reset), ds, TIMER_STOPPABLE)

/datum/summon_weapon/proc/Target(atom/victim)
	if(!istype(victim) || !isturf(victim.loc) || !host.CheckTarget(victim))
		Reset()
		return
	src.victim = victim
	Host.OnTarget(src, victim)





/datum/summon_weapon/proc/AttackLoop()
	if(!victim || !host.CheckTarget(victim))
		deltimer(attack_timerid)
		return
	var/new_angle = angle + 180
	Animate(angle, SIMPLIFY_DEGREES(new_angle))
	Hit(victim)

/datum/summon_weapon/proc/Hit(atom/victim)

/datum/summon_weapon/proc/MoveToAngle()

/datum/summon_weapon/proc/Recall(atom/to_orbit, )

/datum/summon_weapon/proc/Animate(from_angle, to_angle)


/datum/summon_weapon/sword
	icon_state = "sword"

/atom/movable/summon_weapon_effect
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	opacity = FALSE
	density = FALSE
