// a set of helpers -- okay, read sanitization helpers.

/datum/preferences_collection/proc/auto_boolean_toggle(datum/preferences/prefs, key)
	SaveKey(prefs, key, !LoadKey(prefs, key))
