/obj/machinery/atmospherics/components/unary/relief_valve
	name = "pressure relief valve"
	desc = "A valve that opens to the air at a certain pressure, then closes once it goes below another."
	icon = 'icons/obj/atmospherics/components/unary_devices.dmi'
	icon_state = "relief_valve-e"
	var/opened = FALSE
	var/open_pressure = ONE_ATMOSPHERE * 3
	var/close_pressure = ONE_ATMOSPHERE
	pipe_state = "relief_valve-e"

/obj/machinery/atmospherics/components/unary/relief_valve/layer1
	piping_layer = PIPING_LAYER_MIN
	pixel_x = -PIPING_LAYER_P_X
	pixel_y = -PIPING_LAYER_P_Y

/obj/machinery/atmospherics/components/unary/relief_valve/layer3
	piping_layer = PIPING_LAYER_MAX
	pixel_x = PIPING_LAYER_P_X
	pixel_y = PIPING_LAYER_P_Y

/obj/machinery/atmospherics/components/unary/relief_valve/atmos
	var/close_pressure = ONE_ATMOSPHERE * 2

/obj/machinery/atmospherics/components/unary/relief_valve/atmos/atmos_waste
	name = "atmos waste relief valve"
	id =  ATMOS_GAS_MONITOR_WASTE_ATMOS

/obj/machinery/atmospherics/components/unary/relief_valve/update_icon_nopipes()
	cut_overlays()

	if(!nodes[1] || !opened || !is_operational())
		icon_state = "relief_valve-e"
		return

	icon_state = "relief_valve-e-blown"

/obj/machinery/atmospherics/components/unary/outlet_injector/process_atmos()
	..()

	if(!is_operational())
		return

	var/datum/gas_mixture/air_contents = airs[1]
	var/our_pressure = air_contents.return_pressure()
	if(opened && our_pressure < close_pressure)
		opened = FALSE
	else if(!opened && our_pressure >= open_pressure)
		opened = TRUE
	if(opened && air_contents.temperature > 0)
		var/datum/gas_mixture/environment = loc.return_air()
		var/pressure_delta = our_pressure - environment.return_pressure()
		var/transfer_moles = pressure_delta*environment.volume/(air1.temperature * R_IDEAL_GAS_EQUATION)
		if(transfer_moles > 0)
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

			loc.assume_air(removed)
			air_update_turf()

			update_parents()
