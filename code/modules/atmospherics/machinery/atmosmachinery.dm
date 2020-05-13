// Quick overview:
//
// Pipes combine to form pipelines
// Pipelines and other atmospheric objects combine to form pipe_networks
//   Note: A single pipe_network represents a completely open space
//
// Pipes -> Pipelines
// Pipelines + Other Objects -> Pipe network

#define PIPE_VISIBLE_LEVEL 2
#define PIPE_HIDDEN_LEVEL 1

/obj/machinery/atmospherics
	anchored = TRUE
	move_resist = INFINITY				//Moving a connected machine without actually doing the normal (dis)connection things will probably cause a LOT of issues.
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = ENVIRON
	layer = GAS_PIPE_HIDDEN_LAYER //under wires
	resistance_flags = FIRE_PROOF
	max_integrity = 200
	obj_flags = CAN_BE_HIT | ON_BLUEPRINTS
	var/nodealert = 0
	var/can_unwrench = 0
	/// Direction flags that we can connect to nodes in.
	var/initialize_directions = NONE
	var/pipe_color
	/// Our pipe layer.
	var/piping_layer = PIPING_LAYER_DEFAULT
	/// Flags controlling behavior. See __DEFINES/atmospherics/pipe_flags
	var/pipe_flags = NONE

	var/static/list/iconsetids = list()
	var/static/list/pipeimages = list()

	var/image/pipe_vision_img = null

	/// __DEFINES/atmospherics/device_type, how many devices we can connect basically.
	var/device_type = 0
	/// List of connected nodes.
	var/list/obj/machinery/atmospherics/nodes

	var/construction_type
	var/pipe_state //icon_state as a pipe item
	var/on = FALSE

/obj/machinery/atmospherics/examine(mob/user)
	. = ..()
	if(is_type_in_list(src, GLOB.ventcrawl_machinery) && isliving(user))
		var/mob/living/L = user
		if(L.ventcrawler)
			. += "<span class='notice'>Alt-click to crawl through it.</span>"

/obj/machinery/atmospherics/Initialize(mapload, process = TRUE, setdir)
	if(!isnull(setdir))
		setDir(setdir)
	nodes = new(device_type)
	if (!armor)
		armor = list("melee" = 25, "bullet" = 10, "laser" = 10, "energy" = 100, "bomb" = 0, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 70)
	. = ..()
	if(process)
		SSair.atmos_machinery += src		// += not |= hope no insane admin decides to fuck with this haha......

/**
  * Cleans up from our position/location in the game world.
  */
/obj/machinery/atmospherics/proc/Cleanup(update_icon = TRUE)
	. = Separate(update_icon)

/**
  * Sets up from our position/location in the game world.
  */
/obj/machinery/atmospherics/proc/Setup(update_icon = TRUE)
	if(pipe_flags & PIPING_CARDINAL_AUTONORMALIZE)
		normalize_cardinal_directions()
	SetInitDirections()
	. = Join(update_icon)

/obj/machinery/atmospherics/Destroy()
	Cleanup()

	SSair.atmos_machinery -= src
	SSair.pipenets_needing_rebuilt -= src

	dropContents()
	if(pipe_vision_img)
		qdel(pipe_vision_img)

	return ..()

/obj/machinery/atmospherics/forceMove()
	Cleanup(FALSE)
	. = ..()
	Setup(FALSE)
	update_icon()

/**
  * Fully disconnects us from whatever we're connected to. You probably want Cleanup().
  */
/obj/machinery/atmospherics/proc/Separate(update_icon = TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)			// May be reconsidered in the future.
	. = FALSE
	if(!(pipe_flags & PIPING_NETWORK_JOINED))
		CRASH("Tried to Separate() while not Join()ed.")
	pipe_flags &= ~PIPING_NETWORK_JOINED
	breakdown_networks()
	leave_nodes()
	nullify_nodes()
	if(update_icon)
		update_icon()
	return TRUE

/**
  * Checks if it's a valid location to join a network from.
  */
/obj/machinery/atmospherics/proc/CheckJoin(useloc = loc, force = FALSE)
	if(!useloc)
		return FALSE
	// Essential checks should be above and not care about force.
	if(force)
		return TRUE
	if(location_conflicts_at(useloc))
		return FALSE
	return TRUE

/**
  * Automatically connects us, building our network as necessary. You probably want Setup().
  */
/obj/machinery/atmospherics/proc/Join(update_icon = TRUE, force = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)			// May be reconsidered in the future.
	. = FALSE
	if(pipe_flags & PIPING_NETWORK_JOINED)		//do not do it again.
		CRASH("Tried to Join() while already Join()ed.")
	if(!CheckJoin(loc, force))
		return
	pipe_flags |= PIPING_NETWORK_JOINED
	collect_nodes()
	join_nodes()
	form_networks()
	if(update_icon)
		update_icon()
	return TRUE

/**
  * Separates and then Joins.
  */
/obj/machinery/atmospherics/proc/Rebuild(update_icon = TRUE)
	Separate(FALSE)
	Join(FALSE)
	if(update_icon)
		update_icon()

/**
  * Destroys our pipe network, usually used when we're leaving it.
  */
/obj/machinery/atmospherics/proc/breakdown_networks()
	CRASH("breakdown_networks() of base atmospherics machinery called.")

/**
  * Leave connected nodes. This proc should tell them we disconnected.
  */
/obj/machinery/atmospherics/proc/leave_nodes()
	for(var/i in nodes)
		var/obj/machinery/atmospherics/A = i
		if(!A)
			continue
		A.on_disconnect(src)

/**
  * Clears references of connected nodes.
  */
/obj/machinery/atmospherics/proc/nullify_nodes()
	nodes = list(device_type)

/**
  * Collects and sets nodes that we should connect to.
  */
/obj/machinery/atmospherics/proc/collect_nodes()
	var/list/connect_directions = node_connect_directions()
	if(length(connect_directions) != connect_directions)
		CRASH("Found an incorrect number of connect directions! FOUND: [length(connect_directions)]. EXPECTED: [device_type.]")
	for(var/i in 1 to device_type)
		// defaults to single connections only.
		var/obj/machinery/atmospherics/potential = get_valid_node(connect_directions[i], i)
		if(!potential)
			continue
		nodes[i] = potential

/**
  * Joins connected nodes. This proc should tell them we connected.
  */
/obj/machinery/atmospherics/proc/join_nodes()
	for(var/i in nodes)
		var/obj/machinery/atmospherics/A = i
		if(!A)
			continue
		A.on_connect(src)

/**
  * Forms required pipeline datums.
  */
/obj/machinery/atmospherics/proc/form_networks()
	CRASH("form_networks() of base atmospherics machinery called.")

/**
  * Called when a specific machinery is disconnecting from us.
  */
/obj/machinery/atmospherics/proc/on_disconnect(obj/machinery/atmospherics/disconnecting)
	var/nodeindex = nodes.Find(disconnecting)
	if(!nodeindex)
		stack_trace("on_disconnect called without the disconnecting thing being in our nodes! Something has gone horribly wrong!")
	else
		nodes[nodeindex] = null
	update_icon()

/**
  * Gets a list of directions we should be trying to connect to.
  */
/obj/machinery/atmospherics/proc/node_connect_directions()
	var/found = 0
	var/list/connects = list()
	for(var/dir in GLOB.cardinals_multiz)
		if(dir & UP)
			if(!SSmapping.get_turf_above(loc))
				continue
		else if(dir & DOWN)
			if(!SSmapping.get_turf_below(loc))
				continue
		if(found == device_type)
			break
		if(dir & initialize_directions)
			connects += dir
			found++
	return connects

/**
  * Normalizes our directions to be the same as equivalent directions if it doesn't matter if we're, for example, SOUTH rather than NORTH for straight pipes.
  */
/obj/machinery/atmospherics/proc/normalize_cardinal_directions()
	switch(dir)
		if(SOUTH)
			setDir(NORTH)
		if(WEST)
			setDir(EAST)

/**
  * Initialization proc called by SSair after turfs are set up.
  */
/obj/machinery/atmospherics/proc/AtmosInitialize()
	Setup()

/**
  * Temporarily stores air when our parent pipe network breaks down.
  */
/obj/machinery/atmospherics/proc/temporarily_store_air(datum/pipeline/from)
	CRASH("Attempted to temporarily store air on a base atmospherics machinery!")

/**
  * Sets our piping layer.
  */
/obj/machinery/atmospherics/proc/setPipingLayer(new_layer, update_icon = TRUE)
	Separate(FALSE)
	piping_layer = (pipe_flags & PIPING_DEFAULT_LAYER_ONLY) ? PIPING_LAYER_DEFAULT : new_layer
	Join(FALSE)
	if(update_icon)
		update_icon()

/**
  * Checks if we should let someone connect to us. Does not consider their opinions on the matter.
  */
/obj/machinery/atmospherics/proc/node_connection_check(obj/machinery/atmospherics/target, node_index, prompted_layer)
	return node_layer_check(target, prompted_layer) && node_direction_check(target)

/**
  * Checks the target is on the right pipe layer to connect to us.
  */
/obj/machinery/atmospherics/proc/node_layer_check(obj/machinery/atmospherics/target, our_layer = pipe_layer)
	return (target.pipe_layer == our_layer) || ((target.pipe_flags | pipe_flags) & PIPING_ALL_LAYER)

/**
  * Checks the target is in the right direction to connect to us.
  */
/obj/machinery/atmospherics/proc/node_direction_check(obj/machinery/atmospherics/target)
	return get_dir(src, target) & initialize_directions

/**
  * Checks if we can connect to a target, asking both ourselves and them if we can connect the other.
  */
/obj/machinery/atmospherics/proc/can_be_node(obj/machinery/atmospherics/target, node_index, prompted_layer)
	return node_connection_check(target, node_index, prompted_layer) && target.node_connection_check(src, node_index, prompted_layer)

/**
  * Finds all valid nodes in a direction.
  */
/obj/machinery/atmospherics/proc/find_all_valid_nodes(direction, node_index, prompted_layer)
	. = list()
	for(var/obj/machinery/atmospherics/target in get_step_multiz(src, direction))
		if(can_be_node(target, node_index, prompted_layer))
			. += target

/**
  * Finds a valid node in a direction.
  */
 /obj/machinery/atmospherics/proc/find_valid_node(direction, node_index, prompted_layer)
 	for(var/obj/machinery/atmospherics/target in get_step_multiz(src, direction))
 		if(can_be_node(target, node_index, prompted_layer))
 			return target

/**
  * Returns atmospherics machinery that we are connected to that we are directly going to expand our pipenet to (so a logical no-block straight instantenously conducting connection).
  * This proc returns a list that can include nulls. The list this proc returns should not be directly modified!
  */
/obj/machinery/atmospherics/proc/pipeline_expansion(datum/pipeline/from)
	return nodes

/**
  * Automatically sets our initialize_directions, which governs what pipes we're going to try to connect to.
  * Does not do rebuilding or anything.
  */
/obj/machinery/atmospherics/proc/SetInitDirections()
	return

/**
  * Returns the pipenet of the specified node.
  */
/obj/machinery/atmospherics/proc/return_pipenet(node = 1)
	CRASH("Tried to get the pipenet of a base atmospherics machinery. Either this check should be removed, or, more likely, someone screwed up.")

/**
  * Returns all pipenets we have.
  */
/obj/machinery/atmospherics/proc/return_pipenets()
	CRASH("Tried to get all pipenets of a base atmospherics machinery. Either this check should be removed, or, more likely, someone screwed up.")

/**
  * Returns the direct pipenet air of the specified node.
  */
/obj/machinery/atmospherics/proc/return_pipenet_air(node = 1)
	CRASH("Tried to get the pipenet air of a base atmospherics machinery. Either this check should be removed, or, more likely, someone screwed up.")

/**
  * Informs us that a specific node was set to a pipenet.
  */
/obj/machinery/atmospherics/proc/on_set_pipenet(node = 1)
	CRASH("The pipenet of a base atmospherics machinery was on_set. Someone screwed up.")

/obj/machinery/atmospherics/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pipe)) //lets you autodrop
		var/obj/item/pipe/pipe = W
		if(user.dropItemToGround(pipe))
			pipe.setPipingLayer(piping_layer) //align it with us
			return TRUE
	else
		return ..()

/obj/machinery/atmospherics/wrench_act(mob/living/user, obj/item/I)
	if(!can_unwrench(user))
		return ..()

	var/turf/T = get_turf(src)
	if (level==1 && isturf(T) && T.intact)
		to_chat(user, "<span class='warning'>You must remove the plating first!</span>")
		return TRUE

	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	add_fingerprint(user)

	var/unsafe_wrenching = FALSE
	var/internal_pressure = int_air.return_pressure()-env_air.return_pressure()

	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")

	if (internal_pressure > 2*ONE_ATMOSPHERE)
		to_chat(user, "<span class='warning'>As you begin unwrenching \the [src] a gush of air blows in your face... maybe you should reconsider?</span>")
		unsafe_wrenching = TRUE //Oh dear oh dear

	if(I.use_tool(src, user, 20, volume=50))
		user.visible_message( \
			"[user] unfastens \the [src].", \
			"<span class='notice'>You unfasten \the [src].</span>", \
			"<span class='italics'>You hear ratchet.</span>")
		investigate_log("was <span class='warning'>REMOVED</span> by [key_name(usr)]", INVESTIGATE_ATMOS)

		//You unwrenched a pipe full of pressure? Let's splat you into the wall, silly.
		if(unsafe_wrenching)
			unsafe_pressure_release(user, internal_pressure)
		deconstruct(TRUE)
	return TRUE

/obj/machinery/atmospherics/proc/can_unwrench(mob/user)
	return can_unwrench

// Throws the user when they unwrench a pipe with a major difference between the internal and environmental pressure.
/obj/machinery/atmospherics/proc/unsafe_pressure_release(mob/user, pressures = null)
	if(!user)
		return
	if(!pressures)
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		pressures = int_air.return_pressure() - env_air.return_pressure()

	user.visible_message("<span class='danger'>[user] is sent flying by pressure!</span>","<span class='userdanger'>The pressure sends you flying!</span>")

	// if get_dir(src, user) is not 0, target is the edge_target_turf on that dir
	// otherwise, edge_target_turf uses a random cardinal direction
	// range is pressures / 250
	// speed is pressures / 1250
	user.throw_at(get_edge_target_turf(user, get_dir(src, user) || pick(GLOB.cardinals)), pressures / 250, pressures / 1250)

/obj/machinery/atmospherics/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(can_unwrench)
			var/obj/item/pipe/stored = new construction_type(loc, null, dir, src)
			stored.setPipingLayer(piping_layer)
			if(!disassembled)
				stored.obj_integrity = stored.max_integrity * 0.5
			transfer_fingerprints_to(stored)
	..()

/obj/machinery/atmospherics/proc/getpipeimage(iconset, iconstate, direction, col=rgb(255,255,255), piping_layer=2)

	//Add identifiers for the iconset
	if(iconsetids[iconset] == null)
		iconsetids[iconset] = num2text(iconsetids.len + 1)

	//Generate a unique identifier for this image combination
	var/identifier = iconsetids[iconset] + "_[iconstate]_[direction]_[col]_[piping_layer]"

	if((!(. = pipeimages[identifier])))
		var/image/pipe_overlay
		pipe_overlay = . = pipeimages[identifier] = image(iconset, iconstate, dir = direction)
		pipe_overlay.color = col
		PIPING_LAYER_SHIFT(pipe_overlay, piping_layer)

/obj/machinery/atmospherics/on_construction(obj_color, set_layer)
	if(can_unwrench)
		add_atom_colour(obj_color, FIXED_COLOUR_PRIORITY)
		pipe_color = obj_color
	setPipingLayer(set_layer)
	var/turf/T = get_turf(src)
	level = T.intact ? 2 : 1
	atmosinit()
	var/list/nodes = pipeline_expansion()
	for(var/obj/machinery/atmospherics/A in nodes)
		A.atmosinit()
		A.addMember(src)
	build_network()

/obj/machinery/atmospherics/Entered(atom/movable/AM)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.ventcrawl_layer = piping_layer
	return ..()

/obj/machinery/atmospherics/singularity_pull(S, current_size)
	if(current_size >= STAGE_FIVE)
		deconstruct(FALSE)
	return ..()

#define VENT_SOUND_DELAY 30

/obj/machinery/atmospherics/relaymove(mob/living/user, direction)
	direction &= initialize_directions
	if(!direction || !(direction in GLOB.cardinals)) //cant go this way.
		return

	if(user in buckled_mobs)// fixes buckle ventcrawl edgecase fuck bug
		return

	var/obj/machinery/atmospherics/target_move = findConnecting(direction, user.ventcrawl_layer)
	if(target_move)
		if(target_move.can_crawl_through())
			if(is_type_in_typecache(target_move, GLOB.ventcrawl_machinery))
				user.forceMove(target_move.loc) //handle entering and so on.
				user.visible_message("<span class='notice'>You hear something squeezing through the ducts...</span>", "<span class='notice'>You climb out the ventilation system.")
			else
				var/list/pipenetdiff = return_pipenets() ^ target_move.return_pipenets()
				if(pipenetdiff.len)
					user.update_pipe_vision(target_move)
				user.forceMove(target_move)
				user.client.eye = target_move  //Byond only updates the eye every tick, This smooths out the movement
				if(world.time - user.last_played_vent > VENT_SOUND_DELAY)
					user.last_played_vent = world.time
					playsound(src, 'sound/machines/ventcrawl.ogg', 50, 1, -3)
	else if(is_type_in_typecache(src, GLOB.ventcrawl_machinery) && can_crawl_through()) //if we move in a way the pipe can connect, but doesn't - or we're in a vent
		user.forceMove(loc)
		user.visible_message("<span class='notice'>You hear something squeezing through the ducts...</span>", "<span class='notice'>You climb out the ventilation system.")

/obj/machinery/atmospherics/AltClick(mob/living/L)
	if(is_type_in_typecache(src, GLOB.ventcrawl_machinery))
		return L.handle_ventcrawl(src)
	return ..()


/obj/machinery/atmospherics/proc/can_crawl_through()
	return TRUE

/obj/machinery/atmospherics/update_remote_sight(mob/user)
	user.sight |= (SEE_TURFS|BLIND)

//Used for certain children of obj/machinery/atmospherics to not show pipe vision when mob is inside it.
/obj/machinery/atmospherics/proc/can_see_pipes()
	return TRUE

/obj/machinery/atmospherics/update_icon()
	. = ..()
	update_alpha()
	update_layer()
	update_offsets()

/**
  * Updates our visual pixel shifts.
  */
/obj/machinery/atmospherics/proc/update_offsets()
	if(pipe_flags & PIPING_AUTO_DOUBLE_SHIFT_OFFSETS)
		PIPING_LAYER_DOUBLE_SHIFT(src, pipe_layer)
	else if(pipe_flags & PIPING_AUTO_SHIFT_OFFSETS)
		PIPING_LAYER_SHIFT(src, pipe_layer)
	else
		pixel_x = 0
		pixel_y = 0

/**
  * Updates our visaul alpha
  */
/obj/machinery/atmospherics/proc/update_alpha()

/**
  * Updates our visual layer
  */
/obj/machinery/atmospherics/proc/update_layer()
	layer = initial(layer) + (piping_layer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_LCHANGE
