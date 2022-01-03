/**
 * Simple summon weapon code in this file
 *
 * tl;dr latch onto target, repeatedly proc attacks, animate using transforms,
 * no real hitboxes/collisions, think of /datum/component/orbit-adjacent
 */
/obj/item/summon
	name = "a horrifying mistake"
	desc = "Why does this exist?"

/obj/item/summon/Initialize()
	. = ..()

/obj/item/summon/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()

/obj/item/summon/proc/


/obj/item/summon/sword

/**
 * Serves as the master datum for summon weapons
 */
/datum/summon_weapon_host

/**
 * A singular summoned object
 */
/datum/summon_weapon
	/// host
	var/datum/summon_weapon_host/host
	/// icon file
	var/icon
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


/datum/summon_weapon/New(datum/summon_weapon_host/host, mutable_appearance/appearance_override)
	if(host)
		src.host = host
	if(appearance_override)
		appearance = appearance_override
	Setup()

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

/datum/summon_weapon/proc/Reset()
	angle = null
	victim = null


/datum/summon_weapon/proc/Target(atom/victim)
	if(!istype(victim) || !isturf(victim.loc) || !host.CheckTarget(victim))
		Reset()
		return
	src.victim = victim
	angle = rand(0, 359)




/datum/summon_weapon/proc/AttackLoop(atom/victim)

/datum/summon_weapon/proc/Hit(atom/victim)

/datum/summon_weapon/proc/MoveToAngle()

/datum/summon_weapon/proc/Recall(atom/to_orbit, )


/atom/movable/summon_weapon_effect
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	opacity = FALSE
	density = FALSE
