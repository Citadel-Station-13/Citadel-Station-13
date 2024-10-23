// Active directional block system. Shared code is in [living_blocking_parrying.dm]
/mob/living/proc/stop_active_blocking(was_forced = FALSE)
	if(!(combat_flags & (COMBAT_FLAG_ACTIVE_BLOCK_STARTING | COMBAT_FLAG_ACTIVE_BLOCKING)))
		return FALSE
	var/obj/item/I = active_block_item
	combat_flags &= ~(COMBAT_FLAG_ACTIVE_BLOCKING | COMBAT_FLAG_ACTIVE_BLOCK_STARTING)
	active_block_effect_end()
	active_block_item = null
	REMOVE_TRAIT(src, TRAIT_MOBILITY_NOUSE, ACTIVE_BLOCK_TRAIT)
	REMOVE_TRAIT(src, TRAIT_SPRINT_LOCKED, ACTIVE_BLOCK_TRAIT)
	REMOVE_TRAIT(src, TRAIT_NO_STAMINA_BUFFER_REGENERATION, ACTIVE_BLOCK_TRAIT)
	REMOVE_TRAIT(src, TRAIT_NO_STAMINA_REGENERATION, ACTIVE_BLOCK_TRAIT)
	remove_movespeed_modifier(/datum/movespeed_modifier/active_block)
	var/datum/block_parry_data/data = I.get_block_parry_data()
	DelayNextAction(data.block_end_click_cd_add)
	return TRUE

/mob/living/proc/active_block_start(obj/item/I)
	if(combat_flags & (COMBAT_FLAG_ACTIVE_BLOCK_STARTING | COMBAT_FLAG_ACTIVE_BLOCKING))
		return FALSE
	if(!(I in held_items))
		return FALSE
	var/datum/block_parry_data/data = I.get_block_parry_data()
	if(!istype(data))		//Typecheck because if an admin/coder screws up varediting or something we do not want someone being broken forever, the CRASH logs feedback so we know what happened.
		CRASH("ACTIVE_BLOCK_START called with an item with no valid data: [I] --> [I.block_parry_data]!")
	combat_flags |= COMBAT_FLAG_ACTIVE_BLOCKING
	active_block_item = I
	if(data.block_lock_attacking)
		ADD_TRAIT(src, TRAIT_MOBILITY_NOUSE, ACTIVE_BLOCK_TRAIT)		//probably should be something else at some point
	if(data.block_lock_sprinting)
		ADD_TRAIT(src, TRAIT_SPRINT_LOCKED, ACTIVE_BLOCK_TRAIT)
	if(data.block_no_stamina_regeneration)
		ADD_TRAIT(src, TRAIT_NO_STAMINA_REGENERATION, ACTIVE_BLOCK_TRAIT)
	if(data.block_no_stambuffer_regeneration)
		ADD_TRAIT(src, TRAIT_NO_STAMINA_BUFFER_REGENERATION, ACTIVE_BLOCK_TRAIT)
	add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/active_block, multiplicative_slowdown = data.block_slowdown)
	active_block_effect_start()
	return TRUE

/// Visual effect setup for starting a directional block
/mob/living/proc/active_block_effect_start()
	visible_message("<span class='warning'>[src] raises their [active_block_item], dropping into a defensive stance!</span>")
	animate(src, pixel_x = get_standard_pixel_x_offset(), pixel_y = get_standard_pixel_y_offset(), time = 2.5, FALSE, SINE_EASING | EASE_OUT)

/// Visual effect cleanup for starting a directional block
/mob/living/proc/active_block_effect_end()
	visible_message("<span class='warning'>[src] lowers their [active_block_item].</span>")
	animate(src, pixel_x = get_standard_pixel_x_offset(), pixel_y = get_standard_pixel_y_offset(), time = 2.5, FALSE, SINE_EASING | EASE_IN)

/mob/living/proc/continue_starting_active_block()
	return (combat_flags & COMBAT_FLAG_ACTIVE_BLOCK_STARTING)

/mob/living/get_standard_pixel_x_offset()
	. = ..()
	if(combat_flags & (COMBAT_FLAG_ACTIVE_BLOCK_STARTING | COMBAT_FLAG_ACTIVE_BLOCKING))
		if(dir & EAST)
			. += 4
		if(dir & WEST)
			. -= 4

/mob/living/get_standard_pixel_y_offset()
	. = ..()
	if(combat_flags & (COMBAT_FLAG_ACTIVE_BLOCK_STARTING | COMBAT_FLAG_ACTIVE_BLOCKING))
		if(dir & NORTH)
			. += 4
		if(dir & SOUTH)
			. -= 4

/**
  * Proc called by keybindings to toggle active blocking.
  */
/mob/living/proc/keybind_toggle_active_blocking()
	if(combat_flags & (COMBAT_FLAG_ACTIVE_BLOCK_STARTING | COMBAT_FLAG_ACTIVE_BLOCKING))
		return keybind_stop_active_blocking()
	else
		return keybind_start_active_blocking()

/**
  * Proc called by keybindings to start active blocking.
  */
/mob/living/proc/keybind_start_active_blocking()
	if(combat_flags & (COMBAT_FLAG_ACTIVE_BLOCK_STARTING | COMBAT_FLAG_ACTIVE_BLOCKING))
		return FALSE
	if(!(combat_flags & COMBAT_FLAG_BLOCK_CAPABLE))
		to_chat(src, "<span class='warning'>You're not something that can actively block.</span>")
		return FALSE
	// QOL: Instead of trying to just block with held item, grab first available item.
	var/obj/item/I = find_active_block_item()
	var/list/other_items = list()
	if(SEND_SIGNAL(src, COMSIG_LIVING_ACTIVE_BLOCK_START, I, other_items) & COMPONENT_PREVENT_BLOCK_START)
		to_chat(src, "<span class='warning'>Something is preventing you from blocking!</span>")
		return
	if(!I)
		if(!length(other_items))
			to_chat(src, "<span class='warning'>You can't block with your bare hands!</span>")
			return
		I = other_items[1]
	if(!I.can_active_block())
		to_chat(src, "<span class='warning'>[I] is either not capable of being used to actively block, or is not currently in a state that can! (Try wielding it if it's twohanded, for example.)</span>")
		return
	var/datum/block_parry_data/data = I.get_block_parry_data()
	var/delay = data.block_start_delay
	combat_flags |= COMBAT_FLAG_ACTIVE_BLOCK_STARTING
	animate(src, pixel_x = get_standard_pixel_x_offset(), pixel_y = get_standard_pixel_y_offset(), time = delay, FALSE, SINE_EASING | EASE_IN)
	if(!do_after(src, delay, src, (IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE), extra_checks = CALLBACK(src, PROC_REF(continue_starting_active_block))))
		to_chat(src, "<span class='warning'>You fail to raise [I].</span>")
		combat_flags &= ~(COMBAT_FLAG_ACTIVE_BLOCK_STARTING)
		animate(src, pixel_x = get_standard_pixel_x_offset(), pixel_y = get_standard_pixel_y_offset(), time = 2.5, FALSE, SINE_EASING | EASE_IN, ANIMATION_END_NOW)
		return
	combat_flags &= ~(COMBAT_FLAG_ACTIVE_BLOCK_STARTING)
	active_block_start(I)

/**
  * Gets the first item we can that can block, but if that fails, default to active held item.COMSIG_ENABLE_COMBAT_MODE
  */
/mob/living/proc/find_active_block_item()
	var/obj/item/held = get_active_held_item()
	if(!held?.can_active_block())
		for(var/obj/item/I in held_items - held)
			if(I.can_active_block())
				return I
	else
		return held

/**
  * Proc called by keybindings to stop active blocking.
  */
/mob/living/proc/keybind_stop_active_blocking()
	combat_flags &= ~(COMBAT_FLAG_ACTIVE_BLOCK_STARTING)
	if(combat_flags & COMBAT_FLAG_ACTIVE_BLOCKING)
		stop_active_blocking(FALSE)
	return TRUE

/**
  * Returns if we can actively block.
  */
/obj/item/proc/can_active_block()
	return block_parry_data && (item_flags & ITEM_CAN_BLOCK)

/**
  * Calculates FINAL ATTACK DAMAGE after mitigation
  */
/obj/item/proc/active_block_calculate_final_damage(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return, passive = FALSE)
	var/datum/block_parry_data/data = get_block_parry_data()
	var/absorption = data.attack_type_list_scan(data.block_damage_absorption_override, attack_type)
	var/efficiency = data.attack_type_list_scan(data.block_damage_multiplier_override, attack_type)
	var/limit = data.attack_type_list_scan(data.block_damage_limit_override, attack_type)
	// must use isnulls to handle 0's.
	if(isnull(absorption))
		absorption = data.block_damage_absorption
	if(isnull(efficiency))
		efficiency = data.block_damage_multiplier * (passive? (1 / data.block_automatic_mitigation_multiplier) : 1)
	if(isnull(limit))
		limit = data.block_damage_limit
	// now we calculate damage to reduce.
	var/final_damage = 0
	// apply limit
	if(damage > limit)		//clamp and apply overrun
		final_damage += (damage - limit)
		damage = limit
	// apply absorption
	damage -= min(absorption, damage)		//this way if damage is less than absorption it 0's properly.
	// apply multiplier to remaining
	final_damage += (damage * efficiency)
	return final_damage

/// Amount of stamina from damage blocked. Note that the damage argument is damage_blocked.
/obj/item/proc/active_block_stamina_cost(mob/living/owner, atom/object, damage_blocked, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return, passive = FALSE)
	var/datum/block_parry_data/data = get_block_parry_data()
	var/efficiency = data.attack_type_list_scan(data.block_stamina_efficiency_override, attack_type)
	if(isnull(efficiency))
		efficiency = data.block_stamina_efficiency
	var/multiplier = 1
	if(!CHECK_MOBILITY(owner, MOBILITY_STAND))
		multiplier = data.attack_type_list_scan(data.block_resting_stamina_penalty_multiplier_override, attack_type)
		if(isnull(multiplier))
			multiplier = data.block_resting_stamina_penalty_multiplier
	return (damage_blocked / efficiency) * multiplier * (passive? data.block_automatic_stamina_multiplier : 1)

/// Apply the stamina damage to our user, notice how damage argument is stamina_amount.
/obj/item/proc/active_block_do_stamina_damage(mob/living/owner, atom/object, stamina_amount, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(istype(object, /obj/item/projectile))
		var/obj/item/projectile/P = object
		if(P.stamina)
			var/blocked = active_block_calculate_final_damage(owner, object, P.stamina, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return)
			var/stam = active_block_stamina_cost(owner, object, blocked, attack_text, ATTACK_TYPE_PROJECTILE, armour_penetration, attacker, def_zone, final_block_chance, block_return)
			stamina_amount += stam
	var/datum/block_parry_data/data = get_block_parry_data()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		var/held_index = C.get_held_index_of_item(src)
		var/obj/item/bodypart/BP = C.hand_bodyparts[held_index]
		if(!BP?.body_zone)
			return C.adjustStaminaLoss(stamina_amount)		//nah
		var/zone = BP.body_zone
		var/stamina_to_zone = data.block_stamina_limb_ratio * stamina_amount
		var/stamina_to_chest = stamina_amount - stamina_to_zone
		var/stamina_buffered = stamina_to_chest * data.block_stamina_buffer_ratio
		stamina_to_chest -= stamina_buffered
		C.apply_damage(stamina_to_zone, STAMINA, zone)
		C.apply_damage(stamina_to_chest, STAMINA, BODY_ZONE_CHEST)
		C.adjustStaminaLoss(stamina_buffered)
	else
		owner.adjustStaminaLoss(stamina_amount)

/obj/item/proc/on_active_block(mob/living/owner, atom/object, damage, damage_blocked, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return, override_direction)
	return

/obj/item/proc/active_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return, override_direction)
	return directional_block(owner, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return, override_direction)

/obj/item/proc/can_passive_block()
	if(!block_parry_data || !(item_flags & ITEM_CAN_BLOCK))
		return FALSE
	var/datum/block_parry_data/data = return_block_parry_datum(block_parry_data)
	return data.block_automatic_enabled

/obj/item/proc/passive_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return, override_direction)
	return directional_block(owner, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return, override_direction, TRUE)

/obj/item/proc/directional_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return, override_direction, passive = FALSE)
	if(!can_active_block())
		return BLOCK_NONE
	var/datum/block_parry_data/data = get_block_parry_data()
	if(attack_type && !(attack_type & data.can_block_attack_types))
		return BLOCK_NONE
	var/incoming_direction
	if(isnull(override_direction))
		if(istype(object, /obj/item/projectile))
			var/obj/item/projectile/P = object
			incoming_direction = angle2dir(P.Angle)
		else
			incoming_direction = get_dir(get_turf(attacker) || get_turf(object), src)
	if(!CHECK_MOBILITY(owner, MOBILITY_STAND) && !(data.block_resting_attack_types_anydir & attack_type) && (!(data.block_resting_attack_types_directional & attack_type) || !can_block_direction(owner.dir, incoming_direction)))
		return BLOCK_NONE
	else if(!can_block_direction(owner.dir, incoming_direction, passive))
		return BLOCK_NONE
	block_return[BLOCK_RETURN_ACTIVE_BLOCK] = TRUE
	var/final_damage = active_block_calculate_final_damage(owner, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return, passive)
	var/damage_blocked = damage - final_damage
	var/stamina_cost = active_block_stamina_cost(owner, object, damage_blocked, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return, passive)
	active_block_do_stamina_damage(owner, object, stamina_cost, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return)
	block_return[BLOCK_RETURN_ACTIVE_BLOCK_DAMAGE_MITIGATED] = damage - final_damage
	block_return[BLOCK_RETURN_SET_DAMAGE_TO] = final_damage
	block_return[BLOCK_RETURN_MITIGATION_PERCENT] = clamp(1 - (final_damage / damage), 0, 1)
	. = BLOCK_SHOULD_CHANGE_DAMAGE
	if((final_damage <= 0) || (damage <= 0))
		. |= BLOCK_SUCCESS			//full block
		owner.visible_message("<span class='warning'>[owner] blocks \the [attack_text] with [src]!</span>")
	else
		owner.visible_message("<span class='warning'>[owner] dampens \the [attack_text] with [src]!</span>")
	block_return[BLOCK_RETURN_PROJECTILE_BLOCK_PERCENTAGE] = data.block_projectile_mitigation
	if(length(data.block_sounds))
		playsound(loc, pickweight(data.block_sounds), 75, TRUE)
	on_active_block(owner, object, damage, damage_blocked, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return, override_direction)

/obj/item/proc/check_active_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!can_active_block())
		return
	var/incoming_direction = get_dir(get_turf(attacker) || get_turf(object), src)
	if(!can_block_direction(owner.dir, incoming_direction))
		return
	block_return[BLOCK_RETURN_ACTIVE_BLOCK] = TRUE
	block_return[BLOCK_RETURN_ACTIVE_BLOCK_DAMAGE_MITIGATED] = damage - active_block_calculate_final_damage(owner, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return)

/**
  * Gets the block direction bitflags of what we can block.
  */
/obj/item/proc/blockable_directions(passive = FALSE)
	var/datum/block_parry_data/data = get_block_parry_data()
	return (!isnull(data.block_automatic_directions) && passive)? data.block_automatic_directions : data.can_block_directions

/**
  * Checks if we can block from a specific direction from our direction.
  *
  * @params
  * * our_dir - our direction.
  * * their_dir - their direction. Must be a single direction, or NONE for an attack from the same tile. This is incoming direction.
  */
/obj/item/proc/can_block_direction(our_dir, their_dir, passive = FALSE)
	their_dir = turn(their_dir, 180)
	if(our_dir != NORTH)
		var/turn_angle = dir2angle(our_dir)
		// dir2angle(), ss13 proc is clockwise so dir2angle(EAST) == 90
		// turn(), byond proc is counterclockwise so turn(NORTH, 90) == WEST
		their_dir = turn(their_dir, turn_angle)
	return (DIR2BLOCKDIR(their_dir) & blockable_directions(passive))

/**
  * can_block_direction but for "compound" directions to check all of them and return the number of directions that were blocked.
  *
  * @params
  * * our_dir - our direction.
  * * their_dirs - list of their directions as we cannot use bitfields here.
  */
/obj/item/proc/can_block_directions_multiple(our_dir, list/their_dirs)
	. = FALSE
	for(var/i in their_dirs)
		. |= can_block_direction(our_dir, i)
