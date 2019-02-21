/mob/living/silicon/robot/key_down(_key, client/user)
	switch(_key)
		if("Shift")
			sprint_hotkey(TRUE)
			return
	return ..()

/mob/living/silicon/robot/key_up(_key, client/user)
	switch(_key)
		if("Shift")
			sprint_hotkey(FALSE)
			return
	return ..()
