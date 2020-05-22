SUBSYSTEM_DEF(input)
	name = "Input"
	wait = 1 //SS_TICKER means this runs every tick
	init_order = INIT_ORDER_INPUT
	flags = SS_TICKER
	priority = FIRE_PRIORITY_INPUT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	/// Classic mode input focused macro set. Manually set because we can't define ANY or ANY+UP for classic.
	var/static/list/macroset_classic_input
	/// Classic mode map focused macro set. Manually set because it needs to be clientside and go to macroset_classic_input.
	var/static/list/macroset_classic_hotkey
	/// New hotkey mode macro set. All input goes into map, game keeps incessently setting your focus to map, we can use ANY all we want here; we don't care about the input bar, the user has to force the input bar every time they want to type.
	var/static/list/macroset_hotkey

	/// Macro set for hotkeys
	var/list/hotkey_mode_macros
	/// Macro set for classic.
	var/list/input_mode_macros

/datum/controller/subsystem/input/Initialize()
	setup_macrosets()

	initialized = TRUE

	refresh_client_macro_sets()

	return ..()

/// Sets up the key list for classic mode for when badmins screw up vv's.
/datum/controller/subsystem/input/proc/setup_macrosets()
	// First, let's do the snowflake keyset!
	macroset_classic_input = list()
	var/list/classic_mode_keys = list(
		"North", "East", "South", "West",
		"Northeast", "Southeast", "Northwest", "Southwest",
		"Insert", "Delete", "Ctrl", "Alt", "Shift",
		"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
		)
	for(var/key in classic_mode_keys)
		macroset_classic_input[key] = "\"KeyDown [key]\""
		macroset_classic_input["[key]+UP"] = "\"KeyUp [key]\""
	// LET'S PLAY THE BIND EVERY KEY GAME!
	// oh except for Backspace and Enter; if you want to use those you shouldn't have used oldmode!
	var/list/classic_ctrl_override_keys = list(
	"\[", "\]", "\\", ";", "'", ",", ".", "/", "-", "\\=", "`"
	)
	// i'm lazy let's play the list iteration game of numbers
	for(var/i in 0 to 9)
		classic_ctrl_override_keys += "[i]"
	// let's play the ascii game of A to Z (UPPERCASE)
	for(var/i in 65 to 90)
		classic_ctrl_override_keys += ascii2text(i)
	// let's play the game of clientside bind overrides!
	classic_ctrl_override_keys -= list("T", "O", "M", "L")
	macroset_classic_input["Ctrl+T"] = "say"
	macroset_classic_input["Ctrl+O"] = "ooc"
	macroset_classic_input["Ctrl+L"] = "looc"
	// let's play the list iteration game x2
	for(var/key in classic_ctrl_override_keys)
		macroset_classic_input["Ctrl+[key]"] = "\"KeyDown [key]\""
		macroset_classic_input["Ctrl+[key]+UP"] = "\"KeyUp [key]\""
	// Misc
	macroset_classic_input["Tab"] = "\".winset \\\"mainwindow.macro=[SKIN_MACROSET_CLASSIC_HOTKEYS] map.focus=true input.background-color=[COLOR_INPUT_DISABLED]\\\"\""
	macroset_classic_input["Escape"] = "\".winset \\\"input.text=\\\"\\\"\\\"\""

	// FINALLY, WE CAN DO SOMETHING MORE NORMAL FOR THE SNOWFLAKE-BUT-LESS KEYSET.
	macroset_classic_hotkey = list(
	"Any" = "\"KeyDown \[\[*\]\]\"",
	"Any+UP" = "\"KeyUp \[\[*\]\]\"",
	"Tab" = "\".winset \\\"mainwindow.macro=[SKIN_MACROSET_CLASSIC_INPUT] input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
	"Escape" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
	"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
	"O" = "ooc",
	"T" = "say",
	"L" = "looc",
	"M" = "me"
	)

	// And finally, the modern set.
	macroset_hotkey = list(
	"Any" = "\"KeyDown \[\[*\]\]\"",
	"Any+UP" = "\"KeyUp \[\[*\]\]\"",
	"Tab" = "\".winset \\\"input.focus=true?map.focus=true input.background-color=[COLOR_INPUT_DISABLED]:input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
	"Escape" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
	"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
	"O" = "ooc",
	"T" = "say",
	"L" = "looc",
	"M" = "me"
	)

// Badmins just wanna have fun ♪
/datum/controller/subsystem/input/proc/refresh_client_macro_sets()
	var/list/clients = GLOB.clients
	for(var/i in 1 to clients.len)
		var/client/user = clients[i]
		user.set_macros()
		user.update_movement_keys()

/datum/controller/subsystem/input/fire()
	var/list/clients = GLOB.clients // Let's sing the list cache song
	for(var/i in 1 to clients.len)
		var/client/C = clients[i]
		C.keyLoop()
