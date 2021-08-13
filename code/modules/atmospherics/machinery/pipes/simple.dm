/**
 * Simple 2-directional pipes
 */

ATMOS_MAPPING_FULL_IX(/obj/machinery/atmospherics/pipe/simple, "pipe11")

/obj/machinery/atmospherics/pipe/simple
	icon = 'icons/obj/atmospherics/pipes/simple.dmi'
	icon_state = "pipe11"

	name = "pipe"
	desc = "A one meter section of regular pipe."

	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	pipe_flags = PIPE_CARDINAL_AUTONORMALIZE

	device_type = BINARY

	construction_type = /obj/item/pipe/binary/bendable
	pipe_state = "simple"

/obj/machinery/atmospherics/pipe/simple/SetInitDirections()
	if(dir in GLOB.diagonals)
		initialize_directions = dir
		return
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = SOUTH|NORTH
		if(EAST, WEST)
			initialize_directions = EAST|WEST

/obj/machinery/atmospherics/pipe/simple/update_icon_state()
	icon_state = "pipe[connected[1] ? "1" : "0"][connected[2] ? "1" : "0"]-[pipe_layer]"
