#define GET_SKILL_DATUM(path) GLOB.skill_datums[path]

/// true/false
#define SKILL_PROGRESSION_BINARY				1
/// numerical
#define SKILL_PROGRESSION_NUMERICAL				2
/// Enum
#define SKILL_PROGRESSION_ENUM					3


/// Max value of skill for numerical skills
#define SKILL_NUMERICAL_MAX			100
/// Min value of skill for numerical skills
#define SKILL_NUMERICAL_MIN			0

// Values for experience skills
#define STD_XP_LVL_UP 100
#define STD_XP_LVL_MULTI 2
#define STD_MAX_LVL 4

#define RPG_MAX_LVL 100

#define DORF_XP_LVL_UP 400
#define DORF_XP_LVL_MULTI 100
#define DORF_MAX_LVL 20 // Dabbling, novice, adequate, [...], legendary +3, legendary +4, legendary +5

//How experience levels are calculated.
#define XP_LEVEL(std, multi, lvl) (std * (multi**lvl))
#define DORF_XP_LEVEL(std, extra, lvl) (std*lvl+extra*(lvl*(lvl/2+0.5)))

//level up methods defines
#define STANDARD_LEVEL_UP "standard_level_up"
#define DWARFY_LEVEL_UP "dwarfy_level_up"

// Standard values for job starting skills

#define STARTING_SKILL_SURGERY_MEDICAL		35		//out of SKILL_NUMERICAL_MAX

// Standard values for job starting skill affinities

#define STARTING_SKILL_AFFINITY_SURGERY_MEDICAL			1.2

// Standard values for skill gain (this is multiplied by affinity)

#define SKILL_GAIN_SURGERY_PER_STEP			0.25

// Misc

/// 40% speedup at 100 skill
#define SURGERY_SKILL_SPEEDUP_NUMERICAL_SCALE(number)			clamp(number / 250, 1, 2)
