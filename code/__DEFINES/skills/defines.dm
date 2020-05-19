
/// true/false
#define SKILL_PROGRESSION_BINARY				1
/// numerical
#define SKILL_PROGRESSION_NUMERICAL				2
/// Enum
#define SKILL_PROGRESSION_ENUM					3
/// Levels
#define SKILL_PROGRESSION_LEVEL					4


/// Max value of skill for numerical skills
#define SKILL_NUMERICAL_MAX			100
/// Min value of skill for numerical skills
#define SKILL_NUMERICAL_MIN			0

// Standard values for job starting skills

#define STARTING_SKILL_SURGERY_MEDICAL		35		//out of SKILL_NUMERICAL_MAX

// Standard values for job starting skill affinities

#define STARTING_SKILL_AFFINITY_DEF_JOB		1.2

// Standard values for skill gain (this is multiplied by affinity)

#define DEF_SKILL_GAIN					1
#define SKILL_GAIN_SURGERY_PER_STEP		0.25

#define SKILL_AFFINITY_MOOD_BONUS 		1.25

///Items skill_flags and other defines
#define SKILL_USE_TOOL			(1<<0)
#define SKILL_TRAINING_TOOL		(1<<1)
#define SKILL_ATTACK_MOB		(1<<2)
#define SKILL_TRAIN_ATTACK_MOB	(1<<3)
#define SKILL_ATTACK_OBJ		(1<<4)
#define SKILL_TRAIN_ATTACK_OBJ	(1<<5)
#define SKILL_STAMINA_COST		(1<<6) //Influences the stamina cost from weapon usage.
#define SKILL_THROW_STAM_COST	(1<<7)
#define SKILL_COMBAT_MODE		(1<<8) //The user must have combat mode on.
#define SKILL_USE_MOOD			(1<<9) //Is the skill negatively affected by bad mood.
#define SKILL_TRAIN_MOOD		(1<<10) //Is this skill training affected by good mood.

///competency_threshold index defines
#define THRESHOLD_COMPETENT	1
#define THRESHOLD_EXPERT	2
#define THRESHOLD_MASTER	3

/// Level/Experience skills defines.
#define STD_XP_LVL_UP 100
#define STD_XP_LVL_MULTI 2
#define STD_MAX_LVL 4

#define RPG_MAX_LVL 100

#define DORF_XP_LVL_UP 400
#define DORF_XP_LVL_MULTI 100
#define DORF_MAX_LVL 20 // Dabbling, novice, adequate, [...], legendary +3, legendary +4, legendary +5

//level up methods defines
#define STANDARD_LEVEL_UP "standard_level_up"
#define DWARFY_LEVEL_UP "dwarfy_level_up"

//job skill level defines
#define JOB_SKILL_UNTRAINED	0
#define JOB_SKILL_BASIC		1
#define JOB_SKILL_TRAINED	2
#define JOB_SKILL_EXPERT	3
#define JOB_SKILL_MASTER	4

//other skill level defines, not an exhaustive catalogue, only contains be most relevant ones.
#define DORF_SKILL_COMPETENT	3
#define DORF_SKILL_EXPERT		8
#define DORF_SKILL_MASTER		12

/// Skill modifier defines and flags.
#define MODIFIER_SKILL_VALUE		(1<<0)
#define MODIFIER_SKILL_AFFINITY 	(1<<1)
#define MODIFIER_SKILL_LEVEL		(1<<2)
///makes the skill modifier a multiplier, not an addendum.
#define MODIFIER_SKILL_MULT			(1<<3)
///Sets the skill to the defined value if lower than that. Highly reccomended you don't use it with MODIFIER_SKILL_MULT.
#define MODIFIER_SKILL_VIRTUE		(1<<4)
///Does the opposite of the above. combining both effectively results in the skill being locked to the specified value.
#define MODIFIER_SKILL_HANDICAP		(1<<5)
///Makes it untransferred by mind.transfer_to()
#define MODIFIER_SKILL_BODYBOUND	(1<<6)
///Adds the difference of the current value and the value stored at the time the modifier was added to the result.
#define MODIFIER_SKILL_ORIGIN_DIFF	(1<<7)

#define MODIFIER_TARGET_VALUE		"value"
#define MODIFIER_TARGET_LEVEL		"level"
#define MODIFIER_TARGET_AFFINITY	"affinity"

///Ascending priority defines.
#define MODIFIER_SKILL_PRIORITY_DEF 50
#define MODIFIER_SKILL_PRIORITY_MAX 100 //max priority, meant for job/antag modifiers so they don't null out any debuff
