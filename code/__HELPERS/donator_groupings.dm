/*
Current specifications:

Donator groups in __DEFINES/donator_groupings.dm, config entries in controllers/configuration/entries/donator.dm

3 groups, Tier 1/2/3
Each tier includes the one before it (ascending)
For fast lookups, this is generated using regenerate_donator_grouping_list()

*/

/proc/is_donator_group(ckey, group)
	ckey = ckey(ckey)		//make sure it's ckey'd.
	var/list/L = GLOB.donators_by_group[group]
	return L && L.Find(ckey)

/proc/regenerate_donator_grouping_list()
	GLOB.donators_by_group = list()			//reinit everything
	var/list/donator_list = GLOB.donators_by_group		//cache
	var/list/tier_3 = TIER_3_DONATORS
	donator_list[DONATOR_GROUP_TIER_3] = tier_3.Copy()		//The .Copy() is to "decouple"/make a new list, rather than letting the global list impact the config list.
	var/list/tier_2 = tier_3 + TIER_2_DONATORS				//Using + on lists implies making new lists, so we don't need to manually Copy().
	donator_list[DONATOR_GROUP_TIER_2] = tier_2
	var/list/tier_1 = tier_2 + TIER_1_DONATORS
	donator_list[DONATOR_GROUP_TIER_1] = tier_1
