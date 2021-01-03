
//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness, ear damage,
// eye damage, eye_blind, eye_blurry, druggy, TRAIT_BLIND trait, and TRAIT_NEARSIGHT trait.

///Set the jitter of a mob
/mob/proc/Jitter(amount)
	jitteriness = max(jitteriness,amount,0)

/**
  * Set the dizzyness of a mob to a passed in amount
  *
  * Except if dizziness is already higher in which case it does nothing
  */
/mob/proc/Dizzy(amount)
	dizziness = max(dizziness,amount,0)

///FOrce set the dizzyness of a mob
/mob/proc/set_dizziness(amount)
	dizziness = max(amount, 0)

/**
  * Sets a mob's blindness to an amount if it was not above it already, similar to how status effects work
  */
/mob/proc/blind_eyes(amount)
	var/old_blind = eye_blind
	eye_blind = max((!eye_blind && stat == UNCONSCIOUS || HAS_TRAIT(src, TRAIT_BLIND)) ? 1 : eye_blind , amount)
	var/new_blind = eye_blind
	if(old_blind != new_blind)
		update_blindness()

/**
  * Adjust a mobs blindness by an amount
  *
  * Will apply the blind alerts if needed
  */
/mob/proc/adjust_blindness(amount)
	var/old_eye_blind = eye_blind
	eye_blind = max((stat == UNCONSCIOUS || HAS_TRAIT(src, TRAIT_BLIND)) ? 1 : 0, eye_blind + amount)
	if(!old_eye_blind || !eye_blind)
		update_blindness()
/**
  * Force set the blindness of a mob to some level
  */
/mob/proc/set_blindness(amount)
	var/old_eye_blind = eye_blind
	eye_blind = max(amount, (stat == UNCONSCIOUS || HAS_TRAIT(src, TRAIT_BLIND)) ? 1 : 0)
	if(!old_eye_blind || !eye_blind)
		update_blindness()

/// proc that adds and removes blindness overlays when necessary
/mob/proc/update_blindness()
	if(eye_blind) // UNCONSCIOUS or has blind trait, or has temporary blindness
		if(stat == CONSCIOUS || stat == SOFT_CRIT)
			throw_alert("blind", /obj/screen/alert/blind)
		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		// You are blind why should you be able to make out details like color, only shapes near you
		// add_client_colour(/datum/client_colour/monochrome/blind)
	else // CONSCIOUS no blind trait, no blindness
		clear_alert("blind")
		clear_fullscreen("blind")
		// remove_client_colour(/datum/client_colour/monochrome/blind)
/**
  * Make the mobs vision blurry
  */
/mob/proc/blur_eyes(amount)
	if(amount>0)
		eye_blurry = max(amount, eye_blurry)
	update_eyeblur()

/**
  * Adjust the current blurriness of the mobs vision by amount
  */
/mob/proc/adjust_blurriness(amount)
	eye_blurry = max(eye_blurry+amount, 0)
	update_eyeblur()

///Set the mobs blurriness of vision to an amount
/mob/proc/set_blurriness(amount)
	eye_blurry = max(amount, 0)
	update_eyeblur()

/mob/proc/update_eyeblur()
	remove_eyeblur()
	if(eye_blurry)
		add_eyeblur()

/mob/proc/add_eyeblur()
	if(!client)
		return
	var/list/screens = list(hud_used.plane_masters["[GAME_PLANE]"], hud_used.plane_masters["[FLOOR_PLANE]"],
							hud_used.plane_masters["[WALL_PLANE]"], hud_used.plane_masters["[ABOVE_WALL_PLANE]"])
	for(var/A in screens)
		var/obj/screen/plane_master/P = A
		P.add_filter("blurry_eyes", 2, EYE_BLUR(clamp(eye_blurry*0.1,0.6,3)))

/mob/proc/remove_eyeblur()
	if(!client)
		return
	var/list/screens = list(hud_used.plane_masters["[GAME_PLANE]"], hud_used.plane_masters["[FLOOR_PLANE]"],
							hud_used.plane_masters["[WALL_PLANE]"], hud_used.plane_masters["[ABOVE_WALL_PLANE]"])
	for(var/A in screens)
		var/obj/screen/plane_master/P = A
		P.remove_filter("blurry_eyes")

///Adjust the drugginess of a mob
/mob/proc/adjust_drugginess(amount)
	return

///Set the drugginess of a mob
/mob/proc/set_drugginess(amount)
	return

///Adjust the disgust level of a mob
/mob/proc/adjust_disgust(amount)
	return

///Set the disgust level of a mob
/mob/proc/set_disgust(amount)
	return

///Adjust the body temperature of a mob, with min/max settings
/mob/proc/adjust_bodytemperature(amount,min_temp=0,max_temp=INFINITY)
	if(bodytemperature >= min_temp && bodytemperature <= max_temp)
		bodytemperature = clamp(bodytemperature + amount,min_temp,max_temp)
