/turf
	var/dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	luminosity           = 1

	var/tmp/lighting_corners_initialised = FALSE

	var/tmp/list/datum/light_source/affecting_lights       // List of light sources affecting this turf.
	var/tmp/atom/movable/lighting_overlay/lighting_overlay // Our lighting overlay.
	var/tmp/list/datum/lighting_corner/corners
	var/tmp/has_opaque_atom = FALSE // Not to be confused with opacity, this will be TRUE if there's any opaque atom on the tile.

/turf/New()
	. = ..()

	if (opacity)
		has_opaque_atom = TRUE

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	for (var/datum/light_source/L in affecting_lights)
		L.vis_update()

/turf/proc/lighting_clear_overlay()
	if (lighting_overlay)
		qdel(lighting_overlay, TRUE)
		lighting_overlay = null

	for (var/datum/lighting_corner/C in corners)
		C.update_active()

	for(var/turf/open/space/S in RANGE_TURFS(1,src)) //RANGE_TURFS is in code\__HELPERS\game.dm
		S.update_starlight()

// Builds a lighting overlay for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if (lighting_overlay)
		return

	var/area/A = loc
	if (IS_DYNAMIC_LIGHTING(A))
		if (!lighting_corners_initialised)
			generate_missing_corners()

		PoolOrNew(/atom/movable/lighting_overlay, src)

		for (var/datum/lighting_corner/C in corners)
			if (!C.active) // We would activate the corner, calculate the lighting for it.
				for (var/L in C.affecting)
					var/datum/light_source/S = L
					S.recalc_corner(C)

				C.active = TRUE

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(var/minlum = 0, var/maxlum = 1)
	if (!lighting_overlay)
		return 0.5

	var/totallums = 0
	for (var/datum/lighting_corner/L in corners)
		totallums += L.lum_r + L.lum_b + L.lum_g

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = (totallums - minlum) / (maxlum - minlum)

	return CLAMP01(totallums)

// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
	has_opaque_atom = FALSE
	for (var/atom/A in src.contents + src) // Loop through every movable atom on our tile PLUS ourselves (we matter too...)
		if (A.opacity)
			has_opaque_atom = TRUE

// If an opaque movable atom moves around we need to potentially update visibility.
/turf/Entered(var/atom/movable/Obj, var/atom/OldLoc)
	. = ..()

	if (Obj && Obj.opacity)
		has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
		reconsider_lights()

/turf/Exited(var/atom/movable/Obj, var/atom/newloc)
	. = ..()

	if (Obj && Obj.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

/turf/change_area(var/area/old_area, var/area/new_area)
	if (IS_DYNAMIC_LIGHTING(new_area) != IS_DYNAMIC_LIGHTING(old_area))
		if (IS_DYNAMIC_LIGHTING(new_area))
			lighting_build_overlay()

		else
			lighting_clear_overlay()

/turf/proc/get_corners()
	if (has_opaque_atom)
		return null // Since this proc gets used in a for loop, null won't be looped though.

	return corners

/turf/proc/generate_missing_corners()
	lighting_corners_initialised = TRUE
	if (!corners)
		corners = list(null, null, null, null)

	for (var/i = 1 to 4)
		if (corners[i]) // Already have a corner on this direction.
			continue

		corners[i] = new/datum/lighting_corner(src, LIGHTING_CORNER_DIAGONAL[i])

/turf/ChangeTurf(path)
	if(!path || (!use_preloader && path == type)) //Sucks this is here but it would cause problems otherwise.
		return ..()

	if (!lighting_corners_initialised)
		if (!corners)
			corners = list(null, null, null, null)

		for (var/i = 1 to 4)
			if (corners[i]) // Already have a corner on this direction.
				continue

			corners[i] = new/datum/lighting_corner(src, LIGHTING_CORNER_DIAGONAL[i])


	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/old_corners = corners

	for(var/obj/effect/decal/cleanable/decal in src.contents)
		qdel(decal)

	. = ..() //At this point the turf has changed

	lighting_corners_initialised = TRUE
	recalc_atom_opacity()
	lighting_overlay = old_lighting_overlay
	affecting_lights = old_affecting_lights
	corners = old_corners
	if((old_opacity != opacity) || (dynamic_lighting != old_dynamic_lighting))
		reconsider_lights()
	if(dynamic_lighting != old_dynamic_lighting)
		if(IS_DYNAMIC_LIGHTING(src))
			lighting_build_overlay()
		else
			lighting_clear_overlay()
