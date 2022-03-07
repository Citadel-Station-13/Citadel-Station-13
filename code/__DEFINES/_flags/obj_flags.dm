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
#define SHOVABLE_ONTO			(1<<9)//called on turf.shove_act() to consider whether an object should have a niche effect (defined in their own shove_act()) when someone is pushed onto it, or do a sanity CanPass() check.
#define EXAMINE_SKIP			(1<<10) /// Makes the Examine proc not read out this item.
#define IN_STORAGE				(1<<11) //is this item in the storage item, such as backpack? used for tooltips
#define HAND_ITEM               (1<<12) // If an item is just your hand (circled hand, slapper) and shouldn't block things like riding

/// Integrity defines for clothing (not flags but close enough)
#define CLOTHING_PRISTINE	0 // We have no damage on the clothing
#define CLOTHING_DAMAGED	1 // There's some damage on the clothing but it still has at least one functioning bodypart
#define CLOTHING_SHREDDED	2 // The clothing is near useless and has their sensors broken

// If you add new ones, be sure to add them to /obj/Initialize as well for complete mapping support

/// Flags for the pod_flags var on /obj/structure/closet/supplypod
#define FIRST_SOUNDS (1<<0) // If it shouldn't play sounds the first time it lands, used for reverse mode
