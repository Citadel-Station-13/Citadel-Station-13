/datum/proc/key_down(key, client/user) // Called when a key is pressed down initially
	SHOULD_NOT_SLEEP(TRUE)

/datum/proc/key_up(key, client/user) // Called when a key is released
	SHOULD_NOT_SLEEP(TRUE)

/datum/proc/keyLoop(client/user) // Called once every frame
	//SHOULD_NOT_SLEEP(TRUE)

// removes all the existing macros
/client/proc/erase_all_macros()
	var/erase_output = ""
	var/list/macro_set = params2list(winget(src, "default.*", "command")) // The third arg doesnt matter here as we're just removing them all
	for(var/k in 1 to length(macro_set))
		var/list/split_name = splittext(macro_set[k], ".")
		var/macro_name = "[split_name[1]].[split_name[2]]" // [3] is "command"
		erase_output = "[erase_output];[macro_name].parent=null"
	winset(src, null, erase_output)

/client/proc/apply_macro_set(name, list/macroset)
	ASSERT(name)
	ASSERT(islist(macroset))
	winclone(src, "default", name)
	for(var/i in 1 to length(macroset))
		var/key = macroset[i]
		var/command = macroset[key]
		winset(src, "[name]-[REF(key)]", "parent=[name];name=[key];command=[command]")
	update_special_keybinds()

/client/proc/set_macros(datum/preferences/prefs_override = prefs)
	set waitfor = FALSE

	keys_held.Cut()

	erase_all_macros()

	apply_macro_set(SKIN_MACROSET_HOTKEYS, SSinput.macroset_hotkey)
	apply_macro_set(SKIN_MACROSET_CLASSIC_HOTKEYS, SSinput.macroset_classic_hotkey)
	apply_macro_set(SKIN_MACROSET_CLASSIC_INPUT, SSinput.macroset_classic_input)

	set_hotkeys_preference(prefs_override)

/client/proc/set_hotkeys_preference(datum/preferences/prefs_override = prefs)
	if(prefs_override.hotkeys)
		winset(src, null, "map.focus=true input.background-color=[COLOR_INPUT_DISABLED] mainwindow.macro=[SKIN_MACROSET_HOTKEYS]")
	else
		winset(src, null, "input.focus=true input.background-color=[COLOR_INPUT_ENABLED] mainwindow.macro=[SKIN_MACROSET_CLASSIC_INPUT]")

/client/proc/ensure_keys_set()
	if(SSinput.initialized)
		full_macro_assert()

/client/proc/full_macro_assert(datum/preferences/prefs_override = prefs)
	set_macros(prefs_override)
	update_special_keybinds(prefs_override)

/*
/datum/controller/subsystem/input
	/** KEEP THIS UP TO DATE WITH update_special_keybinds!
	  * We use this list to detect when to avoid binding a key twice.
	  */
	var/list/special_keybinds = list("North", "East", "West", "South", "Say", "OOC", "Me", "Subtle", "Subtler", "Whisper", "LOOC")

/datum/preferences/proc/get_all_keys_for_special_keybinds()
	for(var/key in key_bindings)
*/

/client/proc/do_special_keybind(key, command)
	var/alt = findtext(key, "Alt")
	if(alt)
		key = copytext(key, 1, alt) + copytext(key, alt + 3, 0)
	var/ctrl = findtext(key, "Ctrl")
	if(ctrl)
		key = copytext(key, 1, ctrl) + copytext(key, ctrl + 4, 0)
	var/shift = findtext(key, "Shift")
	if(shift)
		key = copytext(key, 1, shift) + copytext(key, shift + 5, 0)
	key = "[alt? "Alt+":""][ctrl? "Ctrl+":""][shift? "Shift+":""][key]"
	/// KEEP THIS UP TO DATE!
	var/static/list/all_macrosets = list(
		SKIN_MACROSET_HOTKEYS,
		SKIN_MACROSET_CLASSIC_HOTKEYS,
		SKIN_MACROSET_CLASSIC_INPUT
	)
	for(var/macroset in all_macrosets)
		winset(src, "[macroset]-[REF(key)]", "parent=[macroset];name=[key];command=[command]")

/**
  * Updates the keybinds for special keys
  *
  * Handles adding macros for the keys that need it
  * And adding movement keys to the clients movement_keys list
  * At the time of writing this, communication(OOC, Say, IC) require macros
  * Arguments:
  * * direct_prefs - the preference we're going to get keybinds from
  */
/client/proc/update_special_keybinds(datum/preferences/direct_prefs)
	var/datum/preferences/D = direct_prefs || prefs
	if(!D?.key_bindings)
		return
	movement_keys = list()
	for(var/key in D.key_bindings)
		for(var/kb_name in D.key_bindings[key])
			switch(kb_name)
				if("North")
					movement_keys[key] = NORTH
				if("East")
					movement_keys[key] = EAST
				if("West")
					movement_keys[key] = WEST
				if("South")
					movement_keys[key] = SOUTH
				if("Say")
					do_special_keybind(key, "say")
				if("OOC")
					do_special_keybind(key, "OOC")
				if("Me")
					do_special_keybind(key, "me")
				if("Subtle")
					do_special_keybind(key, "subtle")
				if("Subtler")
					do_special_keybind(key, "Subtler-Anti-Ghost")
				if("Whisper")
					do_special_keybind(key, "whisper")
				if("LOOC")
					do_special_keybind(key, "LOOC")
