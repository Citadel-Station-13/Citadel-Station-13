/datum/keybinding/human
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/human/can_use(client/user)
	return ishuman(user.mob)

/datum/keybinding/human/quick_equipbelt
	hotkey_keys = list("ShiftE")
	name = "quick_equipbelt"
	full_name = "Quick equip belt"
	description = "Put held thing in belt or take out most recent thing from belt"

/datum/keybinding/human/quick_equipbelt/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbelt()
	return TRUE

/datum/keybinding/human/bag_equip
	hotkey_keys = list("ShiftB")
	name = "bag_equip"
	full_name = "Bag equip"
	description = "Put held thing in backpack or take out most recent thing from backpack"

/datum/keybinding/human/bag_equip/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbag()
	return TRUE

/datum/keybinding/human/surrender
	hotkey_keys = list("AltShiftY")
	name = "surrender"
	full_name = "Surrender"
	category = CATEGORY_COMBAT
	description = "Briefly stuns and incapacitates you to show you're no longer a threat."

/datum/keybinding/human/surrender/down(client/user)
	. = ..()
	var/mob/living/carbon/human/H = user.mob
	return H.emote("surrender", intentional=TRUE)