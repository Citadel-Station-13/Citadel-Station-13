GLOBAL_VAR_INIT(unroofed_open_overlay, image('icons/modules/multiz/turf_overlay.dmi', "open"))
GLOBAL_VAR_INIT(unroofed_lattice_overlay, image('icons/modules/multiz/turf_overlay.dmi', "lattice"))
GLOBAL_VAR_INIT(unroofed_catwalk_overlay, image('icons/modules/multiz/turf_overlay.dmi', "catwalk"))

/turf
	/// __DEFINES/flags/turfs.dm
	var/z_flags = Z_AIR_UP | Z_OPEN_UP

/**
 * Used for things like weather
 */
/turf/proc/IsRoofed()

/**
 * Gets the turf above this one if we're multiz
 */
/turf/proc/Above()
	var/target = SSmapping.multiz_lookup_up[z]
	return target && locate(x, y, target)

/**
 * Gets the turf below this one if we're multiz
 */
/turf/proc/Below()
	var/target = SSmapping.multiz_lookup_down[z]
	return target && locate(x, y, target)

/turf/proc/UpdateMultiZ()
	SEND_SIGNAL(src, COMSIG_TURF_UPDATE_MULTIZ)

	#warn check logic
	// DOWNWARDS
	// First, check if we're the bottom level. If we're the bottom level and we're openspace, we need to teardown to the zlevel's baseturf
	// If the zlevels' baseturf IS openspace for some reason, we tear down to space
	var/intact = TRUE
	var/turf/below = Below()
	if(!below)
		intact = FALSE
		if(istype(src, /turf/open/openspace))
			var/type = SSmapping.GetBaseturf(z)
			ChangeTurf(ispath(type, /turf/open/openspace)? /turf/open/space : type)
			// return, as changeturf calls updatemultiz.
			return

	// Then, if we're actually still openspace, we need to update ZMimic.
	if(intact)
		update_mimic()

	// UPWARDS
	// First, check if we're roofed, make an overlay if not
	update_overlays()

/turf/update_overlays()
	. = ..()
	cut_overlay(list(
		GLOB.unroofed_open_overlay,
		GLOB.unroofed_lattice_overlay,
		GLOB.unroofed_catwalk_overlay
	))
	var/turf/T = Above()
	if(!T || !(T.z_flags & Z_CONSIDERED_OPEN))
		return
	if(T.has_catwalk())
		add_overlay(GLOB.unroofed_catwalk_overlay)
	else if(T.has_lattice())
		add_overlay(GLOB.unroofed_lattice_overlay)
	else
		add_overlay(GLOB.unroofed_open_overlay)

/turf/examine(mob/user)
	. = ..()
	#warn multiz examine ,hint that ceiling can be patched with rods/floor if flags are right

/**
 * WARNING: This proc is unique. Read the doc here, especially the return value.
 * Check if an atom can move into us from either above or below
 *
 * We don't use an unified CanZPass() because our codebase does the Funny of allowing logical multiz linkages that aren't actually +1 or -1 zlevel
 * So, it's actually going to be faster doing "snowflakey" in/out calls rather than an unified call that works like CanPass().
 *
 * @param
 * AM - moving atom
 * direction - Direction it's **coming from** (e.g. if it's above us, it'll be **UP**).
 * source - turf it's coming from
 *
 * @return
 * The atom that's blocking. Returns NULL if there's no obstruction.
 */
/turf/proc/zPassInObstruction(atom/movable/A, direction, turf/source)
	if(!(z_flags & (direction == UP? Z_OPEN_UP : Z_OPEN_DOWN)))
		return src
	for(var/atom/movable/AM as anything in contents)
		if(!AM.zPassIn(A, direction, source))
			return AM

/**
 * WARNING: This proc is unique. Read the doc here, especially the return value.
 * Check if an atom can move out of us to either above or below
 *
 * We don't use an unified CanZPass() because our codebase does the Funny of allowing logical multiz linkages that aren't actually +1 or -1 zlevel
 * So, it's actually going to be faster doing "snowflakey" in/out calls rather than an unified call that works like CanPass().
 *
 * @param
 * AM - moving atom
 * direction - Direction it's **going to** (e.g. if it's going through the roof, it'll be **UP**).
 * source - turf it's going to
 *
 * @return
 * The atom that's blocking. Returns NULL if there's no obstruction.
 */
/turf/proc/zPassOutObstruction(atom/movable/A, direction, turf/destination)
	if(!(z_flags & (direction == UP? Z_OPEN_UP : Z_OPEN_DOWN)))
		return src
	for(var/atom/movable/AM as anything in contents)
		if(!AM.zPassOut(A, direction, destination))
			return AM

/turf/CanZPass(atom/movable/AM, direction)
	ASSERT(direction == UP || direction == DOWN)
	var/turf/other = direction == UP? Above() : Below()
	if(!other)
		return FALSE
	return zPassOut(AM, direction, other) && other.zPassIn(AM, direction, src)

/turf/zPassIn(atom/movable/A, direction, turf/source)
	return isnull(zPassInObstruction(A, direction, source))

/turf/zPassOut(atom/movable/A, direction, turf/destination)
	return isnull(zPassOutObstruction(A, direction, source))

/turf/ZImpacted(atom/movable/victim, levels, fall_flags)
	. = ..()
	if(fall_flags & FALL_SILENT)
		return
	if(isitem(victim))
		victim.visible_message(
			span_warning("\the [victim] falls onto \the [src] from above!"),
			null,
			span_warning("You hear something fall onto the floor.")
		)
	else
		victim.visible_message(
			span_danger("\the [victim] crashes into \the [src]!"),
			span_danger("You crash into \the [src]!"),
			span_warning("You hear a loud thud.")
		)
