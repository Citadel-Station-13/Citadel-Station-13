//TODO: move these to their own file
#define POOL_FRIGID 1
#define POOL_COOL 2
#define POOL_NORMAL 3
#define POOL_WARM 4
#define POOL_SCALDING 5

GLOBAL_LIST_INIT(blacklisted_pool_reagents, list(
	/datum/reagent/plasma, /datum/reagent/oxygen, /datum/reagent/n2o, /datum/reagent/nitrogen,		//gases
	/datum/reagent/fermi,		//blanket fermichem ban sorry. this also covers mkultra, genital enlargers, etc etc.
	/datum/reagent/drug/aphrodisiac, /datum/reagent/drug/anaphrodisiac, /datum/reagent/drug/aphrodisiacplus, /datum/reagent/anaphrodisiacplus		//literally asking for prefbreaks
	))
