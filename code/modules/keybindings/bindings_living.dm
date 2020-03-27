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


	return ..()