/// Default explosion power to consider an explosion over
#define EXPLOSION_POWER_DEAD			2.5
/// Default explosion falloff
#define EXPLOSION_DEFAULT_FALLOFF_MULTIPLY		0.95
/// Default explosion constant falloff
#define EXPLOSION_DEFAULT_FALLOFF_SUBTRACT		3.5

/// Explosion power quantization
#define EXPLOSION_POWER_QUANTIZATION_ACCURACY	0.1

// Standardized explosion powers
/// Maxcap
#define EXPLOSION_POWER_MAXCAP					100
/// erases shreds from explosions/item damage
#define EXPLOSION_POWER_ERASE_SHREDS			75

// Walls
#define EXPLOSION_POWER_WALL_SCRAPE				50
#define EXPLOSION_POWER_WALL_DISMANTLE			25
#define EXPLOSION_POWER_WALL_MINIMUM_DISMANTLE	10

#define EXPLOSION_POWER_RWALL_SCRAPE				75
#define EXPLOSIOn_POWER_RWALL_DISMANTLE				40
#define EXPLOSION_POWER_RWALL_MINIMUM_DISMANTLE		25

// Helpers
/// Explosion power to object damage (without taking into consideration armor)
#define EXPLOSION_POWER_STANDARD_SCALE_OBJECT_DAMAGE(power, multiplier)			(35*(power**0.4)*multiplier)
/// Explosion power to object damage for hard obstacles
#define EXPLOSION_POWER_STANDARD_SCALE_HARD_OBSTACLE(power, multiplier)			(45*(power**0.4)*multiplier)
/// Explosion power to object damage for windows
#define EXPLOSION_POWER_STANDARD_SCALE_WINDOW_DAMAGE(power, multiplier)			(45*(power**0.4)*multiplier)

// Standardized explosion constant blocks
#define EXPLOSION_BLOCK_WINDOW							2.5
#define EXPLOSION_BLOCK_MACHINE							5
#define EXPLOSION_BLOCK_REINFORCED_WINDOW				7.5
#define EXPLOSION_BLOCK_DENSE_FILLER					7.5
#define EXPLOSION_BLOCK_WALL							10
#define EXPLOSION_BLOCK_BLAST_PROOF						20
#define EXPLOSION_BLOCK_BOROSILICATE_WINDOW				25
#define EXPLOSION_BLOCK_EXTREME							35

// Standardized explosion factor blocks
#define EXPLOSION_DAMPEN_MACHINE					0.95
#define EXPLOSION_DAMPEN_WINDOW						0.95
#define EXPLOSION_DAMPEN_REINFORCED_WINDOW			0.9
#define EXPLOSION_DAMPEN_DENSE_FILLER				0.85
#define EXPLOSION_DAMPEN_WALL						0.8
#define EXPLOSION_DAMPEN_BOROSILICATE_WINDOW		0.65
#define EXPLOSION_DAMPEN_BLAST_PROOF				0.65
#define EXPLOSION_DAMPEN_EXTREME					0.5
