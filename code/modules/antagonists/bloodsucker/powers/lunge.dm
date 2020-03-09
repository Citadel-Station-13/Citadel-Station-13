// Level 1: Grapple level 2
// Level 2: Grapple 3 from Behind
// Level 3: Grapple 3 from Shadows
/datum/action/bloodsucker/targeted/lunge
	name = "Predatory Lunge"
	desc = "Spring at your target and aggressively grapple them without warning. Attacks from concealment or the rear may even knock them down."
	button_icon_state = "power_lunge"
	bloodcost = 10
	cooldown = 120
	target_range = 3
	power_activates_immediately = TRUE
	message_Trigger = "Whom will you ensnare within your grasp?"
	must_be_capacitated = TRUE
	bloodsucker_can_buy = TRUE

/datum/action/bloodsucker/targeted/lunge/CheckCanUse(display_error)
	if(!..(display_error))// DEFAULT CHECKS
		return FALSE
	// Being Grabbed
	if(owner.pulledby && owner.pulledby.grab_state >= GRAB_AGGRESSIVE)
		if(display_error)
			to_chat(owner, "<span class='warning'>You're being grabbed!</span>")
		return FALSE
	if(!owner.has_gravity(owner.loc))//TODO figure out how to check if theyre able to move while in nograv
		if(display_error)
			to_chat(owner, "<span class='warning'>You cant lunge while floating!</span>")
		return FALSE
	return TRUE

/datum/action/bloodsucker/targeted/lunge/CheckValidTarget(atom/A)
	return iscarbon(A)

/datum/action/bloodsucker/targeted/lunge/CheckCanTarget(atom/A, display_error)
	// Check: Self
	if(target == owner)
		return FALSE
	// Check: Range
	//if (!(target in view(target_range, get_turf(owner))))
	//	if (display_error)
	//		to_chat(owner, "<span class='warning'>Your victim is too far away.</span>")
	//	return FALSE
	// DEFAULT CHECKS (Distance)
	if(!..())
		return FALSE
	// Check: Turf
	var/mob/living/L = A
	if(!isturf(L.loc))
		return FALSE
	return TRUE

/datum/action/bloodsucker/targeted/lunge/FireTargetedPower(atom/A)
	// set waitfor = FALSE   <---- DONT DO THIS!We WANT this power to hold up ClickWithPower(), so that we can unlock the power when it's done.
	var/mob/living/carbon/target = A
	var/turf/T = get_turf(target)
	var/mob/living/L = owner
	// Clear Vars
	owner.pulling = null
	// Will we Knock them Down?
	var/do_knockdown = !is_A_facing_B(target,owner) || owner.alpha <= 0 || istype(owner.loc, /obj/structure/closet)
	// CAUSES: Target has their back to me, I'm invisible, or I'm in a Closet
	// Step One: Heatseek toward Target's Turf
	addtimer(CALLBACK(GLOBAL_PROC, .proc/_walk, owner, 0), 2 SECONDS)
	target.playsound_local(get_turf(owner), 'sound/bloodsucker/lunge_warn.ogg', 60, FALSE, pressure_affected = FALSE) // target-only telegraphing
	owner.playsound_local(owner, 'sound/bloodsucker/lunge_warn.ogg', 60, FALSE, pressure_affected = FALSE) // audio feedback to the user
	if(do_mob(owner, owner, 7, TRUE, TRUE))
		walk_towards(owner, T, 0.1, 10) // yes i know i shouldn't use this but i don't know how to work in anything better
		if(get_turf(owner) != T && !(isliving(target) && target.Adjacent(owner)) && owner.incapacitated() && !CHECK_MOBILITY(L, MOBILITY_STAND))
			var/send_dir = get_dir(owner, T)
			new /datum/forced_movement(owner, get_ranged_target_turf(owner, send_dir, 1), 1, FALSE)
			owner.spin(10)
			// Step Two: Check if I'm at/adjectent to Target's CURRENT turf (not original...that was just a destination)
		for(var/i in 1 to 6)
			if (target.Adjacent(owner))
				// LEVEL 2: If behind target, mute or unconscious!
				if(do_knockdown) // && level_current >= 1)
					target.Knockdown(15 + 10 * level_current,1)
					target.adjustStaminaLoss(40 + 10 * level_current)
				// Cancel Walk (we were close enough to contact them)
				walk(owner, 0)
				target.Stun(10,1) //Without this the victim can just walk away
				target.grabbedby(owner) // Taken from mutations.dm under changelings
				target.grippedby(owner, instant = TRUE) //instant aggro grab
				break
			sleep(3)

/datum/action/bloodsucker/targeted/lunge/DeactivatePower(mob/living/user = owner, mob/living/target)
	..() // activate = FALSE
	user.update_mobility()
