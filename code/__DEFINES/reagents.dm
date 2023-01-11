#define SOLID 			1
#define LIQUID			2
#define GAS				3

//reagents reaction var defines
#define REAGENT_NORMAL_PH 7.000
#define REAGENT_PH_ACCURACY 0.001
#define REAGENT_PURITY_ACCURACY 0.001
#define DEFAULT_SPECIFIC_HEAT 200

//reagents_holder_flags defines
#define INJECTABLE		(1<<0)	// Makes it possible to add reagents through droppers and syringes.
#define DRAWABLE		(1<<1)	// Makes it possible to remove reagents through syringes.

#define REFILLABLE		(1<<2)	// Makes it possible to add reagents through any reagent container.
#define DRAINABLE		(1<<3)	// Makes it possible to remove reagents through any reagent container.

#define TRANSPARENT		(1<<4)	// Used on containers which you want to be able to see the reagents off.
#define AMOUNT_VISIBLE	(1<<5)	// For non-transparent containers that still have the general amount of reagents in them visible.
#define NO_REACT        (1<<6)  // Applied to a reagent holder, the contents will not react with each other.
#define REAGENT_HOLDER_INSTANT_REACT (1<<8) // Applied to a reagent holder, all of the reactions in the reagents datum will be instant. Meant to be used for things like smoke effects where reactions aren't meant to occur

// Is an open container for all intents and purposes.
#define OPENCONTAINER 	(REFILLABLE | DRAINABLE | TRANSPARENT)

//Used in holder.dm/equlibrium.dm to set values and volume limits
///stops floating point errors causing issues with checking reagent amounts
#define CHEMICAL_QUANTISATION_LEVEL 0.0001
///The smallest amount of volume allowed - prevents tiny numbers
#define CHEMICAL_VOLUME_MINIMUM 0.001
///Round to this, to prevent extreme decimal magic and to keep reagent volumes in line with perceived values.
#define CHEMICAL_VOLUME_ROUNDING 0.01
///Default pH for reagents datum
#define CHEMICAL_NORMAL_PH 7.000


//reagent bitflags, used for altering how they works

///allows on_mob_dead() if present in a dead body

#define REAGENT_DEAD_PROCESS (1<<0)

///Do not split the chem at all during processing - ignores all purity effects

#define REAGENT_DONOTSPLIT			(1<<1)
///Doesn't appear on handheld health analyzers.
#define REAGENT_INVISIBLE			(1<<2)
///When inverted, the inverted chem uses the name of the original chem
#define REAGENT_SNEAKYNAME          (1<<3)
///Retains initial volume of chem when splitting for purity effects
#define REAGENT_SPLITRETAINVOL      (1<<4)

//Chemical reaction flags, for determining reaction specialties
///Convert into impure/pure on reaction completion
#define REACTION_CLEAR_IMPURE       (1<<0)
///Convert into inverse on reaction completion when purity is low enough
#define REACTION_CLEAR_INVERSE      (1<<1)
///Clear converted chems retain their purities/inverted purities. Requires 1 or both of the above.
#define REACTION_CLEAR_RETAIN		(1<<2)
///Used to create instant reactions
#define REACTION_INSTANT            (1<<3)
///Used to force reactions to create a specific amount of heat per 1u created. So if thermic_constant = 5, for 1u of reagent produced, the heat will be forced up arbitarily by 5 irresepective of other reagents. If you use this, keep in mind standard thermic_constant values are 100x what it should be with this enabled.
#define REACTION_HEAT_ARBITARY      (1<<4)
///Used to bypass the chem_master transfer block (This is needed for competitive reactions unless you have an end state programmed). More stuff might be added later. When defining this, please add in the comments the associated reactions that it competes with
#define REACTION_COMPETITIVE        (1<<5)

///Used to force an equlibrium to end a reaction in reaction_step() (i.e. in a reaction_step() proc return END_REACTION to end it)
#define END_REACTION                "end_reaction"

//reagents_value defines, basically a multiplier used in reagent containers cargo selling.
#define DEFAULT_REAGENTS_VALUE 1
#define NO_REAGENTS_VALUE 0
#define HARVEST_REAGENTS_VALUE 0.3

/// Standard reagents value defines.
/// Take a grain of salt, only "rare" reagents should have a decent value here, for balance reasons.
/// TL;DR Think of it also like general market request price more than rarity.
#define REAGENT_VALUE_NONE			0	//all the stuff pretty much available in potentially unlimited quantities.
#define REAGENT_VALUE_VERY_COMMON	0.1 //same as above, just not so unlimited.
#define REAGENT_VALUE_COMMON		0.5
#define REAGENT_VALUE_UNCOMMON		1
#define REAGENT_VALUE_RARE			2.5
#define REAGENT_VALUE_VERY_RARE		5
#define REAGENT_VALUE_EXCEPTIONAL	10	//extremely rare or tedious to craft, possibly unsynthetizable, reagents.
#define REAGENT_VALUE_AMAZING		30	//reserved ONLY for non-mass produceable, unsynthetizable reagents.
#define REAGENT_VALUE_GLORIOUS		300	//reagents that shouldn't be possible to get or farm under normal conditions. e.g. Romerol, fungal TB, adminordrazine...

#define TOUCH			1	// splashing
#define INGEST			2	// ingestion
#define VAPOR			3	// foam, spray, blob attack
#define PATCH			4	// patches
#define INJECT			5	// injection

//container_flags
#define PH_WEAK 		(1 << 0)
#define TEMP_WEAK 		(1 << 1)
#define APTFT_VERB		(1 << 2) //APTFT stands for "amount per transfer from this"
#define APTFT_ALTCLICK	(1 << 3)

//defines passed through to the on_reagent_change proc
#define DEL_REAGENT		1	// reagent deleted (fully cleared)
#define ADD_REAGENT		2	// reagent added
#define REM_REAGENT		3	// reagent removed (may still exist)


#define PILL_STYLE_COUNT 22 //Update this if you add more pill icons or you die (literally, we'll toss a nuke at whever your ip turns up)
#define RANDOM_PILL_STYLE 22 //Dont change this one though

#define THRESHOLD_UNHUSK 50 // health threshold for synthflesh/rezadone to unhusk someone

#define SYNTHTISSUE_BORROW_CAP 250	//The cap for synthtissue's borrowed health value when used on someone dead or already having borrowed health.
#define SYNTHTISSUE_DAMAGE_FLIP_CYCLES 45	//After how many cycles the damage will be pure toxdamage as opposed to clonedamage like initially. Gradually changes during its cycles.

//reagent bitflags, used for altering how they works
#define REAGENT_DEAD_PROCESS		(1<<0)	//calls on_mob_dead() if present in a dead body
#define REAGENT_DONOTSPLIT			(1<<1)	//Do not split the chem at all during processing
#define REAGENT_ONLYINVERSE			(1<<2)	//Only invert chem, no splitting
#define REAGENT_ONMOBMERGE			(1<<3)	//Call on_mob_life proc when reagents are merging.
#define REAGENT_INVISIBLE			(1<<4)	//Doesn't appear on handheld health analyzers.
#define REAGENT_FORCEONNEW			(1<<5)  //Forces a on_new() call without a data overhead
#define REAGENT_SNEAKYNAME          (1<<6)  //When inverted, the inverted chem uses the name of the original chem
#define REAGENT_SPLITRETAINVOL      (1<<7)  //Retains initial volume of chem when splitting
#define REAGENT_ORGANIC_PROCESS		(1<<8)	//Can be processed by organic carbons - will otherwise slowly dissipate
#define REAGENT_ROBOTIC_PROCESS		(1<<9)	//Can be processed by robotic carbons - will otherwise slowly dissipate

#define REAGENT_ALL_PROCESS (REAGENT_ORGANIC_PROCESS | REAGENT_ROBOTIC_PROCESS)	//expand this if you for some reason add more process flags

#define INVALID_REAGENT_DISSIPATION 1		//How much of a reagent is removed per reagent tick if invalid processing-flag wise

//Chemical reaction flags, for determining reaction specialties
#define REACTION_CLEAR_IMPURE       (1<<0)  //Convert into impure/pure on reaction completion
#define REACTION_CLEAR_INVERSE      (1<<1)  //Convert into inverse on reaction completion when purity is low enough

//Chemical blacklists for smartdarts
GLOBAL_LIST_INIT(blacklisted_medchems, list(
	/datum/reagent/medicine/morphine, /datum/reagent/medicine/haloperidol,	//harmful chemicals in medicine
	))
