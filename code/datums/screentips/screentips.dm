#define HINT_ICON_FILE 'icons/UI_Icons/screentips/cursor_hints.dmi'

/// Stores the cursor hint icons for screentip context.
GLOBAL_LIST_INIT_TYPED(screentip_context_icons, /image, prepare_screentip_context_icons())

/proc/prepare_screentip_context_icons()
	var/list/output = list()
	for(var/state in icon_states(HINT_ICON_FILE))
		output[state] = image(HINT_ICON_FILE, icon_state = state)
	return output

/*
 * # Builds context with each intent for this key
 * Args:
 * - context = list (REQUIRED)
 * 	- context[key] = list (REQUIRED)
 * - key = string (REQUIRED)
 * - allow_image = boolean (not required)
*/
/proc/build_context(list/context, key, allow_image)
	if(!length(context) || !length(context[key]) || !key)
		return ""
	var/list/to_add
	for(var/intent in context[key])
		// Splits key combinations from mouse buttons. e.g. `Ctrl-Shift-LMB` goes in, `Ctrl-Shift-` goes out. Will be empty for single button actions.
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
	return to_add.Join(separator)

#undef HINT_ICON_FILE
