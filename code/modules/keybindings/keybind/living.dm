/datum/keybinding/living
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/living/can_use(client/user)
	return isliving(user.mob)

/datum/keybinding/living/resist
	hotkey_keys = list("B")
	name = "resist"
	full_name = "Resist"
	description = "Break free of your current state. Handcuffed? on fire? Resist!"

/datum/keybinding/living/resist/down(client/user)
	var/mob/living/L = user.mob
	L.resist()
	return TRUE

/datum/keybinding/living/toggle_combat_mode
	hotkey_keys = list("C")
	name = "toggle_combat_mode"
	full_name = "Toggle combat mode"
	description = "Toggles whether or not you're in combat mode."

/datum/keybinding/living/toggle_combat_mode/can_use(client/user)
	return iscarbon(user.mob)		// for now, only carbons should be using combat mode, although all livings have combat mode implemented.

/datum/keybinding/living/toggle_combat_mode/down(client/user)
	var/mob/living/carbon/C = user.mob
	C.user_toggle_intentional_combat_mode()
	return TRUE

/datum/keybinding/living/toggle_resting
	hotkey_keys = list("V")
	name = "toggle_resting"
	full_name = "Toggle Resting"
	description = "Toggles whether or not you are intentionally laying down."

/datum/keybinding/living/toggle_resting/down(client/user)
	var/mob/living/L = user.mob
	L.lay_down()
