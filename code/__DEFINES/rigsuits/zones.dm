// Rig zones
#define RIG_ZONE_HEAD	"head"
#define RIG_ZONE_CHEST	"chest"
#define RIG_ZONE_L_ARM	"l_arm"
#define RIG_ZONE_R_ARM	"r_arm"
#define RIG_ZONE_L_LEG	"l_leg"
#define RIG_ZONE_R_LEG	"r_leg"
/// This represents full body modules - these modules will take slots and size from all zones.
#define RIG_ZONE_ALL	"all"

// Global list lookup for rig zone to piece bitflag
GLOBAL_LIST_INIT(rig_zone_lookup, list(
	RIG_ZONE_HEAD = RIG_PIECE_HEAD,
	RIG_ZONE_CHEST = RIG_PIECE_SUIT,
	RIG_ZONE_L_ARM = RIG_PIECE_GAUNTLETS,
	RIG_ZONE_R_ARM = RIG_PIECE_GAUNTLETS,
	RIG_ZONE_L_LEG = RIG_PIECE_BOOTS,
	RIG_ZONE_R_LEG = RIG_PIECE_BOOTS
))
