/datum/preferences/proc/get_antag_preferences()
	return LoadKeyCharacter("__[PREFERENCES_SAVE_KEY_ANTAGONISM]_override")? \
	LoadKeyCharacter(PREFERENCES_SAVE_KEY_ANTAGONISM, "be_special") : LoadKeyGlobal(PREFERENCES_SAVE_KEY_ANTAGONISM, "be_special")

/datum/preferences/proc/get_midround_antagonism()
	return LoadKeyCharacter("__[PREFERENCES_SAVE_KEY_ANTAGONISM]_override")? \
	LoadKeyCharacter(PREFERENCES_SAVE_KEY_ANTAGONISM, "midround_antagonist") : LoadKeyGlobal(PREFERENCES_SAVE_KEY_ANTAGONISM, "midround_antagonist")
