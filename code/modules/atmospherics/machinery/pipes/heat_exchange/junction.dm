ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/pipe/heat_exchanging/junction, "pipe11")

/obj/machinery/atmospherics/pipe/heat_exchanging/junction
	icon = 'icons/obj/atmospherics/pipes/he-junction.dmi'
	icon_state = "pipe11"

	name = "junction"
	desc = "A one meter junction that connects regular and heat-exchanging pipe."

	minimum_temperature_difference = 300
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

	dir = SOUTH

	device_type = BINARY

	construction_type = /obj/item/pipe/directional
	pipe_state = "junction"

/obj/machinery/atmospherics/pipe/heat_exchanging/junction/SetInitDirections()
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = SOUTH|NORTH
		if(EAST, WEST)
			initialize_directions = WEST|EAST

/obj/machinery/atmospherics/pipe/heat_exchanging/junction/CanConnect(obj/machinery/atmospherics/other, node)
	return ..(other, node, dir == get_dir(other, src)? FALSE : TRUE)

/obj/machinery/atmospherics/pipe/heat_exchanging/junction/update_icon_state()
	icon_state = "pipe[connected[1] ? "1" : "0"][connected[2] ? "1" : "0"]-[pipe_layer]"
