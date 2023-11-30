/datum/component/waddling
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

/datum/component/waddling/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), PROC_REF(Waddle))

/datum/component/waddling/proc/Waddle()
	var/mob/living/L = parent
	if(L.incapacitated() || L.lying)
		return
	var/matrix/otransform = matrix(L.transform) //make a copy of the current transform
	animate(L, pixel_z = 4, time = 0)
	animate(pixel_z = 0, transform = turn(L.transform, pick(-12, 0, 12)), time=2) //waddle.
	animate(pixel_z = 0, transform = otransform, time = 0) //return to previous transform.
