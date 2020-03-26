// Active directional block system. Shared code is in [living_blocking_parrying.dm]
/mob/living
	/// Whether or not the user is actively blocking.
	var/active_blocking = FALSE
	/// The item the user is actively blocking with if any.
	var/obj/item/active_block_item

/mob/living/on_item_dropped(obj/item/I)
	if(I == active_block_item)
		stop_active_blocking()
	return ..()

/mob/living/proc/stop_active_blocking()
	var/obj/item/I = active_block_item
	active_blocking = FALSE
	active_block_item = null
	REMOVE_TRAIT(src, TRAIT_MOBILITY_NOUSE, ACTIVE_BLOCK_TRAIT)
	remove_movespeed_modifier(MOVESPEED_ID_ACTIVE_BLOCK)
	if(timeToNextMove() < I.block_parry_data.block_end_click_cd_add)
		changeNext_move(I.block_parry_data.block_end_click_cd_add)
	active_block_effect_end()
	return TRUE

/mob/living/proc/start_active_blocking(obj/item/I)
	if(active_blocking)
		return FALSE
	if(!(I in held_items))
		return FALSE
	if(!istype(I.block_parry_data))		//Typecheck because if an admin/coder screws up varediting or something we do not want someone being broken forever, the CRASH logs feedback so we know what happened.
		CRASH("start_active_blocking called with an item with no valid block_parry_data: [I.block_parry_data]!")
	active_blocking = TRUE
	active_block_item = I
	if(I.block_parry_data.block_lock_attacking)
		ADD_TRAIT(src, TRAIT_MOBILITY_NOMOVE, ACTIVE_BLOCK_TRAIT)
	add_movespeed_modifier(MOVESPEED_ID_ACTIVE_BLOCK, TRUE, 100, override = TRUE, multiplicative_slowdown = I.block_parry_data.block_slowdown, blacklisted_movetypes = FLOATING)
	active_block_effect_start()
	return TRUE

/// Visual effect setup for starting a directional block
/mob/living/proc/active_block_effect_start()

/// Visual effect cleanup for starting a directional block
/mob/living/proc/active_block_effect_end()

/mob/living/get_standard_pixel_x_offset()
	. = ..()
	if(active_blocking)
		if(dir & EAST)
			. += 12
		if(dir & WEST)
			. -= 12

/mob/living/get_standard_pixel_y_offset()
	. = ..()
	if(active_blocking)
		if(dir & NORTH)
			. += 12
		if(dir & SOUTH)
			. -= 12

/// The amount of damage that is blocked.
/obj/item/proc/active_block_damage_mitigation(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	var/absorption = block_parry_data.block_damage_absorption_override[attack_type]
	var/efficiency = block_parry_data.block_damage_multiplier_override[attack_type]
	var/limit = block_parry_data.block_damage_limit_override[attack_type]
	// must use isnulls to handle 0's.
	if(isnull(absorption))
		absorption = block_parry_data.block_damage_absorption
	if(isnull(efficiency))
		efficiency = block_parry_data.block_damage_multiplier
	if(isnull(limit))
		limit = block_parry_data.block_damage_limit
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
/obj/item/proc/active_block_stamina_cost(mob/living/owner, atom/object, damage_blocked, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	var/efficiency = block_parry_data.block_stamina_efficiency_override[attack_type]
	if(isnull(efficiency))
		efficiency = block_parry_data.block_stamina_efficiency
	return damage_blocked / efficiency

/// Apply the stamina damage to our user, notice how damage argument is stamina_amount.
/obj/item/proc/active_block_do_stamina_damage(mob/living/owner, atom/object, stamina_amount, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		var/held_index = C.get_held_index_of_item(src)
		var/obj/item/bodypart/BP = C.hand_bodyparts[held_index]
		if(!BP?.body_zone)
			return C.adjustStaminaLossBuffered(stamina_amount)		//nah
		var/zone = BP.body_zone
		var/stamina_to_zone = block_parry_data.block_stamina_limb_ratio * stamina_amount
		var/stamina_to_chest = stamina_amount - stamina_to_zone
		var/stamina_buffered = stamina_to_chest * block_parry_data.block_stamina_buffer_ratio
		stamina_to_chest -= stamina_buffered
		C.apply_damage(stamina_to_zone, STAMINA, zone)
		C.apply_damage(stamina_to_chest, STAMINA, BODY_ZONE_CHEST)
		C.adjustStaminaLossBuffered(stamina_buffered)
	else
		owner.adjustStaminaLossBuffered(stamina_amount)

/obj/item/proc/active_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!CHECK_BITFIELD(item_flags, ITEM_CAN_BLOCK))
		return
	if(!CHECK_BITFIELD(item_flags, ITEM_CAN_BLOCK))
		return
	var/incoming_direction = get_dir(get_turf(attacker) || get_turf(object), src)
	if(!can_block_direction(owner.dir, incoming_direction))
		return
	block_return[BLOCK_RETURN_ACTIVE_BLOCK] = TRUE
	var/damage_mitigated = active_block_damage_mitigation(owner, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return)
	var/final_damage = max(0, damage - damage_mitigated)
	var/stamina_cost = active_block_stamina_cost(owner, object, final_damage, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return)
	active_block_do_stamina_damage(owner, object, stamina_cost, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return)
	block_return[BLOCK_RETURN_ACTIVE_BLOCK_DAMAGE_MITIGATED] = damage_mitigated
	block_return[BLOCK_RETURN_SET_DAMAGE_TO] = final_damage
	. = BLOCK_CHANGE_DAMAGE
	if(final_damage <= 0)
		. |= BLOCK_SUCCESS			//full block
		owner.visible_message("<span class='warning'>[owner] blocks \the [attack_text] with [src]!</span>")
	else
		owner.visible_message("<span class='warning'>[owner] dampens \the [attack_text] with [src]!</span>")

/obj/item/proc/check_active_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!CHECK_BITFIELD(item_flags, ITEM_CAN_BLOCK))
		return
	var/incoming_direction = get_dir(get_turf(attacker) || get_turf(object), src)
	if(!can_block_direction(owner.dir, incoming_direction))
		return
	block_return[BLOCK_RETURN_ACTIVE_BLOCK] = TRUE
	block_return[BLOCK_RETURN_ACTIVE_BLOCK_DAMAGE_MITIGATED] = active_block_damage_mitigation(owner, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, final_block_chance, block_return)

/**
  * Gets the list of directions we can block. Include DOWN to block attacks from our same tile.
  */
/obj/item/proc/blockable_directions()
	return block_parry_data.can_block_directions

/**
  * Checks if we can block from a specific direction from our direction.
  *
  * @params
  * * our_dir - our direction.
  * * their_dir - their direction. Must be a single direction, or NONE for an attack from the same tile.
  */
/obj/item/proc/can_block_direction(our_dir, their_dir)
	if(our_dir != NORTH)
		var/turn_angle = dir2angle(our_dir)
		// dir2angle(), ss13 proc is clockwise so dir2angle(EAST) == 90
		// turn(), byond proc is counterclockwise so turn(NORTH, 90) == WEST
		their_dir = turn(their_dir, turn_angle)
	return (DIR2BLOCKDIR(their_dir) in blockable_directions())

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
