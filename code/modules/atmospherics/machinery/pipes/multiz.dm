/**
 * Multiz up/down pipes
 */

ATMOS_MAPPING_FULL_IX(/obj/machinery/atmospherics/pipe/up, "up")
ATMOS_MAPPING_FULL_IX(/obj/machinery/atmospherics/pipe/down, "down")
ATMOS_MAPPING_MINIMAL(/obj/machinery/atmospherics/pipe/multiz_deck)

/**
 * One side goes up
 */
/obj/machinery/atmospherics/pipe/up
	name = "upwards pipe"
	desc = "A pipe that goes upwards."
	icon_state = "up"
	icon = 'icons/modules/atmospherics/pipes/multiz.dmi'
	device_type = BINARY

/obj/machinery/atmospherics/pipe/up/GetNodeIndex(dir, layer)
	if(dir == UP)
		return 2
	return 1

/obj/machinery/atmospherics/pipe/up/SetInitDirections()
	ASSERT(!(dir & (dir - 1)))		// cardinal
	initialize_directions = UP | dir

/obj/machinery/atmospherics/pipe/up/update_icon_state()
	icon_state = "pipe_up[connected[2]? "1" : "0"]-[pipe_layer]"

/**
 * One side goes down
 */
/obj/machinery/atmospherics/pipe/down
	name = "downwards pipe"
	desc = "A pipe that goes upwards."
	icon_state = "pipe_down"
	icon = 'icons/modules/atmospherics/pipes/multiz.dmi'
	device_type = BINARY

/obj/machinery/atmospherics/pipe/up/GetNodeIndex(dir, layer)
	if(dir == DOWN)
		return 2
	return 1

/obj/machinery/atmospherics/pipe/up/SetInitDirections()
	ASSERT(!(dir & (dir - 1)))		// cardinal
	initialize_directions = DOWN | dir

/obj/machinery/atmospherics/pipe/up/update_icon_state()
	icon_state = "pipe_down[connected[2]? "1" : "0"]-[pipe_layer]"
