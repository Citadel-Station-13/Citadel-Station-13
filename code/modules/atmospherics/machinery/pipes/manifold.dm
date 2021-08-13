/**
 * Simple 3 way manifolds.
 */

ATMOS_MAPPING_FULL_PX_DOUBLE(/obj/machinery/atmospherics/pipe/manifold)

/obj/machinery/atmospherics/pipe/manifold
	icon = 'icons/obj/atmospherics/pipes/manifold.dmi'
	icon_state = "manifold"

	name = "pipe manifold"
	desc = "A manifold composed of regular pipes."

	dir = SOUTH
	initialize_directions = EAST|NORTH|WEST

	device_type = TRINARY

	construction_type = /obj/item/pipe/trinary
	pipe_state = "manifold"

	var/mutable_appearance/center

/obj/machinery/atmospherics/pipe/manifold/Initialize()
	icon_state = ""
	center = mutable_appearance(icon, "manifold_center")
	return ..()

/obj/machinery/atmospherics/pipe/manifold/SetInitDirections()
	initialize_directions = NORTH|SOUTH|EAST|WEST
	initialize_directions &= ~dir

/obj/machinery/atmospherics/pipe/manifold/update_overlays()
	. = ..()
	PIPE_LAYER_DOUBLE_SHIFT(center, pipe_layer)
	. += center
	//Add non-broken pieces
	for(var/i in 1 to device_type)
		if(connected[i])
			. += getpipeimage(icon, "pipe-[pipe_layer]", get_dir(src, connected[i]))


