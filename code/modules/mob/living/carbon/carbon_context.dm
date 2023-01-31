/mob/living/carbon/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if (!isnull(held_item))
		return .

	if (!ishuman(user))
		return .

	var/combat_mode = SEND_SIGNAL(user, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_ACTIVE)

	switch(user.a_intent)
		if(INTENT_HELP)
			if(user == src)
				context[SCREENTIP_CONTEXT_LMB] = "Check injuries"
			else if(!lying)
				context[SCREENTIP_CONTEXT_LMB] = "Comfort"
			else if (health >= 0 && !HAS_TRAIT(src, TRAIT_FAKEDEATH))
				context[SCREENTIP_CONTEXT_LMB] = "Shake"
			else
				context[SCREENTIP_CONTEXT_LMB] = "CPR"
		if(INTENT_DISARM)
			context[SCREENTIP_CONTEXT_LMB] = "Disarm"
			if(combat_mode)
				context[SCREENTIP_CONTEXT_RMB] = "Shove"
		if(INTENT_GRAB)
			if(src != user)
				if (pulledby == user)
					switch (user.grab_state)
						if (GRAB_PASSIVE)
							context[SCREENTIP_CONTEXT_LMB] = "Grip"
						if (GRAB_AGGRESSIVE)
							context[SCREENTIP_CONTEXT_LMB] = "Choke"
						if (GRAB_NECK)
							context[SCREENTIP_CONTEXT_LMB] = "Strangle"
						else
							return .
				else
					context[SCREENTIP_CONTEXT_LMB] = "Pull"
		if(INTENT_HARM)
			context[SCREENTIP_CONTEXT_LMB] = "Attack"

	// Did you know we cannot upgrade grabs from ctrl-click, that's cool
	if(pulledby != user)
		context[SCREENTIP_CONTEXT_CTRL_LMB] = "Pull"
	// Happens on any intent i believe
	if((user == src) && combat_mode && lying)
		context[SCREENTIP_CONTEXT_RMB] = "Force to get up"

	return CONTEXTUAL_SCREENTIP_SET
