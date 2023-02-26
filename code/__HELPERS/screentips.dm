#define HINT_ICON_FILE 'icons/UI_Icons/screentips/cursor_hints.dmi'

// Generate intent icons
GLOBAL_LIST_INIT_TYPED(screentip_context_icons, /image, prepare_screentip_context_icons())

/proc/prepare_screentip_context_icons()
	. = list()
	for(var/state in icon_states(HINT_ICON_FILE))
		.[state] = image(HINT_ICON_FILE, icon_state = state)

/*
 * # Builds context with each intent for this key
 * Args:
 * - context = list (REQUIRED)
 * - key = string (REQUIRED)
 * - allow_image = boolean (not required)
*/
/proc/build_context(list/context, key, allow_image)
	var/list/to_add
	for(var/intent in context[key])
		var/key_help = "[length(key) > 3 ? "[copytext(key, 1, -3)][allow_image ? " " : ""]" : ""]"
		var/icon = "[copytext(key, -3)]-[intent]"
		if(allow_image)
			icon = "\icon[GLOB.screentip_context_icons[icon]]"
		LAZYADD(to_add, "[key_help][icon]: [context[key][intent]]")

	var/separator = "[allow_image ? "  " : " | "]"
	return english_list(to_add, "", separator, separator)

#undef HINT_ICON_FILE
