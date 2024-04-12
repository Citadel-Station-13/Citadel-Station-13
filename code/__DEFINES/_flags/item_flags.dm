// Flags for the item_flags var on /obj/item

#define BEING_REMOVED						(1<<0)
///is this item equipped into an inventory slot or hand of a mob? used for tooltips
#define IN_INVENTORY						(1<<1)
///used for tooltips
#define FORCE_STRING_OVERRIDE				(1<<2)
///Used by security bots to determine if this item is safe for public use.
#define NEEDS_PERMIT						(1<<3)
#define SLOWS_WHILE_IN_HAND					(1<<4)
///Stops you from putting things like an RCD or other items into an ORM or protolathe for materials.
#define NO_MAT_REDEMPTION					(1<<5)
///When dropped, it calls qdel on itself
#define DROPDEL								(1<<6)
///when an item has this it produces no "X has been hit by Y with Z" message in the default attackby()
#define NOBLUDGEON							(1<<7)
///for all things that are technically items but used for various different stuff
#define ABSTRACT							(1<<8)
///When players should not be able to change the slowdown of the item (Speed potions, ect)
#define IMMUTABLE_SLOW          			(1<<9)
///Tool commonly used for surgery: won't attack targets in an active surgical operation on help intent (in case of mistakes)
#define SURGICAL_TOOL						(1<<10)
///Can be worn on certain slots (currently belt and id) that would otherwise require an uniform.
#define NO_UNIFORM_REQUIRED					(1<<11)
/// This item can be used to parry. Only a basic check used to determine if we should proceed with parry chain at all.
#define ITEM_CAN_PARRY						(1<<12)
/// This item can be used in the directional blocking system. Only a basic check used to determine if we should proceed with directional block handling at all.
#define ITEM_CAN_BLOCK						(1<<13)

// Flags for the clothing_flags var on /obj/item/clothing

#define LAVAPROTECT 			(1<<0)
#define STOPSPRESSUREDAMAGE		(1<<1)	//SUIT and HEAD items which stop pressure damage. To stop you taking all pressure damage you must have both a suit and head item with this flag.
#define BLOCK_GAS_SMOKE_EFFECT	(1<<2)	//blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets ONLY!
#define ALLOWINTERNALS		  	(1<<3)	//mask allows internals
#define NOSLIP                  (1<<4)	//prevents from slipping on wet floors, in space etc
#define NOSLIP_ICE				(1<<5)	 //prevents from slipping on frozen floors
#define THICKMATERIAL			(1<<6)	//prevents syringes, parapens and hypos if the external suit or helmet (if targeting head) has this flag. Example: space suits, biosuit, bombsuits, thick suits that cover your body.
#define VOICEBOX_TOGGLABLE 		(1<<7)	//The voicebox in this clothing can be toggled.
#define VOICEBOX_DISABLED 		(1<<8)	//The voicebox is currently turned off.
#define IGNORE_HAT_TOSS			(1<<9)	//Hats with negative effects when worn (i.e the tinfoil hat).
#define SCAN_REAGENTS			(1<<10)	// Allows helmets and glasses to scan reagents.

// Flags for the organ_flags var on /obj/item/organ

#define ORGAN_SYNTHETIC			(1<<0)	//Synthetic organs, or cybernetic organs. Reacts to EMPs and don't deteriorate or heal
#define ORGAN_FROZEN			(1<<1)	//Frozen organs, don't deteriorate
#define ORGAN_FAILING			(1<<2)	//Failing organs perform damaging effects until replaced or fixed
#define ORGAN_EXTERNAL			(1<<3)	//Was this organ implanted/inserted/etc, if true will not be removed during species change.
#define ORGAN_VITAL				(1<<4)	//Currently only the brain
#define ORGAN_NO_SPOIL			(1<<5)	//Do not spoil under any circumstances
#define ORGAN_NO_DISMEMBERMENT	(1<<6)	//Immune to disembowelment.
#define ORGAN_EDIBLE			(1<<7)	//is a snack? :D
#define ORGAN_SYNTHETIC_EMP		(1<<8)	//Synthetic organ affected by an EMP. Deteriorates over time.
