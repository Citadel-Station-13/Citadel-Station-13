/datum/config_entry/flag/dynamic_voting

/datum/config_entry/flag/no_storyteller_threat_removal

/datum/config_entry/number/dynamic_high_pop_limit
	default = 55
	min_val = 1

/datum/config_entry/number/dynamic_pop_per_requirement
	default = 6
	min_val = 1

/datum/config_entry/number/dynamic_midround_delay_min
	default = 15
	min_val = 1

/datum/config_entry/number/dynamic_midround_delay_max
	default = 35
	min_val = 1

/datum/config_entry/number/dynamic_latejoin_delay_min
	default = 5
	min_val = 1

/datum/config_entry/number/dynamic_latejoin_delay_max
	default = 25
	min_val = 1

/datum/config_entry/number/dynamic_first_midround_delay_min
	default = 20
	min_val = 1

/datum/config_entry/number/dynamic_first_midround_delay_max
	default = 40
	min_val = 1

/datum/config_entry/number/dynamic_first_latejoin_delay_min
	default = 10
	min_val = 1

/datum/config_entry/number/dynamic_first_latejoin_delay_max
	default = 30
	min_val = 1


/datum/config_entry/keyed_list/dynamic_cost
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/dynamic_weight
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/dynamic_requirements
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM_LIST

/datum/config_entry/keyed_list/dynamic_high_population_requirement
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/number_list/dynamic_second_rule_requirements

/datum/config_entry/number_list/dynamic_third_rule_requirements

/datum/config_entry/number/dynamic_second_rule_high_pop_requirement
	default = 50

/datum/config_entry/number/dynamic_third_rule_high_pop_requirement
	default = 70

/datum/config_entry/number/dynamic_threat_baseline
	default = 50

/datum/config_entry/number_list/dynamic_hijack_requirements

/datum/config_entry/number/dynamic_hijack_high_population_requirement
	default = 25

/datum/config_entry/number/dynamic_hijack_cost
	default = 5

/datum/config_entry/number/dynamic_glorious_death_cost
	default = 5

/datum/config_entry/number/dynamic_assassinate_cost
	default = 2

/datum/config_entry/number/dynamic_warops_requirement
	default = 60
	min_val = 0

/datum/config_entry/number/dynamic_warops_cost
	default = 10
	min_val = 0

/datum/config_entry/keyed_list/dynamic_mode_days
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/storyteller_weight
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/storyteller_min_players
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/storyteller_min_chaos
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/storyteller_max_chaos
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM
