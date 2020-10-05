// PLEASE KEEP ALL VOLUME DEFINES IN THIS FILE, it's going to be hell to keep track of them later.

#define DEFAULT_VOLUME_TINY				2
#define DEFAULT_VOLUME_SMALL			3
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
#define AUTO_SCALE_VOLUME(w_class)							(GLOB.default_weight_class_to_volume["[w_class]"])
/// Macro for automatically getting the volume of a storage item from its max_w_class and max_combined_w_class.
#define AUTO_SCALE_STORAGE_VOLUME(w_class, max_combined_w_class)		(AUTO_SCALE_VOLUME(w_class) * (max_combined_w_class / w_class))

// Let's keep all of this in one place. given what we put above anyways..

// volume amount for items
/// volume for a data disk
#define ITEM_VOLUME_DISK					1
/// volume for a shotgun stripper clip holding 4 shells
#define ITEM_VOLUME_STRIPPER_CLIP			(DEFAULT_VOLUME_NORMAL * 0.5)

// #define SAMPLE_VOLUME_AMOUNT 2

// max_weight_class for storages
#define MAX_WEIGHT_CLASS_BACKPACK					WEIGHT_CLASS_NORMAL
#define MAX_WEIGHT_CLASS_BAG_OF_HOLDING				WEIGHT_CLASS_BULKY

// max_volume for storages
#define STORAGE_VOLUME_BACKPACK						(DEFAULT_VOLUME_NORMAL * 7)
#define STORAGE_VOLUME_DUFFLEBAG					(DEFAULT_VOLUME_NORMAL * 10)
#define STORAGE_VOLUME_BAG_OF_HOLDING				(DEFAULT_VOLUME_NORMAL * 20)
#define STORAGE_VOLUME_CHEMISTRY_BAG				(DEFAULT_VOLUME_TINY * 50)
#define STORAGE_VOLUME_PILL_BOTTLE					(DEFAULT_VOLUME_TINY * 7)
