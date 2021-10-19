//4-Way Manifold
ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w)

/obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w
	icon = 'icons/modules/atmospherics/pipes/he_manifold4.dmi'
	icon_state = "manifold4w"

	name = "4-way pipe manifold"
	desc = "A manifold composed of heat-exchanging pipes."

	initialize_directions = NORTH|SOUTH|EAST|WEST

	device_type = QUATERNARY

	construction_type = /obj/item/pipe/quaternary
	pipe_state = "he_manifold4w"

	var/mutable_appearance/center

/obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w/New()
	icon_state = ""
	center = mutable_appearance(icon, "manifold4w_center")
	return ..()

/obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w/SetInitDirections()
	initialize_directions = initial(initialize_directions)

/obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w/update_overlays()
	. = ..()
	PIPE_LAYER_DOUBLE_SHIFT(center, pipe_layer)
	. += center

	//Add non-broken pieces
	for(var/i in 1 to device_type)
		if(connected[i])
			. += getpipeimage(icon, "pipe-[pipe_layer]", get_dir(src, connected[i]))
