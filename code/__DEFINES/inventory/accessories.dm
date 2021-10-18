/**
 * Clothing accessory system defines
 * Only valid for /obj/item/clothing
 */

// accessory types - flags, but every clothing can only be one of these at most.
/// cloak
#define ACCESSORY_TYPE_CLOAK			(1<<0)
/// jacket
#define ACCESSORY_TYPE_JACKET			(1<<1)
/// misc decals
#define ACCESSORY_TYPE_DECAL			(1<<2)
/// scarf
#define ACCESSORY_TYPE_SCARF			(1<<3)
/// medal - singular because fuck milrpers who attach 3 of these
#define ACCESSORY_TYPE_MEDAL			(1<<4)
/// shirt
#define ACCESSORY_TYPE_SHIRT			(1<<5)

/// max number of decals per clothing item
#define MAX_DECAL_ACCESSORIES			5
