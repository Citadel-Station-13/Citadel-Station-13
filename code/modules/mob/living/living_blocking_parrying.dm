// yell at me later for file naming
// This file contains stuff relating to the new directional blocking and parry system.
/mob/living
	/// Whether ot not the user is in the middle of an active parry. Set to [UNARMED_PARRY], [ITEM_PARRY], [MARTIAL_PARRY] if parrying.
	var/parrying = FALSE
	/// The itme the user is currently parrying with, if any.
	var/obj/item/active_parry_item
	/// world.time of parry action start
	var/parry_start_time = 0
	/// Whether or not we can unarmed parry
	var/parry_while_unarmed = FALSE
	/// Should we prioritize martial art parrying when unarmed?
	var/parry_prioritize_martial = TRUE
	/// Our block_parry_data for unarmed blocks/parries. Currently only used for parrying, as unarmed block isn't implemented yet.
	var/datum/block_parry_data/block_parry_data

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

	/*
	 * NOTE: Overrides for attack types for most the block_stamina variables were removed,
	 * because at the time of writing nothing needed to use it. Add them if you need it,
	 * it should be pretty easy, just copy [active_block_damage_mitigation]
	 * for how to override with list.
	 */

	/// Default damage-to-stamina coefficient, higher is better. This is based on amount of damage BLOCKED, not initial damage, to prevent damage from "double dipping".
	var/block_stamina_efficiency = 2
	/// Override damage-to-stamina coefficient, see [block_efficiency], this should be list(ATTACK_TYPE_DEFINE = coefficient_number)
	var/list/block_stamina_efficiency_override
	/// Ratio of stamina incurred by blocking that goes to the arm holding the object instead of the chest. Has no effect if this is not held in hand.
	var/block_stamina_limb_ratio = 0.5
	/// Ratio of stamina incurred by chest (so after [block_stamina_limb_ratio] runs) that is buffered.
	var/block_stamina_buffer_ratio = 1

	/// Stamina dealt directly via adjustStaminaLossBuffered() per SECOND of block.
	var/block_stamina_cost_per_second = 1.5

	/////////// PARRYING ////////////
	/// Prioriry for [mob/do_run_block()] while we're being used to parry.
	//  None - Parry is always highest priority!

	/// Parry windup duration in deciseconds
	var/parry_time_windup = 2
	/// Parry spindown duration in deciseconds
	var/parry_time_spindown = 3
	/// Main parry window in deciseconds
	var/parry_time_active = 5
	/// Perfect parry window in deciseconds from the main window. 3 with main 5 = perfect on third decisecond of main window.
	var/parry_time_perfect = 2.5
	/// Time on both sides of perfect parry that still counts as well, perfect
	var/parry_time_perfect_leeway = 1
	/// [parry_time_perfect_leeway] override for attack types, list(ATTACK_TYPE_DEFINE = deciseconds)
	var/list/parry_time_perfect_leeway_override
	/// Parry "efficiency" falloff in percent per decisecond once perfect window is over.
	var/parry_time_imperfect_falloff_percent = 20
	/// [parry_imperfect_falloff_percent] override for attack types, list(ATTACK_TYPE_DEFINE = deciseconds)
	var/list/parry_time_imperfect_falloff_percent_override
	/// Efficiency in percent on perfect parry.
	var/parry_efficiency_perfect = 120

/obj/item/proc/active_parry(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!CHECK_BITFIELD(item_flags, ITEM_CAN_PARRY))
		return
	/// Yadda yadda WIP access block/parry data...

/// same return values as normal blocking, called with absolute highest priority in the block "chain".
/mob/living/proc/run_parry(real_attack = TRUE, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list = list())

/// Gets the datum/block_parry_data we're going to use to parry.
/mob/living/proc/get_parry_data()
	if(parrying == ITEM_PARRY)
		return active_parry_item.block_parry_data
	else if(parrying == UNARMED_PARRY)
		return block_parry_data
	else if(parrying == MARTIAL_PARRY)
		return mind.martial_art.block_parry_data

#define UNARMED_PARRY
#define MARTIAL_PARRY
#define ITEM_PARRY

