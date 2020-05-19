/datum/keybinding/movement
    category = CATEGORY_MOVEMENT
    weight = WEIGHT_HIGHEST

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
