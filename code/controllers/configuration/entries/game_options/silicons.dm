/datum/config_entry/flag/allow_ai	// allow ai job

/datum/config_entry/flag/allow_ai_multicam //whether the AI can use their multicam

/datum/config_entry/flag/disable_borg_flash_knockdown //Should borg flashes be capable of knocking humanoid entities down?

/datum/config_entry/flag/weaken_secborg //Brings secborgs and k9s back in-line with the other borg modules

/datum/config_entry/flag/disable_secborg	// disallow secborg module to be chosen.

/datum/config_entry/flag/disable_peaceborg

/datum/config_entry/flag/silent_ai

/datum/config_entry/flag/silent_borg

/datum/config_entry/number/minimum_secborg_alert	//Minimum alert level for secborgs to be chosen.
	config_entry_value = 3

/datum/config_entry/number/default_laws //Controls what laws the AI spawns with.
	config_entry_value = 0
	min_val = 0
	max_val = 3

/datum/config_entry/number/silicon_max_law_amount
	config_entry_value = 12
	min_val = 0

/datum/config_entry/keyed_list/random_laws
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/law_weight
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM
	splitter = ","
