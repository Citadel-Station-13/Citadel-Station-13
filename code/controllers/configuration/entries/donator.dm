/datum/config_entry/multi_keyed_flag/donator_group
	abstract_type = /datum/config_entry/multi_keyed_flag/donator_group

//If we're in the middle of a config load, only do the regeneration afterwards to prevent this from wasting a massive amount of CPU for list regenerations.
/datum/config_entry/multi_keyed_flag/donator_group/ValidateAndSet(str_val, during_load)
	. = ..()
	if(. && !during_load)
		regenerate_donator_grouping_list()

/datum/config_entry/multi_keyed_flag/donator_group/process_key(key)
	return ckey(key)

/datum/config_entry/multi_keyed_flag/donator_group/OnPostload()
	. = ..()
	regenerate_donator_grouping_list()

//This is kinda weird in that the config entries are defined here but all the handling/calculations are in __HELPERS/donator_groupings.dm

/datum/config_entry/multi_keyed_flag/donator_group/tier_1_donators

/datum/config_entry/multi_keyed_flag/donator_group/tier_2_donators

/datum/config_entry/multi_keyed_flag/donator_group/tier_3_donators
