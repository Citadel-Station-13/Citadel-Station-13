/datum/preferences_collection/character
	collection_type = COLLECTION_GLOBAL

/datum/preferences_collection/character/SaveKey(datum/preferences/prefs, key, value)
	return prefs.SetKeyCharacter(key, value)

/datum/preferences_collection/character/LoadKey(datum/preferences/prefs, key)
	return prefs.LoadKeyCharacter(key)
