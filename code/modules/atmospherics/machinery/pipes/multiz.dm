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
	icon_state = "pipe_up"
	icon = 'icons/obj/atmos.dmi'
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
	icon = 'icons/obj/atmos.dmi'
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

/**
 * Joins every layer to both up and down, without mixing layers.
 */
/obj/machinery/atmospherics/pipe/mains/multiz
	name = "multi deck mains adapter"
	desc = "A massive multi-deck pipe that connects all layers above and below themselves, without intermixing layers."
	icon_state = "multiz_pipe"
	icon = 'icons/obj/atmos.dmi'
	device_type = QUATERNARY

/obj/machinery/atmospherics/pipe/mains/multiz/update_overlays()
	. = ..()
	var/image/multiz_overlay_node = new(src) //If we have a firing state, light em up!
	multiz_overlay_node.icon = 'icons/obj/atmos.dmi'
	multiz_overlay_node.icon_state = "multiz_pipe"
	multiz_overlay_node.layer = HIGH_OBJ_LAYER
	. += multiz_overlay_node

/obj/machinery/atmospherics/pipe/mains/multiz/GetNodeIndex(dir, layer)
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

///Attempts to locate a multiz pipe that's above us, if it finds one it merges us into its pipenet
/obj/machinery/atmospherics/pipe/mains/multiz/DirectConnection(datum/pipeline/querying, obj/machinery/atmospherics/source)
	. = ..()
	var/turf/T = get_turf(src)
	var/obj/machinery/atmospherics/pipe/mains/multiz/above = locate() in SSmapping.get_turf_above(T)
	var/obj/machinery/atmospherics/pipe/mains/multiz/below = locate() in SSmapping.get_turf_below(T)
	if(above)
		. |= above
	if(below)
		. |= below
