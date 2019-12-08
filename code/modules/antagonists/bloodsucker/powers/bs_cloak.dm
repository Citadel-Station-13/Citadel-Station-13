

/datum/action/bloodsucker/cloak
	name = "Cloak of Darkness"
	desc = "Blend into the shadows and become invisible to the untrained eye."
	button_icon_state = "power_cloak"
	bloodcost = 5
	cooldown = 50
	bloodsucker_can_buy = TRUE
	amToggle = TRUE
	warn_constant_cost = TRUE

	var/light_min = 0.5 	// If lum is above this, no good.

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
	while (bloodsuckerdatum && ContinueActive(user))
		// Fade from sight
		owner.alpha = max(0, owner.alpha - min(75, 20 + 15 * level_current))
		bloodsuckerdatum.AddBloodVolume(-0.2)
		ADD_TRAIT(user, TRAIT_NORUNNING, "cloak of darkness")
		sleep(5)

/datum/action/bloodsucker/cloak/ContinueActive(mob/living/user, mob/living/target)
	if (!..())
		return FALSE
	// Must be CONSCIOUS
	if(user.stat == !CONSCIOUS)
		to_chat(owner, "<span class='warning'>Your cloak failed due to you falling unconcious! </span>")
		return FALSE
	// Must be DARK
	var/turf/T = owner.loc
	if(istype(T) && T.get_lumcount() > light_min)
		to_chat(owner, "<span class='warning'>Your cloak failed due to there being too much light!</span>")
		return FALSE
	return TRUE


/datum/action/bloodsucker/cloak/DeactivatePower(mob/living/user = owner, mob/living/target)
	..()
	REMOVE_TRAIT(user, TRAIT_NORUNNING, "cloak of darkness")
	user.alpha = 255
