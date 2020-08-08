/datum/config_entry/keyed_list/gamemodes
	abstract_type = /datum/config_entry/keyed_list/gamemodes
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/gamemodes/ValidateListEntry(key_name, key_value)
	if(!(key_name in config.modes))
		return FALSE
	return ..()

/datum/config_entry/keyed_list/gamemodes/probability
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/gamemodes/max_pop
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/gamemodes/min_pop
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/gamemodes/primary_scaling
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/gamemodes/secondary_scaling
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/gamemodes/tertiary_scaling
	value_mode = VALUE_MODE_NUM

/// Which gamemodes are considered high action
/datum/config_entry/keyed_list/gamemodes/high_action_gamemodes
	value_mode = VALUE_MODE_FLAG

/// Which gamemodes continue if all antagonists die
/datum/config_entry/keyed_list/gamemodes/continuous
	value_mode = VALUE_MODE_FLAG

/// Which gamemodes use the midround antagonist system
/datum/config_entry/keyed_list/gamemodes/midround_antag
	value_mode = VALUE_MODE_FLAG

/// Do we force people to get antags even with it off?
/datum/config_entry/keyed_list/gamemodes/force_antag_count
	value_mode = VALUE_MODE_FLAG

/// Minimum antags for each gamemode.
/datum/config_entry/keyed_list/gamemodes/minimum_antagonists
	value_mode = VALUE_MODE_NUM

/// Maximum antags for each gamemode.
/datum/config_entry/keyed_list/gamemodes/maximum_antagonists
	value_mode = VALUE_MODE_NUM

/// number of rounds to remember
/datum/config_entry/number/gamemode_memory_rounds
	config_entry_value = 0

/// max high action rounds for every x rounds remembered
/datum/config_entry/number/gamemode_memory_max_high_action
	config_entry_value = INFINITY

/// min high action rounds for every x rounds remembered
/datum/config_entry/number/gamemode_memory_min_high_action
	config_entry_value = 0

/datum/config_entry/number/security_scaling_coeff	//how much does the amount of players get divided by to determine open security officer positions
	config_entry_value = 8
	min_val = 1

/datum/config_entry/number/traitor_objectives_amount
	config_entry_value = 2
	min_val = 0

/datum/config_entry/number/brother_objectives_amount
	config_entry_value = 2
	min_val = 0
