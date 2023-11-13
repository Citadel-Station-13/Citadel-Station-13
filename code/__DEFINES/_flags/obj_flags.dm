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
#define BLOCK_Z_OUT_DOWN		(1<<9)  // Should this object block z falling from loc?
#define BLOCK_Z_OUT_UP			(1<<10) // Should this object block z uprise from loc?
#define BLOCK_Z_IN_DOWN			(1<<11) // Should this object block z falling from above?
#define BLOCK_Z_IN_UP			(1<<12) // Should this object block z uprise from below?
#define SHOVABLE_ONTO			(1<<13)//called on turf.shove_act() to consider whether an object should have a niche effect (defined in their own shove_act()) when someone is pushed onto it, or do a sanity CanPass() check.
#define EXAMINE_SKIP			(1<<14) /// Makes the Examine proc not read out this item.
#define IN_STORAGE				(1<<15) //is this item in the storage item, such as backpack? used for tooltips
#define HAND_ITEM               (1<<16) // If an item is just your hand (circled hand, slapper) and shouldn't block things like riding
/// Has contextual screentips when HOVERING OVER OTHER objects
#define ITEM_HAS_CONTEXTUAL_SCREENTIPS (1 << 17)

/// Integrity defines for clothing (not flags but close enough)
#define CLOTHING_PRISTINE	0 // We have no damage on the clothing
#define CLOTHING_DAMAGED	1 // There's some damage on the clothing but it still has at least one functioning bodypart
#define CLOTHING_SHREDDED	2 // The clothing is near useless and has their sensors broken

// If you add new ones, be sure to add them to /obj/Initialize as well for complete mapping support

/// Flags for the pod_flags var on /obj/structure/closet/supplypod
#define FIRST_SOUNDS (1<<0) // If it shouldn't play sounds the first time it lands, used for reverse mode
