/**
 * 4-sided devices
 *
 * NODE ORDER:
 * Static, NESW 1234.
 * If all layers, *= layer.
 */
/obj/machinery/atmospherics/component/quaternary
	icon = 'icons/obj/atmospherics/component/quaternary_devices.dmi'
	dir = SOUTH
	initialize_directions = NORTH|SOUTH|EAST|WEST
	use_power = IDLE_POWER_USE
	device_type = QUATERNARY
	layer = GAS_FILTER_LAYER
	pipe_flags = PIPE_ONE_PER_TURF

/obj/machinery/atmospherics/component/quaternary/SetInitDirections()
	initialize_directions = NORTH|SOUTH|EAST|WEST

/obj/machinery/atmospherics/component/quaternary/GetNodeIndex(dir, layer)
	switch(dir)
		if(NORTH)
			. = 1
		if(SOUTH)
			. = 3
		if(EAST)
			. = 2
		if(WEST)
			. = 4
	if(pipe_flags & PIPE_ALL_LAYER)
		layer + ((. - 1) * PIPE_LAYER_TOTAL)
