
/datum/action/innate/ability/coiling
	name = "Coil Grabbed Mob"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "slimepuddle"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	required_mobility_flags = MOBILITY_STAND
	var/currently_coiling = FALSE
	var/mob/living/carbon/human/currently_coiled

/datum/action/innate/ability/coiling/Activate()
	// make sure they meet the mobility/check flags
	if(IsAvailable()
		var/mob/living/carbon/human/H = owner
		// check that the user has grabbed someone and they are not currently coiling someone
		if(ishuman(owner.pulling) && !currently_coiling)
			coil_mob(owner.pulling)

/datum/action/innate/ability/coiling/proc/cancel_coil()
	// cancel the coiling action by removing the overlay
	message_admins("[owner] has stopped coiling [currently_coiled]")
	currently_coiling = FALSE
	currently_coiled = null

/datum/action/innate/ability/coiling/proc/coil_mob(var/mob/living/carbon/human/H victim)
	// begin the coiling action
	message_admins("[owner] is coiling [H]")
	currently_coiling = TRUE
	currently_coiled = H

	// cancel the coiling action if certain things are done
	REGISTER_SIGNAL(owner, COMSIG_MOVABLE_MOVED, cancel_coil)
	REGISTER_SIGNAL(owner, COMSIG_LIVING_RESTING, cancel_coil)
	REGISTER_SIGNAL(owner, COMSIG_LIVING_STOPPED_PULLING, cancel_coil)


