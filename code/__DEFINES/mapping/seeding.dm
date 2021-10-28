// /spawn_type
/// Do not ever spawn
#define SUBMAP_SPAWN_DISABLED			0
/// Default biome/theme/base weighted spawns
#define SUBMAP_SPAWN_NORMAL				1
/// Special spawn for planetary feature forcing/whatnot
#define SUBMAP_SPAWN_SPECIAL			2
/// Always spawn if it has even one matching biome + theme
#define SUBMAP_SPAWN_FORCED				3

// /exclusion_mode
/// We literally do not care
#define SUBMAP_CHECK_NONE				1
/// Check only center tile
#define SUBMAP_CHECK_CENTER				2
/// Check 4 corners only
#define SUBMAP_CHECK_CORNERS			3
/// Full bounding box check
#define SUBMAP_CHECK_ALL				4
