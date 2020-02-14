
// Level 1: Speed to location
// Level 2: Dodge Bullets
// Level 3: Stun People Passed

/datum/action/bloodsucker/targeted/haste
	name = "Immortal Haste"
	desc = "Dash somewhere with supernatural speed. Those nearby may be knocked away, stunned, or left empty-handed."
	button_icon_state = "power_speed"
	bloodcost = 6
	cooldown = 50
	target_range = 15
	power_activates_immediately = TRUE
	message_Trigger = ""//"Whom will you subvert to your will?"
	bloodsucker_can_buy = TRUE
	must_be_capacitated = TRUE

/datum/action/bloodsucker/targeted/haste/CheckCanUse(display_error)
	. = ..()
	if(!.)
		return
	// Being Grabbed
	if(owner.pulledby && owner.pulledby.grab_state >= GRAB_AGGRESSIVE)
		if(display_error)
			to_chat(owner, "<span class='warning'>You're being grabbed!</span>")
		return FALSE
	if(!owner.has_gravity(owner.loc)) //We dont want people to be able to use this to fly around in space
		if(display_error)
			to_chat(owner, "<span class='warning'>You cant dash while floating!</span>")
		return FALSE
	return TRUE

/datum/action/bloodsucker/targeted/haste/CheckValidTarget(atom/A)
	return isturf(A) || A.loc != owner.loc // Anything will do, if it's not me or my square

/datum/action/bloodsucker/targeted/haste/CheckCanTarget(atom/A, display_error)
	// DEFAULT CHECKS (Distance)
	if (!..())
		return FALSE
	// Check: Range
	//if (!(A in view(target_range, get_turf(owner))))
	//	return FALSE
	return TRUE

/datum/action/bloodsucker/targeted/haste/FireTargetedPower(atom/A)
	// set waitfor = FALSE   <---- DONT DO THIS!We WANT this power to hold up ClickWithPower(), so that we can unlock the power when it's done.
	var/mob/living/user = owner
	var/turf/T = isturf(A) ? A : get_turf(A)
	// Pulled? Not anymore.
	owner.pulledby = null
	// Step One: Heatseek toward Target's Turf
	walk_to(owner, T, 0, 0.01, 20) // NOTE: this runs in the background! to cancel it, you need to use walk(owner.current,0), or give them a new path.
	playsound(get_turf(owner), 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	var/safety = 20
	while(get_turf(owner) != T && safety > 0 && !(isliving(target) && target.Adjacent(owner)))
		user.canmove = FALSE //Dont move while doing the thing, or itll break
		safety --
		// Did I get knocked down?
		if(owner && owner.incapacitated(ignore_restraints=TRUE, ignore_grab=TRUE))// owner.incapacitated())
			// We're gonna cancel. But am I on the ground? Spin me!
			if(user.resting)
				var/send_dir = get_dir(owner, T)
				new /datum/forced_movement(owner, get_ranged_target_turf(owner, send_dir, 1), 1, FALSE)
				owner.spin(10)
			break
		// Spin/Stun people we pass.
		//var/mob/living/newtarget = locate(/mob/living) in oview(1, owner)
		var/list/mob/living/foundtargets = list()
		for(var/mob/living/newtarget in oview(1, owner))
			if (newtarget && newtarget != target && !(newtarget in foundtargets))//!newtarget.IsKnockdown())
				if (rand(0, 5) < level_current)
					playsound(get_turf(newtarget), "sound/weapons/punch[rand(1,4)].ogg", 15, 1, -1)
					newtarget.Knockdown(10 + level_current * 5)
				if(newtarget.IsStun())
					newtarget.spin(10,1)
					if (rand(0,4))
						newtarget.drop_all_held_items()
				foundtargets += newtarget
		sleep(1)
	if(user)
		user.update_canmove() //Let the poor guy move again

/datum/action/bloodsucker/targeted/haste/DeactivatePower(mob/living/user = owner, mob/living/target)
	..() // activate = FALSE
	user.update_canmove()
