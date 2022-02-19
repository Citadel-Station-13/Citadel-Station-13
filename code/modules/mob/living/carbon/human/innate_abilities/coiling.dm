
/datum/action/innate/ability/coiling
	name = "Coil Grabbed Mob"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "slimepuddle"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	required_mobility_flags = MOBILITY_STAND
	var/currently_coiling = FALSE
	var/mob/living/carbon/human/currently_coiled
	var/mutable_appearance/tracked_overlay

/datum/action/innate/ability/coiling/Activate()
	// make sure they meet the mobility/check flags
	if(IsAvailable())
		// check that the user has grabbed someone and they are not currently coiling someone
		if(ishuman(owner.pulling) && !currently_coiling)
			coil_mob(owner.pulling)

/datum/action/innate/ability/coiling/proc/update_coil_offset()
	// update the coiling offset on the coiled user depending on the way the owner is facing
	switch(owner.dir)
		if(NORTH)
			owner.pixel_x = -12
		if(EAST)
			owner.pixel_x = -12
		if(SOUTH)
			owner.pixel_x = 12
		if(NORTH)
			owner.pixel_x = 12

/datum/action/innate/ability/coiling/proc/coil_mob(var/mob/living/carbon/human/H)
	// begin the coiling action
	message_admins("[owner] is coiling [H]")
	currently_coiling = TRUE
	currently_coiled = H

	H.layer -= 0.1 // LISTEN I HATE TOUCHING MOB LAYERS TOO BUT THIS IS JUST SO THEY RENDER UNDER THE OTHER PLAYER SDFHSDFHDSFHDSH

	// move user to same tile
	H.forceMove(get_turf(owner))

	// cancel the coiling action if certain things are done
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, .proc/cancel_coil)
	RegisterSignal(owner, COMSIG_LIVING_RESTING, .proc/cancel_coil)
	RegisterSignal(owner, COMSIG_LIVING_STOPPED_PULLING, .proc/cancel_coil)

	// update the coil offset, update again if owner changes direction
	update_coil_offset()
	RegisterSignal(owner, COMSIG_ATOM_DIR_CHANGE, .proc/update_coil_offset)

	// set our overlay to new image

	var/mob/living/carbon/human/user = owner
	user.dna.species.mutant_bodyparts["taur"] = "Naga (coiled)"
	user.dna.features["taur"] = "Naga (coiled)"
	user.update_mutant_bodyparts()

/datum/action/innate/ability/coiling/proc/cancel_coil()
	var/mob/living/carbon/human/H = owner

	// cancel the coiling action by removing the overlay
	message_admins("[owner] has stopped coiling [currently_coiled]")
	currently_coiling = FALSE
	currently_coiled = null

	// unregister signals
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_LIVING_RESTING)
	UnregisterSignal(owner, COMSIG_LIVING_STOPPED_PULLING)
	UnregisterSignal(owner, COMSIG_ATOM_DIR_CHANGE)

	// change overlay back to original image
	H.dna.species.mutant_bodyparts["taur"] = "Naga"
	H.update_body()

	H.layer += 0.1

	// remove the added overlay
	owner.cut_overlay(tracked_overlay)
	tracked_overlay = null

/datum/action/innate/ability/coiling/Remove(mob/M)
	cancel_coil()
	..(M)