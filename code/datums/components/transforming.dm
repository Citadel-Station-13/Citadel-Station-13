/* Simple transforming component
 * Doesn't have default support for automatically updating icons (pending update_icon refactor) or automatically setting force.
 */

/datum/component/transforming
	var/compflags_transforming = ATTACK_SELF_TRANSFORM
	/// Are we currently active?
	var/active = FALSE
	/// Either a callback or a proctype. Called with arguments (obj/item/parent, new_active, mob/user, forced, datum/signal_source, checks_passed) where checks_passed is if it could transform.
	var/datum/callback/on_transform
	/// Either a callback or a proctype. Called with (obj/item/parent, current_active, new_active, mob/user, datum/signal_source). Should return TRUE or FALSE to allow/deny transform (forced will override)
	var/datum/callback/can_transform
	/// Either a callback or a proctype. Called with (obj/item/parent, current_active, new_active, mob/user, dautm/signal_source) on failure of can_transform.
	var/datum/callback/on_transform_fail

/// On transform and can transform can be proctypes/procpaths if the target is parent.
/datum/component/transforming/Initialize(compflags_transforming, datum/callback/on_transform, datum/callback/can_transform, datum/callback/on_transform_fail)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isnull(compflags_transforming))
		src.compflags_transforming = compflags_transforming
	// Register signals here, we are not transferable.
	RegisterSignal(parent, COMSIG_HAS_TRANSFORM, .proc/signal_has_transform)
	RegisterSignal(parent, COMSIG_IS_TRANSFORMED, .proc/signal_is_transformed)
	RegisterSignal(parent, COMSIG_CAN_TRANSFORM, .proc/signal_can_transform)
	RegisterSignal(parent, COMSIG_SET_TRANSFORM, .proc/signal_set_transform)
	RegisterSignal(parent, COMSIG_TOGGLE_TRANSFORM, .proc/signal_toggle_transform)
	RegisterSignal(parent, COMSIG_TRANSFORM_ACTIVATE, .proc/signal_transform_activate)
	RegisterSignal(parent, COMSIG_TRANSFORM_DEACTIVATE, .proc/signal_transform_deactivate)
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, .proc/on_attack_self)
	src.on_transform = on_transform
	src.can_transform = can_transform
	src.on_transform_fail = on_transform_fail

/datum/component/transforming/proc/invoke_on_transform(mob/user, forced = FALSE, datum/signal_source, checks_passed = TRUE)
	if(!on_transform)
		return
	else if(istype(on_transform))
		on_transform.Invoke(parent, active, user, forced, signal_source, checks_passed)
	else
		call(parent, on_transform)(parent, active, user, forced, signal_source, checks_passed)

/datum/component/transforming/proc/invoke_can_transform(mob/user, datum/signal_source, new_active)
	. = TRUE
	if(!can_transform)
		return
	else if(istype(can_transform))
		. = can_transform.Invoke(parent, active, new_active, user, signal_source)
	else
		. = call(parent, can_transform)(parent, active, new_active, user, signal_source)

/datum/component/transforming/proc/invoke_on_transform_fail(mob/user, datum/signal_source, new_active)
	if(!on_transform_fail)
		return
	else if(istype(on_transform_fail))
		on_transform_fail.Invoke(parent, active, new_active, user, signal_source)
	else
		call(parent, on_trasnform_fail)(parent, active, new_active, user, signal_source)

/datum/component/transforming/proc/transform_on(mob/user, forced = FALSE, datum/signal_source, checks_passed = TRUE)
	if(active)			//already on
		return TRUE
	active = TRUE
	invoke_on_transform(user, forced, signal_source, checks_passed)
	return TRUE

/datum/component/transforming/proc/transform_off(mob/user, forced = FALSE, datum/signal_source, checks_passed = TRUE)
	if(!active)			//already off
		return TRUE
	active = FALSE
	invoke_on_transform(user, forced, signal_source, checks_passed)
	return TRUE

/datum/component/transforming/proc/transform_toggle(mob/user, forced = FALSE, datum/signal_source, checks_passed = TRUE)
	if(active)
		. = transform_off(user, forced, signal_source, checks_passed)
	else
		. = transform_on(user, forced, signal_source, checks_passed)

/datum/component/transforming/proc/check_transform(mob/user, datum/signal_source, new_active = !active)
	return invoke_can_transform(user, signal_source, new_active)

/datum/component/transforming/proc/on_attack_self(datum/source, mob/living/user)
	if(check_transform(user, source, !active))
		transform_toggle(user, FALSE, source, TRUE)
		return COMPONENT_NO_INTERACT

/datum/component/transforming/proc/signal_toggle_transform(datum/source, mob/living/user, forced)
	var/passed = check_transform(source, user, !active)
	if(passed || forced)
		if(transform_toggle(user, forced, source, passed))
			return COMPONENT_TRANSFORM_SUCCESS

/datum/component/transforming/proc/signal_transform_activate(datum/source, mob/living/user, forced)
	if(active)
		return COMPONENT_ALREADY_TRANSFORMED
	var/passed = check_transform(source, user, TRUE)
	if(passed || forced)
		if(transform_on(user, forced, source, passed))
			return COMPONENT_TRANSFORM_SUCCESS

/datum/component/transforming/proc/signal_transform_deactivate(datum/source, mob/living/user, forced)
	if(!active)
		return COMPONENT_ALREADY_TRANSFORMED
	var/passed = check_transform(source, user, FALSE)
	if(passed || forced)
		if(transform_off(user, forced, source, passed))
			return COMPONENT_TRANSFORM_SUCCESS

/datum/component/transforming/proc/signal_set_transform(datum/source, new_active, mob/user, force)
	return new_active? signal_transform_activate(source, user, force) : signal_transform_deactivate(source, user, force)

/datum/component/transforming/proc/signal_can_transform(datum/source, mob/user)
	return invoke_can_transform(user, FALSE, source)? COMPONENT_CAN_TRANSFORM : NONE

/datum/component/transforming/proc/signal_is_transformed(datum/source)
	return active? COMPONENT_IS_TRANSFORMED : NONE

/datum/component/transforming/proc/signal_has_transform(datum/source)
	return COMPONENT_HAS_TRANSFORM
