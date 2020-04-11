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
	/// Our block_parry_data for unarmed blocks/parries. Currently only used for parrying, as unarmed block isn't implemented yet. YOU MUST RUN [get_block_parry_data(this)] INSTEAD OF DIRECTLY ACCESSING!
	var/datum/block_parry_data/block_parry_data

GLOBAL_LIST_EMPTY(block_parry_data)

/proc/get_block_parry_data(datum/block_parry_data/type_id_datum)
	if(istype(type_id_datum))
		return type_id_datum
	if(ispath(type_id_datum))
		. = GLOB.block_parry_data["[type_id_datum]"]
		if(!.)
			. = GLOB.block_parry_data["[type_id_datum]"] = new type_id_datum
	else		//text id
		return GLOB.block_parry_data["[type_id_datum]"]

/proc/set_block_parry_data(id, datum/block_parry_data/data)
	if(ispath(id))
		CRASH("Path-fetching of block parry data is only to grab static data, do not attempt to modify global caches of paths. Use string IDs.")
	GLOB.block_parry_data["[id]"] = data

/// Carries data like list data that would be a waste of memory if we initialized the list on every /item as we can cache datums easier.
/datum/block_parry_data
	/////////// BLOCKING ////////////

	/// NOTE: FOR ATTACK_TYPE_DEFINE, you MUST wrap it in "[DEFINE_HERE]"! The defines are bitflags, and therefore, NUMBERS!

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

	/// Parry windup duration in deciseconds. 0 to this is windup, afterwards is main stage.
	var/parry_time_windup = 2
	/// Parry spindown duration in deciseconds. main stage end to this is the spindown stage, afterwards the parry fully ends.
	var/parry_time_spindown = 3
	/// Main parry window in deciseconds. This is between [parry_time_windup] and [parry_time_spindown]
	var/parry_time_active = 5
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
	/// Parry data.
	var/list/parry_data = list(
		PARRY_REFLEX_COUNTERATTACK = PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN
		)

/mob/living/proc/handle_block_parry(seconds = 1)
	if(active_blocking)
		var/datum/block_parry_data/data = get_block_parry_data(active_block_item.block_parry_data)
		adjustStaminaLossBuffered(data.block_stamina_cost_per_second * seconds)

/obj/item/proc/active_parry(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!CHECK_BITFIELD(item_flags, ITEM_CAN_PARRY))
		return
	/// Yadda yadda WIP access block/parry data...

/obj/item/proc/active_parry_reflex_counter(atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list)

/mob/living/proc/active_parry_reflex_counter(atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list)

/datum/martial_art/proc/active_parry_reflex_counter(atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list)

/mob/living/proc/get_parry_stage()
	if(!parrying)
		return NOT_PARRYING
	var/datum/block_parry_data/data = get_parry_data()
	var/windup_end = data.parry_time_windup
	var/active_end = windup_end + data.parry_time_active
	var/spindown_end = active_end + data.parry_time_spindown
	switch(get_parry_time())
		if(0 to windup_end)
			return PARRY_WINDUP
		if(windup_end to active_end)
			return PARRY_ACTIVE
		if(active_end to spindown_end)
			return PARRY_SPINDOWN
	return NOT_PARRYING

/mob/living/proc/get_parry_efficiency(attack_type)
	var/datum/block_parry_data/data = get_parry_data()
	if(get_parry_stage() != PARRY_ACTIVE)
		return 0
	var/difference = abs(get_parry_time() - (data.parry_time_perfect + data.parry_time_windup))
	var/leeway = data.parry_time_perfect_leeway_override["[attack_type]"]
	if(isnull(leeway))
		leeway = data.parry_time_perfect_leeway
	difference -= leeway
	. = data.parry_efficiency_perfect
	if(difference <= 0)
		return
	var/falloff = data.parry_imperfect_falloff_percent_override["[attack_type]"]
	if(isnull(falloff))
		falloff = data.parry_imperfect_falloff_percent
	. -= falloff * difference

/mob/living/proc/get_parry_time()
	return world.time - parry_start_time

/// same return values as normal blocking, called with absolute highest priority in the block "chain".
/mob/living/proc/run_parry(atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list = list())

/// Run counterattack if any
/mob/living/proc/run_parry_countereffects(atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, list/return_list = list())
	if(!isliving(attacker))
		return
	var/mob/living/L = attacker
	var/datum/block_parry_data/data = get_parry_data()
	var/list/effect_text = list()
	if(data.parry_data[PARRY_REFLEX_COUNTERATTACK])
		switch(data.parry_data[PARRY_REFLEX_COUNTERATTACK])
			if(PARRY_COUNTERATTACK_PROC)
				switch(parrying)
					if(ITEM_PARRY)
						active_parry_item.active_parry_reflex_counter(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list)
					if(UNARMED_PARRY)
						active_parry_reflex_counter(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list)
					if(MARTIAL_PARRY)
						mind.martial_art.active_parry_reflex_counter(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list)
			if(PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN)
				switch(parrying)
					if(ITEM_PARRY)
						active_parry_item.melee_attack_chain(src, attacker, null)
					if(UNARMED_PARRY)
						UnarmedAttack(attacker)
					if(MARTIAL_PARRY)
						UnarmedAttack(attacker)
	if(data.parry_data[PARRY_DISARM_ATTACKER])
		L.drop_all_held_items()
		effect_text += "disarming"
	if(data.parry_data[PARRY_KNOCKDOWN_ATTACKER])
		L.DefaultCombatKnockdown(data.parry_data[PARRY_KNOCKDOWN_ATTACKER])
		effect_text += "knocking them to the ground"
	if(data.parry_data[PARRY_STAGGER_ATTACKER])
		L.Stagger(data.parry_data[PARRY_STAGGER_ATTACKER])
		effect_text += "staggering"
	if(data.parry_data[PARRY_DAZE_ATTACKER])
		L.Daze(data.parry_data[PARRY_DAZE_ATTACKER])
		effect_text += "dazing"

/// Gets the datum/block_parry_data we're going to use to parry.
/mob/living/proc/get_parry_data()
	if(parrying == ITEM_PARRY)
		return active_parry_item.get_block_parry_data()
	else if(parrying == UNARMED_PARRY)
		return get_block_parry_data(block_parry_data)
	else if(parrying == MARTIAL_PARRY)
		return get_block_parry_data(mind.martial_art.block_parry_data)

