/datum/preferences/proc/get_quirks()
	var/list/L = LoadKeyCharacter(PREFERENCES_SAVE_KEY_QUIRKS, "quirks")
	return istype(L)? deepCopyList(L) : list()
