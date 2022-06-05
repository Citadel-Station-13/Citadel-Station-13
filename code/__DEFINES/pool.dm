//TODO: move these to their own file
#define POOL_FRIGID 1
#define POOL_COOL 2
#define POOL_NORMAL 3
#define POOL_WARM 4
#define POOL_SCALDING 5

GLOBAL_LIST_INIT(blacklisted_pool_reagents, list(
	/datum/reagent/toxin/plasma, /datum/reagent/oxygen, /datum/reagent/nitrous_oxide, /datum/reagent/nitrogen,		//gases
	/datum/reagent/fermi,		//blanket fermichem ban sorry. this also covers mkultra, genital enlargers, etc etc.
	/datum/reagent/consumable/semen,			//NO.
	/datum/reagent/consumable/milk
	))
