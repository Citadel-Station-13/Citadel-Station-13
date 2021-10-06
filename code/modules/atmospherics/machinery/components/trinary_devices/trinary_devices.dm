/obj/machinery/atmospherics/component/trinary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST
	use_power = IDLE_POWER_USE
	device_type = TRINARY
	layer = GAS_FILTER_LAYER
	pipe_flags = PIPE_ONE_PER_TURF

	/// If this device is flipped
	var/flipped = FALSE
	/// Alternative layout
	var/t_layout = FALSE

/obj/machinery/atmospherics/component/trinary/SetInitDirections()
	if(!t_layout)
		switch(dir)
			if(NORTH)
				initialize_directions = EAST|NORTH|SOUTH
			if(SOUTH)
				initialize_directions = SOUTH|WEST|NORTH
			if(EAST)
				initialize_directions = EAST|WEST|SOUTH
			if(WEST)
				initialize_directions = WEST|NORTH|EAST
	else
		initialize_directions = dir | turn(dir, 90) | turn(dir, -90)

/obj/machinery/atmospherics/component/trinary/GetNodeIndex(dir, layer)
	// non t_layout: node 2 is side
	if(!t_layout)
		if(dir == turn(src.dir, -90))
			. = 2
		else if(dir == (flipped? src.dir : turn(src.dir, 180)))
			. = 1
		else if(dir == (flipped? turn(src.dir, 90) : turn(src.dir, -90)))
			. = 3
	// t_layout: node 3 is front, node 1 is left, node 2 is right, RELATIVE TO FRONT
	else
		if(dir == src.dir)
			. = 3
		else if(dir == (flipped? turn(src.dir, -90) : turn(src.dir, 90)))
			. = 1
		else if(dir == (flipped? turn(src.dir, 90) : turn(src.dir, -90)))
			. = 2
	if(pipe_flags & PIPE_ALL_LAYER)
		. = pipe_layer + ((. - 1) * PIPE_LAYER_TOTAL)
