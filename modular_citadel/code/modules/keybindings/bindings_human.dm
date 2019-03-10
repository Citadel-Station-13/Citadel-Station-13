/mob/living/carbon/human/key_down(_key, client/user)
	switch(_key)
		if("Shift")
			sprint_hotkey(TRUE)
			return
	return ..()

/mob/living/carbon/human/key_up(_key, client/user)
	switch(_key)
		if("Shift")
			sprint_hotkey(FALSE)
			return
	return ..()
