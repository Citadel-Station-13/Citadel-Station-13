/datum/preferences/proc/check_cit_toggle(flag)
	. = LoadKeyCharacter("__[PREFERENCES_SAVE_KEY_FETISH]_override")? \
	LoadKeyCharacter(PREFERENCES_SAVE_KEY_FETISH, "cit_toggles") : LoadKeyGlobal(PREFERENCES_SAVE_KEY_FETISH, "cit_toggles")
	return . & flag
