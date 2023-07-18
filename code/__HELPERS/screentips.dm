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
 * 	- context[key] = list (REQUIRED)
 * - key = string (REQUIRED)
 * - allow_image = boolean (not required)
*/
/proc/build_context(list/context, key, allow_image)
	if(!(length(context) && length(context[key]) && key))
		return ""
	var/list/to_add
	for(var/intent in context[key])
		// Get everything but the mouse button, may be empty
		var/key_combo = length(key) > 3 ? "[copytext(key, 1, -3)]" : ""
		// Grab the mouse button, LMB/RMB+intent
		var/button = "[copytext(key, -3)]-[intent]"
		if(allow_image)
			// Compile into image, if allowed
			button = "\icon[GLOB.screentip_context_icons[button]]"
		LAZYADD(to_add, "[key_combo][button][allow_image ? "" : ":"] [context[key][intent]]")

	// Prepare separator for same button but different intent
	var/separator = "[allow_image ? " " : " / "]"

	// Voilá, final result
	return english_list(to_add, "", separator, separator)

#undef HINT_ICON_FILE
