// yell at me later for file naming
// This file contains stuff relating to the new directional blocking and parry system.
GLOBAL_LIST_EMPTY(block_parry_data)

/proc/return_block_parry_datum(datum/block_parry_data/type_id_datum)
	if(istype(type_id_datum))
		return type_id_datum
	if(ispath(type_id_datum))
		. = GLOB.block_parry_data["[type_id_datum]"]
		if(!.)
			. = GLOB.block_parry_data["[type_id_datum]"] = new type_id_datum
	else		//text id
		return GLOB.block_parry_data["[type_id_datum]"]

/proc/set_block_parry_datum(id, datum/block_parry_data/data)
	if(ispath(id))
		CRASH("Path-fetching of block parry data is only to grab static data, do not attempt to modify global caches of paths. Use string IDs.")
	GLOB.block_parry_data["[id]"] = data

/// Carries data like list data that would be a waste of memory if we initialized the list on every /item as we can cache datums easier.
/datum/block_parry_data
	/////////// BLOCKING ////////////

	/// NOTE: FOR ATTACK_TYPE_DEFINE, you MUST wrap it in "[DEFINE_HERE]"! The defines are bitflags, and therefore, NUMBERS!

	/// See defines. Point of reference is someone facing north.
	var/can_block_directions = BLOCK_DIR_NORTH | BLOCK_DIR_NORTHEAST | BLOCK_DIR_NORTHWEST
	/// Attacks we can block
	var/can_block_attack_types = ALL
	/// Our slowdown added while blocking
	var/block_slowdown = 2
	/// Clickdelay added to user after block ends
	var/block_end_click_cd_add = 4
	/// Disallow attacking during block
	var/block_lock_attacking = TRUE
	/// The priority we get in [mob/do_run_block()] while we're being used to parry.
	var/block_active_priority = BLOCK_PRIORITY_ACTIVE_BLOCK
	/// Windup before we have our blocking active.
	var/block_start_delay = 5

	/// Amount of "free" damage blocking absorbs
	var/block_damage_absorption = 10
	/// Override absorption, list("[ATTACK_TYPE_DEFINE]" = absorption), see [block_damage_absorption]
	var/list/block_damage_absorption_override

	/// Ratio of damage block above absorption amount, coefficient, lower is better, this is multiplied by damage to determine how much is blocked.
	var/block_damage_multiplier = 0.5
	/// Override damage overrun efficiency, list("[ATTACK_TYPE_DEFINE]" = absorption), see [block_damage_efficiency]
	var/list/block_damage_multiplier_override

	/// Upper bound of damage block, anything above this will go right through.
	var/block_damage_limit = 80
	/// Override upper bound of damage block, list("[ATTACK_TYPE_DEFINE]" = absorption), see [block_damage_limit]
	var/list/block_damage_limit_override

	/*
	 * NOTE: Overrides for attack types for most the block_stamina variables were removed,
	 * because at the time of writing nothing needed to use it. Add them if you need it,
	 * it should be pretty easy, just copy [active_block_damage_mitigation]
	 * for how to override with list.
	 */

	/// Default damage-to-stamina coefficient, higher is better. This is based on amount of damage BLOCKED, not initial damage, to prevent damage from "double dipping".
	var/block_stamina_efficiency = 2
	/// Override damage-to-stamina coefficient, see [block_efficiency], this should be list("[ATTACK_TYPE_DEFINE]" = coefficient_number)
	var/list/block_stamina_efficiency_override
	/// Ratio of stamina incurred by blocking that goes to the arm holding the object instead of the chest. Has no effect if this is not held in hand.
	var/block_stamina_limb_ratio = 0.5
	/// Ratio of stamina incurred by chest (so after [block_stamina_limb_ratio] runs) that is buffered.
	var/block_stamina_buffer_ratio = 1

	/// Stamina dealt directly via adjustStaminaLossBuffered() per SECOND of block.
	var/block_stamina_cost_per_second = 1.5

	/// Bitfield for attack types that we can block while down. This will work in any direction.
	var/block_resting_attack_types_anydir = ATTACK_TYPE_MELEE | ATTACK_TYPE_UNARMED | ATTACK_TYPE_TACKLE
	/// Bitfield for attack types that we can block while down but only in our normal directions.
	var/block_resting_attack_types_directional = ATTACK_TYPE_PROJECTILE | ATTACK_TYPE_THROWN
	/// Multiplier to stamina damage taken for attacks blocked while downed.
	var/block_resting_stamina_penalty_multiplier = 1.5
	/// Override list for multiplier to stamina damage taken for attacks blocked while down. list("[ATTACK_TYPE_DEFINE]" = multiplier_number)
	var/list/block_resting_stamina_penalty_multiplier_override

	/// Sounds for blocking
	var/list/block_sounds = list('sound/block_parry/block_metal1.ogg' = 1, 'sound/block_parry/block_metal1.ogg' = 1)

	/////////// PARRYING ////////////
	/// Prioriry for [mob/do_run_block()] while we're being used to parry.
	//  None - Parry is always highest priority!
	/// Parry doesn't work if you aren't able to otherwise attack due to clickdelay
	var/parry_respect_clickdelay = TRUE
	/// Parry stamina cost
	var/parry_stamina_cost = 5
	/// Attack types we can block
	var/parry_attack_types = ALL
	/// Parry flags
	var/parry_flags = PARRY_DEFAULT_HANDLE_FEEDBACK | PARRY_LOCK_ATTACKING

	/// Parry windup duration in deciseconds. 0 to this is windup, afterwards is main stage.
	var/parry_time_windup = 2
	/// Parry spindown duration in deciseconds. main stage end to this is the spindown stage, afterwards the parry fully ends.
	var/parry_time_spindown = 3
	/// Main parry window in deciseconds. This is between [parry_time_windup] and [parry_time_spindown]
	var/parry_time_active = 5
	// Visual overrides
	/// If set, overrides visual duration of windup
	var/parry_time_windup_visual_override
	/// If set, overrides visual duration of active period
	var/parry_time_active_visual_override
	/// If set, overrides visual duration of spindown
	var/parry_time_spindown_visual_override
	/// Perfect parry window in deciseconds from the start of the main window. 3 with main 5 = perfect on third decisecond of main window.
	var/parry_time_perfect = 2.5
	/// Time on both sides of perfect parry that still counts as part of the perfect window.
	var/parry_time_perfect_leeway = 1
	/// [parry_time_perfect_leeway] override for attack types, list("[ATTACK_TYPE_DEFINE]" = deciseconds)
	var/list/parry_time_perfect_leeway_override
	/// Parry "efficiency" falloff in percent per decisecond once perfect window is over.
	var/parry_imperfect_falloff_percent = 20
	/// [parry_imperfect_falloff_percent] override for attack types, list("[ATTACK_TYPE_DEFINE]" = deciseconds)
	var/list/parry_imperfect_falloff_percent_override
	/// Efficiency in percent on perfect parry.
	var/parry_efficiency_perfect = 120
	/// Parry effect data.
	var/list/parry_data = list(
		PARRY_REFLEX_COUNTERATTACK = PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN
		)
	/// Efficiency must be at least this to be considered successful
	var/parry_efficiency_considered_successful = 0.1
	/// Efficiency must be at least this to run automatic counterattack
	var/parry_efficiency_to_counterattack = 0.1
	/// Maximum attacks to parry successfully or unsuccessfully (but not efficiency < 0) during active period, hitting this immediately ends the sequence.
	var/parry_max_attacks = INFINITY
	/// Visual icon state override for parrying
	var/parry_effect_icon_state = "parry_bm_hold"
	/// Parrying cooldown, separate of clickdelay. It must be this much deciseconds since their last parry for them to parry with this object.
	var/parry_cooldown = 0
	/// Parry start sound
	var/parry_start_sound = 'sound/block_parry/sfx-parry.ogg'
	/// Sounds for parrying
	var/list/parry_sounds = list('sound/block_parry/block_metal1.ogg' = 1, 'sound/block_parry/block_metal1.ogg' = 1)
	/// Stagger duration post-parry if you fail to parry an attack
	var/parry_failed_stagger_duration = 3.5 SECONDS
	/// Clickdelay duration post-parry if you fail to parry an attack
	var/parry_failed_clickcd_duration = 2 SECONDS

/**
  * Quirky proc to get average of flags in list that are in attack_type because why is attack_type a flag.
  */
/datum/block_parry_data/proc/attack_type_list_scan(list/L, attack_type)
	var/total = 0
	var/div = 0
	for(var/flagtext in L)
		if(attack_type & num2text(flagtext))
			total += L[flagtext]
			div++
	// if none, return null.
	if(!div)
		return
	return total/div	//groan

/**
  * Called every life tick to handle blocking/parrying effects.
  */
/mob/living/proc/handle_block_parry(seconds = 1)
	if(combat_flags & COMBAT_FLAG_ACTIVE_BLOCKING)
		var/datum/block_parry_data/data = return_block_parry_datum(active_block_item.block_parry_data)
		adjustStaminaLossBuffered(data.block_stamina_cost_per_second * seconds)
	if(parrying)
		if(!CHECK_MOBILITY(src, MOBILITY_USE))
			to_chat(src, "<span class='warning'>Your parry is interrupted!</span>")
			end_parry_sequence()
