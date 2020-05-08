/mob/living/carbon/key_down(_key, client/user)
	switch(_key)
		if("R", "Southwest") // Southwest is End
			toggle_throw_mode()
			return
		if("C")
			user_toggle_intentional_combat_mode()
			return
	return ..()