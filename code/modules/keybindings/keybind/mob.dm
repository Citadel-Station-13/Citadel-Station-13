/datum/keybinding/mob
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/mob/stop_pulling
	hotkey_keys = list("H", "Delete")
	name = "stop_pulling"
	full_name = "Stop pulling"
	description = ""

/datum/keybinding/mob/stop_pulling/down(client/user)
	var/mob/M = user.mob
	if(!M.pulling)
		to_chat(user, "<span class='notice'>You are not pulling anything.</span>")
	else
		M.stop_pulling()
	return TRUE

/datum/keybinding/mob/cycle_intent_right
	hotkey_keys = list("Unbound")
	name = "cycle_intent_right"
	full_name = "Cycle Action Intent Right"
	description = ""

/datum/keybinding/mob/cycle_intent_right/down(client/user)
	var/mob/M = user.mob
	M.a_intent_change(INTENT_HOTKEY_RIGHT)
	return TRUE

/datum/keybinding/mob/cycle_intent_left
	hotkey_keys = list("Unbound")
	name = "cycle_intent_left"
	full_name = "Cycle Action Intent Left"
	description = ""

/datum/keybinding/mob/cycle_intent_left/down(client/user)
	var/mob/M = user.mob
	M.a_intent_change(INTENT_HOTKEY_LEFT)
	return TRUE

/datum/keybinding/mob/swap_hands
	hotkey_keys = list("X", "Northeast") // PAGEUP
	name = "swap_hands"
	full_name = "Swap hands"
	description = ""

/datum/keybinding/mob/swap_hands/down(client/user)
	var/mob/M = user.mob
	M.swap_hand()
	return TRUE

/datum/keybinding/mob/activate_inhand
	hotkey_keys = list("Z", "Southeast") // PAGEDOWN
	name = "activate_inhand"
	full_name = "Activate in-hand"
	description = "Uses whatever item you have inhand"

/datum/keybinding/mob/activate_inhand/down(client/user)
	var/mob/M = user.mob
	M.mode()
	return TRUE

/datum/keybinding/mob/drop_item
	hotkey_keys = list("Q")
	name = "drop_item"
	full_name = "Drop Item"
	description = ""

/datum/keybinding/mob/drop_item/down(client/user)
	if(iscyborg(user.mob)) //cyborgs can't drop items
		return FALSE
	var/mob/M = user.mob
	var/obj/item/I = M.get_active_held_item()
	if(!I)
		to_chat(user, "<span class='warning'>You have nothing to drop in your hand!</span>")
	else
		user.mob.dropItemToGround(I)
	return TRUE

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

/datum/keybinding/living/subtle
	hotkey_keys = list("5")
	classic_keys = list()
	name = "subtle_emote"
	full_name = "Subtle Emote"

/datum/keybinding/living/subtle/down(client/user)
	var/mob/living/L = user.mob
	L.subtle()
	return TRUE

/datum/keybinding/living/subtler
	hotkey_keys = list("6")
	classic_keys = list()
	name = "subtler_emote"
	full_name = "Subtler Anti-Ghost Emote"

/datum/keybinding/living/subtler/down(client/user)
	var/mob/living/L = user.mob
	L.subtler()
	return TRUE

/datum/keybinding/mob/whisper
	hotkey_keys = list("Y")
	classic_keys = list()
	name = "whisper"
	full_name = "Whisper"

/datum/keybinding/mob/whisper/down(client/user)
	var/mob/M = user.mob
	M.whisper_keybind()
	return TRUE

