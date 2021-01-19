/datum/keybinding/carbon/showoff
	hotkey_keys = list("Unbound")
	name = "showoff"
	full_name = "Show your held item"
	description = "Show your held item, people close to you can examine it, \
	if you're not holding anything, you'll show your arm."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/showoff/down(client/user)
	var/mob/living/carbon/L = user.mob
	L.showoff()
	return TRUE
