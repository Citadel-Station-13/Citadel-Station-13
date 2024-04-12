/mob/living/carbon/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if (!isnull(held_item))
		return .

	if (!ishuman(user))
		return .

	var/combat_mode = SEND_SIGNAL(user, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_ACTIVE)

	if(user == src)
		LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_HELP, "Check injuries")
	else if(!lying)
		LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_HELP, "Comfort")
	else if (health >= 0 && !HAS_TRAIT(src, TRAIT_FAKEDEATH))
		LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_HELP, "Shake")
	else
		LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_HELP, "CPR")

	LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_DISARM, "Disarm")
	if(combat_mode && (src != user))
		LAZYSET(context[SCREENTIP_CONTEXT_RMB], INTENT_DISARM, "Shove")

	if(src != user)
		if (pulledby == user)
			switch (user.grab_state)
				if (GRAB_PASSIVE)
					LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_GRAB, "Grip")
				if (GRAB_AGGRESSIVE)
					LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_GRAB, "Choke")
				if (GRAB_NECK)
					LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_GRAB, "Strangle")
				else
					return .
		else
			LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_GRAB, "Pull")

	LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_HARM, "Attack")

	// Monkeys cannot be grabbed harder using ctrl-click, don't ask.
	if((pulledby != user) && (src != user))
		LAZYSET(context[SCREENTIP_CONTEXT_CTRL_LMB], INTENT_ANY, "Pull")
	// Happens on any intent i believe
	if((user == src) && combat_mode && lying)
		LAZYSET(context[SCREENTIP_CONTEXT_RMB], INTENT_ANY, "Force to get up")

	return CONTEXTUAL_SCREENTIP_SET
