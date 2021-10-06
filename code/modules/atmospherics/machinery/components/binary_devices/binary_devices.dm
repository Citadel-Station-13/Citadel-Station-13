/**
 * "Straight" pipe-like binary devices
 *
 * NODE ORDER:
 * Flow goes THROUGH dir, aka dir is output, turn(dir, 180) is input
 * IF all layer, order *= layer.
 */
/obj/machinery/atmospherics/component/binary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	use_power = IDLE_POWER_USE
	device_type = BINARY
	layer = GAS_PUMP_LAYER

/obj/machinery/atmospherics/component/binary/SetInitDirections()
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = NORTH|SOUTH
		if(EAST, WEST)
			initialize_directions = EAST|WEST

/obj/machinery/atmospherics/component/binary/GetNodeIndex(dir, layer)
	if(dir == src.dir)
		. = 2
	else
		. = 1
	if(pipe_flags & PIPE_ALL_LAYER)
		. = pipe_layer + ((. - 1) * PIPE_LAYER_TOTAL)
