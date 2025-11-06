//Preset for general and toggled actions
/datum/action/innate
	check_flags = NONE
	required_mobility_flags = NONE
	/// Whether we're active or not, if we're a innate - toggle action.
	var/active = FALSE

/datum/action/innate/Trigger(trigger_flags)
	if(!..())
		return FALSE
	var/active_status = active
	if(active_status)
		Deactivate()
	else
		Activate()

	if(active != active_status)
		build_all_button_icons(UPDATE_BUTTON_STATUS)
	return TRUE

/datum/action/innate/is_action_active(atom/movable/screen/movable/action_button/current_button)
	return active

/datum/action/innate/proc/Activate()
	return

/datum/action/innate/proc/Deactivate()
	return
