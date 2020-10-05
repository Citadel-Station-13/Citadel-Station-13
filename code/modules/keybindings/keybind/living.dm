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

/datum/keybinding/living/toggle_resting
	hotkey_keys = list("V")
	name = "toggle_resting"
	full_name = "Toggle Resting"
	description = "Toggles whether or not you are intentionally laying down."

/datum/keybinding/living/toggle_resting/down(client/user)
	var/mob/living/L = user.mob
	L.lay_down()
