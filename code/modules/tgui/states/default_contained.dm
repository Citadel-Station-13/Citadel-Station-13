/**
 * tgui state: default_contained
 *
 * Basically default and contained combined, allowing for both
 */

GLOBAL_DATUM_INIT(default_contained_state, /datum/ui_state/default/contained, new)

/datum/ui_state/default/contained/can_use_topic(atom/src_object, mob/user)
	if(src_object.contains(user))
		return UI_INTERACTIVE
	return ..()
	