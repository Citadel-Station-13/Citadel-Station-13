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
#define DUMB		512
#define MONKEYLIKE	1024 //sets IsAdvancedToolUser to FALSE
=======
#define BLIND 		"blind"
#define MUTE		"mute"
#define DEAF		"deaf"
#define NEARSIGHT	"nearsighted"
#define FAT			"fat"
#define HUSK		"husk"
#define NOCLONE		"noclone"
#define CLUMSY		"clumsy"
#define DUMB        "dumb"
#define MONKEYLIKE  "monkeylike" //sets IsAdvancedToolUser to FALSE
#define PACIFISM 	"pacifism"

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
>>>>>>> 146d167... [Ready Again]Refactors disabilities into lists, allowing for independent disability sources (#33055)

// bitflags for machine stat variable
#define BROKEN		1
#define NOPOWER		2
#define MAINT		4			// under maintaince
#define EMPED		8		// temporary broken by EMP pulse

//ai power requirement defines
#define POWER_REQ_NONE 0
#define POWER_REQ_ALL 1
#define POWER_REQ_CLOCKCULT 2
