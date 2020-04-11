/mob/living/key_down(_key, client/user)
	switch(_key)
		if("B")
			resist()
			return
		if("1")
			if(possible_a_intents)
				a_intent_change(INTENT_HELP)
				return
		if("2")
			if(possible_a_intents)
				a_intent_change(INTENT_DISARM)
				return
		if("3")
			if(possible_a_intents)
				a_intent_change(INTENT_GRAB)
				return
		if("4")
			if(possible_a_intents)
				a_intent_change(INTENT_HARM)
				return
		if ("V")
			lay_down()
			return
		if("Insert")
			if(client.keys_held["Ctrl"])
				keybind_toggle_active_blocking()
				return
			else
				keybind_parry()
				return
		if("G")
			keybind_parry()
			return
		if("F")
			keybind_start_active_blocking()
	return ..()

/mob/living/key_up(_key, client/user)
	switch(_key)
		if("F")
			keybind_stop_active_blocking()
			return
	return ..()
