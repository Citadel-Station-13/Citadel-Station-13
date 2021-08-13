ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/unary/portables_connector, "connector_map")

/obj/machinery/atmospherics/component/unary/portables_connector
	icon_state = "connector_map"
	name = "connector port"
	desc = "For connecting portables devices related to atmospherics control."
	icon = 'icons/obj/atmospherics/component/unary_devices.dmi'
	can_unwrench = TRUE
	use_power = NO_POWER_USE
	level = 0
	layer = GAS_FILTER_LAYER
	pipe_flags = PIPE_ONE_PER_TURF
	pipe_state = "connector"

	var/obj/machinery/portable_atmospherics/connected_device

/obj/machinery/atmospherics/component/unary/portables_connector/InitAtmos()
	. = ..()
	var/datum/gas_mixture/air_contents = airs[1]
	air_contents.set_volume(0)

/obj/machinery/atmospherics/component/unary/portables_connector/Destroy()
	if(connected_device)
		connected_device.disconnect()
	return ..()

/obj/machinery/atmospherics/component/unary/portables_connector/update_icon_nopipes()
	icon_state = "connector"
	if(showpipe)
		var/image/cap = getpipeimage(icon, "connector_cap", initialize_directions, pipe_layer = pipe_layer)
		add_overlay(cap)

/obj/machinery/atmospherics/component/unary/portables_connector/process_atmos()
	if(!connected_device)
		return
	MarkDirty()

/obj/machinery/atmospherics/component/unary/portables_connector/can_unwrench(mob/user)
	. = ..()
	if(. && connected_device)
		to_chat(user, "<span class='warning'>You cannot unwrench [src], detach [connected_device] first!</span>")
		return FALSE

/obj/machinery/atmospherics/component/unary/portables_connector/proc/portableConnectorReturnAir()
	return connected_device.portableConnectorReturnAir()
