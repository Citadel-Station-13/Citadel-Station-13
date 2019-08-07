#define DONATOR_GROUPING_TIER_1_CONFIG_PATH /datum/config_entry/keyed_list/donator/tier_1_donators
#define DONATOR_GROUPING_TIER_2_CONFIG_PATH /datum/config_entry/keyed_list/donator/tier_2_donators
#define DONATOR_GROUPING_TIER_3_CONFIG_PATH /datum/config_entry/keyed_list/donator/tier_3_donators

#define DONATOR_GROUPING_TIER_1_CONFIG_SUBPATH keyed_list/donator/tier_1_donators
#define DONATOR_GROUPING_TIER_2_CONFIG_SUBPATH keyed_list/donator/tier_2_donators
#define DONATOR_GROUPING_TIER_3_CONFIG_SUBPATH keyed_list/donator/tier_3_donators

#define TIER_1_DONATORS CONFIG_GET(DONATOR_GROUPING_TIER_1_CONFIG_SUBPATH)
#define TIER_2_DONATORS CONFIG_GET(DONATOR_GROUPING_TIER_2_CONFIG_SUBPATH)
#define TIER_3_DONATORS CONFIG_GET(DONATOR_GROUPING_TIER_3_CONFIG_SUBPATH)

//flags
#define DONATOR_GROUP_TIER_1 "T1"
#define DONATOR_GROUP_TIER_2 "T2"
#define DONATOR_GROUP_TIER_3 "T3"

#define IS_CKEY_DONATOR_GROUP(ckey, group) is_donator_group(ckey, group)
