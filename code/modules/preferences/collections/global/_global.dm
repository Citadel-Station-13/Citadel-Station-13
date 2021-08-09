/datum/preferences_collection/global
	collection_type = COLLECTION_GLOBAL

/datum/preferences_collection/global/SaveKey(datum/preferences/prefs, key, value)
	return prefs.SetKeyGlobal(key, value)

/datum/preferences_collection/global/LoadKey(datum/preferences/prefs, key)
	return prefs.LoadKeyGlobal(key, value)
