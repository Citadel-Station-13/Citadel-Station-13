
/datum/action/innate/ability/coiling
	name = "Coil Grabbed Mob"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "coil_icon"
	icon_icon = 'icons/mob/actions/actions_snake.dmi'
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

/datum/action/innate/ability/coiling/proc/update_coil_offset(atom/source, old_dir, new_dir)
	// update the coiling offset on the coiled user depending on the way the owner is facing
	switch(new_dir)
		if(NORTH)
			currently_coiled.pixel_x = -12
		if(EAST)
			currently_coiled.pixel_x = -12
		if(SOUTH)
			currently_coiled.pixel_x = 12
		if(WEST)
			currently_coiled.pixel_x = 12

/datum/action/innate/ability/coiling/proc/coil_mob(var/mob/living/carbon/human/H)
	if(currently_coiling)
		to_chat(owner, span_warning("You are already coiling someone!"))
		return

	// begin the coiling action
	H.visible_message("<span class='warning'>[owner] coils [H] with their tail!</span>", \
						  "<span class='userdanger'>[owner] coils you with their tail!</span>")
	currently_coiling = TRUE
	currently_coiled = H

	H.layer -= 0.1 // LISTEN I HATE TOUCHING MOB LAYERS TOO BUT THIS IS JUST SO THEY RENDER UNDER THE OTHER PLAYER SDFHSDFHDSFHDSH

	// move user to same tile
	H.forceMove(get_turf(owner))

	// cancel the coiling action if certain things are done
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(cancel_coil))
	RegisterSignal(owner, COMSIG_LIVING_RESTING, PROC_REF(cancel_coil))
	RegisterSignal(owner, COMSIG_LIVING_STOPPED_PULLING, PROC_REF(cancel_coil))

	// update the coil offset, update again if owner changes direction
	RegisterSignal(owner, COMSIG_ATOM_DIR_CHANGE, PROC_REF(update_coil_offset))
	update_coil_offset(null, null, owner.dir)

	// set our overlay to new image
	var/mob/living/carbon/human/user = owner
	user.dna.species.mutant_bodyparts["taur"] = "Naga (coiled)"
	user.dna.features["taur"] = "Naga (coiled)"
	user.update_mutant_bodyparts()

/datum/action/innate/ability/coiling/proc/cancel_coil()
	var/mob/living/carbon/human/H = owner

	if(!currently_coiling)
		return

	// cancel the coiling action by removing the overlay
	currently_coiled.pixel_x = 0

	currently_coiling = FALSE
	currently_coiled = null

	// unregister signals
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_LIVING_RESTING)
	UnregisterSignal(owner, COMSIG_LIVING_STOPPED_PULLING)
	UnregisterSignal(owner, COMSIG_ATOM_DIR_CHANGE)

	// change overlay back to original image
	H.dna.species.mutant_bodyparts["taur"] = "Naga"
	H.dna.features["taur"] = "Naga"
	H.update_mutant_bodyparts()

	H.update_body()

	H.layer += 0.1

	// remove the added overlay
	owner.cut_overlay(tracked_overlay)
	tracked_overlay = null

/datum/action/innate/ability/coiling/Remove(mob/M)
	cancel_coil()
	..(M)
