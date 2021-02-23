/obj/item/pipe/bluespace
	pipe_type = /obj/machinery/atmospherics/pipe/bluespace
	var/bluespace_network_name = "default"
	icon_state = "bluespace"
	desc = "Transmits gas across large distances of space. Developed using bluespace technology. Use a multitool on it to set its network."

/obj/item/pipe/bluespace/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_MULTITOOL)
		var/new_name = input(user, "Enter identifier for bluespace pipe network", "bluespace pipe", bluespace_network_name) as text|null
		if(!isnull(new_name))
			bluespace_network_name = new_name
	else
		return

/obj/item/pipe/bluespace/make_from_existing(obj/machinery/atmospherics/pipe/bluespace/make_from)
	bluespace_network_name = make_from.bluespace_network_name
	return ..()

/obj/item/pipe/bluespace/build_pipe(obj/machinery/atmospherics/pipe/bluespace/A)
	A.bluespace_network_name = bluespace_network_name
	return ..()

/obj/item/pipe/bluespace/directional
	RPD_type = PIPE_UNARY
