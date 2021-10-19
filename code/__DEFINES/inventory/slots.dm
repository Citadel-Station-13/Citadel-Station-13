// Standard, hardcoded slots:

// slots by ID

// real slots
#define INV_SLOT_HEAD				"head"
#define INV_SLOT_GLOVES				"gloves"
#define INV_SLOT_SHOES				"shoes"
#define INV_SLOT_UNIFORM			"uniform"
#define INV_SLOT_SUIT				"suit"
#define INV_SLOT_BACK				"back"
#define INV_SLOT_BELT				"belt"
#define INV_SLOT_EYES				"eyes"
#define INV_SLOT_MASK				"mask"
#define INV_SLOT_NECK				"neck"
#define INV_SLOT_SUIT_STORAGE		"suit_store"
#define INV_SLOT_ID					"id"
#define INV_SLOT_LEFT_POCKET		"pocket_left"
#define INV_SLOT_RIGHT_POCKET		"pocket_right"
#define INV_SLOT_HANDCUFFS			"handcuffs"
#define INV_SLOT_LEGCUFFS			"legcuffs"
#define INV_SLOT_DEXTROUS_STORAGE	"dextrous"
#define INV_SLOT_EARS				"ears"

// "virtual" special slots
/// insertion-only: put item in any hand
#define	INV_VIRTUALSLOT_IN_HANDS			"hands"
/// insertion-only: put item in belt
#define INV_VIRTUALSLOT_IN_BELT				"belt"
/// insertion-only: put item in backpack
#define INV_VIRTUALSLOT_IN_BACKPACK			"backpack"
/// insertion-only: put item in any pocket
#define INV_VIRTUALSLOT_IN_POCKETS			"pockets"

/// Special "all" slot used in spritesheet/flags defines
#define INV_SLOT_ANY				"_ANY_"

// equip returns
/// success
#define EQUIP_SUCCESS				NONE
/// no slot on mob
#define EQUIP_FAIL_NO_SLOT			(1<<0)
/// slot occupied
#define EQUIP_FAIL_SLOT_OCCUPIED	(1<<1)
/// item doesn't fit in slot - item refused
#define EQUIP_FAIL_NOFIT_ITEM		(1<<2)
/// item doesn't fit in slot - slot refused
#define EQUIP_FAIL_NOFIT_SLOT		(1<<3)

// /obj/item/slot_flags
#define SLOT_FLAG_SUIT			(1<<0)
#define SLOT_FLAG_UNIFORM		(1<<1)
#define SLOT_FLAG_GLOVES		(1<<2)
#define SLOT_FLAG_EYES			(1<<3)
#define SLOT_FLAG_EARS			(1<<4)
#define SLOT_FLAG_MASK			(1<<5)
#define SLOT_FLAG_HEAD			(1<<6)
#define SLOT_FLAG_FEET			(1<<7)
#define SLOT_FLAG_ID			(1<<8)
#define SLOT_FLAG_BELT			(1<<9)
#define SLOT_FLAG_BACK			(1<<10)
#define SLOT_FLAG_POCKET		(1<<11) // this is to allow items with a w_class of WEIGHT_CLASS_NORMAL or WEIGHT_CLASS_BULKY to fit in pockets.
#define SLOT_FLAG_DENYPOCKET	(1<<12) // this is to deny items with a w_class of WEIGHT_CLASS_SMALL or WEIGHT_CLASS_TINY to fit in pockets.
#define SLOT_FLAG_NECK			(1<<13)
#define SLOT_FLAG_SUIT_STORE	(1<<14)	// always wearable in suit storage

/// **heuristic** for what slot flag a slot is
/proc/inv_slot_to_flag(slot)
	. = NONE
	switch(slot)
		if(INV_SLOT_HEAD)
			return SLOT_FLAG_HEAD
		if(INV_SLOT_EYES)
			return SLOT_FLAG_EYES
		if(INV_SLOT_UNIFORM)
			return SLOT_FLAG_UNIFORM
		if(INV_SLOT_SUIT)
			return SLOT_FLAG_SUIT
		if(INV_SLOT_BACK)
			return SLOT_FLAG_BACK
		if(INV_SLOT_MASK)
			return SLOT_FLAG_MASK
		if(INV_SLOT_NECK)
			return SLOT_FLAG_NECK
		if(INV_SLOT_BELT)
			return SLOT_FLAG_BELT
		if(INV_SLOT_ID)
			return SLOT_FLAG_ID
		if(INV_SLOT_GLOVES)
			return SLOT_FLAG_GLOVES
		if(INV_SLOT_BELT)
			return SLOT_FLAG_BELT
		if(INV_SLOT_LEFT_POCKET, INV_SLOT_RIGHT_POCKET, INV_VIRTUALSLOT_IN_POCKETS)
			return SLOT_FLAG_POCKET
		if(INV_SLOT_SUIT_STORAGE)
			return SLOT_FLAG_SUIT_STORE
		if(INV_SLOT_EARS)
			return SLOT_FLAG_EARS
		if(INV_SLOT_SHOES)
			return SLOT_FLAG_FEET





//flags for alternate styles: These are hard sprited so don't set this if you didn't put the effort in
#define NORMAL_STYLE		0
#define ALT_STYLE			1

//flags for female outfits: How much the game can safely "take off" the uniform without it looking weird
#define NO_FEMALE_UNIFORM			0
#define FEMALE_UNIFORM_FULL			1
#define FEMALE_UNIFORM_TOP			2

//flags for outfits that have mutant race variants: Most of these require additional sprites to work.
#define STYLE_DIGITIGRADE		(1<<0) //jumpsuits, suits and shoes
#define STYLE_MUZZLE			(1<<1) //hats or masks
#define STYLE_SNEK_TAURIC		(1<<2) //taur-friendly suits
#define STYLE_PAW_TAURIC		(1<<3)
#define STYLE_HOOF_TAURIC		(1<<4)
#define STYLE_ALL_TAURIC		(STYLE_SNEK_TAURIC|STYLE_PAW_TAURIC|STYLE_HOOF_TAURIC)
#define STYLE_NO_ANTHRO_ICON	(1<<5) //When digis fit the default sprite fine and need no copypasted states. This is the case of skirts and winter coats, for example.
#define USE_SNEK_CLIP_MASK		(1<<6)
#define USE_QUADRUPED_CLIP_MASK	(1<<7)
#define USE_TAUR_CLIP_MASK		(USE_SNEK_CLIP_MASK|USE_QUADRUPED_CLIP_MASK)

//digitigrade legs settings.
#define NOT_DIGITIGRADE				0
#define FULL_DIGITIGRADE			1
#define SQUISHED_DIGITIGRADE		2

//flags for covering body parts
#define GLASSESCOVERSEYES	(1<<0)
#define MASKCOVERSEYES		(1<<1)		// get rid of some of the other stupidity in these flags
#define HEADCOVERSEYES		(1<<2)		// feel free to realloc these numbers for other purposes
#define MASKCOVERSMOUTH		(1<<3)		// on other items, these are just for mask/head
#define HEADCOVERSMOUTH		(1<<4)

#define TINT_DARKENED 2			//Threshold of tint level to apply weld mask overlay
#define TINT_BLIND 3			//Threshold of tint level to obscure vision fully


//Allowed equipment lists for security vests and hardsuits.

GLOBAL_LIST_INIT(advanced_hardsuit_allowed, typecacheof(list(
	/obj/item/ammo_box,
	/obj/item/ammo_casing,
	/obj/item/flashlight,
	/obj/item/gun,
	/obj/item/melee/baton,
	/obj/item/reagent_containers/spray/pepper,
	/obj/item/restraints/handcuffs,
	/obj/item/tank/internals)))

GLOBAL_LIST_INIT(security_hardsuit_allowed, typecacheof(list(
	/obj/item/ammo_box,
	/obj/item/ammo_casing,
	/obj/item/flashlight,
	/obj/item/gun/ballistic,
	/obj/item/gun/energy,
	/obj/item/melee/baton,
	/obj/item/reagent_containers/spray/pepper,
	/obj/item/restraints/handcuffs,
	/obj/item/tank/internals)))

GLOBAL_LIST_INIT(detective_vest_allowed, typecacheof(list(
	/obj/item/ammo_box,
	/obj/item/ammo_casing,
	/obj/item/detective_scanner,
	/obj/item/flashlight,
	/obj/item/taperecorder,
	/obj/item/gun/ballistic,
	/obj/item/gun/energy,
	/obj/item/lighter,
	/obj/item/melee/baton,
	/obj/item/melee/classic_baton,
	/obj/item/reagent_containers/spray/pepper,
	/obj/item/restraints/handcuffs,
	/obj/item/storage/fancy/cigarettes,
	/obj/item/tank/internals/emergency_oxygen,
	/obj/item/tank/internals/plasmaman)))

GLOBAL_LIST_INIT(security_vest_allowed, typecacheof(list(
	/obj/item/ammo_box,
	/obj/item/ammo_casing,
	/obj/item/flashlight,
	/obj/item/gun/ballistic,
	/obj/item/gun/energy,
	/obj/item/kitchen/knife/combat,
	/obj/item/melee/baton,
	/obj/item/melee/classic_baton/telescopic,
	/obj/item/reagent_containers/spray/pepper,
	/obj/item/restraints/handcuffs,
	/obj/item/tank/internals/emergency_oxygen,
	/obj/item/tank/internals/plasmaman)))

GLOBAL_LIST_INIT(security_wintercoat_allowed, typecacheof(list(
	/obj/item/ammo_box,
	/obj/item/ammo_casing,
	/obj/item/flashlight,
	/obj/item/storage/fancy/cigarettes,
	/obj/item/gun/ballistic,
	/obj/item/gun/energy,
	/obj/item/lighter,
	/obj/item/melee/baton,
	/obj/item/melee/classic_baton/telescopic,
	/obj/item/reagent_containers/spray/pepper,
	/obj/item/restraints/handcuffs,
	/obj/item/tank/internals/emergency_oxygen,
	/obj/item/tank/internals/plasmaman,
	/obj/item/toy)))

//Internals checker
#define GET_INTERNAL_SLOTS(C) list(C.head, C.wear_mask)

//Slots that won't trigger humans' update_genitals() on equip().
GLOBAL_LIST_INIT(no_genitals_update_slots, list(SLOT_L_STORE, SLOT_R_STORE, SLOT_S_STORE, SLOT_IN_BACKPACK, SLOT_LEGCUFFED, SLOT_HANDCUFFED, SLOT_HANDS, SLOT_GENERC_DEXTROUS_STORAGE))
