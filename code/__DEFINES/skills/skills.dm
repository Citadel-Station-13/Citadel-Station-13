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

// Standard values for job starting skills

#define STARTING_SKILL_SURGERY_MEDICAL		35		//out of SKILL_NUMERICAL_MAX

// Standard values for job starting skill affinities

#define STARTING_SKILL_AFFINITY_SURGERY_MEDICAL			1.2

// Standard values for skill gain (this is multiplied by affinity)

#define SKILL_GAIN_SURGERY_PER_STEP			0.25

// Misc

/// 40% speedup at 100 skill
#define SURGERY_SKILL_SPEEDUP_NUMERICAL_SCALE(number)			clamp(number / 250, 1, 2)
