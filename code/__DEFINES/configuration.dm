//config files
#define CONFIG_GET(X) global.config.Get(/datum/config_entry/##X)
#define CONFIG_SET(X, Y) global.config.Set(/datum/config_entry/##X, ##Y)
#define CONFIG_GET_ENTRY(X) global.config.GetEntryDatum(/datum/config_entry/##X)

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
