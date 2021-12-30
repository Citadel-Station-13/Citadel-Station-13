/**
 * A datum holding and managing plane masters
 */
/datum/plane_holder
	/// all plane masters. Sorted list outside of adminbus fuckery.
	var/list/atom/movable/screen/plane_master/planes
	/// Planes by .. well, plane. Assoc list.
	var/list/plane_lookup
	/// initialized?
	var/initialized = FALSE
	/// clients applied to
	var/list/client/clients
	/// override alphas by plane
	var/list/override_alphas
	/// override colors by plane
	var/list/override_colors

/datum/plane_holder/Destroy()
	for(var/client/C in clients)
		RemoveFromClient(C)
	return ..()

/datum/plane_holder/proc/Instantiate()
	if(initialized)
		return
	for(var/path in GetPlaneTypes())
		var/atom/movable/screen/plane_master/P = new path
		planes += P
		plane_lookup["[P.plane]"] = P
		P.screen_loc = GetScreenLoc(P)

/datum/plane_holder/proc/GetPlaneTypes()
	. = list()
	for(var/path in subtypesof(/atom/movable/screen/plane_master))
		var/atom/movable/screen/plane_master/P = path
		if(initial(P.abstract_type) == path)
			continue
		. += path

/datum/plane_holder/proc/GetScreenLoc(atom/movable/screen/plane_master/P)
	return "CENTER"

/datum/plane_holder/proc/ApplyToClient(client/C)
	C.screen |= planes
	clients |= C
	RegisterSignal(C, COMSIG_PARENT_QDELETING, .proc/RemoveFromClient)

/datum/plane_holder/proc/RemoveFromClient(client/C)
	clients -= C
	C.screen -= planes

/datum/plane_holder/proc/SetAlpha(plane, alpha, override = FALSE)
	var/atom/movable/screen/plane_master/P = plane_lookup["[plane]"]
	if(!override && override_alphas && override_alphas["[plane]"])
		return
	if(override)
		LAZYSET(override_alphas, "[plane]", alpha)
	P.alpha = alpha

/datum/plane_holder/proc/SetColor(plane, color, override = FALSE)
	var/atom/movable/screen/plane_master/P = plane_lookup["[plane]"]
	if(!override && override_colors && override_colors["[plane]"])
		return
	if(override)
		LAZYSET(override_colors, "[plane]", color)
	P.color = color

/**
 * Used for secondary screens
 */
/datum/plane_holder/secondary
	/// secondary screen id
	var/screen_id

/datum/plane_holder/secondary/New(screen_id)
	src.screen_id = screen_id

/datum/plane_holder/secondary/GetScreenLoc(atom/movable/screen/plane_master/P)
	return "[screen_id]:[..()]"
