/datum/preferences/proc/check_cit_toggle(flag)
	. = LoadKeyCharacter("__[PREFERENCES_SAVE_KEY_FETISH]_override")? \
	LoadKeyCharacter(PREFERENCES_SAVE_KEY_ANTAGONISM, "midround_antagonist") : LoadKeyGlobal(PREFERENCES_SAVE_KEY_ANTAGONISM, "midround_antagonist")
	return . & flag
