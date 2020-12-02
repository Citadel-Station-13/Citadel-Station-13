/datum/proc/key_down(key, client/user) // Called when a key is pressed down initially
	SHOULD_NOT_SLEEP(TRUE)

/datum/proc/key_up(key, client/user) // Called when a key is released
	SHOULD_NOT_SLEEP(TRUE)

/datum/proc/keyLoop(client/user) // Called once every frame
	//SHOULD_NOT_SLEEP(TRUE)

/client/verb/fix_macros()
	set name = "Fix Keybindings"
	set desc = "Re-assert all your macros/keybindings."
	set category = "OOC"
	if(last_macro_fix > (world.time - 10 SECONDS))
		to_chat(src, "<span class='warning'>It's been too long since the last reset. Wait a while.</span>")
		return
	if(!SSinput.initialized)
		to_chat(src, "<span class='warning'>Input hasn't been initialized yet. Wait a while.</span>")
		return
	to_chat(src, "<span class='danger'>Force-reasserting all macros.</span>")
	last_macro_fix = world.time
	full_macro_assert()

// removes all the existing macros
/client/proc/erase_all_macros()
	var/erase_output = ""
	var/list/set_text = list()
	for(var/macroset in SSinput.all_macrosets)
		set_text += "[macroset].*"
	set_text = set_text.Join(";")
	var/list/macro_set = params2list(winget(src, "[set_text]", "command"))
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

/client/proc/set_macros(datum/preferences/prefs_override = prefs)
	keys_held.Cut()

	apply_macro_set(SKIN_MACROSET_HOTKEYS, SSinput.macroset_hotkey)
	apply_macro_set(SKIN_MACROSET_CLASSIC_HOTKEYS, SSinput.macroset_classic_hotkey)
	apply_macro_set(SKIN_MACROSET_CLASSIC_INPUT, SSinput.macroset_classic_input)

/client/proc/set_hotkeys_preference(datum/preferences/prefs_override = prefs)
	if(prefs_override.hotkeys)
		winset(src, null, "map.focus=true input.background-color=[COLOR_INPUT_DISABLED] mainwindow.macro=[SKIN_MACROSET_HOTKEYS]")
	else
		winset(src, null, "input.focus=true input.background-color=[COLOR_INPUT_ENABLED] mainwindow.macro=[SKIN_MACROSET_CLASSIC_INPUT]")

/client/proc/ensure_keys_set(datum/preferences/prefs_override = prefs)
	if(SSinput.initialized)
		full_macro_assert(prefs_override)

/client/proc/full_macro_assert(datum/preferences/prefs_override = prefs)
	INVOKE_ASYNC(src, .proc/do_full_macro_assert, prefs_override)		// winget sleeps.

/client/proc/do_full_macro_assert(datum/preferences/prefs_override = prefs)
	erase_all_macros()
	set_macros(prefs_override)
	update_special_keybinds(prefs_override)
	set_hotkeys_preference(prefs_override)

/proc/keybind_collision_permutation(key, alt = FALSE, ctrl = FALSE, shift = FALSE)
	var/list/permutations = list()
	if(!shift)
		permutations += "Shift"
	if(!ctrl)
		permutations += "Ctrl"
	if(!alt)
		permutations += "Alt"
	. = list()
	do_keybind_collision_permutations(key, permutations, .)

/proc/do_keybind_collision_permutations(key, list/permutations = list(), list/out = list())
	. = out
	for(var/mod in permutations.Copy())
		permutations -= mod
		. += "[mod]+[key]"
		do_keybind_collision_permutations("[mod]+[key]", permutations.Copy(), .)

/client/proc/do_special_keybind(key, command, datum/preferences/prefs_override = prefs)
	var/alt = findtext(key, "Alt")
	if(alt)
		key = copytext(key, 1, alt) + copytext(key, alt + 3, 0)
	var/ctrl = findtext(key, "Ctrl")
	if(ctrl)
		key = copytext(key, 1, ctrl) + copytext(key, ctrl + 4, 0)
	var/shift = findtext(key, "Shift")
	if(shift)
		key = copytext(key, 1, shift) + copytext(key, shift + 5, 0)
	if(!alt && !ctrl && !shift && !prefs_override.hotkeys)
		return	/// DO NOT.
	key = "[alt? "Alt+":""][ctrl? "Ctrl+":""][shift? "Shift+":""][key]"
	var/list/settings = list("[key]" = "[command]")
	var/list/permutations = keybind_collision_permutation(key, alt, ctrl, shift)
	for(var/i in permutations)
		permutations[i] = NONSENSICAL_VERB
	settings |= permutations
	for(var/macroset in SSinput.all_macrosets)
		for(var/k in settings)
			var/c  = settings[k]
			winset(src, "[macroset]-[REF(k)]", "parent=[macroset];name=[k];command=[c]")

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
				else
					var/datum/keybinding/KB = GLOB.keybindings_by_name[kb_name]
					if(!KB.clientside)
						continue
					do_special_keybind(key, KB.clientside, D)
