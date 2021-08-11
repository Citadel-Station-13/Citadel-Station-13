// a set of helpers -- okay, read sanitization helpers.

/datum/preferences_collection/proc/auto_boolean_toggle(datum/preferences/prefs, key)
	SaveKey(prefs, key, !LoadKey(prefs, key))

/datum/preferences_collection/proc/auto_add_bitfield(datum/preferences/prefs, key, flags)
	SaveKey(prefs, key, (LoadKey(prefs, key) || NONE) | flags)

/datum/preferences_collection/proc/auto_reemove_bitfield(datum/preferences/prefs, key, flags)
	SaveKey(prefs, key, (LoadKey(prefs, key) || NONE) & (~flags))

/datum/preferences_collection/proc/auto_toggle_bitfield(datum/preferences/prefs, key, flags)
	SaveKey(prefs, key, (LoadKey(prefs, key) || NONE) ^ flags)
