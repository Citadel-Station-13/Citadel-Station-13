// Rig piece types - only one of each type should exist on a given rig.
// This is a bitfield for easier conflict checking
/// Head - RIG_ZONE_HEAD translates to this
#define RIG_PIECE_HEAD		(1<<0)
/// Suit - RIG_ZONE_CHEST translates to this
#define RIG_PIECE_SUIT		(1<<1)
/// Gauntlets - RIG_ZONE_L/R_ARM translates to this
#define RIG_PIECE_GAUNTLETS	(1<<2)
/// Boots - RIG_ZONE_L/R_LEG translates to this
#define RIG_PIECE_BOOTS		(1<<3)

