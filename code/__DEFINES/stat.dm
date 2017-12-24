/*
	Used with the various stat variables (mob, machines)
*/

//mob/var/stat things
#define CONSCIOUS	0
#define SOFT_CRIT	1
#define UNCONSCIOUS	2
#define DEAD		3

//mob disabilities stat

<<<<<<< HEAD
#define BLIND 		1
#define MUTE		2
#define DEAF		4
#define NEARSIGHT	8
#define FAT			32
#define HUSK		64
#define NOCLONE		128
#define CLUMSY		256
#define DUMB        512
#define MONKEYLIKE  1024 //sets IsAdvancedToolUser to FALSE
#define PACIFISM 	2048
=======
#define DISABILITY_BLIND 		"blind"
#define DISABILITY_MUTE			"mute"
#define DISABILITY_DEAF			"deaf"
#define DISABILITY_NEARSIGHT	"nearsighted"
#define DISABILITY_FAT			"fat"
#define DISABILITY_HUSK			"husk"
#define DISABILITY_NOCLONE		"noclone"
#define DISABILITY_CLUMSY		"clumsy"
#define DISABILITY_DUMB			"dumb"
#define DISABILITY_MONKEYLIKE	"monkeylike" //sets IsAdvancedToolUser to FALSE
#define DISABILITY_PACIFISM		"pacifism"

// common disability sources
#define EYE_DAMAGE "eye_damage"
#define GENETIC_MUTATION "genetic"
#define STATUE_MUTE "statue"
#define CHANGELING_DRAIN "drain"
#define OBESITY "obesity"
#define MAGIC_DISABILITY "magic"
#define STASIS_MUTE "stasis"
#define GENETICS_SPELL "genetics_spell"
#define TRAUMA_DISABILITY "trauma"
>>>>>>> bc20a75... Merge pull request #33783 from Cruix/fix_blind

// bitflags for machine stat variable
#define BROKEN		1
#define NOPOWER		2
#define MAINT		4			// under maintaince
#define EMPED		8		// temporary broken by EMP pulse

//ai power requirement defines
#define POWER_REQ_NONE 0
#define POWER_REQ_ALL 1
#define POWER_REQ_CLOCKCULT 2
