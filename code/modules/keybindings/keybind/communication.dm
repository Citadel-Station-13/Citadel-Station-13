/datum/keybinding/client/communication
	category = CATEGORY_COMMUNICATION

/datum/keybinding/client/communication/say
	hotkey_keys = list("T")
	name = "Say"
	full_name = "IC Say"

/datum/keybinding/client/communication/say/down(client/user)
	var/mob/M = user.mob
	var/speech = input(user, "", "say")
	M.say_verb(speech)

/datum/keybinding/client/communication/ooc
	hotkey_keys = list("O")
	name = "OOC"
	full_name = "Out Of Character Say (OOC)"

/datum/keybinding/client/communication/ooc/down(client/user)
	var/speech = input(user, "", "OOC")
	user.ooc(speech)
	return TRUE

/datum/keybinding/client/communication/me
	hotkey_keys = list("M")
	name = "Me"
	full_name = "Custom Emote (/Me)"

/datum/keybinding/client/communication/me/down(client/user)
	var/mob/M = user.mob
	var/emote = input(user, "", "Me")
	M.me_verb(emote)
	return TRUE

//indicators
/datum/keybinding/mob/say_with_indicator
	hotkey_keys = list("CtrlT")
	classic_keys = list()
	name = "say_with_indicator"
	full_name = "Say with Typing Indicator"

/datum/keybinding/mob/say_with_indicator/down(client/user)
	var/mob/M = user.mob
	M.say_typing_indicator()
	return TRUE

/datum/keybinding/mob/me_with_indicator
	hotkey_keys = list("CtrlM")
	classic_keys = list()
	name = "me_with_indicator"
	full_name = "Me (emote) with Typing Indicator"

/datum/keybinding/mob/me_with_indicator/down(client/user)
	var/mob/M = user.mob
	M.me_typing_indicator()
	return TRUE