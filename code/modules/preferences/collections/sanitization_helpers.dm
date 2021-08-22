// A set of helpers to automatically sanitize values to save on the SaveKey LoadKey spam
// WARNING: This file assumes you're using SaveKey and LoadKey standard behavior
// Snowflake collections that are both character and global at the same time, that aren't hybrid, need to implement
// their own behavior, as otherwise you might sanitize or write to the wrong areas.

/datum/preferences_collection/proc/auto_sanitize_list(datum/preferences/prefs, key)
	var/list/L = LoadKey(prefs, key)
	L = SANITIZE_LIST(L)
	SaveKey(prefs, key, L)

/datum/preferences_collection/proc/auto_sanitize_integer(datum/preferences/prefs, key, min, max, default)
	var/int = LoadKey(prefs, key)
	int = sanitize_integer(int, min, max, default)
	SaveKey(prefs, key, int)

/datum/preferences_collection/proc/auto_sanitize_boolean(datum/preferences/prefs, key, default)
	var/int = LoadKey(prefs, key)
	int = sanitize_integer(int, 0, 1, default)
	SaveKey(prefs, key, int)

/datum/preferences_collection/proc/auto_sanitize_bitfield(datum/preferences/prefs, key)
	return auto_sanitize_integer(prefs, key, NONE, SHORT_REAL_LIMIT - 1, NONE)

/datum/preferences_collection/proc/auto_sanitize_in_list(datum/preferences/prefs, key, list/L, default)
	var/val = LoadKey(prefs, key)
	if(!(val in L))
		SaveKey(prefs, key, default)
