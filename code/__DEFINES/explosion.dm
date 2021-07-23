// THIS IS INSANITY
// These are how wave explosions track when there's not only one direction to keep track of (diagonals, etc)
#define WEX_DIR_NORTH	NORTH
#define WEX_DIR_SOUTH	SOUTH
#define WEX_DIR_EAST	EAST
#define WEX_DIR_WEST	WEST
#define WEX_ALLDIRS		(WEX_DIR_NORTH | WEX_DIR_SOUTH | WEX_DIR_EAST | WEX_DIR_WEST)

/// Default explosion power to consider an explosion over
#define EXPLOSION_POWER_DEAD			2.5
/// Default explosion falloff
#define EXPLOSION_DEFAULT_FALLOFF_MULTIPLY		0.98
/// Default explosion constant falloff
#define EXPLOSION_DEFAULT_FALLOFF_SUBTRACT		5
/// Block amount at which point having 0 block resistance will result in a full block
#define EXPLOSION_POWER_NO_RESIST_THRESHOLD		5

/// Explosion power quantization
#define EXPLOSION_POWER_QUANTIZATION_ACCURACY	0.1

// [explosion_flags] variable on /atom
/// No blocking if we're not dense
#define EXPLOSION_FLAG_DENSITY_DEPENDENT			(1<<0)
/// If we survive the explosion, we block ALL the power and ignore the results of wave_ex_act().
#define EXPLOSION_FLAG_HARD_OBSTACLE				(1<<1)

// Standardized explosion powers
/// Maxcap
#define EXPLOSION_POWER_MAXCAP					500
/// erases shreds from explosions/item damage
#define EXPLOSION_POWER_ERASE_SHREDS			400
/// Gibs most mobs
#define EXPLOSION_POWER_NORMAL_MOB_GIB			400

// Walls
#define EXPLOSION_POWER_WALL_SCRAPE				400
#define EXPLOSION_POWER_WALL_DISMANTLE			300
#define EXPLOSION_POWER_WALL_MINIMUM_DISMANTLE	200

#define EXPLOSION_POWER_RWALL_SCRAPE				450
#define EXPLOSION_POWER_RWALL_DISMANTLE				400
#define EXPLOSION_POWER_RWALL_MINIMUM_DISMANTLE		300

// Floors
#define EXPLOSION_POWER_FLOOR_TILE_BREAK			50
#define EXPLOSION_POWER_FLOOR_MINIMUM_TURF_BREAK	125
#define EXPLOSION_POWER_FLOOR_TURF_BREAK_BONUS		225
#define EXPLOSION_POWER_FLOOR_TURF_BREAK			350
#define EXPLOSION_POWER_FLOOR_TURF_SCRAPE			425
#define EXPLOSION_POWER_FLOOR_SHIELDED_IMMUNITY		250

// Helpers
/// Explosion power to object damage (without taking into consideration armor)
#define EXPLOSION_POWER_STANDARD_SCALE_OBJECT_DAMAGE(power, multiplier)			(power>500)?(10*(power**0.6)*multiplier):(0.1*(power**1.3)*multiplier)
/// Explosion power to object damage for hard obstacles
#define EXPLOSION_POWER_STANDARD_SCALE_HARD_OBSTACLE_DAMAGE(power, multiplier)	(power>500)?(10*(power**0.6)*multiplier):(0.15*(power**1.3)*multiplier)
/// Explosion power to object damage for windows
#define EXPLOSION_POWER_STANDARD_SCALE_WINDOW_DAMAGE(power, multiplier)			(power>500)?(10*(power**0.6)*multiplier):(0.2*(power**1.3)*multiplier)
/// Default brute damage to do to living things
#define EXPLOSION_POWER_STANDARD_SCALE_MOB_DAMAGE(power, multiplier)			((power / 2) * multiplier)

// Damage factors
/// Factor to multiply damage to a door by if it's open (and therefore not blocking the explosion)
#define EXPLOSION_DAMAGE_OPEN_DOOR_FACTOR			0.25

// Standardized explosion constant blocks
#define EXPLOSION_BLOCK_WINDOW							10
#define EXPLOSION_BLOCK_MACHINE							20
#define EXPLOSION_BLOCK_SPACE							20
#define EXPLOSION_BLOCK_REINFORCED_WINDOW				50
#define EXPLOSION_BLOCK_DENSE_FILLER					50
#define EXPLOSION_BLOCK_WALL							75
#define EXPLOSION_BLOCK_BLAST_PROOF						250
#define EXPLOSION_BLOCK_BOROSILICATE_WINDOW				250
#define EXPLOSION_BLOCK_EXTREME							250

// Standardized explosion factor blocks
#define EXPLOSION_DAMPEN_MACHINE					0.95
#define EXPLOSION_DAMPEN_SPACE						0.95
#define EXPLOSION_DAMPEN_WINDOW						0.95
#define EXPLOSION_DAMPEN_REINFORCED_WINDOW			0.9
#define EXPLOSION_DAMPEN_DENSE_FILLER				0.85
#define EXPLOSION_DAMPEN_WALL						0.8
#define EXPLOSION_DAMPEN_BOROSILICATE_WINDOW		0.65
#define EXPLOSION_DAMPEN_BLAST_PROOF				0.65
#define EXPLOSION_DAMPEN_EXTREME					0.5
