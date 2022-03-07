/atom/movable
	/// The mimic (if any) that's *directly* copying us.
	var/tmp/atom/movable/openspace/mimic/bound_overlay
	/// Movable-level Z-Mimic flags. This uses ZMM_* flags, not ZM_* flags.
	var/zmm_flags = NONE

/atom/movable/doMove(atom/destination)
	. = ..()
	if (. && bound_overlay)
		// The overlay will handle cleaning itself up on non-openspace turfs.
		if (isturf(destination))
			bound_overlay.forceMove(get_step_multiz(src, UP))
			if (dir != bound_overlay.dir)
				bound_overlay.setDir(dir)
		else	// Not a turf, so we need to destroy immediately instead of waiting for the destruction timer to proc.
			qdel(bound_overlay)

/atom/movable/Move()
	. = ..()
	if (. && bound_overlay)
		bound_overlay.forceMove(get_step_multiz(src, UP))
		if (bound_overlay.dir != dir)
			bound_overlay.setDir(dir)

/atom/movable/setDir(newdir)
	. = ..()
	if (. && bound_overlay)
		bound_overlay.setDir(newdir)

/atom/movable/update_above()
	if (!bound_overlay || !isturf(loc))
		return

	var/turf/T = loc

	if (TURF_IS_MIMICKING(T.zm_above))
		SSzcopy.queued_overlays += bound_overlay
		bound_overlay.queued += 1
	else
		qdel(bound_overlay)

// Grabs a list of every openspace object that's directly or indirectly mimicking this object. Returns an empty list if none found.
/atom/movable/proc/get_above_oo()
	. = list()
	var/atom/movable/curr = src
	while (curr.bound_overlay)
		. += curr.bound_overlay
		curr = curr.bound_overlay

// -- Openspace movables --

/atom/movable/openspace
	name = ""
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/openspace/can_fall()
	return FALSE

// -- MULTIPLIER / SHADOWER --

// Holder object used for dimming openspaces & copying lighting of below turf.
/atom/movable/openspace/multiplier
	name = "openspace multiplier"
	desc = "You shouldn't see this."
	icon = 'icons/effects/lighting_overlay.dmi'
	icon_state = "dark"
	plane = OPENTURF_MAX_PLANE
	layer = MIMICED_LIGHTING_LAYER
	blend_mode = BLEND_MULTIPLY
	color = SHADOWER_DARKENING_COLOR

/atom/movable/openspace/multiplier/Destroy()
	var/turf/myturf = loc
	if (istype(myturf))
		myturf.shadower = null

	return ..()

/atom/movable/openspace/multiplier/proc/copy_lighting(atom/movable/lighting_object/LO)
	appearance = LO
	layer = MIMICED_LIGHTING_LAYER
	plane = OPENTURF_MAX_PLANE
	invisibility = 0

	var/list/old = color
	if(islist(old))
		for(var/i in 1 to old.len)
			old[i] *= SHADOWER_DARKENING_FACTOR
		color = old
	else
		color = SHADOWER_DARKENING_COLOR

	update_above()


// -- OPENSPACE MIMIC --

// Object used to hold a mimiced atom's appearance.
/atom/movable/openspace/mimic
	plane = OPENTURF_MAX_PLANE
	var/atom/movable/associated_atom
	var/depth
	var/queued = 0
	var/destruction_timer
	var/mimiced_type
	var/original_z
	var/override_depth

/atom/movable/openspace/mimic/New()
	flags_1 |= INITIALIZED_1
	SSzcopy.openspace_overlays += 1

/atom/movable/openspace/mimic/Destroy()
	SSzcopy.openspace_overlays -= 1
	queued = 0

	if (associated_atom)
		associated_atom.bound_overlay = null
		associated_atom = null

	if (destruction_timer)
		deltimer(destruction_timer)

	return ..()

/atom/movable/openspace/mimic/attackby(obj/item/W, mob/user)
	to_chat(user, span_notice("\The [src] is too far away."))

/atom/movable/openspace/mimic/attack_hand(mob/user)
	to_chat(user, span_notice("You cannot reach \the [src] from here."))

/atom/movable/openspace/mimic/examine(...)
	SHOULD_CALL_PARENT(FALSE)
	. = associated_atom.examine(arglist(args))	// just pass all the args to the copied atom

/atom/movable/openspace/mimic/forceMove(turf/dest)
	. = ..()
	if (TURF_IS_MIMICKING(dest))
		if (destruction_timer)
			deltimer(destruction_timer)
			destruction_timer = null
			invisibility = 0
	else if (!destruction_timer)
		invisibility = INVISIBILITY_ABSTRACT
		destruction_timer = addtimer(CALLBACK(GLOBAL_PROC, /proc/qdel, src), 10 SECONDS, TIMER_STOPPABLE)

// Called when the turf we're on is deleted/changed.
/atom/movable/openspace/mimic/proc/owning_turf_changed()
	if (!destruction_timer)
		destruction_timer = addtimer(CALLBACK(GLOBAL_PROC, /proc/qdel, src), 10 SECONDS, TIMER_STOPPABLE)
		invisibility = INVISIBILITY_ABSTRACT

// -- TURF PROXY --

// This thing holds the mimic appearance for non-OVERWRITE turfs.
/atom/movable/openspace/turf_proxy
	plane = OPENTURF_MAX_PLANE
	mouse_opacity = 0
	zm_flags = ZMM_IGNORE  // Only one of these should ever be visible at a time, the mimic logic will handle that.

// experimental - directly pass clicks
/atom/movable/openspace/turf_proxy/Click(...)
	return loc.Click(arglist(args))

// /atom/movable/openspace/turf_proxy/attackby(obj/item/W, mob/user)
// 	loc.attackby(W, user)

// /atom/movable/openspace/turf_proxy/attack_hand(mob/user as mob)
// 	loc.attack_hand(user)

// /atom/movable/openspace/turf_proxy/attack_generic(mob/user as mob)
// 	loc.attack_generic(user)

/atom/movable/openspace/turf_proxy/examine(...)
	SHOULD_CALL_PARENT(FALSE)
	. = loc.examine(arglist(args))


// -- TURF MIMIC --

// A type for copying non-overwrite turfs' self-appearance.
/atom/movable/openspace/turf_mimic
	plane = OPENTURF_MAX_PLANE	// These *should* only ever be at the top?
	mouse_opacity = 0
	var/turf/delegate

/atom/movable/openspace/turf_mimic/Initialize(mapload, ...)
	. = ..()
	ASSERT(isturf(loc))
	delegate = loc:zm_below

/atom/movable/openspace/turf_mimic/attackby(obj/item/W, mob/user)
	loc.attackby(W, user)

/atom/movable/openspace/turf_mimic/attack_hand(mob/user as mob)
	to_chat(user, span_notice("You cannot reach \the [src] from here."))

/atom/movable/openspace/turf_mimic/attack_generic(mob/user as mob)
	to_chat(user, span_notice("You cannot reach \the [src] from here."))

/atom/movable/openspace/turf_mimic/examine(...)
	SHOULD_CALL_PARENT(FALSE)
	. = delegate.examine(arglist(args))
