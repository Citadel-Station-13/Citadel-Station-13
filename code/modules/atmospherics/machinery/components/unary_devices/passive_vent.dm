ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/unary/passive_vent, "passive_vent_map")

/obj/machinery/atmospherics/component/unary/passive_vent
	icon = 'icons/modules/atmospherics/components/vent.dmi'
	icon_state = "passive_vent_map"

	name = "passive vent"
	desc = "It is an open vent."
	can_unwrench = TRUE

	level = 1
	interacts_with_air = TRUE
	layer = GAS_SCRUBBER_LAYER

	pipe_state = "pvent"

/obj/machinery/atmospherics/component/unary/passive_vent/update_icon_nopipes()
	cut_overlays()
	if(showpipe)
		var/image/cap = getpipeimage(icon, "vent_cap", initialize_directions, pipe_layer = pipe_layer)
		add_overlay(cap)
	icon_state = "passive_vent"

/obj/machinery/atmospherics/component/unary/passive_vent/process_atmos()
	..()

	var/active = FALSE

	var/datum/gas_mixture/external = loc.return_air()
	var/datum/gas_mixture/internal = airs[1]
	var/external_pressure = external.return_pressure()
	var/internal_pressure = internal.return_pressure()
	var/pressure_delta = abs(external_pressure - internal_pressure)

	if(pressure_delta > 0.5)
		equalize_all_gases_in_list(list(internal,external))
		active = TRUE

	active = internal.temperature_share(external, OPEN_HEAT_TRANSFER_COEFFICIENT) || active

	if(active)
		air_update_turf()
		MarkDirty()

/obj/machinery/atmospherics/component/unary/passive_vent/can_crawl_through()
	return TRUE
