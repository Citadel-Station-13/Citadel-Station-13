TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggleeatingnoise)()
	set name = "Toggle Eating Noises"
	set category = "Preferences"
	set desc = "Hear Eating noises"
	usr.client.prefs.current_tab = 1
	usr.client.prefs.ShowChoices(usr)
	usr.client.prefs.toggles ^= EATING_NOISES
	usr.client.prefs.save_preferences()
	usr.stop_sound_channel(CHANNEL_PRED)
	to_chat(usr, "You will [(usr.client.prefs.toggles & EATING_NOISES) ? "now" : "no longer"] hear eating noises.")
/datum/verbs/menu/Settings/Sound/toggleeatingnoise/Get_checked(client/C)
	return !(C.prefs.toggles & EATING_NOISES)


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggledigestionnoise)()
	set name = "Toggle Digestion Noises"
	set category = "Preferences"
	set desc = "Hear digestive noises"
	usr.client.prefs.toggles ^= DIGESTION_NOISES
	usr.client.prefs.save_preferences()
	usr.stop_sound_channel(CHANNEL_DIGEST)
	to_chat(usr, "You will [(usr.client.prefs.toggles & DIGESTION_NOISES) ? "now" : "no longer"] hear digestion noises.")
/datum/verbs/menu/Settings/Sound/toggledigestionnoise/Get_checked(client/C)
	return !(C.prefs.toggles & DIGESTION_NOISES)
