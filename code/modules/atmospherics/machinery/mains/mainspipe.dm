/**
 * Mains pipes, including 2 way, 3 way, and 4 ways.
 *
 * Connect layers together without intermixing
 */

ATMOS_MAPPING_COLORS(/obj/machinery/atmospherics/mains/pipe)
ATMOS_MAPPING_COLORS(/obj/machinery/atmospherics/mains/manifold)
ATMOS_MAPPING_COLORS(/obj/machinery/atmospherics/mains/manifold4)

/obj/machinery/atmospherics/mains/pipe
	name = "mains pipe"
	desc = "A massive pipe that connects every pipe layer at once, without intermixing them."
	icon = 'icons/obj/atmospherics/pipes/manifold.dmi'
	icon_state = "mains"
	pipe_flags = PIPE_ALL_LAYER | PIPE_CARDINAL_AUTONORMALIZE
	device_type = BINARY

/obj/machinery/atmospherics/mains/pipe/GetNodeIndex(dir, layer)
	if(dir == src.dir)
		. = 2
	else
		. = 1
	return layer + ((. - 1) * PIPE_LAYER_TOTAL)

/obj/machinery/atmospherics/mains/pipe/SetInitDirections()
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = NORTH|SOUTH
		if(EAST, WEST)
			initialize_directions = EAST|WEST

/obj/machinery/atmospherics/mains/manifold
	name = "mains manifold"
	desc = "A massive pipe that connects every pipe layer at once, without intermixing them."
	icon = 'icons/obj/atmospherics/pipes/manifold.dmi'
	icon_state = "mains3"
	pipe_flags = PIPE_ALL_LAYER
	device_type = TRINARY

/obj/machinery/atmospherics/mains/manifold/SetInitDirections()
	switch(dir)
		if(NORTH)
			initialize_directions = EAST|NORTH|SOUTH
		if(SOUTH)
			initialize_directions = SOUTH|WEST|NORTH
		if(EAST)
			initialize_directions = EAST|WEST|SOUTH
		if(WEST)
			initialize_directions = WEST|NORTH|EAST

/obj/machinery/atmospherics/mains/manifold/GetNodeIndex(dir, layer)
	if(!(src.dir in GLOB.cardinals))
		CRASH("Self dir not in cardinals on mains manifold. Unsupported.")
	var/list/lookup = GLOB.atmos_trinary_lookup_dirs[src.dir]
	for(var/i in 1 to 3)		// hardcoded because why not :)
		if(lookup[i] == dir)
			return layer + ((i - 1) * PIPE_LAYER_TOTAL)
	CRASH("Mains manifold failed to get node index for dir [dir] layer [layer] selfdir [src.dir]")

/obj/machinery/atmospherics/mains/manifold4w
	name = "mains 4-way manifold"
	desc = "A massive pipe that connects every pipe layer at once, without intermixing them."
	icon = 'icons/obj/atmospherics/pipes/manifold.dmi'
	icon_state = "mains4"
	pipe_flags = PIPE_ALL_LAYER
	device_type = QUATERNARY

/obj/machinery/atmospherics/mains/manifold4w/GetNodeIndex(dir, layer)
	switch(dir)
		if(NORTH)
			. = 1
		if(SOUTH)
			. = 3
		if(EAST)
			. = 2
		if(WEST)
			. = 4
	return layer + ((. - 1) * PIPE_LAYER_TOTAL)
