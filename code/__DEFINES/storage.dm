// storage_flags variable on /datum/component/storage

// Storage limits. These can be combined I guess but you really, really shouldn't (don't do it really)
/// Check max_items and contents.len when trying to insert
#define STORAGE_LIMIT_MAX_ITEMS				(1<<0)
/// Check w_class and max_combined_w_class, aka legacy behavior if you combine it with [STORAGE_LIMIT_MAX_ITEMS].
#define STORAGE_LIMIT_COMBINED_W_CLASS		(1<<1)
/// Use max_w_class for maximum w_class but use the new volume system. Will automatically force rendering to use the new volume/baystation scaling UI so this is kind of incompatible with stuff like stack storage etc etc.
#define STORAGE_LIMIT_VOLUME				(1<<2)

//ITEM INVENTORY WEIGHT, FOR w_class
/// Usually items smaller then a human hand, ex: Playing Cards, Lighter, Scalpel, Coins/Money
#define WEIGHT_CLASS_TINY     1
/// Pockets can hold small and tiny items, ex: Flashlight, Multitool, Grenades, GPS Device
#define WEIGHT_CLASS_SMALL    2
/// Standard backpacks can carry tiny, small & normal items, ex: Fire extinguisher, Stunbaton, Gas Mask, Metal Sheets
#define WEIGHT_CLASS_NORMAL   3
/// Items that can be weilded or equipped but not stored in a normal bag, ex: Defibrillator, Backpack, Space Suits
#define WEIGHT_CLASS_BULKY    4
/// Usually represents objects that require two hands to operate, ex: Shotgun, Two Handed Melee Weapons - Can not fit in Boh
#define WEIGHT_CLASS_HUGE     5
/// Essentially means it cannot be picked up or placed in an inventory, ex: Mech Parts, Safe - Can not fit in Boh
#define WEIGHT_CLASS_GIGANTIC 6

/// Macro for automatically getting the volume of an item from its w_class.
#define AUTO_SCALE_VOLUME(w_class)							(2 ** w_class)
/// Macro for automatically getting the volume of a storage item from its max_w_class and max_combined_w_class.
#define AUTO_SCALE_STORAGE_VOLUME(w_class, max_combined_w_class)		(AUTO_SCALE_VOLUME(w_class) * (max_combined_w_class / w_class))

// UI defines
/// Minimum pixels an item must have in volumetric scaled storage UI
#define MINIMUM_PIXELS_PER_ITEM 2
/// Maximum number of objects that will be allowed to be displayed using the volumetric display system. Arbitrary number to prevent server lockups.
#define MAXIMUM_VOLUMETRIC_ITEMS 256
