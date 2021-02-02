/datum/keybinding/movement
	category = CATEGORY_MOVEMENT
	weight = WEIGHT_HIGHEST
	special = TRUE

/datum/keybinding/movement/north
	hotkey_keys = list("W", "North")
	name = "North"
	full_name = "Move North"
	description = "Moves your character north"

/datum/keybinding/movement/south
	hotkey_keys = list("S", "South")
	name = "South"
	full_name = "Move South"
	description = "Moves your character south"

/datum/keybinding/movement/west
	hotkey_keys = list("A", "West")
	name = "West"
	full_name = "Move West"
	description = "Moves your character left"

/datum/keybinding/movement/east
	hotkey_keys = list("D", "East")
	name = "East"
	full_name = "Move East"
	description = "Moves your character east"

/datum/keybinding/mob/face_north
	hotkey_keys = list("CtrlW", "CtrlNorth")
	name = "face_north"
	full_name = "Face North"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/face_north/down(client/user)
	var/mob/M = user.mob
	M.northface()
	return TRUE

/datum/keybinding/mob/face_east
	hotkey_keys = list("CtrlD", "CtrlEast")
	name = "face_east"
	full_name = "Face East"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/face_east/down(client/user)
	var/mob/M = user.mob
	M.eastface()
	return TRUE

/datum/keybinding/mob/face_south
	hotkey_keys = list("CtrlS", "CtrlSouth")
	name = "face_south"
	full_name = "Face South"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/face_south/down(client/user)
	var/mob/M = user.mob
	M.southface()
	return TRUE

/datum/keybinding/mob/face_west
	hotkey_keys = list("CtrlA", "CtrlWest")
	name = "face_west"
	full_name = "Face West"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/face_west/down(client/user)
	var/mob/M = user.mob
	M.westface()
	return TRUE

/datum/keybinding/mob/shift_north
	hotkey_keys = list("CtrlShiftW", "CtrlShiftNorth")
	name = "pixel_shift_north"
	full_name = "Pixel Shift North"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/shift_north/down(client/user)
	var/mob/M = user.mob
	M.northshift()
	return TRUE

/datum/keybinding/mob/shift_east
	hotkey_keys = list("CtrlShiftD", "CtrlShiftEast")
	name = "pixel_shift_east"
	full_name = "Pixel Shift East"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/shift_east/down(client/user)
	var/mob/M = user.mob
	M.eastshift()
	return TRUE

/datum/keybinding/mob/shift_south
	hotkey_keys = list("CtrlShiftS", "CtrlShiftSouth")
	name = "pixel_shift_south"
	full_name = "Pixel Shift South"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/shift_south/down(client/user)
	var/mob/M = user.mob
	M.southshift()
	return TRUE

/datum/keybinding/mob/shift_west
	hotkey_keys = list("CtrlShiftA", "CtrlShiftWest")
	name = "pixel_shift_west"
	full_name = "Pixel Shift West"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/shift_west/down(client/user)
	var/mob/M = user.mob
	M.westshift()
	return TRUE

/datum/keybinding/living/hold_sprint
	hotkey_keys = list()
	classic_keys = list()
	name = "hold_sprint"
	full_name = "Sprint (hold down)"
	description = "Hold down to sprint"
	category = CATEGORY_MOVEMENT

/datum/keybinding/living/hold_sprint/can_use(client/user)
	return ishuman(user.mob) || iscyborg(user.mob)

/datum/keybinding/living/hold_sprint/down(client/user)
	var/mob/living/L = user.mob
	L.sprint_hotkey(TRUE)
	return TRUE

/datum/keybinding/living/hold_sprint/up(client/user)
	var/mob/living/L = user.mob
	L.sprint_hotkey(FALSE)
	return TRUE

/datum/keybinding/living/toggle_sprint
	hotkey_keys = list("Shift")
	classic_keys = list("Shift")
	name = "toggle_sprint"
	full_name = "Sprint (toggle)"
	description = "Press to toggle sprint"
	category = CATEGORY_MOVEMENT

/datum/keybinding/living/toggle_sprint/can_use(client/user)
	return ishuman(user.mob) || iscyborg(user.mob)

/datum/keybinding/living/toggle_sprint/down(client/user)
	var/mob/living/L = user.mob
	L.default_toggle_sprint()
	return TRUE

/datum/keybinding/mob/toggle_move_intent
	hotkey_keys = list("Alt")
	name = "toggle_move_intent"
	full_name = "Hold to toggle move intent"
	description = "Held down to cycle to the other move intent, release to cycle back"
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/toggle_move_intent/down(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE

/datum/keybinding/mob/toggle_move_intent/up(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE

/datum/keybinding/mob/toggle_move_intent_alternative
	hotkey_keys = list("Unbound")
	name = "toggle_move_intent_alt"
	full_name = "press to cycle move intent"
	description = "Pressing this cycle to the opposite move intent, does not cycle back"
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/toggle_move_intent_alternative/down(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE
