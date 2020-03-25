
//	* MEZMERIZE
//		LOVE:		Target falls in love with you. Being harmed directly causes them harm if they see it?
//		STAY:		Target will do everything they can to stand in the same place.
//		FOLLOW:		Target follows you, spouting random phrases from their history (or maybe Poly's or NPC's vocab?)
//		ATTACK:		Target finds a nearby non-Bloodsucker victim to attack.

/datum/action/bloodsucker/targeted/mesmerize
	name = "Mesmerize"
	desc = "Dominate the mind of a mortal who can see your eyes."
	button_icon_state = "power_mez"
	bloodcost = 30
	cooldown = 300
	target_range = 2
	power_activates_immediately = TRUE
	message_Trigger = "Whom will you subvert to your will?"
	must_be_capacitated = TRUE
	bloodsucker_can_buy = TRUE
	var/windup_time = 30
	var/success
	var/mob/living/current_victim

/datum/action/bloodsucker/targeted/mesmerize/Destroy()
	cleanup_victim()
	return ..()

/datum/action/bloodsucker/targeted/mesmerize/CheckCanUse(display_error)
	. = ..()
	if(!.)
		return
	if(!owner.getorganslot(ORGAN_SLOT_EYES))
		if (display_error)
			to_chat(owner, "<span class='warning'>You have no eyes with which to mesmerize.</span>")
		return FALSE
	// Check: Eyes covered?
	var/mob/living/L = owner
	if(istype(L) && L.is_eyes_covered() || !isturf(owner.loc))
		if(display_error)
			to_chat(owner, "<span class='warning'>Your eyes are concealed from sight.</span>")
		return FALSE
	return TRUE

/datum/action/bloodsucker/targeted/mesmerize/CheckValidTarget(atom/A)
	return iscarbon(A)

/datum/action/bloodsucker/targeted/mesmerize/CheckCanTarget(atom/A,display_error)
	// Check: Self
	if(A == owner)
		return FALSE
	var/mob/living/carbon/target = A // We already know it's carbon due to CheckValidTarget()

	// Bloodsucker
	if(target.mind && target.mind.has_antag_datum(ANTAG_DATUM_BLOODSUCKER))
		if (display_error)
			to_chat(owner, "<span class='warning'>Bloodsuckers are immune to [src].</span>")
		return FALSE
	// Dead/Unconscious
	if(target.stat > CONSCIOUS)
		if (display_error)
			to_chat(owner, "<span class='warning'>Your victim is not [(target.stat == DEAD || HAS_TRAIT(target, TRAIT_FAKEDEATH))?"alive":"conscious"].</span>")
		return FALSE
	// Check: Target has eyes?
	if(!target.getorganslot(ORGAN_SLOT_EYES))
		if (display_error)
			to_chat(owner, "<span class='warning'>They have no eyes!</span>")
		return FALSE
	// Check: Target blind?
	if(target.eye_blind > 0)
		if (display_error)
			to_chat(owner, "<span class='warning'>Your victim's eyes are glazed over. They cannot perceive you.</span>")
		return FALSE
	// Check: Target See Me? (behind wall)
	if(!(target in view(target_range, get_turf(owner))))
		// Sub-Check: GET CLOSER
		//if (!(owner in range(target_range, get_turf(target)))
		//	if (display_error)
		//		to_chat(owner, "<span class='warning'>You're too far from your victim.</span>")
		if(display_error)
			to_chat(owner, "<span class='warning'>You're too far outside your victim's view.</span>")
		return FALSE

	if(target.has_status_effect(STATUS_EFFECT_MESMERIZE)) // ignores facing once the windup has started
		return TRUE

	// Check: Facing target?
	if(!is_A_facing_B(owner,target))	// in unsorted.dm
		if (display_error)
			to_chat(owner, "<span class='warning'>You must be facing your victim.</span>")
		return FALSE
	// Check: Target facing me?
	if (CHECK_MOBILITY(target, MOBILITY_STAND) && !is_A_facing_B(target,owner))
		if(display_error)
			to_chat(owner, "<span class='warning'>Your victim must be facing you to see into your eyes.</span>")
		return FALSE
	return TRUE

/datum/action/bloodsucker/targeted/mesmerize/proc/ContinueTarget(atom/A)
	var/mob/living/carbon/target = A
	var/mob/living/user = owner

	var/cancontinue=CheckCanTarget(target)
	if(!cancontinue)
		success = FALSE
		target.remove_status_effect(STATUS_EFFECT_MESMERIZE)
		DeactivatePower()
		DeactivateRangedAbility()
		StartCooldown()
		to_chat(user, "<span class='warning'>[target] has escaped your gaze!</span>")
		UnregisterSignal(target, COMSIG_MOVABLE_MOVED)

/datum/action/bloodsucker/targeted/mesmerize/FireTargetedPower(atom/A)
	// set waitfor = FALSE   <---- DONT DO THIS!We WANT this power to hold up ClickWithPower(), so that we can unlock the power when it's done.
	var/mob/living/carbon/target = A
	var/mob/living/user = owner

	if(istype(target))
		success = TRUE
		setup_target(user, target)
		do_mesmerize_cycle(user, target)
		cleanup_target(user, target, success)

/datum/action/bloodsucker/targeted/mesmerize/proc/do_mesmerize_cycle(mob/living/user, mob/living/carbon/target)
	var/power_time = 138 + level_current * 12
	sleep(windup_time)
	if(success)
		PowerActivatedSuccessfully() // blood & cooldown only altered if power activated successfully - less "fuck you"-y
		target.face_atom(user)
		target.apply_status_effect(STATUS_EFFECT_MESMERIZE, power_time) // pretty much purely cosmetic
		ADD_TRAIT(target, TRAIT_MOBILITY_NOPICKUP, src)
		ADD_TRAIT(target, TRAIT_MOBILITY_NOUSE, src)
		ADD_TRAIT(target, TRAIT_MOBILITY_NOMOVE, src)
		to_chat(user, "<span class='notice'>[target] is fixed in place by your hypnotic gaze.</span>")
		addtimer(CALLBACK(src, .proc/reset_victim), power_time)
		reset_victim()		//make sure old one is cleared if it isn't already 
		current_victim = target
		RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/reset_victim)

/datum/action/bloodsucker/targeted/mesmerize/proc/reset_victim()
	if(!current_victim)
		return
	var/mob/living/target = current_victim
	current_victim = null
	REMOVE_TRAIT(target, TRAIT_MOBILITY_NOMOVE, src)
	REMOVE_TRAIT(target, TRAIT_MOBILITY_NOUSE, src)
	REMOVE_TRAIT(target, TRAIT_MOBILITY_NOPICKUP, src)
	target.remove_status_effect(STATUS_EFFECT_MESMERIZE)
	UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	if(istype(user) && target.stat == CONSCIOUS && (target in view(10, get_turf(user)))  )
		to_chat(user, "<span class='warning'>[target] has snapped out of their trance.</span>")

/datum/action/bloodsucker/targeted/mesmerize/proc/setup_target(mob/living/user, mob/living/target)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/ContinueTarget)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/ContinueTarget)
	target.apply_status_effect(STATUS_EFFECT_MESMERIZE, windup_time)

/datum/action/bloodsucker/targeted/mesmerize/proc/cleanup_target(mob/living/user, mob/living/target, success = FALSE)
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	if(!success)
		target.remove_status_effect(STATUS_EFFECT_MESMERIZE) 

/datum/action/bloodsucker/targeted/mesmerize/ContinueActive(mob/living/user, mob/living/target)
	return ..() && CheckCanUse() && CheckCanTarget(target)
