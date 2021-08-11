/datum/preferences/proc/get_keybinds()
	var/list/L = LoadKeyGlobal(PREFERENCES_SAVE_KEY_KEYBINDINGS, "keybinds")
	if(istype(L))
		return deepCopyList(L)
	else
		return list()

/datum/preferences/proc/get_modless_keybinds()
	var/list/L = LoadKeyGlobal(PREFERENCES_SAVE_KEY_KEYBINDINGS, "keybinds_modless")
	if(istype(L))
		return deepCopyList(L)
	else
		return list()

/datum/preferences/proc/get_hotkey_toggle()
	return LoadKeyGlobal(PREFERENCES_SAVE_KEY_KEYBINDINGS, "hotkeyS")
