
/// true/false
#define SKILL_PROGRESSION_BINARY				1
/// numerical
#define SKILL_PROGRESSION_NUMERICAL				2
/// Enum
#define SKILL_PROGRESSION_ENUM					3
/// Levels
#define SKILL_PROGRESSION_LEVEL					4

// Standard values for job starting skills

#define STARTING_SKILL_SURGERY_MEDICAL		35		//out of SKILL_NUMERICAL_MAX

// Standard values for job starting skill affinities

#define STARTING_SKILL_AFFINITY_DEF_JOB		1.2

// Standard values for skill gain (this is multiplied by affinity)

#define DEF_SKILL_GAIN					1
#define SKILL_GAIN_SURGERY_PER_STEP		0.25
#define STD_USE_TOOL_MULT				1
#define EASY_USE_TOOL_MULT				0.75
#define TRIVIAL_USE_TOOL_MULT			0.5
#define BARE_USE_TOOL_MULT				0.25

//multiplier of the difference of max_value and min_value. Mostly for balance purposes between numerical and level-based skills.
#define STD_NUM_SKILL_ITEM_GAIN_MULTI	0.002

//An extra point for each few seconds of delay when using a tool. Before the multiplier.
#define SKILL_GAIN_DELAY_DIVISOR		3 SECONDS

///Items skill_traits and other defines
#define SKILL_USE_TOOL			"use_tool"
#define SKILL_TRAINING_TOOL		"training_tool"
#define SKILL_ATTACK_MOB		"attack_mob"
#define SKILL_TRAIN_ATTACK_MOB	"train_attack_mob"
#define SKILL_ATTACK_OBJ		"attack_obj"
#define SKILL_TRAIN_ATTACK_OBJ	"train_attack_obj"
#define SKILL_STAMINA_COST		"stamina_cost" //Influences the stamina cost from weapon usage.
#define SKILL_THROW_STAM_COST	"throw_stam_cost"
#define SKILL_SANITY			"sanity" //Is the skill affected by (in)sanity.
#define SKILL_INTELLIGENCE		"intelligence" //Is the skill affected by brain damage?

///competency_threshold  defines
#define THRESHOLD_UNTRAINED "untrained"
#define THRESHOLD_COMPETENT	"competent"
#define THRESHOLD_EXPERT	"expert"
#define THRESHOLD_MASTER	"master"

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
///Will this skill use competency thresholds instead of preset values
#define MODIFIER_USE_THRESHOLDS		(1<<8)

#define MODIFIER_TARGET_VALUE		"value"
#define MODIFIER_TARGET_LEVEL		"level"
#define MODIFIER_TARGET_AFFINITY	"affinity"

///Ascending priority defines.
#define MODIFIER_SKILL_PRIORITY_LOW 100
#define MODIFIER_SKILL_PRIORITY_DEF 50
#define MODIFIER_SKILL_PRIORITY_MAX 1 //max priority, meant for job/antag modifiers so they don't null out other (de)buffs

// UI Defines
///Categories of skills, these will be displayed alphabetically.
#define SKILL_UI_CAT_ENG	"Engineering"
#define SKILL_UI_CAT_MED	"Medical"
#define SKILL_UI_CAT_MISC	"Misc"
