//Inventory depth: limits how many nested storage items you can access directly.
//1: stuff in mob, 2: stuff in backpack, 3: stuff in box in backpack, etc
#define INVENTORY_DEPTH		3
#define STORAGE_VIEW_DEPTH	2

// defines for AFK theft
/// How many messages you can remember while logged out before you stop remembering new ones
#define AFK_THEFT_MAX_MESSAGES 10
/// If someone logs back in and there are entries older than this, just tell them they can't remember who it was or when
#define AFK_THEFT_FORGET_DETAILS_TIME 5 MINUTES
/// The index of the entry in 'afk_thefts' with the person's visible name at the time
#define AFK_THEFT_NAME 1
/// The index of the entry in 'afk_thefts' with the text
#define AFK_THEFT_MESSAGE 2
/// The index of the entry in 'afk_thefts' with the time it happened
#define AFK_THEFT_TIME 3

// inventory hide modes - if >= inventory_hide_level on a slot it'll show
/// show all slots
#define INVENTORY_HIDE_NONE		10
/// show "static inventory"
#define INVENTORY_HIDE_COMMON	5
/// show nothing
#define INVENTORY_HIDE_ALL		15
/// absolute maximum - these slots never show on UI at all
#define INVENTORY_HIDE_MAXIMUM	101
