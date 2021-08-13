/obj/machinery/atmospherics/component/unary
	icon = 'icons/obj/atmospherics/component/unary_devices.dmi'
	dir = SOUTH
	initialize_directions = SOUTH
	device_type = UNARY
	pipe_flags = PIPE_ONE_PER_TURF
	construction_type = /obj/item/pipe/directional
	var/uid
	var/static/gl_uid = 1

/obj/machinery/atmospherics/component/unary/SetInitDirections()
	initialize_directions = dir

/obj/machinery/atmospherics/component/unary/proc/assign_uid_vents()
	uid = num2text(gl_uid++)
	return uid

/obj/machinery/atmospherics/component/unary/GetNodeIndex(dir, layer)
	return (pipe_flags & PIPE_ALL_LAYER)? layer : 1
