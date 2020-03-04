SUBSYSTEM_DEF(input)
	name = "Input"
	wait = 1 //SS_TICKER means this runs every tick
	init_order = INIT_ORDER_INPUT
	flags = SS_TICKER
	priority = FIRE_PRIORITY_INPUT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/macro_sets
	var/list/movement_keys
	/*! Special thing (until we get custom keybinds that also support clientside macros :weary:) that lets us do stuff like look up "which key is say/me bound to". Special format too, the value of a key should be list(key, modifier1, modifier2, ...). "default" unless override.
	 *  USE get_key_for_macro_id or get_typing_indicator_binds TO ACCESS!
	 */
	var/list/macro_set_reverse_lookups
	/// cache these for speed.
	var/list/typing_indicator_binds
	/// same
	var/static/list/typing_indicator_verbs

/datum/controller/subsystem/input/Initialize()
	setup_default_macro_sets()

	setup_default_movement_keys()

	initialized = TRUE

	refresh_client_macro_sets()

	return ..()

// This is for when macro sets are eventualy datumized
/datum/controller/subsystem/input/proc/setup_default_macro_sets()
	var/list/static/default_macro_sets

	if(default_macro_sets)
		macro_sets = default_macro_sets
		return

	default_macro_sets = list(
		"default" = list(
			"Tab" = "\".winset \\\"input.focus=true?map.focus=true input.background-color=[COLOR_INPUT_DISABLED]:input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
			"O" = "ooc",
			"Ctrl+O" = "looc",
			"T" = "say",
			"Ctrl+T" = "whisper",
			"M" = "me",
			"Ctrl+M" = "subtle",
			"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"", // This makes it so backspace can remove default inputs
			"Any" = "\"KeyDown \[\[*\]\]\"",
			"Any+UP" = "\"KeyUp \[\[*\]\]\"",
			),
		"old_default" = list(
			"Tab" = "\".winset \\\"mainwindow.macro=old_hotkeys map.focus=true input.background-color=[COLOR_INPUT_DISABLED]\\\"\"",
			"Ctrl+T" = "say",
			"Ctrl+O" = "ooc",
			),
		"old_hotkeys" = list(
			"Tab" = "\".winset \\\"mainwindow.macro=old_default input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
			"O" = "ooc",
			"L" = "looc",
			"T" = "say",
			"M" = "me",
			"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"", // This makes it so backspace can remove default inputs
			"Any" = "\"KeyDown \[\[*\]\]\"",
			"Any+UP" = "\"KeyUp \[\[*\]\]\"",
			),
		)

	macro_set_reverse_lookups = list(
		"default" = list(
			"say_keybind" = list("T"),
			"whisper" = list("T", "Ctrl"),
			"me_keybind" = list("M"),
			"subtle" = list("M", "Ctrl")
			),
		"old_default" = list(
			"say_keybind" = list("T", "Ctrl"),
			),
		"old_hotkeys" = list(
			"say_keybind" = list("T"),
			"me_keybind" = list("M"),
			)
		)

	typing_indicator_verbs = list("me", "say")
	typing_indicator_binds = list()
	for(var/check_verb in typing_indicator_verbs)
		for(var/macro_set in macro_set_reverse_lookups)
			var/list/keylist = macro_set_reverse_lookups[macro_set][check_verb]
			if(!keylist)
				continue
			var/key = keylist[1]
			typing_indicator_binds[key] = TRUE

	// Because i'm lazy and don't want to type all these out twice
	var/list/old_default = default_macro_sets["old_default"]

	var/list/static/oldmode_keys = list(
		"North", "East", "South", "West",
		"Northeast", "Southeast", "Northwest", "Southwest",
		"Insert", "Delete", "Ctrl", "Alt",
		"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
		)

	for(var/i in 1 to oldmode_keys.len)
		var/key = oldmode_keys[i]
		old_default[key] = "\"KeyDown [key]\""
		old_default["[key]+UP"] = "\"KeyUp [key]\""

	var/list/static/oldmode_ctrl_override_keys = list(
		"W" = "W", "A" = "A", "S" = "S", "D" = "D", // movement
		"1" = "1", "2" = "2", "3" = "3", "4" = "4", // intent
		"B" = "B", // resist
		"E" = "E", // quick equip
		"F" = "F", // intent left
		"G" = "G", // intent right
		"H" = "H", // stop pulling
		"Q" = "Q", // drop
		"R" = "R", // throw
		"X" = "X", // switch hands
		"Y" = "Y", // activate item
		"Z" = "Z", // activate item
		)

	for(var/i in 1 to oldmode_ctrl_override_keys.len)
		var/key = oldmode_ctrl_override_keys[i]
		var/override = oldmode_ctrl_override_keys[key]
		old_default["Ctrl+[key]"] = "\"KeyDown [override]\""
		old_default["Ctrl+[key]+UP"] = "\"KeyUp [override]\""

	macro_sets = default_macro_sets

// For initially setting up or resetting to default the movement keys
/datum/controller/subsystem/input/proc/setup_default_movement_keys()
	var/static/list/default_movement_keys = list(
		"W" = NORTH, "A" = WEST, "S" = SOUTH, "D" = EAST,				// WASD
		"North" = NORTH, "West" = WEST, "South" = SOUTH, "East" = EAST,	// Arrow keys & Numpad
		)

	movement_keys = default_movement_keys.Copy()

// Badmins just wanna have fun ♪
/datum/controller/subsystem/input/proc/refresh_client_macro_sets()
	var/list/clients = GLOB.clients
	for(var/i in 1 to clients.len)
		var/client/user = clients[i]
		user.set_macros()

/datum/controller/subsystem/input/fire()
	var/list/clients = GLOB.clients // Let's sing the list cache song
	for(var/i in 1 to length(clients))
		var/client/C = clients[i]
		C.keyLoop()

/datum/controller/subsystem/input/proc/get_key_for_macro_id(macro_id, macroset)
	return macro_set_reverse_lookups[macroset][macro_id] || macro_set_reverse_lookups["default"][macro_id]

/// Returns an associative list of keys without modifiers like ctrl. You have to do another lookup, this is for the first check to be faster.
/datum/controller/subsystem/input/proc/get_typing_indicator_binds(macroset)
	return typing_indicator_binds[macroset]
