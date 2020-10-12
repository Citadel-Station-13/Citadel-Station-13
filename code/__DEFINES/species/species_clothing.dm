// Types of clothing so we can restrict certain clothing to certain species
// This is in racial_worn_types variable of /obj/item, and /datum/species
/// Default. Non human mobs have this.
#define RACIAL_WORN_DEFAULT		(1<<0)

// Type of default icons to use for clothing. Species variable var/clothing_asset_set. If an icon state is not in it it will fallback to default.
/// Default. Fallback if an item state isn't found elsewhere.
#define CLOTHING_ASSET_SET_DEFAULT		"DEFAULT"
