// Includes turf graphics.
#define OPENTURF_MAX_PLANE -70
#define OPENTURF_MAX_DEPTH 10		// The maxiumum number of planes deep we'll go before we just dump everything on the same plane.
#define SHADOWER_DARKENING_FACTOR 0.6	// The multiplication factor for openturf shadower darkness. Lighting will be multiplied by this.
#define SHADOWER_DARKENING_COLOR "#999999"	// The above, but as an RGB string for lighting-less turfs.

SUBSYSTEM_DEF(zcopy)
	name = "Z-Copy"
	wait = 1
	init_order = INIT_ORDER_ZCOPY
	priority = FIRE_PRIORITY_ZCOPY
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/queued_turfs = list()
	var/qt_idex = 1
	var/list/queued_overlays = list()
	var/qo_idex = 14

	var/openspace_overlays = 0
	var/openspace_turfs = 0

	var/multiqueue_skips_turf = 0
	var/multiqueue_skips_object = 0

	// Caches for fixup.
	var/list/fixup_cache = list()
	var/list/fixup_known_good = list()

	// Fixup stats.
	var/fixup_miss = 0
	var/fixup_noop = 0
	var/fixup_hit = 0

/datum/controller/subsystem/zcopy/Initialize(timeofday)
	// Flush the queue.
	fire(FALSE, TRUE)
	return ..()

// for admin proc-call
/datum/controller/subsystem/zcopy/proc/update_all()
	disable()
	subsystem_log("update_all() invoked.")

	var/turf/T 	// putting the declaration up here totally speeds it up, right?
	var/num_upd = 0
	var/num_del = 0
	var/num_amupd = 0
	for (var/atom/A in world)
		if (isturf(A))
			T = A
			if (T.zm_flags & ZM_MIMIC_BELOW)
				T.update_mimic()
				num_upd += 1

		else if (istype(A, /atom/movable/openspace/mimic))
			var/turf/Tloc = A.loc
			if (TURF_IS_MIMICKING(Tloc))
				Tloc.update_mimic()
				num_amupd += 1
			else
				qdel(A)
				num_del += 1

		CHECK_TICK

	subsystem_log("[num_upd + num_amupd] turf updates queued ([num_upd] direct, [num_amupd] indirect), [num_del] orphans destroyed.")

	enable()

// for admin proc-call
/datum/controller/subsystem/zcopy/proc/hard_reset()
	disable()
	subsystem_log("hard_reset() invoked.")
	var/num_deleted = 0
	var/num_turfs = 0

	var/turf/T
	for (var/atom/A in world)
		if (isturf(A))
			T = A
			if (T.zm_flags & ZM_MIMIC_BELOW)
				T.update_mimic()
				num_turfs += 1

		else if (istype(A, /atom/movable/openspace/mimic))
			qdel(A)
			num_deleted += 1

		CHECK_TICK

	subsystem_log("deleted [num_deleted] overlays, and queued [num_turfs] turfs for update.")

	enable()

/datum/controller/subsystem/zcopy/stat_entry()
	..("Q:{T:[queued_turfs.len - (qt_idex - 1)]|O:[queued_overlays.len - (qo_idex - 1)]}\n\tT:{T:[openspace_turfs]|O:[openspace_overlays]}\n\tSk:{T:[multiqueue_skips_turf]|O:[multiqueue_skips_object]}")

/datum/controller/subsystem/zcopy/StartLoadingMap()
	suspend()

/datum/controller/subsystem/zcopy/StopLoadingMap()
	wake()

/datum/controller/subsystem/zcopy/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		qt_idex = 1
		qo_idex = 1

	MC_SPLIT_TICK_INIT(2)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	var/list/curr_turfs = queued_turfs
	var/list/curr_ov = queued_overlays

	// ensure stack lookup works
	SSmapping.GetZStack()

	while (qt_idex <= curr_turfs.len)
		var/turf/T = curr_turfs[qt_idex]
		curr_turfs[qt_idex] = null
		qt_idex += 1

		if (!isturf(T) || !(T.zm_flags & ZM_MIMIC_BELOW) || !T.z_queued)
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// If we're not at our most recent queue position, don't bother -- we're updating again later anyways.
		if (T.z_queued > 1)
			T.z_queued -= 1
			multiqueue_skips_turf += 1
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// Z-Turf on the bottom-most level, just fake-copy space.
		// If this is ever true, that turf should always pass this condition, so don't bother cleaning up beyond the Destroy() hook.
		if (!T.zm_below)	// Z-turf on the bottom-most level, just fake-copy space.
			if (T.zm_flags & ZM_MIMIC_OVERWRITE)
				T.icon = 'icons/turf/space.dmi'
				T.icon_state = SPACE_ICON_STATE_DIRECT(T.x, T.y, T.z)
				T.plane = PLANE_SPACE
				T.layer = SPACE_LAYER
				T.name = initial(T.name)
				T.desc = initial(T.desc)
				T.gender = initial(T.gender)
			else
				// Some openturfs have icons, so we can't overwrite their appearance.
				if (!T.mimic_underlay)
					T.mimic_underlay = new(T)
				var/atom/movable/openspace/turf_proxy/TO = T.mimic_underlay
				TO.icon = 'icons/turf/space.dmi'
				TO.icon_state = SPACE_ICON_STATE_DIRECT(T.x, T.y, T.z)
				TO.plane = PLANE_SPACE
				TO.layer = SPACE_LAYER
				TO.name = initial(T.name)
				TO.desc = initial(T.desc)
				TO.gender = initial(T.gender)
				TO.mouse_opacity = initial(T.mouse_opacity)

			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		if (!T.shadower)	// If we don't have a shadower yet, something has gone horribly wrong.
			stack_trace("Turf [T] at [T.x],[T.y],[T.z] was queued, but had no shadower.")
			continue

		T.z_generation += 1

		// Get the bottom-most turf, the one we want to mimic.
		var/turf/Td = T
		while (Td.zm_below)
			Td = Td.zm_below

		// Depth must be the depth of the *visible* turf, not self.
		var/turf_depth = T.z_depth = SSmapping.z_stack_lookup[T.z].Find(T.z)

		var/t_target = OPENTURF_MAX_PLANE - turf_depth	// This is where the turf (but not the copied atoms) gets put.

		// Handle space parallax & starlight.
		if (T.zm_below.z_eventually_space)
			T.z_eventually_space = TRUE
			t_target = PLANE_SPACE

		if (T.zm_flags & ZM_MIMIC_OVERWRITE)
			// This openturf doesn't care about its icon, so we can just overwrite it.
			if (T.zm_below.mimic_proxy)
				QDEL_NULL(T.zm_below.mimic_proxy)
			T.appearance = T.zm_below
			T.name = initial(T.name)
			T.desc = initial(T.desc)
			T.gender = initial(T.gender)
			T.opacity = FALSE
			T.plane = t_target
		else
			// Some openturfs have icons, so we can't overwrite their appearance.
			if (!T.zm_below.mimic_proxy)
				T.zm_below.mimic_proxy = new(T)
			var/atom/movable/openspace/turf_proxy/TO = T.zm_below.mimic_proxy
			TO.appearance = Td
			TO.name = T.name
			TO.gender = T.gender	// Need to grab this too so PLURAL works properly in examine.
			TO.opacity = FALSE
			TO.plane = t_target
			TO.mouse_opacity = initial(TO.mouse_opacity)

		// T.queue_ao(T.ao_neighbors_mimic == null)	// If ao_neighbors hasn't been set yet, we need to do a rebuild

		// Explicitly copy turf delegates so they show up properly on below levels.
		//   I think it's possible to get this to work without discrete delegate copy objects, but I'd rather this just work.
		if ((T.zm_below.zm_flags & (ZM_MIMIC_BELOW|ZM_MIMIC_OVERWRITE)) == ZM_MIMIC_BELOW)
			// Below is a delegate, gotta explicitly copy it for recursive copy.
			if (!T.zm_below.mimic_above_copy)
				T.zm_below.mimic_above_copy = new(T)
			var/atom/movable/openspace/turf_mimic/DC = T.zm_below.mimic_above_copy
			DC.appearance = T.zm_below
			DC.mouse_opacity = initial(DC.mouse_opacity)
			DC.plane = OPENTURF_MAX_PLANE

		else if (T.zm_below.mimic_above_copy)
			QDEL_NULL(T.zm_below.mimic_above_copy)

		// Handle below atoms.

		// Add everything below us to the update queue.
		for (var/thing in T.zm_below)
			var/atom/movable/object = thing
			if (QDELETED(object) || (object.zmm_flags & ZMM_IGNORE) || object.loc != T.zm_below || object.invisibility == INVISIBILITY_ABSTRACT)
				// Don't queue deleted stuff, stuff that's not visible, blacklisted stuff, or stuff that's centered on another tile but intersects ours.
				continue

			// Special case: these are merged into the shadower to reduce memory usage.
			if (object.type == /atom/movable/lighting_object)
				T.shadower.copy_lighting(object)
				continue

			if (!object.bound_overlay)	// Generate a new overlay if the atom doesn't already have one.
				object.bound_overlay = new(T)
				object.bound_overlay.associated_atom = object

			var/override_depth
			var/original_type = object.type
			var/original_z = object.z
			switch (object.type)
				if (/atom/movable/openspace/mimic)
					var/atom/movable/openspace/mimic/OOO = object
					original_type = OOO.mimiced_type
					override_depth = OOO.override_depth
					original_z = OOO.original_z

				if (/atom/movable/openspace/turf_proxy, /atom/movable/openspace/turf_mimic)
					// If we're a turf overlay (the mimic for a non-OVERWRITE turf), we need to make sure copies of us respect space parallax too
					if (T.z_eventually_space)
						// Yes, this is an awful hack; I don't want to add yet another override_* var.
						override_depth = OPENTURF_MAX_PLANE - PLANE_SPACE

			var/atom/movable/openspace/mimic/OO = object.bound_overlay

			// If the OO was queued for destruction but was claimed by another OT, stop the destruction timer.
			if (OO.destruction_timer)
				deltimer(OO.destruction_timer)
				OO.destruction_timer = null

			OO.depth = override_depth || min(SSmapping.z_stack_lookup[T.z].Find(T.z), OPENTURF_MAX_DEPTH)

			// These types need to be pushed a layer down for bigturfs to function correctly.
			switch (original_type)
				if (/atom/movable/openspace/multiplier, /atom/movable/openspace/turf_mimic, /atom/movable/openspace/turf_proxy)
					if (OO.depth < OPENTURF_MAX_DEPTH)
						OO.depth += 1

			OO.mimiced_type = original_type
			OO.override_depth = override_depth
			OO.original_z = original_z

			// Multi-queue to maintain ordering of updates to these
			//   queueing it multiple times will result in only the most recent
			//   actually processing.
			OO.queued += 1
			queued_overlays += OO

		T.z_queued -= 1
		if (T.zm_above)
			T.zm_above.update_mimic()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (qt_idex > 1)
		curr_turfs.Cut(1, qt_idex)
		qt_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (qo_idex <= curr_ov.len)
		var/atom/movable/openspace/mimic/OO = curr_ov[qo_idex]
		curr_ov[qo_idex] = null
		qo_idex += 1

		if (QDELETED(OO) || !OO.queued)
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		if (QDELETED(OO.associated_atom))	// This shouldn't happen, but just in-case.
			qdel(OO)

			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// Don't update unless we're at the most recent queue occurrence.
		if (OO.queued > 1)
			OO.queued -= 1
			multiqueue_skips_object += 1
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// Actually update the overlay.
		if (OO.dir != OO.associated_atom.dir)
			OO.setDir(OO.associated_atom.dir)

		OO.appearance = OO.associated_atom
		OO.zmm_flags = OO.associated_atom.zmm_flags
		OO.plane = OPENTURF_MAX_PLANE - OO.depth

		OO.opacity = FALSE
		OO.queued = 0

		// If an atom has explicit plane sets on its overlays/underlays, we need to replace the appearance so they can be mangled to work with our planing.
		if (OO.zmm_flags & ZMM_MANGLE_PLANES)
			var/new_appearance = fixup_appearance_planes(OO.appearance)
			if (new_appearance)
				OO.appearance = new_appearance

		if (OO.bound_overlay)	// If we have a bound overlay, queue it too.
			OO.update_above()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (qo_idex > 1)
		curr_ov.Cut(1, qo_idex)
		qo_idex = 1

// Recurse: for self, check if planes are invalid, if yes; return fixed appearance
// For each of overlay,underlay, call fixup_appearance_planes; if it returns a new appearance, replace self

/// Generate a new appearance from `appearance` with planes mangled to work with Z-Mimic. Do not pass a depth.
/datum/controller/subsystem/zcopy/proc/fixup_appearance_planes(appearance, depth = 0)
	if (fixup_known_good[appearance])
		fixup_hit += 1
		return null
	if (fixup_cache[appearance])
		fixup_hit += 1
		return fixup_cache[appearance]

	// If you have more than 4 layers of overlays within overlays, I dunno what to say.
	if (depth > 4)
		var/icon_name = "[appearance:icon]"
		WARNING("Fixup of appearance with icon [icon_name || "<unknown file>"] exceeded maximum recursion limit, bailing")
		return null

	var/plane_needs_fix = FALSE

	// Don't fixup the root object's plane.
	if (depth > 0)
		switch (appearance:plane)
			if (GAME_PLANE, FLOAT_PLANE)
				// fine
			else
				plane_needs_fix = TRUE

	// Scan & fix overlays
	var/list/fixed_overlays
	if (appearance:overlays:len)
		var/mutated = FALSE
		var/fixed_appearance
		for (var/i in 1 to appearance:overlays:len)
			if ((fixed_appearance = .(appearance:overlays[i], depth + 1)))
				mutated = TRUE
				if (!fixed_overlays)
					fixed_overlays = new(appearance:overlays.len)
				fixed_overlays[i] = fixed_appearance

		if (mutated)
			for (var/i in 1 to fixed_overlays.len)
				if (fixed_overlays[i] == null)
					fixed_overlays[i] = appearance:overlays[i]

	// Scan & fix underlays
	var/list/fixed_underlays
	if (appearance:underlays:len)
		var/mutated = FALSE
		var/fixed_appearance
		for (var/i in 1 to appearance:underlays:len)
			if ((fixed_appearance = .(appearance:underlays[i], depth + 1)))
				mutated = TRUE
				if (!fixed_underlays)
					fixed_underlays = new(appearance:underlays.len)
				fixed_underlays[i] = fixed_appearance

		if (mutated)
			for (var/i in 1 to fixed_overlays.len)
				if (fixed_underlays[i] == null)
					fixed_underlays[i] = appearance:underlays[i]

	// If we did nothing (no violations), don't bother creating a new appearance
	if (!plane_needs_fix && !fixed_overlays && !fixed_underlays)
		fixup_noop += 1
		fixup_known_good[appearance] = TRUE
		return null

	fixup_miss += 1

	var/mutable_appearance/MA = new(appearance)
	if (plane_needs_fix)
		MA.plane = depth == 0 ? GAME_PLANE : FLOAT_PLANE
		MA.layer = FLY_LAYER	// probably fine

	if (fixed_overlays)
		MA.overlays = fixed_overlays

	if (fixed_underlays)
		MA.underlays = fixed_underlays

	fixup_cache[appearance] = MA.appearance

	return MA

#define FMT_DEPTH(X) (X == null ? "(null)" : X)

// This is a dummy object used so overlays can be shown in the analyzer.
/atom/movable/openspace/debug

/client/proc/analyze_openturf(turf/T)
	set name = "Analyze Openturf"
	set desc = "Show the layering of an openturf and everything it's mimicking."
	set category = "Debug"

	if (!check_rights(R_DEBUG))
		return

	var/is_above_space = T.is_above_space()
	var/list/out = list(
		"<head><meta charset='utf-8'/></head><body>",
		"<h1>Analysis of [T] at [T.x],[T.y],[T.z]</h1>",
		"<b>Queue occurrences:</b> [T.z_queued]",
		"<b>Above space:</b> Apparent [T.z_eventually_space ? "Yes" : "No"], Actual [is_above_space ? "Yes" : "No"] - [T.z_eventually_space == is_above_space ? "<font color='green'>OK</font>" : "<font color='red'>MISMATCH</font>"]",
		"<b>Z Flags</b>: [english_list(bitfield2list(T.zm_flags, GLOB.bitfields["zm_flags"]), "(none)")]",
		"<b>Has Shadower:</b> [T.shadower ? "Yes" : "No"]",
		"<b>Has turf proxy:</b> [T.mimic_proxy ? "Yes" : "No"]",
		"<b>Has above copy:</b> [T.mimic_above_copy ? "Yes" : "No"]",
		"<b>Has mimic underlay:</b> [T.mimic_underlay ? "Yes" : "No"]",
		"<b>Below:</b> [!T.zm_below ? "(nothing)" : "[T.zm_below] at [T.zm_below.x],[T.zm_below.y],[T.zm_below.z]"]",
		"<b>Depth:</b> [FMT_DEPTH(T.z_depth)] [T.z_depth == OPENTURF_MAX_DEPTH ? "(max)" : ""]",
		"<b>Generation:</b> [T.z_generation]",
		"<ul>"
	)

	var/list/found_oo = list(T)
	for (var/atom/movable/openspace/O in T)
		found_oo += O

	if (T.shadower.overlays.len)
		for (var/overlay in T.shadower.overlays)
			var/atom/movable/openspace/debug/D = new
			D.appearance = overlay
			if (D.plane < -10000)	// FLOAT_PLANE
				D.plane = T.shadower.plane
			found_oo += D

	sortTim(found_oo, /proc/cmp_atom_layer_asc)

	var/list/atoms_list_list = list()
	for (var/thing in found_oo)
		var/atom/A = thing
		var/pl = "[A.plane]"
		LAZYINITLIST(atoms_list_list[pl])
		atoms_list_list[pl] += A

	if (atoms_list_list["0"])
		out += "<strong>Non-Z</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list["0"], out, T)

		atoms_list_list -= "0"

	for (var/d in 0 to OPENTURF_MAX_DEPTH)
		var/pl = OPENTURF_MAX_PLANE - d
		if (!atoms_list_list["[pl]"])
			out += "<strong>Depth [d], plane [pl] — empty</strong>"
			continue

		out += "<strong>Depth [d], plane [pl]</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list["[pl]"], out, T)

		// Flush the list so we can find orphans.
		atoms_list_list -= "[pl]"

	if (atoms_list_list["[PLANE_SPACE]"])	// Space parallax plane
		out += "<strong>Space parallax plane</strong> ([PLANE_SPACE])"
		SSzcopy.debug_fmt_planelist(atoms_list_list["[PLANE_SPACE]"], out, T)
		atoms_list_list -= "[PLANE_SPACE]"

	for (var/key in atoms_list_list)
		out += "<strong style='color: red;'>Unknown plane: [key]</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list[key], out, T)

		out += "<hr/>"

	out += "</body>"

	usr << browse(out.Join("<br>"), "size=980x580;window=openturfanalysis-\ref[T]")

// Yes, I know this proc is a bit of a mess. Feel free to clean it up.
/datum/controller/subsystem/zcopy/proc/debug_fmt_thing(atom/A, list/out, turf/original)
	if (istype(A, /atom/movable/openspace/mimic))
		var/atom/movable/openspace/mimic/OO = A
		var/atom/movable/AA = OO.associated_atom
		var/copied_type = AA.type == OO.mimiced_type ? "[AA.type] \[direct\]" : "[AA.type], eventually [OO.mimiced_type]"
		return "<li>\icon[A] <b>\[Mimic\]</b> plane [A.plane], layer [A.layer], depth [FMT_DEPTH(OO.depth)], associated Z-level [AA.z] - [OO.type] copying [AA] ([copied_type])</li>"
	else if (istype(A, /atom/movable/openspace/turf_mimic))
		var/atom/movable/openspace/turf_mimic/DC = A
		return "<li>\icon[A] <b>\[Turf Mimic\]</b> plane [A.plane], layer [A.layer], Z-level [A.z], delegate of \icon[DC.delegate] [DC.delegate] ([DC.delegate.type])</li>"
	else if (isturf(A))
		if (A == original)
			return "<li>\icon[A] <b>\[Turf\]</b> plane [A.plane], layer [A.layer], depth [FMT_DEPTH(A:z_depth)], Z-level [A.z] - [A] ([A.type]) - <font color='green'>SELF</font></li>"
		else	// foreign turfs - not visible here, but sometimes good for figuring out layering -- showing these is currently not enabled
			return "<li>\icon[A] <b>\[Turf\]</b> <em><font color='#646464'>plane [A.plane], layer [A.layer], depth [FMT_DEPTH(A:z_depth)], Z-level [A.z] - [A] ([A.type])</font></em> - <font color='red'>FOREIGN</font></em></li>"
	else if (A.type == /atom/movable/openspace/multiplier)
		return "<li>\icon[A] <b>\[Shadower\]</b> plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"
	else if (A.type == /atom/movable/openspace/debug)	// These are fake objects that exist just to show the shadower's overlays in this list.
		return "<li>\icon[A] <b>\[Shadower True Overlay\]</b> plane [A.plane], layer [A.layer] - <font color='grey'>VIRTUAL</font></li>"
	else if (A.type == /atom/movable/openspace/turf_proxy)
		return "<li>\icon[A] <b>\[Turf Proxy\]</b> plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"
	else
		return "<li>\icon[A] <b>\[?\]</b>  plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"

/datum/controller/subsystem/zcopy/proc/debug_fmt_planelist(list/things, list/out, turf/original)
	if (things)
		out += "<ul>"
		for (var/thing in things)
			out += debug_fmt_thing(thing, out, original)
		out += "</ul>"
	else
		out += "<em>No atoms.</em>"

#undef FMT_DEPTH
