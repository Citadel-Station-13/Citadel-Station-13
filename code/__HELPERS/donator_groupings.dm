/*
Current specifications:

Donator groups in __DEFINES/donator_groupings.dm, config entries in controllers/configuration/entries/donator.dm

3 groups, Tier 1/2/3
Each tier includes the one before it (ascending)
For fast lookups, this is generated using regenerate_donator_grouping_list()

*/

/proc/is_donator_group(ckey, group)
	ckey = ckey(ckey)		//make sure it's ckey'd.
	return GLOB.donators_by_group[group]?.Find(ckey)

/proc/regenerate_donator_grouping_list()
	var/list/donator_list = GLOB.donators_by_group = list()			//reinit everything

	var/list/inclusive_add = list()		//speed!

	inclusive_add += TIER_1_DONATORS
	donator_list[DONATOR_GROUP_TIER_1] = inclusive_add.Copy()
	inclusive_add += TIER_2_DONATORS
	donator_list[DONATOR_GROUP_TIER_2] = inclusive_add.Copy()
	inclusive_add += TIER_3_DONATORS
	donator_list[DONATOR_GROUP_TIER_3] = inclusive_add.Copy()
