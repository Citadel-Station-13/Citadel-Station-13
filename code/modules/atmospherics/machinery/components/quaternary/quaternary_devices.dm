/**
 * 4-sided devices
 *
 * NODE ORDER:
 * Static, NESW 1234.
 * If all layers, *= layer.
 */
/obj/machinery/atmospherics/component/quaternary
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
		. = pipe_layer + ((. - 1) * PIPE_LAYER_TOTAL)

/obj/machinery/atmospherics/component/quaternary/proc/IndexToDir(index)
	if(isnull(index))
		return null
	if(pipe_flags & PIPE_ALL_LAYER)
		index = FLOOR((index / PIPE_LAYER_TOTAL) - 0.01, 1) + 1		// jank, sue me lol
	switch(index)
		if(1)
			return NORTH
		if(2)
			return EAST
		if(3)
			return SOUTH
		if(4)
			return WEST

/obj/machinery/atmospherics/component/quaternary/proc/DirToIndex(dir, layer = pipe_layer)
	if(isnull(dir))
		return null
	return GetNodeIndex(dir, layer)
