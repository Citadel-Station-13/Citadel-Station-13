/datum/keybinding/living
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/living/can_use(client/user)
	return isliving(user.mob)

/datum/keybinding/living/quick_equip
	hotkey_keys = list("E")
	name = "quick_equip"
	full_name = "Quick Equip"
	description = "Quickly puts an item in the best slot available"

/datum/keybinding/living/quick_equip/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.quick_equip()
	return TRUE

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

/datum/keybinding/living/cancel_action
	hotkey_keys = list("Unbound")
	name = "cancel_action"
	full_name = "Cancel Action"
	description = "Cancel the current action."

/// Technically you shouldn't be doing any actions if you were sleeping either but...
/datum/keybinding/living/can_use(client/user)
	. = ..()
	var/mob/living/mob = user.mob
	return . && (mob.stat == CONSCIOUS)

/datum/keybinding/living/cancel_action/down(client/user)
	var/mob/M = user.mob
	if(length(M.do_afters))
		var/atom/target = M.do_afters[M.do_afters.len]
		to_chat(M, "<span class='notice'>You stop interacting with \the [target].</span>")
		LAZYREMOVE(M.do_afters, target)
	else
		to_chat(M, "<span class='notice'>There's nothing that you can cancel right now.</span>")
	return TRUE
