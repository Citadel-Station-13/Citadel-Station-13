// yell at me later for file naming
// This file contains stuff relating to the new directional blocking and parry system.
/mob/living
	var/obj/item/active_block_item
	var/obj/item/active_parry_item
	var/parrying = FALSE
	var/parry_frame = 0


GLOBAL_LIST_EMPTY(block_parry_data)

/proc/get_block_parry_data(type_or_id)
	if(ispath(type_or_id))
		. = GLOB.block_parry_data["[type_or_id]"]
		if(!.)
			. = GLOB.block_parry_data["[type_or_id]"] = new type_or_id
	else		//text id
		return GLOB.block_parry_data["[type_or_id]"]

/proc/set_block_parry_data(id, datum/block_parry_data/data)
	if(ispath(id))
		CRASH("Path-fetching of block parry data is only to grab static data, do not attempt to modify global caches of paths. Use string IDs.")
	GLOB.block_parry_data["[id]"] = data

/// Carries data like list data that would be a waste of memory if we initialized the list on every /item as we can cache datums easier.
/datum/block_parry_data
	/////////// BLOCKING ////////////
	/// See defines.
	var/can_block_directions = BLOCK_DIR_NORTH | BLOCK_DIR_NORTHEAST | BLOCK_DIR_NORTHWEST
	/// Our slowdown added while blocking
	var/block_slowdown = 2
	/// Clickdelay added to user after block ends
	var/block_end_click_cd_add = 4
	/// Disallow attacking during block
	var/block_lock_attacking = TRUE
	/// The priority we get in [mob/do_run_block()] while we're being used to parry.
	var/block_active_priority = BLOCK_PRIORITY_ACTIVE_BLOCK

	/// Amount of "free" damage blocking absorbs
	var/block_damage_absorption = 10
	/// Override absorption, list(ATTACK_TYPE_DEFINE = absorption), see [block_damage_absorption]
	var/list/block_damage_absorption_override

	/// Ratio of damage block above absorption amount, coefficient, lower is better, this is multiplied by damage to determine how much is blocked.
	var/block_damage_multiplier = 0.5
	/// Override damage overrun efficiency, list(ATTACK_TYPE_DEFINE = absorption), see [block_damage_efficiency]
	var/list/block_damage_multiplier_override

	/// Upper bound of damage block, anything above this will go right through.
	var/block_damage_limit = 80
	/// Override upper bound of damage block, list(ATTACK_TYPE_DEFINE = absorption), see [block_damage_limit]
	var/list/block_damage_limit_override

	/// Default damage-to-stamina coefficient, higher is better. This is based on amount of damage BLOCKED, not initial damage, to prevent damage from "double dipping".
	var/block_stamina_efficiency = 2
	/// Override damage-to-stamina coefficient, see [block_efficiency], this should be list(ATTACK_TYPE_DEFINE = coefficient_number)
	var/list/block_stamina_efficiency_override

	/// Ratio of stamina incurred by blocking that goes to the arm holding the object instead of the chest. Has no effect if this is not held in hand.
	var/block_stamina_limb_ratio = 0.5
	/// Override stamina limb ratio, list(ATTACK_TYPE_DEFINE = absorption), see [block_stamina_limb_ratio]
	var/list/block_stamina_limb_ratio_override

	/// Stamina dealt directly via adjustStaminaLoss() per SECOND of block.
	var/block_stamina_cost_per_second = 1.5

	/////////// PARRYING ////////////
	/// Prioriry for [mob/do_run_block()] while we're being used to parry.
	var/parry_active_priority = BLOCK_PRIORITY_ACTIVE_PARRY
	/// Parry windup duration in deciseconds
	var/parry_time_windup = 2
	/// Parry spooldown duration in deciseconds
	var/parry_time_spooldown = 3
	/// Main parry window in deciseconds
	var/parry_time_active = 5
	/// Perfect parry window in deciseconds from the main window. 3 with main 5 = perfect on third decisecond of main window.
	var/parry_time_perfect = 2.5
	/// Time on both sides of perfect parry that still counts as well, perfect
	var/parry_time_perfect_leeway = 1
	/// [parry_time_perfect_leeway] override for attack types, list(ATTACK_TYPE_DEFINE = deciseconds)
	var/list/parry_time_perfect_leeway_override
	/// Parry "efficiency" falloff in percent per decisecond once perfect window is over.
	var/parry_imperfect_falloff_percent = 20
	/// [parry_imperfect_falloff_percent] override for attack types, list(ATTACK_TYPE_DEFINE = deciseconds)
	var/list/parry_time_imperfect_falloff_percent_override
	/// Efficiency in percent on perfect parry.
	var/parry_efficiency_perfect = 120



/obj/item/proc/active_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!CHECK_BITFIELD(item_flags, ITEM_CAN_BLOCK))
		return
	/// Yadda yadda WIP access block/parry data...

/obj/item/proc/active_parry(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!CHECK_BITFIELD(item_flags, ITEM_CAN_PARRY))
		return
	/// Yadda yadda WIP access block/parry data...

/obj/item/proc/check_active_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!CHECK_BITFIELD(item_flags, ITEM_CAN_BLOCK))
		return
	/// Yadda yadda WIP access block/parry data...

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
