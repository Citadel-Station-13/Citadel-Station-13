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

/// Parry effects.
/// List association must be one of the things underneath
#define PARRY_REFLEX_COUNTERATTACK			"reflex_counter"
	// Uses active_parry_reflex_counter() on the mob (if unarmed)/item/martial art used to parry.
	#define PARRY_COUNTERATTACK_PROC					"proc"
	// Automatically melee attacks back normally, LMB equivalent action of an harm intent attack.
	#define PARRY_COUNTERATTACK_MELEE_ATTACK_CHAIN		"default"
/// No list association
#define PARRY_DISARM_ATTACKER				"disarm_attacker"
/// List association should be duration or null for just plain knockdown.
#define PARRY_KNOCKDOWN_ATTACKER			"knockdown_attacker"
/// List association should be duration.
#define PARRY_STAGGER_ATTACKER				"stagger_attacker"
/// List association should be amount of time to daze attacker.
#define PARRY_DAZE_ATTACKER					"daze_attacker"
