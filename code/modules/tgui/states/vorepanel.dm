 /**
  * tgui state: vorepanel_state
  *
  * Only checks that the user and src_object are the same.
 **/

GLOBAL_DATUM_INIT(ui_vorepanel_state, /datum/ui_state/vorepanel_state, new)

/datum/ui_state/vorepanel_state/can_use_topic(src_object, mob/user)
	if(src_object != user)
		// Note, in order to allow others to look at others vore panels, change this to
		// UI_UPDATE
		return UI_CLOSE
	if(!user.client)
		return UI_CLOSE
	if(user.stat == DEAD)
		return UI_DISABLED
	return UI_INTERACTIVE
