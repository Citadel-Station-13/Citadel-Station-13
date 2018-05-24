/*
	These defines are specific to the atom/flags_1 bitmask
*/
#define ALL (~0) //For convenience.
#define NONE 0

GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))

// for /datum/var/datum_flags
#define DF_USE_TAG		(1<<0)
#define DF_VAR_EDITED	(1<<1)

//FLAGS BITMASK

#define NODROP_1					(1<<1)		// This flag makes it so that an item literally cannot be removed at all, or at least that's how it should be. Only deleted.
#define NOBLUDGEON_1				(1<<2)		// when an item has this it produces no "X has been hit by Y with Z" message in the default attackby()
#define HEAR_1						(1<<3)		// This flag is what recursive_hear_check() uses to determine wether to add an item to the hearer list or not.
#define CHECK_RICOCHET_1			(1<<4)		// Projectiels will check ricochet on things impacted that have this.
#define CONDUCT_1					(1<<5)		// conducts electricity (metal etc.)
#define ABSTRACT_1					(1<<6)		// for all things that are technically items but used for various different stuff, made it 128 because it could conflict with other flags other way
#define NODECONSTRUCT_1				(1<<7)		// For machines and structures that should not break into parts, eg, holodeck stuff
#define OVERLAY_QUEUED_1			(1<<8)		// atom queued to SSoverlay
#define ON_BORDER_1					(1<<9)		// item has priority to check when entering or leaving
#define DROPDEL_1					(1<<10)	// When dropped, it calls qdel on itself
#define PREVENT_CLICK_UNDER_1		(1<<11)	//Prevent clicking things below it on the same turf eg. doors/ fulltile windows
#define NO_EMP_WIRES_1				(1<<12)
#define HOLOGRAM_1					(1<<13)
#define TESLA_IGNORE_1				(1<<14) // TESLA_IGNORE grants immunity from being targeted by tesla-style electricity


//turf-only flags
#define NOJAUNT_1				(1<<0)
#define UNUSED_TRANSIT_TURF_1	(1<<1)
#define CAN_BE_DIRTY_1			(1<<2) // If a turf can be made dirty at roundstart. This is also used in areas.
#define NO_DEATHRATTLE_1		(1<<4) // Do not notify deadchat about any deaths that occur on this turf.
#define NO_RUINS_1				(1<<5) //Blocks ruins spawning on the turf
#define NO_LAVA_GEN_1			(1<<6) //Blocks lava rivers being generated on the turf

/*
	These defines are used specifically with the atom/pass_flags bitmask
	the atom/checkpass() proc uses them (tables will call movable atom checkpass(PASSTABLE) for example)
*/
//flags for pass_flags
#define PASSTABLE		(1<<0)
#define PASSGLASS		(1<<1)
#define PASSGRILLE		(1<<2)
#define PASSBLOB		(1<<3)
#define PASSMOB			(1<<4)
#define PASSCLOSEDTURF	(1<<5)
#define LETPASSTHROW	(1<<6)


//Movement Types
#define GROUND (1<<0)
#define FLYING (1<<1)

// Flags for reagents
#define REAGENT_NOREACT (1<<0)

//Fire and Acid stuff, for resistance_flags
#define LAVA_PROOF		(1<<0)
#define FIRE_PROOF		(1<<1) //100% immune to fire damage (but not necessarily to lava or heat)
#define FLAMMABLE		(1<<2)
#define ON_FIRE			(1<<3)
#define UNACIDABLE		(1<<4) //acid can't even appear on it, let alone melt it.
#define ACID_PROOF		(1<<5) //acid stuck on it doesn't melt it.
#define INDESTRUCTIBLE	(1<<6) //doesn't take damage
#define FREEZE_PROOF	(1<<7) //can't be frozen
