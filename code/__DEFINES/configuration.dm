//config files
#define CONFIG_GET(X) global.config.Get(/datum/config_entry/##X)
#define CONFIG_SET(X, Y) global.config.Set(/datum/config_entry/##X, ##Y)
/// Gets the datum of the object, for when editing a const define.
#define CONFIG_GET_ENTRY(X) global.config.GetEntryDatum(/datum/config_entry/##X)
/// Caches an entry in the proc
#define CONFIG_CACHE_ENTRY_AND_FETCH_VALUE(X, varname) var/static/datum/config_entry/##X/entrycache_##varname;if(!entrycache_##varname){entrycache_##varname=CONFIG_GET_ENTRY(##X);};var/##varname=entrycache_##varname.config_entry_value

#define CONFIG_MAPS_FILE "maps.txt"

//flags
#define CONFIG_ENTRY_LOCKED 1	//can't edit
#define CONFIG_ENTRY_HIDDEN 2	//can't see value

// Policy config keys
// MAKE SURE THESE ARE UPPERCASE
/// Displayed to cloned patients
#define POLICYCONFIG_ON_CLONE "ON_CLONE"
/// Displayed to defibbed/revival surgery'd patients before the memory loss time threshold
#define POLICYCONFIG_ON_DEFIB_INTACT "ON_DEFIB_INTACT"
/// Displayed to defibbed/revival surgery'd patients after the memory loss time threshold
#define POLICYCONFIG_ON_DEFIB_LATE "ON_DEFIB_LATE"
/// Displayed to pyroclastic slimes on spawn
#define POLICYCONFIG_ON_PYROCLASTIC_SENTIENT "PYROCLASTIC_SLIME"
/// Displayed to pAIs on spawn
#define POLICYCONFIG_PAI "PAI_SPAWN"
/// displayed to lavaland elites on spawn, overriding the default if set
#define POLICYCONFIG_ELITE_SPAWN "ELITE_FAUNA_SPAWN"
/// displayed to lavaland elites on sentience potion, overriding the default if set
#define POLICYCONFIG_ELITE_SENTIENCE "ELITE_FAUNA_SENTIENCE"
/// displayed to lavaland elites on winning the fight, overriding the default if set
#define POLICYCONFIG_ELITE_WIN "ELITE_FAUNA_WIN"
/// displayed to prisoners on spawn, overriding the default if set
#define POLICYCONFIG_JOB_PRISONER "JOB_PRISONER"
