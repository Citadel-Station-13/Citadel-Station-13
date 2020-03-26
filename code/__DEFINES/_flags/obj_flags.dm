// Flags for the obj_flags var on /obj

#define EMAGGED					(1<<0)
#define IN_USE					(1<<1)	//If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
#define CAN_BE_HIT				(1<<2)	//can this be bludgeoned by items?
#define BEING_SHOCKED			(1<<3)	//Whether this thing is currently (already) being shocked by a tesla
#define DANGEROUS_POSSESSION	(1<<4)	//Admin possession yes/no
#define ON_BLUEPRINTS			(1<<5)	//Are we visible on the station blueprints at roundstart?
#define UNIQUE_RENAME			(1<<6)	//can you customize the description/name of the thing?
#define USES_TGUI				(1<<7)	//put on things that use tgui on ui_interact instead of custom/old UI.
#define FROZEN					(1<<8)
#define SHOVABLE_ONTO			(1<<9)	//called on turf.shove_act() to consider whether an object should have a niche effect (defined in their own shove_act()) when someone is pushed onto it, or do a sanity CanPass() check.
#define BLOCK_Z_FALL			(1<<10)

// If you add new ones, be sure to add them to /obj/Initialize as well for complete mapping support
