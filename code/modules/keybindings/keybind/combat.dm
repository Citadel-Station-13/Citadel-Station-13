/datum/keybinding/living/toggle_combat_mode
	hotkey_keys = list("C")
	name = "toggle_combat_mode"
	full_name = "Toggle combat mode"
	category = CATEGORY_COMBAT
	description = "Toggles whether or not you're in combat mode."

/datum/keybinding/living/toggle_combat_mode/can_use(client/user)
	return iscarbon(user.mob)		// for now, only carbons should be using combat mode, although all livings have combat mode implemented.

/datum/keybinding/living/toggle_combat_mode/down(client/user)
	var/mob/living/carbon/C = user.mob
	C.user_toggle_intentional_combat_mode()
	return TRUE

/datum/keybinding/living/active_block
	hotkey_keys = list("Northwest", "F") // HOME
	name = "active_block"
	full_name = "Block"
	category = CATEGORY_COMBAT
	description = "Hold down to actively block with your currently in-hand object."

/datum/keybinding/living/active_block/down(client/user)
	var/mob/living/L = user.mob
	L.keybind_start_active_blocking()
	return TRUE

/datum/keybinding/living/active_block/up(client/user)
	var/mob/living/L = user.mob
	L.keybind_stop_active_blocking()

/datum/keybinding/living/active_parry
	hotkey_keys = list("Insert", "G")
	name = "active_parry"
	full_name = "Parry"
	category = CATEGORY_COMBAT
	description = "Press to initiate a parry sequence with your currently in-hand object."

/datum/keybinding/living/active_parry/down(client/user)
	var/mob/living/L = user.mob
	L.keybind_parry()
	return TRUE
