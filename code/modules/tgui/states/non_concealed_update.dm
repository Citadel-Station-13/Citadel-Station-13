 /**
  * tgui state: non_concealed_update
  *
  * Checks that the src_object is in the user's hands or adjacent, or block view updates entirely.
 **/

GLOBAL_DATUM_INIT(non_concealed_update /datum/ui_state/non_concealed_update, new)

/datum/ui_state/non_concealed_update/can_use_topic(src_object, mob/user)
	. = user.shared_ui_interaction(src_object)
	if(user.hands_can_use_topic(src_object) < UI_INTERACTIVE)
		return min(., UI_DISABLED)
	if(get_dist(src_object, user) > 1)
		return min(., UI_DISABLED)
