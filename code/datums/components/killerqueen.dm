/**
  * KILLER QUEEN
  *
  * Simple contact bomb component
  * Blows up the first person to touch it.
  */
/datum/component/killerqueen
	can_transfer = TRUE
	/// strength of explosion on the touch-er. 0 to disable. usually only used if the normal explosion is disabled (this is the default).
	var/ex_strength = EXPLODE_HEAVY
	/// callback to invoke with (parent, victim) before standard detonation - useful for losing a reference to this component or implementing custom behavior. return FALSE to prevent explosion.
	var/datum/callback/pre_explode
	/// callback to invoke with (parent) when deleting without an explosion
	var/datum/callback/failure
	/// did we explode
	var/exploded = FALSE
	/// examine message
	var/examine_message
	/// light explosion radius
	var/light = 0
	/// heavy explosion radius
	var/heavy = 0
	/// dev explosion radius
	var/dev = 0
	/// flame explosion radius
	var/flame = 0
	/// only triggered by living mobs
	var/living_only = TRUE


/datum/component/killerqueen/Initialize(ex_strength = EXPLODE_HEAVY, datum/callback/pre_explode, datum/callback/failure, examine_message, light = 0, heavy = 0, dev = 0, flame = 0, living_only = TRUE)
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	src.ex_strength = ex_strength
	src.pre_explode = pre_explode
	src.failure = failure
	src.examine_message = examine_message
	src.light = light
	src.heavy = heavy
	src.dev = dev
	src.flame = flame
	src.living_only = living_only

/datum/component/killerqueen/Destroy()
	if(!exploded)
		failure?.Invoke(parent)
	return ..()

/datum/component/killerqueen/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_ATTACK_PAW, COMSIG_ATOM_ATTACK_ANIMAL), PROC_REF(touch_detonate))
	RegisterSignal(parent, COMSIG_MOVABLE_BUMP, PROC_REF(bump_detonate))
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(attackby_detonate))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/killerqueen/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(COMSIG_ATOM_ATTACK_ANIMAL, COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_ATTACK_PAW,
	COMSIG_MOVABLE_BUMP, COMSIG_PARENT_ATTACKBY, COMSIG_PARENT_EXAMINE))

/datum/component/killerqueen/proc/attackby_detonate(datum/source, obj/item/I, mob/user)
	detonate(user)

/datum/component/killerqueen/proc/bump_detonate(datum/source, atom/A)
	var/atom/us = parent
	if(!us.density)		// lazy anti-item-throw-OHKO, we need something better at some point
		return
	detonate(A)

/datum/component/killerqueen/proc/touch_detonate(datum/source, mob/user)
	detonate(user)
	return COMPONENT_NO_ATTACK_HAND

/datum/component/killerqueen/proc/on_examine(datum/source, mob/examiner, list/examine_return)
	if(examine_message)
		examine_return += examine_message

/datum/component/killerqueen/proc/detonate(atom/victim)
	if(!isliving(victim) && living_only)
		return
	if(pre_explode && !pre_explode.Invoke(parent, victim))
		return
	if(ex_strength)
		victim.ex_act(ex_strength)
	if(light || heavy || dev || flame)
		explosion(parent, dev, heavy, light, flame_range = flame)
	else
		var/turf/T = get_turf(parent)
		playsound(T, 'sound/effects/explosion2.ogg', 200, 1)
		new /obj/effect/temp_visual/explosion(T)
	exploded = TRUE
	qdel(src)
