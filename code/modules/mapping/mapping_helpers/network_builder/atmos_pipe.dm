#define NO_KNOT 0
#define KNOT_AUTO 1
#define KNOT_FORCED 2

/* Automatically places pipes on init based on any pipes connecting to it and adjacent helpers. Only supports cardinals.
 * Conflicts with ANY PIPE ON ITS LAYER, as well as atmos network build helpers on the same layer, as well as any pipe on all layers. Do those manually.
*/
/obj/effect/network_builder/atmos_pipe
	name = "atmos pipe autobuilder"
	icon_state = "atmospipebuilder"

	/// Layer to put our pipes on
	var/pipe_layer = PIPING_LAYER_DEFAULT

	/// Color to set our pipes to
	var/pipe_color

	/// Whether or not pipes we make are visible
	var/visible_pipes = FALSE

	color = null

/obj/effect/network_builder/atmos_pipe/check_duplicates()
	for(var/obj/effect/network_builder/atmos_pipe/other in loc)
		if(other.pipe_layer == pipe_layer)
			return other
	for(var/obj/machinery/atmospherics/A in loc)
		if(A.pipe_flags & PIPING_ALL_LAYER)
			return A
		if(A.pipe_layer == pipe_layer)
			return A
	return FALSE

/// Scans directions, sets network_directions to have every direction that we can link to. If there's another power cable builder detected, make sure they know we're here by adding us to their cable directions list before we're deleted.
/obj/effect/network_builder/atmos_pipe/scan_directions()
	var/turf/T
	for(var/i in GLOB.cardinal)
		if(i in network_directions)
			continue				//we're already set, that means another builder set us.
		T = get_step(loc, i)
		if(!T)
			continue
		var/found = FALSE
		for(var/obj/effect/network_builder/atmos_pipe/other in T)
			if(other.pipe_layer == pipe_layer)
				network_directions += i
				LAZYADD(other.network_directions, turn(i, 180))
				found = TRUE
				break
		if(found)
			continue
		for(var/obj/machinery/atmospherics/A in T)
			if((A.pipe_layer == pipe_layer) && (A.initialize_directions & i))
				network_directions += i
				break
	return network_directions

/// Directions should only ever have cardinals.
/obj/effect/network_builder/atmos_pipe/build_network(list/directions = pipe_directions)
	if(!length(directions) <= 1)
		return
	var/obj/machinery/atmospherics/pipe/built
	switch(length(directions))
		if(2)		//straight pipe
			built = new /obj/machinery/atmospherics/simple(loc)
			built.setDir(directions[1] | directions[2])
		if(3)		//manifold
			var/list/missing = directions ^ GLOB.cardinal
			missing = missing[1]
			built = new /obj/machinery/atmospherics/pipe/manifold(loc)
			built.setDir(missing)
		if(4)		//4 way manifold
			built = new /obj/machinery/atmospherics/pipe/manifold4w(loc)
		built.SetInitDirections()
		built.on_construction(pipe_color, piping_layer)

/obj/item/pipe/wrench_act(mob/living/user, obj/item/wrench/W)
	if(!isturf(loc))
		return TRUE

	add_fingerprint(user)

	var/obj/machinery/atmospherics/fakeA = pipe_type
	var/flags = initial(fakeA.pipe_flags)
	for(var/obj/machinery/atmospherics/M in loc)
		if((M.pipe_flags & flags & PIPING_ONE_PER_TURF))	//Only one dense/requires density object per tile, eg connectors/cryo/heater/coolers.
			to_chat(user, "<span class='warning'>Something is hogging the tile!</span>")
			return TRUE
		if((M.piping_layer != piping_layer) && !((M.pipe_flags | flags) & PIPING_ALL_LAYER)) //don't continue if either pipe goes across all layers
			continue
		if(M.GetInitDirections() & SSair.get_init_dirs(pipe_type, fixed_dir()))	// matches at least one direction on either type of pipe
			to_chat(user, "<span class='warning'>There is already a pipe at that location!</span>")
			return TRUE
	// no conflicts found

	var/obj/machinery/atmospherics/A = new pipe_type(loc)
	build_pipe(A)
	A.on_construction(color, piping_layer)
	transfer_fingerprints_to(A)

	W.play_tool_sound(src)
	user.visible_message( \
		"[user] fastens \the [src].", \
		"<span class='notice'>You fasten \the [src].</span>", \
		"<span class='italics'>You hear ratcheting.</span>")

	qdel(src)

/obj/item/pipe/proc/build_pipe(obj/machinery/atmospherics/A)
	A.setDir(fixed_dir())
	A.SetInitDirections()

	if(pipename)
		A.name = pipename
	if(A.on)
		// Certain pre-mapped subtypes are on by default, we want to preserve
		// every other aspect of these subtypes (name, pre-set filters, etc.)
		// but they shouldn't turn on automatically when wrenched.
		A.on = FALSE

/obj/effect/network_builder/atmos_pipe/proc/spawn_wires(list/directions)
	if(!length(directions))
		return
	else if(length(directions) == 1)
		var/knot = (knot == KNOT_FORCED) || ((knot == KNOT_AUTO) && should_auto_knot())
		if(knot)
			var/dir = directions[1]
			new /obj/structure/cable(loc, cable_color, NONE, directions[1])
	else
		if(knot == KNOT_FORCED)
			for(var/d in directions)
				new /obj/structure/cable(loc, cable_color, NONE, d)
		else
			var/knot = (knot == KNOT_FORCED) || ((knot == KNOT_AUTO) && should_auto_knot())
			var/dirs = length(directions)
			for(var/i in dirs)
				var/li = i - 1
				if(li < 1)
					li = dirs + li
				new /obj/structure/cable(loc, cable_color, directions[i], directions[li])
				if(knot)
					new /obj/structure/cable(loc, cable_color, NONE, directions[i])
					knot = FALSE

/obj/effect/network_builder/atmos_pipe/distro
	name = "distro line autobuilder"
	piping_layer = PIPING_LAYER_MIN
	pixel_x = -PIPING_LAYER_P_X
	pixel_y = -PIPING_LAYER_P_Y
	pipe_color = rgb(130,43,255)
	color = rgb(130,43,255)

/obj/effect/network_builder/atmos_pipe/scrubbers
	name = "scrubbers line autobuilder"
	piping_layer = PIPING_LAYER_MAX
	pixel_x = PIPING_LAYER_P_X
	pixel_y = PIPING_LAYER_P_Y
	pipe_color = rgb(255,0,0)
	color = rgb(255,0,0)
