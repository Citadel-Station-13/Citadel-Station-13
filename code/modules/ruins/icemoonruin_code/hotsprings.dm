GLOBAL_LIST_EMPTY(cursed_minds)

/**
  * Turns whoever enters into a mob
  *
  * If mob is chosen, turns the person into a random animal type
  * Once the spring is used, it cannot be used by the same mind ever again
  * After usage, teleports the user back to a random safe turf (so mobs are not killed by ice moon atmosphere)
  *
  */

/turf/open/water/cursed_spring
	baseturfs = /turf/open/water/cursed_spring
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS

/turf/open/water/cursed_spring/Entered(atom/movable/thing, atom/oldLoc)
	. = ..()
	if(!isliving(thing))
		return
	var/mob/living/L = thing
	if(!L.client)
		return
	if(GLOB.cursed_minds[L.mind])
		return
	GLOB.cursed_minds[L.mind] = TRUE
	RegisterSignal(L.mind, COMSIG_PARENT_QDELETING, .proc/remove_from_cursed)
	L = wabbajack(L, "animal") // Appearance randomization removed so citadel players don't get randomized into some ungodly ugly creature and complain
	var/turf/T = find_safe_turf()
	L.forceMove(T)
	to_chat(L, "<span class='notice'>You blink and find yourself in [get_area_name(T)].</span>")

/**
  * Deletes minds from the cursed minds list after their deletion
  *
  */
/turf/open/water/cursed_spring/proc/remove_from_cursed(datum/mind/M)
	GLOB.cursed_minds -= M
