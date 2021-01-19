GLOBAL_LIST_EMPTY(bluespace_pipe_networks)
/obj/machinery/atmospherics/pipe/bluespace
	name = "bluespace pipe"
	desc = "Transmits gas across large distances of space. Developed using bluespace technology. Use a multitool on it to set its network."
	icon = 'modular_sand/icons/obj/atmospherics/pipes/bluespace.dmi'
	icon_state = "blue_map-2"
	pipe_state = "bluespace"
	dir = SOUTH
	initialize_directions = SOUTH
	device_type = UNARY
	can_buckle = FALSE
	construction_type = /obj/item/pipe/bluespace/directional
	var/bluespace_network_name

/obj/machinery/atmospherics/pipe/bluespace/New()
	icon_state = "map"
	if(bluespace_network_name) // in case someone maps one in for some reason
		if(!GLOB.bluespace_pipe_networks[bluespace_network_name])
			GLOB.bluespace_pipe_networks[bluespace_network_name] = list()
		GLOB.bluespace_pipe_networks[bluespace_network_name] |= src
	..()

/obj/machinery/atmospherics/pipe/bluespace/on_construction()
	. = ..()
	if(bluespace_network_name)
		if(!GLOB.bluespace_pipe_networks[bluespace_network_name])
			GLOB.bluespace_pipe_networks[bluespace_network_name] = list()
		GLOB.bluespace_pipe_networks[bluespace_network_name] |= src

/obj/machinery/atmospherics/pipe/bluespace/Destroy()
	if(GLOB.bluespace_pipe_networks[bluespace_network_name])
		GLOB.bluespace_pipe_networks[bluespace_network_name] -= src
		for(var/p in GLOB.bluespace_pipe_networks[bluespace_network_name])
			var/obj/machinery/atmospherics/pipe/bluespace/P = p
			QDEL_NULL(P.parent)
			P.build_network()
	return ..()

/obj/machinery/atmospherics/pipe/bluespace/examine(user)
	. = ..()
	to_chat(user, "<span class='notice'>This one is connected to the \"[html_encode(bluespace_network_name)]\" network</span>")

/obj/machinery/atmospherics/pipe/bluespace/SetInitDirections()
	initialize_directions = dir

/obj/machinery/atmospherics/pipe/bluespace/pipeline_expansion()
	return ..() + GLOB.bluespace_pipe_networks[bluespace_network_name] - src

/obj/machinery/atmospherics/pipe/bluespace/hide()
	update_icon()

/obj/machinery/atmospherics/pipe/bluespace/update_icon(showpipe)
	underlays.Cut()

	var/turf/T = loc
	if(level == 2 || !T.intact)
		icon_state = "blue_map-2"
		showpipe = TRUE
		plane = GAME_PLANE
	else
		showpipe = FALSE
		plane = FLOOR_PLANE

	if(!showpipe)
		return //no need to update the pipes if they aren't showing
/* This shit aint in here
	var/connected = 0 //Direction bitset

	for(var/i in 1 to device_type) //adds intact pieces
		if(nodes[i])
			connected |= icon_addintact(nodes[i])

	icon_addbroken(connected) //adds broken pieces//adds broken pieces
*/
	if(piping_layer == 1)
		icon_state = "blue_map-1"
	else if(piping_layer == 2)
		icon_state = "blue_map-2"
	else if(piping_layer == 3)
		icon_state = "blue_map-3"

/obj/machinery/atmospherics/pipe/bluespace/paint()
	return FALSE

/obj/machinery/atmospherics/pipe/bluespace/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/multitool))
		var/new_name = input(user, "Enter identifier for bluespace pipe network", "bluespace pipe", bluespace_network_name) as text|null
		if(!isnull(new_name))
			bluespace_network_name = new_name
	else
		return

/obj/machinery/atmospherics/pipe/bluespace/layer1
	piping_layer = 1
	icon_state = "blue_map-1"

/obj/machinery/atmospherics/pipe/bluespace/layer2
	piping_layer = 2
	icon_state = "blue_map-2"

/obj/machinery/atmospherics/pipe/bluespace/layer3
	piping_layer = 3
	icon_state = "blue_map-3"
