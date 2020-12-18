/// Preferences datums keyed to ckey = datum
GLOBAL_LIST_EMPTY(preferences_datums)

/**
  * Preferences datums
  *
  * Holds character setup and global settings information for players.
  */
/datum/preferences
	/// Owning client, if connected
	var/client/parent
	/// Owner ckey
	var/ckey

	/// Variable store for the actual preference collections. list(save_key = list(var1 = val1, ...), ...)
	var/list/preferences

	// Key bindings are stored directly for performance
	/// Custom Keybindings
	var/list/key_bindings = list()
	/// List with a key string associated to a list of keybindings. Unlike key_bindings, this one operates on raw key, allowing for binding a key that triggers regardless of if a modifier is depressed as long as the raw key is sent.
	var/list/modless_key_bindings = list()

	// Metadata begin

	// Metadata end

	// Other loaded settings begin - these aren't stored in [preferences] either because they're accessed super often, or for some other reason that makes the inherent slowness unfavorable

	// End

/datum/preferences/New(client/C)
	preferences = list()
	var/ckey = istext(C)? C : C?.ckey
	if(!ckey)
		CRASH("Preferences datum instantiated with no client or ckey. Aborting initialization.")

/**
 * Directly sets to in-memory stores for a certain collection of a save key
 */
/datum/preferences/proc/set_data(save_key, key, data)
	LAZYSET(preferences[save_key], key, data)

/**
 * Directly reads from in-memory stores for a certain collection of a save key
 */
/datum/preferences/proc/load_data(save_key, key)
	return LAZYACCESS(preferences[save_key], key)

/**
 * Directly reads from in-memory stores for a certain collection of a save key. Returns default if null.
 */
/datum/preferences/proc/load_data_or_default(save_key, key, default)
	. = LAZYACCESS(preferences[save_key], key)
	if(isnull(.))
		return default
