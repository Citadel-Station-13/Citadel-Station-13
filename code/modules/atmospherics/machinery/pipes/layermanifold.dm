/obj/machinery/atmospherics/pipe/layer_manifold
	name = "layer adaptor"
	icon = 'icons/obj/atmospherics/pipes/manifold.dmi'
	icon_state = "manifoldlayer"
	desc = "A special pipe to bridge pipe layers with."
	dir = SOUTH
	initialize_directions = NORTH|SOUTH
	pipe_flags = PIPING_ALL_LAYER | PIPING_DEFAULT_LAYER_ONLY | PIPING_CARDINAL_AUTONORMALIZE
	piping_layer = PIPING_LAYER_DEFAULT
	device_type = 0
	volume = 260
	construction_type = /obj/item/pipe/binary
	pipe_state = "manifoldlayer"
	var/list/front_nodes = list()
	var/list/back_nodes = list()

/obj/machinery/atmospherics/pipe/layer_manifold/Initialize()
	icon_state = "manifoldlayer_center"
	return ..()

/obj/machinery/atmospherics/pipe/layer_manifold/nullify_nodes()
	front_nodes = null
	back_nodes = null

/obj/machinery/atmospherics/pipe/layer_manifoold/leave_nodes()
	for(var/obj/machinery/atmospherics/A in front_nodes|back_nodes)
		A.on_disconnect(src)

/obj/machinery/atmospherics/pipe/layer_manifold/collect_nodes()
	front_nodes = list()
	back_nodes = list()
	var/list/new_nodes = list()
	for(var/p_layer in PIPING_LAYER_MIN to PIPING_LAYER_MAX)
		var/obj/machinery/atmospherics/front = findConnecting(dir, p_layer)
		var/obj/machinery/atmospherics/back = findConnecting(turn(dir, 180), p_layer)
		if(front)
			front_nodes += front
			new_nodes += front
		if(back)
			back_nodes += back
			new_nodes += back
	return new_nodes()

/obj/machinery/atmospherics/pipe/layer_manifold/join_nodes()
	for(var/obj/machinery/atmospherics/A in front_nodes|back_nodes)
		A.on_connect(src)

/obj/machinery/atmospherics/pipe/layer_manifold/proc/get_all_connected_nodes()
	return front_nodes + back_nodes

/obj/machinery/atmospherics/pipe/layer_manifold/SetInitDirections()
	switch(dir)
		if(NORTH || SOUTH)
			initialize_directions = NORTH|SOUTH
		if(EAST || WEST)
			initialize_directions = EAST|WEST

/obj/machinery/atmospherics/pipe/layer_manifold/on_disconnect(obj/machinery/atmospherics/disconnecting)
	front_nodes -= disconnecting
	back_nodes -= disconnecting

/obj/machinery/atmospherics/pipe/layer_manifold/isConnectable(obj/machinery/atmospherics/target, given_layer)
	if(!given_layer)
		return TRUE
	. = ..()

/obj/machinery/atmospherics/pipe/layer_manifold/setPipingLayer()
	piping_layer = PIPING_LAYER_DEFAULT
	return ..()

/obj/machinery/atmospherics/pipe/layer_manifold/pipeline_expansion()
	return get_all_connected_nodes()

/obj/machinery/atmospherics/pipe/layer_manifold/relaymove(mob/living/user, dir)
	if(initialize_directions & dir)
		return ..()
	if((NORTH|EAST) & dir)
		user.ventcrawl_layer = clamp(user.ventcrawl_layer + 1, PIPING_LAYER_MIN, PIPING_LAYER_MAX)
	if((SOUTH|WEST) & dir)
		user.ventcrawl_layer = clamp(user.ventcrawl_layer - 1, PIPING_LAYER_MIN, PIPING_LAYER_MAX)
	to_chat(user, "You align yourself with the [user.ventcrawl_layer]\th output.")

/obj/machinery/atmospherics/pipe/layer_manifold/update_layer()
	layer = initial(layer) + (PIPING_LAYER_MAX * PIPING_LAYER_LCHANGE)	//This is above everything else.

/obj/machinery/atmospherics/pipe/layer_manifold/update_overlays()
	cut_overlays()

	for(var/node in front_nodes)
		add_attached_images(node)
	for(var/node in back_nodes)
		add_attached_images(node)

	update_alpha()

/obj/machinery/atmospherics/pipe/layer_manifold/proc/add_attached_images(obj/machinery/atmospherics/A)
	if(!A)
		return
	if(istype(A, /obj/machinery/atmospherics/pipe/layer_manifold))
		for(var/i in PIPING_LAYER_MIN to PIPING_LAYER_MAX)
			add_attached_image(get_dir(src, A), i)
			return
	add_attached_image(get_dir(src, A), A.piping_layer, A.pipe_color)

/obj/machinery/atmospherics/pipe/layer_manifold/proc/add_attached_image(p_dir, p_layer, p_color = null)
	var/image/I

	if(p_color)
		I = getpipeimage(icon, "pipe", p_dir, p_color, piping_layer = piping_layer)
	else
		I = getpipeimage(icon, "pipe", p_dir, piping_layer = piping_layer)

	I.layer = layer - 0.01
	PIPING_LAYER_SHIFT(I, p_layer)
	add_overlay(I)
