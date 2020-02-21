

/datum/action/bloodsucker/cloak
	name = "Cloak of Darkness"
	desc = "Blend into the shadows and become invisible to the untrained eye."
	button_icon_state = "power_cloak"
	bloodcost = 5
	cooldown = 50
	bloodsucker_can_buy = TRUE
	amToggle = TRUE
	warn_constant_cost = TRUE
	var/was_running

	var/light_min = 0.2  	// If lum is above this, no good.

/datum/action/bloodsucker/cloak/CheckCanUse(display_error)
	. = ..()
	if(!.)
		return
	// Must be Dark
	var/turf/T = owner.loc
	if(istype(T) && T.get_lumcount() > light_min)
		to_chat(owner, "<span class='warning'>This area is not dark enough to blend in</span>")
		return FALSE
	return TRUE

/datum/action/bloodsucker/cloak/ActivatePower()
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = owner.mind.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
	var/mob/living/user = owner
	was_running = (user.m_intent == MOVE_INTENT_RUN)
	if(was_running)
		user.toggle_move_intent()
	ADD_TRAIT(user, TRAIT_NORUNNING, "cloak of darkness")
	while(bloodsuckerdatum && ContinueActive(user))
		// Pay Blood Toll (if awake)
		owner.alpha = max(20, owner.alpha - min(75, 10 + 5 * level_current))
		bloodsuckerdatum.AddBloodVolume(-0.2)
		sleep(5) // Check every few ticks that we haven't disabled this power

/datum/action/bloodsucker/cloak/ContinueActive(mob/living/user, mob/living/target)
	if (!..())
		return FALSE
	if(user.stat == !CONSCIOUS) // Must be CONSCIOUS
		to_chat(owner, "<span class='warning'>Your cloak failed due to you falling unconcious! </span>")
		return FALSE
	var/turf/T = owner.loc // Must be DARK
	if(istype(T) && T.get_lumcount() > light_min)
		to_chat(owner, "<span class='warning'>Your cloak failed due to there being too much light!</span>")
		return FALSE
	return TRUE

/datum/action/bloodsucker/cloak/DeactivatePower(mob/living/user = owner, mob/living/target)
	..()
	REMOVE_TRAIT(user, TRAIT_NORUNNING, "cloak of darkness")
	user.alpha = 255
	if(was_running && user.m_intent != MOVE_INTENT_RUN)
		user.toggle_move_intent()
