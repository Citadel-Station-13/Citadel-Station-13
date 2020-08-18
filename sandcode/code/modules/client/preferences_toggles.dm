TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, megafauna_music)()
	set name = "Toggle Megafauna Music"
	set category = "Preferences"
	set desc = "Turn megafauna music on/off"

	usr.client.prefs.toggles ^= SOUND_MEGAFAUNA
	usr.client.prefs.save_preferences()
	to_chat(usr, "You [(usr.client.prefs.toggles & SOUND_MEGAFAUNA) ? "turn on" : "turn off"] the playback of megafauna music.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Megafauna Music", "[usr.client.prefs.toggles & SOUND_MEGAFAUNA ? "Yes" : "No"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/verbs/menu/Settings/megafauna_music/Get_checked(client/C)
	return C.prefs.toggles & SOUND_MEGAFAUNA
