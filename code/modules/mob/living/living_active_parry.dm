// Active parry system goes in here.
/**
  * Determines if we can actively parry.
  */
/obj/item/proc/can_active_parry(mob/user)
	return block_parry_data && (item_flags & ITEM_CAN_PARRY)

/**
  * Called from keybindings.
  */
/mob/living/proc/keybind_parry()
	initiate_parry_sequence()

/**
  * Initiates a parrying sequence.
  */
/mob/living/proc/initiate_parry_sequence(silent = FALSE, list/override_method_data)
	if(parrying)
		return FALSE		// already parrying
	if(!(mobility_flags & MOBILITY_USE))
		if(!silent)
			to_chat(src, "<span class='warning'>You can't move your arms!</span>")
		return FALSE
	if(!(combat_flags & COMBAT_FLAG_PARRY_CAPABLE))
		if(!silent)
			to_chat(src, "<span class='warning'>You are not something that can parry attacks.</span>")
		return FALSE
	if(!(mobility_flags & MOBILITY_STAND))
		if(!silent)
			to_chat(src, "<span class='warning'>You aren't able to parry without solid footing!</span>")
		return FALSE
	var/datum/block_parry_data/data
	var/list/determined = override_method_data || determine_parry_method(FALSE, FALSE)
	if(!islist(determined))
		return FALSE
	var/method = determined[1]
	data = return_block_parry_datum(determined[2])
	var/datum/tool = determined[3]
	var/full_parry_duration = data.parry_time_windup + data.parry_time_active + data.parry_time_spindown
	// no system in place to "fallback" if out of the 3 the top priority one can't parry due to constraints but something else can.
	// can always implement it later, whatever.
	if((data.parry_respect_clickdelay && !CheckActionCooldown()) || ((parry_end_time_last + data.parry_cooldown) > world.time))
		if(!silent)
			to_chat(src, "<span class='warning'>You are not ready to parry (again)!</span>")
		return FALSE
	// Point of no return, make sure everything is set.
	parrying = method
	if(method == ITEM_PARRY)
		active_parry_item = tool
	if(!UseStaminaBuffer(data.parry_stamina_cost, TRUE))
		return FALSE
	parry_start_time = world.time
	successful_parries = list()
	successful_parry_counterattacks = list()
	addtimer(CALLBACK(src, .proc/end_parry_sequence), full_parry_duration)
	if(data.parry_flags & PARRY_LOCK_ATTACKING)
		ADD_TRAIT(src, TRAIT_MOBILITY_NOUSE, ACTIVE_PARRY_TRAIT)
	if(data.parry_flags & PARRY_LOCK_SPRINTING)
		ADD_TRAIT(src, TRAIT_SPRINT_LOCKED, ACTIVE_PARRY_TRAIT)
	handle_parry_starting_effects(data)
	return TRUE

/**
 * Massive snowflake proc for getting something to parry with.
 *
 * @return list of [method, data, tool], where method is the parry method define, data is the block_parry_data var that must be run through return_block_parry_data, and tool is the concept/object/martial art/etc used.
 */
/mob/living/proc/determine_parry_method(silent = TRUE, autoparry = FALSE)
	// Prioritize item, then martial art, then unarmed.
	// yanderedev else if time
	var/obj/item/using_item = get_active_held_item()
	var/datum/block_parry_data/data
	var/datum/tool
	var/method
	if(using_item?.can_active_parry(src))
		data = using_item.block_parry_data
		method = ITEM_PARRY
		tool = using_item
	else if(mind?.martial_art?.can_martial_parry)
		data = mind.martial_art.block_parry_data
		method = MARTIAL_PARRY
		tool = mind.martial_art
	else if((combat_flags & COMBAT_FLAG_UNARMED_PARRY) && check_unarmed_parry_activation_special())
		data = block_parry_data
		method = UNARMED_PARRY
		tool = src
	else
		// QOL: If none of the above work, try to find another item.
		var/obj/item/backup = find_backup_parry_item()
		if(backup)
			tool = backup
			data = backup.block_parry_data
			using_item = backup
			method = ITEM_PARRY
	var/list/other_items = list()
	var/list/override = list()
	if(SEND_SIGNAL(src, COMSIG_LIVING_ACTIVE_PARRY_START, method, tool, other_items, override) & COMPONENT_PREVENT_PARRY_START)
		if(!silent)
			to_chat(src, "<span class='warning'>Something is preventing you from parrying!</span>")
		return
	if(length(override))
		var/datum/thing = override[1]
		var/_method = override[thing]
		if(_method == ITEM_PARRY)
			using_item = thing
			tool = using_item
			method = ITEM_PARRY
			data = using_item.block_parry_data
		else if(_method == UNARMED_PARRY)
			method = UNARMED_PARRY
			tool = src
			data = thing
	if(!using_item && !method && length(other_items))
		using_item = other_items[1]
		tool = using_item
		method = ITEM_PARRY
		data = using_item.block_parry_data
	if(!method)
		if(!silent)
			to_chat(src, "<span class='warning'>You have nothing to parry with!</span>")
		return FALSE
	return list(method, data, tool)

/**
  * Tries to find a backup parry item.
  * Does not look at active held item.
  */
/mob/living/proc/find_backup_parry_item()
	for(var/obj/item/I in held_items - get_active_held_item())
		if(I.can_active_parry(src))
			return I

/**
  * Check if we can unarmed parry
  */
/mob/living/proc/check_unarmed_parry_activation_special()
	return TRUE

/**
  * Called via timer when the parry sequence ends.
  */
/mob/living/proc/end_parry_sequence()
	if(!parrying)
		return
	REMOVE_TRAIT(src, TRAIT_MOBILITY_NOUSE, ACTIVE_PARRY_TRAIT)
	REMOVE_TRAIT(src, TRAIT_SPRINT_LOCKED, ACTIVE_PARRY_TRAIT)
	if(parry_visual_effect)
		QDEL_NULL(parry_visual_effect)
	var/datum/block_parry_data/data = get_parry_data()
	var/list/effect_text = list()
	var/successful = FALSE
	for(var/efficiency in successful_parries)
		if(efficiency >= data.parry_efficiency_considered_successful)
			successful = TRUE
			break
	if(!successful)		// didn't parry anything successfully
		if(data.parry_failed_stagger_duration)
			Stagger(data.parry_failed_stagger_duration)
			effect_text += "staggering themselves"
		if(data.parry_failed_clickcd_duration)
			DelayNextAction(data.parry_failed_clickcd_duration, flush = TRUE)
			effect_text += "throwing themselves off balance"
	handle_parry_ending_effects(data, effect_text)
	parrying = NOT_PARRYING
	parry_start_time = 0
	parry_end_time_last = world.time + (successful? 0 : data.parry_failed_cooldown_duration)
	successful_parries = null
	successful_parry_counterattacks = null

/**
  * Handles starting effects for parrying.
  */
/mob/living/proc/handle_parry_starting_effects(datum/block_parry_data/data)
	playsound(src, data.parry_start_sound, 75, 1)
	parry_visual_effect = new /obj/effect/abstract/parry/main(null, TRUE, src, data.parry_effect_icon_state, data.parry_time_windup_visual_override || data.parry_time_windup, data.parry_time_active_visual_override || data.parry_time_active, data.parry_time_spindown_visual_override || data.parry_time_spindown)
	switch(parrying)
		if(ITEM_PARRY)
			visible_message("<span class='warning'>[src] swings [active_parry_item]!</span>")
		else
			visible_message("<span class='warning'>[src] rushes forwards!</span>")

/**
  * Handles ending effects for parrying.
  */
/mob/living/proc/handle_parry_ending_effects(datum/block_parry_data/data, list/failed_effect_text)
	if(length(successful_parries))
		return
	visible_message("<span class='warning'>[src] fails to connect their parry[failed_effect_text? ", [english_list(failed_effect_text)]" : ""]!")

/**
  * Gets this item's datum/block_parry_data
  */
/obj/item/proc/get_block_parry_data()
	return return_block_parry_datum(block_parry_data)

//Stubs.

/**
  * Called when an attack is parried using this, whether or not the parry was successful.
  */
/obj/item/proc/on_active_parry(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/block_return, parry_efficiency, parry_time, autoparry = FALSE)

/**
  * Called when an attack is parried innately, whether or not the parry was successful.
  */
/mob/living/proc/on_active_parry(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/block_return, parry_efficiency, parry_time, autoparry = FALSE)

/**
  * Called when an attack is parried using this, whether or not the parry was successful.
  */
/datum/martial_art/proc/on_active_parry(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/block_return, parry_efficiency, parry_time, autoparry = FALSE)

/**
  * Called when an attack is parried and block_parra_data indicates to use a proc to handle counterattack.
  */
/obj/item/proc/active_parry_reflex_counter(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list, parry_efficiency, list/effect_text)

/**
  * Called when an attack is parried and block_parra_data indicates to use a proc to handle counterattack.
  */
/mob/living/proc/active_parry_reflex_counter(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list, parry_efficiency, list/effect_text)

/**
  * Called when an attack is parried and block_parra_data indicates to use a proc to handle counterattack.
  */
/datum/martial_art/proc/active_parry_reflex_counter(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list, parry_efficiency, list/effect_text)

/**
 * Attempts to automatically parry an attacker.
 */
/mob/living/proc/attempt_auto_parry(atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list = list())
	// determine how we'll parry
	var/list/determined = determine_parry_method(TRUE, TRUE)
	if(!islist(determined))
		return BLOCK_NONE
	var/datum/block_parry_data/data = return_block_parry_datum(determined[2])
	if(!data.parry_automatic_enabled || (last_autoparry > (world.time - data.autoparry_cooldown_absolute)))
		return BLOCK_NONE
	if(attack_type && !(attack_type & data.parry_attack_types))
		return BLOCK_NONE
	// before doing anything, check if the user moused over them properly
	if(!client)
		return BLOCK_NONE
	var/found = attacker == client.mouse_object_ref?.resolve()
	if(!found)
		for(var/i in client.moused_over_objects)
			if(i == object)
				if((client.moused_over_objects[i] + (data.autoparry_mouse_delay_maximum)) >= world.time)
					found = TRUE
				break
	if(!found)
		return BLOCK_NONE

	// if that works, try to start parry
	// first, check cooldowns

	// now, depending on if we're doing a single simulation or a full sequence
	last_autoparry = world.time
	if(data.autoparry_sequence_simulation)
		// for full sequence simulation
		initiate_parry_sequence(TRUE, determined)
		if(data.autoparry_sequence_start_time == -1)
			parry_start_time = world.time - data.parry_time_windup
		else
			parry_start_time = world.time - data.autoparry_sequence_start_time
		// recurse back to original
		return run_parry(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, FALSE)
	else
		// yes, this is mostly a copypaste of run_parry.
		var/efficiency = data.attack_type_list_scan(data.autoparry_single_efficiency_override, attack_type)
		if(isnull(efficiency))
			efficiency = data.autoparry_single_efficiency
		var/method = determined[1]
		switch(method)
			if(ITEM_PARRY)
				var/obj/item/I = determined[3]
				. = I.on_active_parry(src, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, efficiency, null, TRUE)
			if(UNARMED_PARRY)
				. = on_active_parry(src, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, efficiency, null, TRUE)
			if(MARTIAL_PARRY)
				. = mind.martial_art.on_active_parry(src, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, efficiency, null, TRUE)
		if(!isnull(return_list[BLOCK_RETURN_OVERRIDE_PARRY_EFFICIENCY]))		// one of our procs overrode
			efficiency = return_list[BLOCK_RETURN_OVERRIDE_PARRY_EFFICIENCY]
		if(efficiency <= 0)		// Do not allow automatically handled/standardized parries that increase damage for now.
			return
		. |= BLOCK_SHOULD_PARTIAL_MITIGATE
		if(efficiency >= data.parry_efficiency_perfect)
			. |= data.perfect_parry_block_return_flags
			if(data.perfect_parry_block_return_list)
				return_list |= data.perfect_parry_block_return_list
		else if(efficiency >= data.parry_efficiency_considered_successful)
			. |= data.imperfect_parry_block_return_flags
			if(data.imperfect_parry_block_return_list)
				return_list |= data.imperfect_parry_block_return_list
		else
			. |= data.failed_parry_block_return_flags
			if(data.failed_parry_block_return_list)
				return_list |= data.failed_parry_block_return_list
		if(isnull(return_list[BLOCK_RETURN_MITIGATION_PERCENT]))		//  if one of the on_active_parry procs overrode. We don't have to worry about interference since parries are the first thing checked in the [do_run_block()] sequence.
			return_list[BLOCK_RETURN_MITIGATION_PERCENT] = clamp(efficiency, 0, 100)		// do not allow > 100% or < 0% for now.
		if((return_list[BLOCK_RETURN_MITIGATION_PERCENT] >= 100) || (damage <= 0))
			. |= BLOCK_SUCCESS
		var/list/effect_text
		var/pacifist_counter_check = TRUE
		if(HAS_TRAIT(src, TRAIT_PACIFISM))
			switch(parrying)
				if(ITEM_PARRY)
					pacifist_counter_check = (!active_parry_item.force || active_parry_item.damtype == STAMINA)
				else
					pacifist_counter_check = FALSE //Both martial and unarmed counter attacks generally are harmful, so no need to have the same line twice.
		if(efficiency >= data.parry_efficiency_to_counterattack && pacifist_counter_check && !return_list[BLOCK_RETURN_FORCE_NO_PARRY_COUNTERATTACK] && (!(attacker in successful_parry_counterattacks) && !data.parry_allow_repeated_counterattacks))
			effect_text = run_parry_countereffects(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, efficiency, data)
		if(data.parry_flags & PARRY_DEFAULT_HANDLE_FEEDBACK)
			handle_parry_feedback(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, efficiency, effect_text, data)

/**
  * Gets the stage of our parry sequence we're currently in.
  */
/mob/living/proc/get_parry_stage()
	if(!parrying)
		return NOT_PARRYING
	var/datum/block_parry_data/data = get_parry_data()
	var/windup_end = data.parry_time_windup
	var/active_end = windup_end + data.parry_time_active
	var/spindown_end = active_end + data.parry_time_spindown
	var/current_time = get_parry_time()
	// Not a switch statement because byond switch statements don't support floats at time of writing with "to" keyword.
	if(current_time < 0)
		return NOT_PARRYING
	else if(current_time < windup_end)
		return PARRY_WINDUP
	else if(current_time <= active_end)		// this uses <= on purpose, give a slight bit of advantage because time is rounded to world.tick_lag
		return PARRY_ACTIVE
	else if(current_time <= spindown_end)
		return PARRY_SPINDOWN
	else
		return NOT_PARRYING

/**
  * Gets the current decisecond "frame" of an active parry.
  */
/mob/living/proc/get_parry_time()
	return world.time - parry_start_time

/// same return values as normal blocking, called with absolute highest priority in the block "chain".
/mob/living/proc/run_parry(atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list = list(), allow_auto = TRUE)
	var/stage = get_parry_stage()
	if(attack_type & ATTACK_TYPE_PARRY_COUNTERATTACK)
		return BLOCK_NONE		// don't infinite loop
	if(stage != PARRY_ACTIVE)
		// If they're not currently parrying, attempt auto parry
		if(stage == NOT_PARRYING)
			if(!allow_auto || SEND_SIGNAL(src, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_INACTIVE))
				return BLOCK_NONE
			return attempt_auto_parry(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list)
		else
			return BLOCK_NONE
	var/datum/block_parry_data/data = get_parry_data()
	if(attack_type && !(attack_type & data.parry_attack_types))
		return BLOCK_NONE
	var/efficiency = data.get_parry_efficiency(attack_type, get_parry_time())
	switch(parrying)
		if(ITEM_PARRY)
			if(!active_parry_item.can_active_parry(src))
				return BLOCK_NONE
			. = active_parry_item.on_active_parry(src, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, efficiency, get_parry_time())
		if(UNARMED_PARRY)
			. = on_active_parry(src, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, efficiency, get_parry_time())
		if(MARTIAL_PARRY)
			. = mind.martial_art.on_active_parry(src, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, efficiency, get_parry_time())
	if(!isnull(return_list[BLOCK_RETURN_OVERRIDE_PARRY_EFFICIENCY]))		// one of our procs overrode
		efficiency = return_list[BLOCK_RETURN_OVERRIDE_PARRY_EFFICIENCY]
	if(efficiency <= 0)		// Do not allow automatically handled/standardized parries that increase damage for now.
		return
	. |= BLOCK_SHOULD_PARTIAL_MITIGATE
	if(efficiency >= data.parry_efficiency_perfect)
		. |= data.perfect_parry_block_return_flags
		if(data.perfect_parry_block_return_list)
			return_list |= data.perfect_parry_block_return_list
	else if(efficiency >= data.parry_efficiency_considered_successful)
		. |= data.imperfect_parry_block_return_flags
		if(data.imperfect_parry_block_return_list)
			return_list |= data.imperfect_parry_block_return_list
	else
		. |= data.failed_parry_block_return_flags
		if(data.failed_parry_block_return_list)
			return_list |= data.failed_parry_block_return_list
	if(isnull(return_list[BLOCK_RETURN_MITIGATION_PERCENT]))		//  if one of the on_active_parry procs overrode. We don't have to worry about interference since parries are the first thing checked in the [do_run_block()] sequence.
		return_list[BLOCK_RETURN_MITIGATION_PERCENT] = clamp(efficiency, 0, 100)		// do not allow > 100% or < 0% for now.
	if((return_list[BLOCK_RETURN_MITIGATION_PERCENT] >= 100) || (damage <= 0))
		. |= BLOCK_SUCCESS
	var/list/effect_text
	var/pacifist_counter_check = TRUE
	if(HAS_TRAIT(src, TRAIT_PACIFISM))
		switch(parrying)
			if(ITEM_PARRY)
				pacifist_counter_check = (!active_parry_item.force || active_parry_item.damtype == STAMINA)
			else
				pacifist_counter_check = FALSE //Both martial and unarmed counter attacks generally are harmful, so no need to have the same line twice.
	if(efficiency >= data.parry_efficiency_to_counterattack && pacifist_counter_check && !return_list[BLOCK_RETURN_FORCE_NO_PARRY_COUNTERATTACK] && (!(attacker in successful_parry_counterattacks) && !data.parry_allow_repeated_counterattacks))
		effect_text = run_parry_countereffects(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, efficiency)
	if(data.parry_flags & PARRY_DEFAULT_HANDLE_FEEDBACK)
		handle_parry_feedback(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, efficiency, effect_text)
	successful_parries += efficiency
	if(length(successful_parries) >= data.parry_max_attacks)
		end_parry_sequence()

/mob/living/proc/handle_parry_feedback(atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list = list(), parry_efficiency, list/effect_text, datum/block_parry_data/data)
	if(!data)
		data = get_parry_data()
	var/knockdown_check = FALSE
	if(data.parry_data[PARRY_KNOCKDOWN_ATTACKER] && parry_efficiency >= data.parry_efficiency_to_counterattack)
		knockdown_check = TRUE
	if(data.parry_sounds)
		playsound(src, pick(data.parry_sounds), 75)
	visible_message("<span class='danger'>[src] parries [attack_text][length(effect_text)? ", [english_list(effect_text)] [attacker]" : ""][length(effect_text) && knockdown_check? " and" : ""][knockdown_check? " knocking them to the ground" : ""]!</span>")

/// Run counterattack if any
/mob/living/proc/run_parry_countereffects(atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list = list(), parry_efficiency, datum/block_parry_data/data)
	if(!isliving(attacker))
		return
	var/mob/living/L = attacker
	if(!data)
		data = get_parry_data()
	var/list/effect_text = list()
	successful_parry_counterattacks |= attacker
	// Always proc so items can override behavior easily
	switch(parrying)
		if(ITEM_PARRY)
			active_parry_item.active_parry_reflex_counter(src, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, parry_efficiency, effect_text)
		if(UNARMED_PARRY)
			active_parry_reflex_counter(src, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, parry_efficiency, effect_text)
		if(MARTIAL_PARRY)
			mind.martial_art.active_parry_reflex_counter(src, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list, parry_efficiency, effect_text)
	if(Adjacent(attacker) || data.parry_data[PARRY_COUNTERATTACK_IGNORE_ADJACENCY])
		if(data.parry_data[PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN])
			switch(parrying)
				if(ITEM_PARRY)
					active_parry_item.melee_attack_chain(src, attacker, null, ATTACK_IS_PARRY_COUNTERATTACK | ATTACK_IGNORE_CLICKDELAY | ATTACK_IGNORE_ACTION | NO_AUTO_CLICKDELAY_HANDLING, data.parry_data[PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN])
					effect_text += "reflexively counterattacking with [active_parry_item]"
				if(UNARMED_PARRY)		// WARNING: If you are using these two, the attackchain parry counterattack flags and damage multipliers are unimplemented. Be careful with how you handle this.
					UnarmedAttack(attacker)
					effect_text += "reflexively counterattacking in the process"
				if(MARTIAL_PARRY)		// Not well implemeneted, recommend custom implementation using the martial art datums.
					UnarmedAttack(attacker)
					effect_text += "reflexively maneuvering to retaliate"
		if(data.parry_data[PARRY_DISARM_ATTACKER])
			L.drop_all_held_items()
			effect_text += "disarming"
		if(data.parry_data[PARRY_STAGGER_ATTACKER])
			L.Stagger(data.parry_data[PARRY_STAGGER_ATTACKER])
			effect_text += "staggering"
		if(data.parry_data[PARRY_DAZE_ATTACKER])
			L.Daze(data.parry_data[PARRY_DAZE_ATTACKER])
			effect_text += "dazing"
		if(data.parry_data[PARRY_KNOCKDOWN_ATTACKER])
			L.DefaultCombatKnockdown(data.parry_data[PARRY_KNOCKDOWN_ATTACKER])
			// effect_text += "knocking them to the ground" - snowflaked above
	return effect_text

/// Gets the datum/block_parry_data we're going to use to parry.
/mob/living/proc/get_parry_data()
	if(parrying == ITEM_PARRY)
		return active_parry_item.get_block_parry_data()
	else if(parrying == UNARMED_PARRY)
		return return_block_parry_datum(block_parry_data)
	else if(parrying == MARTIAL_PARRY)
		return return_block_parry_datum(mind.martial_art.block_parry_data)

/// Effects
/obj/effect/abstract/parry
	icon = 'icons/effects/block_parry.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = FLOAT_LAYER
	plane = FLOAT_PLANE
	vis_flags = VIS_INHERIT_LAYER|VIS_INHERIT_PLANE
	/// The person we're on
	var/mob/living/owner

/obj/effect/abstract/parry/main
	name = null

/obj/effect/abstract/parry/main/Initialize(mapload, autorun, mob/living/owner, set_icon_state, windup, active, spindown)
	. = ..()
	icon_state = set_icon_state
	if(owner)
		attach_to(owner)
	if(autorun)
		INVOKE_ASYNC(src, .proc/run_animation, windup, active, spindown)

/obj/effect/abstract/parry/main/Destroy()
	detach_from(owner)
	return ..()

/obj/effect/abstract/parry/main/proc/attach_to(mob/living/attaching)
	if(owner)
		detach_from(owner)
	owner = attaching
	owner.vis_contents += src

/obj/effect/abstract/parry/main/proc/detach_from(mob/living/detaching)
	if(detaching == owner)
		owner = null
	detaching.vis_contents -= src

/obj/effect/abstract/parry/main/proc/run_animation(windup_time = 2, active_time = 5, spindown_time = 3)
	var/matrix/current = transform
	transform = matrix(0.1, 0, 0, 0, 0.1, 0)
	animate(src, transform = current, time = windup_time)
	sleep(active_time)
	animate(src, alpha = 0, spindown_time)
