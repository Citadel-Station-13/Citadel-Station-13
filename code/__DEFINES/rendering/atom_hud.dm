// Entry type
/// Entries are individual images
#define HUD_ENTRY_IMAGE		1
/// Entries are lists of images
#define HUD_ENTRY_LIST		2


// Unique IDs for HUD icons

// Hud sources
/// Admins
#define HUD_SOURCE_ADMINBUS		"admin"
/// Mecha
#define HUD_SOURCE_MECH			"mech"
/// Glasses
#define HUD_SOURCE_GLASSES		"glasses"
/// Mob innate
#define HUD_SOURCE_INNATE		"innate"



//data HUD (medhud, sechud) defines
//Don't forget to update human/New() if you change these!
#define DATA_HUD_SECURITY_BASIC			1
#define DATA_HUD_SECURITY_ADVANCED		2
#define DATA_HUD_MEDICAL_BASIC			3
#define DATA_HUD_MEDICAL_ADVANCED		4
#define DATA_HUD_DIAGNOSTIC_BASIC		5
#define DATA_HUD_DIAGNOSTIC_ADVANCED	6
#define DATA_HUD_ABDUCTOR				7
#define DATA_HUD_SENTIENT_DISEASE		8
#define DATA_HUD_AI_DETECT				9

//antag HUD defines
#define ANTAG_HUD_CULT			10
#define ANTAG_HUD_REV			11
#define ANTAG_HUD_OPS			12
#define ANTAG_HUD_WIZ			13
#define ANTAG_HUD_SHADOW    	14
#define ANTAG_HUD_TRAITOR 		15
#define ANTAG_HUD_NINJA 		16
#define ANTAG_HUD_CHANGELING 	17
#define ANTAG_HUD_ABDUCTOR 		18
#define ANTAG_HUD_DEVIL			19
#define ANTAG_HUD_SINTOUCHED	20
#define ANTAG_HUD_SOULLESS		21
#define ANTAG_HUD_CLOCKWORK		22
#define ANTAG_HUD_BROTHER		23
#define ANTAG_HUD_BLOODSUCKER   24
#define ANTAG_HUD_FUGITIVE		25
#define ANTAG_HUD_HERETIC	26

// Notification action types
#define NOTIFY_JUMP "jump"
#define NOTIFY_ATTACK "attack"
#define NOTIFY_ORBIT "orbit"

#define ADD_HUD_TO_COOLDOWN 20 //cooldown for being shown the images for any particular data hud
