// Flags for the item_flags var on /obj/item

#define BEING_REMOVED						(1<<0)
#define IN_INVENTORY						(1<<1)	//is this item equipped into an inventory slot or hand of a mob? used for tooltips
#define FORCE_STRING_OVERRIDE				(1<<2)	//used for tooltips
#define NEEDS_PERMIT						(1<<3)	//Used by security bots to determine if this item is safe for public use.
#define SLOWS_WHILE_IN_HAND					(1<<4)
#define NO_MAT_REDEMPTION					(1<<5)	//Stops you from putting things like an RCD or other items into an ORM or protolathe for materials.
#define DROPDEL								(1<<6)	//When dropped, it calls qdel on itself
#define NOBLUDGEON							(1<<7)	//when an item has this it produces no "X has been hit by Y with Z" message in the default attackby()
#define ABSTRACT							(1<<8) 	//for all things that are technically items but used for various different stuff
#define IMMUTABLE_SLOW          			(1<<9)	//When players should not be able to change the slowdown of the item (Speed potions, ect)
#define SURGICAL_TOOL						(1<<10)	//Tool commonly used for surgery: won't attack targets in an active surgical operation on help intent (in case of mistakes)
#define NO_UNIFORM_REQUIRED					(1<<11) //Can be worn on certain slots (currently belt and id) that would otherwise require an uniform.
#define NO_ATTACK_CHAIN_SOFT_STAMCRIT		(1<<12)		//Entirely blocks melee_attack_chain() if user is soft stamcritted. Uses getStaminaLoss() to check at this point in time. THIS DOES NOT BLOCK RANGED AFTERATTACK()S, ONLY MELEE RANGE AFTERATTACK()S.
/// This item can be used to parry. Only a basic check used to determine if we should proceed with parry chain at all.
#define ITEM_CAN_PARRY						(1<<0)
/// This item can be used in the directional blocking system. Only a basic check used to determine if we should proceed with directional block handling at all.
#define ITEM_CAN_BLOCK						(1<<1)


// Flags for the clothing_flags var on /obj/item/clothing

#define LAVAPROTECT 			(1<<0)
#define STOPSPRESSUREDAMAGE		(1<<1)	//SUIT and HEAD items which stop pressure damage. To stop you taking all pressure damage you must have both a suit and head item with this flag.
#define BLOCK_GAS_SMOKE_EFFECT	(1<<2)	//blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets ONLY!
#define ALLOWINTERNALS		  	(1<<3)	//mask allows internals
#define NOSLIP                  (1<<4)	//prevents from slipping on wet floors, in space etc
#define THICKMATERIAL			(1<<5)	//prevents syringes, parapens and hypos if the external suit or helmet (if targeting head) has this flag. Example: space suits, biosuit, bombsuits, thick suits that cover your body.
#define VOICEBOX_TOGGLABLE 		(1<<6)	//The voicebox in this clothing can be toggled.
#define VOICEBOX_DISABLED 		(1<<7)	//The voicebox is currently turned off.
#define IGNORE_HAT_TOSS			(1<<8)	//Hats with negative effects when worn (i.e the tinfoil hat).
#define SCAN_REAGENTS			(1<<9)	// Allows helmets and glasses to scan reagents.

// Flags for the organ_flags var on /obj/item/organ

#define ORGAN_SYNTHETIC			(1<<0)	//Synthetic organs, or cybernetic organs. Reacts to EMPs and don't deteriorate or heal
#define ORGAN_FROZEN			(1<<1)	//Frozen organs, don't deteriorate
#define ORGAN_FAILING			(1<<2)	//Failing organs perform damaging effects until replaced or fixed
#define ORGAN_EXTERNAL			(1<<3)	//Was this organ implanted/inserted/etc, if true will not be removed during species change.
#define ORGAN_VITAL				(1<<4)	//Currently only the brain
#define ORGAN_NO_SPOIL			(1<<5)	//Do not spoil under any circumstances
#define ORGAN_NO_DISMEMBERMENT	(1<<6)	//Immune to disembowelment.
