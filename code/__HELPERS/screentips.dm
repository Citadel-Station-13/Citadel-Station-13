// Generate intent icons
/// Help intent icon for screentip context
GLOBAL_DATUM_INIT(icon_intent_help, /image, image('icons/emoji.dmi', icon_state = INTENT_HELP))
/// Disarm intent icon for screentip context
GLOBAL_DATUM_INIT(icon_intent_disarm, /image, image('icons/emoji.dmi', icon_state = INTENT_DISARM))
/// Grab intent icon for screentip context
GLOBAL_DATUM_INIT(icon_intent_grab, /image, image('icons/emoji.dmi', icon_state = INTENT_GRAB))
/// Harm intent icon for screentip context
GLOBAL_DATUM_INIT(icon_intent_harm, /image, image('icons/emoji.dmi', icon_state = INTENT_HARM))

/*
 * # Builds context with each intent for this key
 * Args:
 * - context = list (REQUIRED)
 * - key = string (REQUIRED)
*/
/proc/build_context(list/context, key)
	var/list/to_add
	for(var/intent in context[key])
		switch(intent)
			if(INTENT_HELP)
				LAZYADD(to_add, "\icon[GLOB.icon_intent_help] [key]: [context[key][INTENT_HELP]]")
			if(INTENT_DISARM)
				LAZYADD(to_add, "\icon[GLOB.icon_intent_disarm] [key]: [context[key][INTENT_DISARM]]")
			if(INTENT_GRAB)
				LAZYADD(to_add, "\icon[GLOB.icon_intent_grab] [key]: [context[key][INTENT_GRAB]]")
			if(INTENT_HARM)
				LAZYADD(to_add, "\icon[GLOB.icon_intent_harm] [key]: [context[key][INTENT_HARM]]")
			else // If you're adding intent-less YOU BETTER ADD IT FIRST IN THE LIST
				LAZYADD(to_add, "[key]: [context[key][intent]]")
	return english_list(to_add, "", " ", " ")
