// Savefile versioning
//This is the lowest supported version, anything below this is completely obsolete and the entire savefile will be wiped.
#define SAVEFILE_VERSION_MIN	1

//This is the current version, anything below this will attempt to update (if it's not obsolete)
//	You do not need to raise this if you are adding new values that have sane defaults.
//	Only raise this value when changing the meaning/format/name/layout of an existing value
//	where you would want the updater procs below to run
#define SAVEFILE_VERSION_MAX	1

// Skin element names
#define PREFERENCES_SKIN_PREVIEW_MAP				"character_preview_map"
#define PREFERENCES_SKIN_MAIN						"preferences_browser"
#define PREFERENCES_SKIN_CHARACTER_SELECT			"preferences_character_select"

// Sort orders. Can be freely changed - HOWEVER, this is also the order of copy_to when instantiating a player character. Lower is first.
/// Default
#define PREFERENCES_SORT_ORDER_DEFAULT 0

// Save keys. THIS SHOULD NEVER, EVER BE CHANGED WITHOUT A MIGRATION, OR MASSIVE DATA LOSS WILL HAPPEN!
/// Default
#define PREFERENCES_SAVE_KEY_DEFAULT			"default"
/// Metadata - used by preferences datum to store things like versioning.
#define PREFERENCES_SAVE_KEY_METADATA			"metadata"
// Characters
#define PREFERENCES_SAVE_KEY_IDENTITY			"identity"
#define PREFERENCES_SAVE_KEY_BODY				"body"
#define PREFERENCES_SAVE_KEY_GENITALS			"genitals"
#define PREFERENCES_SAVE_KEY_LOADOUT			"loadout"
#define PREFERNECES_SAVE_KEY_OCCUPATION			"jobs"
#define PREFERENCES_SAVE_KEY_QUIRKS				"quirks"
#define PREFERENCES_SAVE_KEY_RECORDS			"records"
#define PREFERENCES_SAVE_KEY_SILICON			"silicon"
#define PREFERENCES_SAVE_KEY_SPEECH				"speech"
#define PREFERENCES_SAVE_KEY_VORE				"vore"
#define PREFERENCES_SAVE_KEY_PERSIST			"persist"
// Globals
#define PREFERENCES_SAVE_KEY_ADMIN				"admin"
#define PREFERENCES_SAVE_KEY_GLOBAL				"global"
#define PREFERENCES_SAVE_KEY_KEYBINDINGS		"keybindings"
#define PREFERENCES_SAVE_KEY_HIDDEN				"hidden"
// Hybrids
#define PREFERENCES_SAVE_KEY_ANTAGONISM			"antagonism"
#define PREFERENCES_SAVE_KEY_FETISH				"fetish"

// What kind of preview to do
/// Preview the character as fully naked except for underwear
#define PREFERENCES_PREVIEW_MODE_BODY					0
/// Preview the character in full loadout
#define PREFERENCES_PREVIEW_MODE_LOADOUT_ONLY			1
/// Preview the character as if they spawned as a job
#define PREFERENCES_PREVIEW_MODE_ROUNDSTART_SPAWN		2

// Preferences collection types
#define COLLECTION_CHARACTER			1
#define COLLECTION_HYBRID				2
#define COLLECTION_GLOBAL				3

// Collection OnTopic return flags
/// Refresh view
#define PREFERENCES_ONTOPIC_REFRESH					(1<<0)
/// Regenerate character preview
#define PREFERENCES_ONTOPIC_REGENERATE_PREVIEW		(1<<1)
/// Character swapped
#define PREFERENCES_ONTOPIC_CHARACTER_SWAP			(1<<2)
/// Resync preferences variable cache, usually used for things like keybindings.
#define PREFERENCES_ONTOPIC_RESYNC_CACHE			(1<<3)
/// Force client to reassert all keys
#define PREFERENCES_ONTOPIC_KEYBIND_REASSERT		(1<<4)

// Preferences load modes
/// Returning player, just do proper migration
#define PREFERENCES_LOAD_NORMAL				1
/// Returning player from old savefile format prior to datum prefs, do conversion
#define PREFERENCES_LOAD_LEGACY_CONVERSION	2
/// New player, initialize everything
#define PREFERENCES_LOAD_NEW_FILE			3

// Internal flags for copy_to_mob and late_copy_to_mob
/// Visuals only, don't care about detailed things that won't be seen on a sprite
#define COPY_TO_VISUALS_ONLY				(1<<0)
/// Load them in with their custom loadout (instead of handling it elsewhere or not at all)
#define COPY_TO_EQUIP_LOADOUT				(1<<1)
/// The copy to operation is a roundstart load
#define COPY_TO_ROUNDSTART					(1<<2)
/// Write organs like prosthetic limbs and prosthetic internal organs
#define COPY_TO_WRITE_ORGANS				(1<<3)


//Preference toggles
#define SOUND_ADMINHELP			(1<<0)
#define SOUND_MIDI				(1<<1)
#define SOUND_AMBIENCE			(1<<2)
#define SOUND_LOBBY				(1<<3)
#define MEMBER_PUBLIC			(1<<4)
#define INTENT_STYLE			(1<<5)
/// WARNING WARNING WARNING: DEPRECATED, ONLY KEPT AROUND FOR MIGRATION PURPOSES
#define MIDROUND_ANTAG			(1<<6)
#define SOUND_INSTRUMENTS		(1<<7)
#define SOUND_SHIP_AMBIENCE		(1<<8)
#define SOUND_PRAYERS			(1<<9)
#define ANNOUNCE_LOGIN			(1<<10)
#define SOUND_ANNOUNCEMENTS		(1<<11)
#define DISABLE_DEATHRATTLE		(1<<12)
#define DISABLE_ARRIVALRATTLE	(1<<13)
#define COMBOHUD_LIGHTING		(1<<14)

#define TOGGLES_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|MEMBER_PUBLIC|INTENT_STYLE|MIDROUND_ANTAG|SOUND_INSTRUMENTS|SOUND_SHIP_AMBIENCE|SOUND_PRAYERS|SOUND_ANNOUNCEMENTS)

//Chat toggles
#define CHAT_OOC			(1<<0)
#define CHAT_DEAD			(1<<1)
#define CHAT_GHOSTEARS		(1<<2)
#define CHAT_GHOSTSIGHT		(1<<3)
#define CHAT_PRAYER			(1<<4)
#define CHAT_RADIO			(1<<5)
#define CHAT_PULLR			(1<<6)
#define CHAT_GHOSTWHISPER	(1<<7)
#define CHAT_GHOSTPDA		(1<<8)
#define CHAT_GHOSTRADIO 	(1<<9)
#define CHAT_LOOC			(1<<10)
#define CHAT_BANKCARD		(1<<11)

#define TOGGLES_DEFAULT_CHAT (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_RADIO|CHAT_PULLR|CHAT_GHOSTWHISPER|CHAT_GHOSTPDA|CHAT_GHOSTRADIO|CHAT_LOOC|CHAT_BANKCARD)

#define PARALLAX_INSANE -1 //for show offs
#define PARALLAX_HIGH    0 //default.
#define PARALLAX_MED     1
#define PARALLAX_LOW     2
#define PARALLAX_DISABLE 3 //this option must be the highest number

#define PIXEL_SCALING_AUTO 0
#define PIXEL_SCALING_1X 1
#define PIXEL_SCALING_1_2X 1.5
#define PIXEL_SCALING_2X 2
#define PIXEL_SCALING_3X 3

#define SCALING_METHOD_NORMAL "normal"
#define SCALING_METHOD_DISTORT "distort"
#define SCALING_METHOD_BLUR "blur"

#define PARALLAX_DELAY_DEFAULT world.tick_lag
#define PARALLAX_DELAY_MED     1
#define PARALLAX_DELAY_LOW     2

#define SEC_DEPT_NONE "None"
#define SEC_DEPT_RANDOM "Random"
#define SEC_DEPT_ENGINEERING "Engineering"
#define SEC_DEPT_MEDICAL "Medical"
#define SEC_DEPT_SCIENCE "Science"
#define SEC_DEPT_SUPPLY "Supply"

// Playtime tracking system, see jobs_exp.dm
#define EXP_TYPE_LIVING			"Living"
#define EXP_TYPE_CREW			"Crew"
#define EXP_TYPE_COMMAND		"Command"
#define EXP_TYPE_ENGINEERING	"Engineering"
#define EXP_TYPE_MEDICAL		"Medical"
#define EXP_TYPE_SCIENCE		"Science"
#define EXP_TYPE_SUPPLY			"Supply"
#define EXP_TYPE_SECURITY		"Security"
#define EXP_TYPE_SILICON		"Silicon"
#define EXP_TYPE_SERVICE		"Service"
#define EXP_TYPE_ANTAG			"Antag"
#define EXP_TYPE_SPECIAL		"Special"
#define EXP_TYPE_GHOST			"Ghost"
#define EXP_TYPE_ADMIN			"Admin"

//Flags in the players table in the db
#define DB_FLAG_EXEMPT 							(1<<0)
#define DB_FLAG_AGE_CONFIRMATION_INCOMPLETE		(1<<1)
#define DB_FLAG_AGE_CONFIRMATION_COMPLETE		(1<<2)

#define DEFAULT_CYBORG_NAME "Default Cyborg Name"

//Job preferences levels
#define JP_LOW 1
#define JP_MEDIUM 2
#define JP_HIGH 3

//Chaos levels for dynamic voting
#define CHAOS_NONE "None (Extended)"
#define CHAOS_LOW "Low"
#define CHAOS_MED "Medium"
#define CHAOS_HIGH "High"
#define CHAOS_MAX "Maximum"
