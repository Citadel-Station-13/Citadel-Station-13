/datum/component/knockback
	/// distance the atom will be thrown
	var/throw_distance
	/// whether this can throw anchored targets (tables, etc)
	var/throw_anchored
	/// whether this is a gentle throw (default false means people thrown into walls are stunned / take damage)
	var/throw_gentle

/datum/component/knockback/Initialize(throw_distance=1, throw_gentle=FALSE)
	if(!isitem(parent) && !ishostile(parent) && !isgun(parent) && !ismachinery(parent) && !isstructure(parent))
		return COMPONENT_INCOMPATIBLE

	src.throw_distance = throw_distance
	src.throw_anchored = throw_anchored
	src.throw_gentle = throw_gentle

/datum/component/knockback/RegisterWithParent()
	. = ..()
	if(ismachinery(parent) || isstructure(parent) || isgun(parent)) // turrets, etc
		RegisterSignal(parent, COMSIG_PROJECTILE_ON_HIT, .proc/projectile_hit)
	else if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, .proc/item_afterattack)
	else if(ishostile(parent))
		RegisterSignal(parent, COMSIG_HOSTILE_ATTACKINGTARGET, .proc/hostile_attackingtarget)

/datum/component/knockback/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(COMSIG_ITEM_AFTERATTACK, COMSIG_HOSTILE_ATTACKINGTARGET, COMSIG_PROJECTILE_ON_HIT))

/// triggered after an item attacks something
/datum/component/knockback/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	do_knockback(target, user, get_dir(source, target))

/// triggered after a hostile simplemob attacks something
/datum/component/knockback/proc/hostile_attackingtarget(mob/living/simple_animal/hostile/attacker, atom/target)
	do_knockback(target, attacker, get_dir(attacker, target))

/// triggered after a projectile hits something
/datum/component/knockback/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	do_knockback(target, null, angle2dir(Angle))


/**
  * Throw a target in a direction
  *
  * Arguments:
  * * target - Target atom to throw
  * * thrower - Thing that caused this atom to be thrown
  * * throw_dir - Direction to throw the atom
  */
/datum/component/knockback/proc/do_knockback(atom/target, mob/thrower, throw_dir)
	if(!ismovable(target) || throw_dir == null)
		return
	var/atom/movable/throwee = target
	if(throwee.anchored && !throw_anchored)
		return
	if(throw_distance < 0)
		throw_dir = turn(throw_dir, 180)
		throw_distance *= -1
	var/atom/throw_target = get_edge_target_turf(throwee, throw_dir)
	throwee.safe_throw_at(throw_target, throw_distance, 1, thrower)		//, gentle = throw_gentle)
