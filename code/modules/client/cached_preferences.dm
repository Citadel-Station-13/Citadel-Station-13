/**
 * Cached preferences variable
 *
 * Used when performance is key; i.e. keybindings.
 */
/datum/preferences_variable_cache
	/// Key bindings
	var/list/key_bindings
	/// Modless key bindings
	var/list/modless_key_bindings

/datum/preferences_variable_cache/New()
	// Init defaults
	modless_key_bindings = list()
	key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key)

/datum/preferences_variable_cache/proc/sync(datum/preferences/P)
	key_bindings = P.get_keybinds()
	modless_key_bindings = P.get_modless_keybinds()
