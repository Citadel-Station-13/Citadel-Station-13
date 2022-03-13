// Everything regarding space levels goes in here.

// Traits - binary yes/no "Do we have this".
#define ZTRAIT_CENTCOM "CentCom"
#define ZTRAIT_STATION "Station"
#define ZTRAIT_MINING "Mining"
#define ZTRAIT_REEBE "Reebe"
#define ZTRAIT_RESERVED "Transit/Reserved"
#define ZTRAIT_AWAY "Away Mission"
#define ZTRAIT_VR "Virtual Reality"
#define ZTRAIT_SPACE_RUINS "Space Ruins"
#define ZTRAIT_LAVA_RUINS "Lava Ruins"
#define ZTRAIT_ICE_RUINS "Ice Ruins"
#define ZTRAIT_ICE_RUINS_UNDERGROUND "Ice Ruins Underground"
#define ZTRAIT_ISOLATED_RUINS "Isolated Ruins" //Placing ruins on z levels with this trait will use turf reservation instead of usual placement.
#define ZTRAIT_VIRTUAL_REALITY "Virtual Reality"
#define ZTRAIT_MINIMAPS "Minimaps"
/// Having this means gravity is always on.
#define ZTRAIT_GRAVITY "Gravity"

// to be refactored on planets update
#define ZTRAIT_SNOWSTORM "Weather_Snowstorm"
#define ZTRAIT_ASHSTORM "Weather_Ashstorm"
#define ZTRAIT_ACIDRAIN "Weather_Acidrain"
#define ZTRAIT_VOIDSTORM "Weather_Voidstorm"
#define ZTRAIT_ICESTORM "Weather_Icestorm"
#define ZTRAIT_LONGRAIN "Weather_Longrain"

// Attributes - Can include any text data as a field.
/// Bombcap multiplier as number
#define ZATTRIBUTE_BOMBCAP_MULTIPLIER "Bombcap Multiplier"
/// Default airmix
#define ZATTRIBUTE_GAS_STRING "Default Air"

// Linkage types - Normal linkage variables override these, so don't set them if you use these.
/// Default - don't preprocess for unlinked sides, just leave them empty
#define Z_LINKAGE_NORMAL			"Normal"
/// Crosslinked - crosslink with other crosslinked zlevels at random using some semblence of continuity
#define Z_LINKAGE_CROSSLINKED		"Crosslink"
/// Selflooping - automatically link to itself for unlinked sides
#define Z_LINKAGE_SELFLOOP			"Selfloop"

// Misc
/// Transition mirage size
#define TRANSITION_VISUAL_SIZE			7
