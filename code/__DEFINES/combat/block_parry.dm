// We can't determine things like NORTHEAST vs NORTH *and* EAST without making our own flags :(
#define BLOCK_DIR_NORTH			(1<<0)
#define BLOCK_DIR_NORTHEAST		(1<<1)
#define BLOCK_DIR_NORTHWEST		(1<<2)
#define BLOCK_DIR_WEST			(1<<3)
#define BLOCK_DIR_EAST			(1<<4)
#define BLOCK_DIR_SOUTH			(1<<5)
#define BLOCK_DIR_SOUTHEAST		(1<<6)
#define BLOCK_DIR_SOUTHWEST		(1<<7)
#define BLOCK_DIR_ONTOP			(1<<8)

GLOBAL_LIST_INIT(dir2blockdir, list(
	"[NORTH]" = BLOCK_DIR_NORTH,
	"[NORTHEAST]" = BLOCK_DIR_NORTHEAST,
	"[NORTHWEST]" = BLOCK_DIR_NORTHWEST,
	"[WEST]" = BLOCK_DIR_WEST,
	"[EAST]" = BLOCK_DIR_EAST,
	"[SOUTH]" = BLOCK_DIR_SOUTH,
	"[SOUTHEAST]" = BLOCK_DIR_SOUTHEAST,
	"[SOUTHWEST]" = BLOCK_DIR_SOUTHWEST,
	"[NONE]" = BLOCK_DIR_ONTOP
	))

#define DIR2BLOCKDIR(d)			(GLOB.dir2blockdir["[d]"])

GLOBAL_LIST_INIT(block_direction_names, list(
	"[BLOCK_DIR_NORTH]" = "Front",
	"[BLOCK_DIR_NORTHEAST]" = "Front Right",
	"[BLOCK_DIR_NORTHWEST]" = "Front Left",
	"[BLOCK_DIR_WEST]" = "Left",
	"[BLOCK_DIR_EAST]" = "Right",
	"[BLOCK_DIR_SOUTH]" = "Behind",
	"[BLOCK_DIR_SOUTHEAST]" = "Behind Right",
	"[BLOCK_DIR_SOUTHWEST]" = "Behind Left",
	"[BLOCK_DIR_ONTOP]" = "Ontop"
))

/// If this is the value of active_block_starting it signals we want to interrupt the start
#define ACTIVE_BLOCK_STARTING_INTERRUPT "INTERRUPT"

/// ""types"" of parry "items"
#define UNARMED_PARRY		"unarmed"
#define MARTIAL_PARRY		"martial"
#define ITEM_PARRY			"item"

/// Parry phase we're in
#define NOT_PARRYING			0
#define PARRY_WINDUP			1
#define PARRY_ACTIVE			2
#define PARRY_SPINDOWN			3

// /datum/block_parry_data/var/parry_flags
/// Default handling for audio/visual feedback
#define PARRY_DEFAULT_HANDLE_FEEDBACK		(1<<0)
/// Lock sprinting while parrying
#define PARRY_LOCK_SPRINTING				(1<<1)
/// Lock attacking while parrying
#define PARRY_LOCK_ATTACKING				(1<<2)

/// Parry effects.
/// Automatically melee attacks back normally, LMB equivalent action of an harm intent attack. List association should be defaulting to 1, being the attack damage multiplier for said counterattack
#define PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN		"melee_counterattack_chain"
/// List association should be TRUE.
#define PARRY_DISARM_ATTACKER				"disarm_attacker"
/// List association should be duration or null for just plain knockdown.
#define PARRY_KNOCKDOWN_ATTACKER			"knockdown_attacker"
/// List association should be duration.
#define PARRY_STAGGER_ATTACKER				"stagger_attacker"
/// List association should be amount of time to daze attacker.
#define PARRY_DAZE_ATTACKER					"daze_attacker"
/// Set to TRUE in list association to ignore adjacency checks
#define PARRY_COUNTERATTACK_IGNORE_ADJACENCY			"ignore_adjacency"
