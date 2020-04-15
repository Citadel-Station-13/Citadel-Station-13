// storage_flags variable on /datum/component/storage

// Storage limits. These can be combined (and usually are combined).
/// Check max_items and contents.len when trying to insert
#define STORAGE_LIMIT_MAX_ITEMS				(1<<0)
/// Check max_combined_w_class.
#define STORAGE_LIMIT_COMBINED_W_CLASS		(1<<1)
/// Use the new volume system. Will automatically force rendering to use the new volume/baystation scaling UI so this is kind of incompatible with stuff like stack storage etc etc.
#define STORAGE_LIMIT_VOLUME				(1<<2)
/// Use max_w_class
#define STORAGE_LIMIT_MAX_W_CLASS			(1<<3)

#define STORAGE_FLAGS_LEGACY_DEFAULT		(STORAGE_LIMIT_MAX_ITEMS | STORAGE_LIMIT_COMBINED_W_CLASS | STORAGE_LIMIT_MAX_W_CLASS)
#define STORAGE_FLAGS_VOLUME_DEFAULT		(STORAGE_LIMIT_VOLUME | STORAGE_LIMIT_MAX_W_CLASS)

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

#define DEFAULT_VOLUME_TINY				1
#define DEFAULT_VOLUME_SMALL			2
#define DEFAULT_VOLUME_NORMAL			4
#define DEFAULT_VOLUME_BULKY			8
#define DEFAULT_VOLUME_HUGE				16
#define DEFAULT_VOLUME_GIGANTIC			32

GLOBAL_LIST_INIT(default_weight_class_to_volume, list(
	"[WEIGHT_CLASS_TINY]" = DEFAULT_VOLUME_TINY,
	"[WEIGHT_CLASS_SMALL]" = DEFAULT_VOLUME_SMALL,
	"[WEIGHT_CLASS_NORMAL]" = DEFAULT_VOLUME_NORMAL,
	"[WEIGHT_CLASS_BULKY]" = DEFAULT_VOLUME_BULKY,
	"[WEIGHT_CLASS_HUGE]" = DEFAULT_VOLUME_HUGE,
	"[WEIGHT_CLASS_GIGANTIC]" = DEFAULT_VOLUME_GIGANTIC
	))

/// Macro for automatically getting the volume of an item from its w_class.
#define AUTO_SCALE_VOLUME(w_class)							(GLOB.default_Weight_class_to_volume["[w_class]"])
/// Macro for automatically getting the volume of a storage item from its max_w_class and max_combined_w_class.
#define AUTO_SCALE_STORAGE_VOLUME(w_class, max_combined_w_class)		(AUTO_SCALE_VOLUME(w_class) * (max_combined_w_class / w_class))

// Let's keep all of this in one place. given what we put above anyways..
#define MAX_WEIGHT_CLASS_BACKPACK					WEIGHT_CLASS_NORMAL
#define MAX_WEIGHT_CLASS_BAG_OF_HOLDING				WEIGHT_CLASS_BULKY

#define STORAGE_VOLUME_BACKPACK						(DEFAULT_VOLUME_NORMAL * 7)
#define STORAGE_VOLUME_DUFFLEBAG					(DEFAULT_VOLUME_NORMAL * 10)
#define STORAGE_VOLUME_BAG_OF_HOLDING				(DEFAULT_VOLUME_NORMAL * 20)

// UI defines
/// Size of volumetric box icon
#define VOLUMETRIC_STORAGE_BOX_ICON_SIZE 32
/// Size of EACH left/right border icon for volumetric boxes
#define VOLUMETRIC_STORAGE_BOX_BORDER_SIZE 1
/// Minimum pixels an item must have in volumetric scaled storage UI
#define MINIMUM_PIXELS_PER_ITEM 6
/// Maximum number of objects that will be allowed to be displayed using the volumetric display system. Arbitrary number to prevent server lockups.
#define MAXIMUM_VOLUMETRIC_ITEMS 256
/// How much padding to give between items
#define VOLUMETRIC_STORAGE_ITEM_PADDING 1
/// How much padding to give to edges
#define VOLUMETRIC_STORAGE_EDGE_PADDING 1
