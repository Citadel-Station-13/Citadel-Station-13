/datum/config_entry/keyed_list/donator_group
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG
	abstract_type = /datum/config_entry/keyed_list/donator_group

//If we're in the middle of a config load, only do the regeneration afterwards to prevent this from wasting a massive amount of CPU for list regenerations.
/datum/config_entry/keyed_list/donator_group/ValidateAndSet(str_val, during_load)
	. = ..()
	if(. && during_load)
		regenerate_donator_grouping_list()

/datum/config_entry/keyed_list/donator_group/OnPostload()
	. = ..()
	regenerate_donator_grouping_list()

//This is kinda weird in that the config entries are defined here but all the handling/calculations are in __HELPERS/donator_groupings.dm

/datum/config_entry/keyed_list/donator_group/tier_1_donators

/datum/config_entry/keyed_list/donator_group/tier_2_donators

/datum/config_entry/keyed_list/donator_group/tier_3_donators
