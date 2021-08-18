ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmosphehrics/component/unary/outlet_injector, "inje_map")

/obj/machinery/atmospherics/component/unary/outlet_injector
	icon_state = "inje_map"
	name = "air injector"
	desc = "Has a valve and pump attached to it."
	use_power = IDLE_POWER_USE
	can_unwrench = TRUE
	shift_to_layer = TRUE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF //really helpful in building gas chambers for xenomorphs

	var/injecting = FALSE

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

	level = 1
	interacts_with_air = TRUE
	layer = GAS_SCRUBBER_LAYER
	power_efficiency = 2

	pipe_state = "injector"

	allow_alt_click_max_rate = TRUE
	allow_ctrl_click_toggle_power = TRUE
	ui_pump_control_capabilities = ATMOS_UI_CONTROL_POWER | ATMOS_UI_CONTROL_VOLUME | ATMOS_UI_CONTROL_ACTIVE | ATMOS_UI_POWER_USAGE | ATMOS_UI_FLOW_RATE

/obj/machinery/atmospherics/component/unary/outlet_injector/Destroy()
	SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/atmospherics/component/unary/outlet_injector/update_icon_state()
	. = ..()
	if(!connected[1] || !on || !is_operational())
		icon_state = "inje_off"
	else
		icon_state = "inje_on"

/obj/machinery/atmospherics/component/unary/outlet_injector/update_overlays()
	. = ..()
	if(showpipe)
		// everything is already shifted so don't shift the cap
		. += getpipeimage(icon, "inje_cap", initialize_directions)

/obj/machinery/atmospherics/component/unary/outlet_injector/process_atmos()
	active_power_usage = idle_power_usage
	last_power_draw = last_transfer_rate = 0
	injecting = FALSE
	active_power_usage = idle_power_usage

	if(!on || !is_operational())
		return

	var/datum/gas_mixture/air_contents = airs[1]
	var/turf/T = loc
	if(!istype(T))
		return
	if(air_contents.total_moles() > 0)
		var/last_pressure = air_contents.return_pressure()
		active_power_usage = last_power_draw = pump_gas(air_contents, T.return_air(), (rate_setting / air_contents.return_volume()) * air_contents.total_moles(), power_setting, power_efficiency)
		last_transfer_rate = (air_contents.return_pressure() / last_pressure) * air_contents.return_volume()
		air_update_turf()
		MarkDirty()

/obj/machinery/atmospherics/component/unary/outlet_injector/proc/inject()
	if(on || injecting || !is_operational())
		return

	injecting = TRUE
	flick("inje_inject", src)

	var/datum/gas_mixture/air_contents = airs[1]
	var/turf/T = loc
	if(!istype(T))
		return
	if(air_contents.total_moles() > 0)
		var/last_pressure = air_contents.return_pressure()
		active_power_usage = last_power_draw = pump_gas(air_contents, T.return_air(), (rate_setting / air_contents.return_volume()) * air_contents.total_moles(), power_setting, power_efficiency)
		last_transfer_rate = (air_contents.return_pressure() / last_pressure) * air_contents.return_volume()
		air_update_turf()
		MarkDirty()

/obj/machinery/atmospherics/component/unary/outlet_injector/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency)

/obj/machinery/atmospherics/component/unary/outlet_injector/proc/broadcast_status()

	if(!radio_connection)
		return

	var/datum/signal/signal = new(list(
		"tag" = id,
		"device" = "AO",
		"power" = on,
		"rate_setting" = rate_setting,
		//"timestamp" = world.time,
		"sigtype" = "status"
	))
	radio_connection.post_signal(src, signal)

/obj/machinery/atmospherics/component/unary/outlet_injector/InitAtmos()
	. = ..()
	set_frequency(frequency)
	broadcast_status()

/obj/machinery/atmospherics/component/unary/outlet_injector/receive_signal(datum/signal/signal)

	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return

	if("power" in signal.data)
		on = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		on = !on

	if("inject" in signal.data)
		INVOKE_ASYNC(src, .proc/inject)
		return

	if("set_volume_rate" in signal.data)
		var/number = text2num(signal.data["set_volume_rate"])
		var/datum/gas_mixture/air_contents = airs[1]
		rate_setting = clamp(number, 0, air_contents.return_volume())

	addtimer(CALLBACK(src, .proc/broadcast_status), 2)

	if(!("status" in signal.data)) //do not update_icon
		update_icon()


/obj/machinery/atmospherics/component/unary/outlet_injector/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosPump", name)
		ui.open()

/obj/machinery/atmospherics/component/unary/outlet_injector/ui_act(action, params)
	if((. = ..()))
		broadcast_status()

/obj/machinery/atmospherics/component/unary/outlet_injector/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational())
		to_chat(user, "<span class='warning'>You cannot unwrench [src], turn it off first!</span>")
		return FALSE

// mapping

ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/unary/outlet_injector/on, "inje_map_on")
/obj/machinery/atmospherics/component/unary/outlet_injector/on
	on = TRUE
	icon_state = "inje_map_on"

/obj/machinery/atmospherics/component/unary/outlet_injector/atmos
	frequency = FREQ_ATMOS_STORAGE
	on = TRUE
	rate_setting = 200

/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/atmos_waste
	name = "atmos waste outlet injector"
	id =  ATMOS_GAS_MONITOR_WASTE_ATMOS
/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/engine_waste
	name = "engine outlet injector"
	id = ATMOS_GAS_MONITOR_WASTE_ENGINE
/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/toxin_input
	name = "plasma tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_TOX
/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/oxygen_input
	name = "oxygen tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_O2
/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/nitrogen_input
	name = "nitrogen tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_N2
/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/mix_input
	name = "mix tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_MIX
/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/nitrous_input
	name = "nitrous oxide tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_N2O
/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/air_input
	name = "air mix tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_AIR
/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/carbon_input
	name = "carbon dioxide tank input injector"
	id = ATMOS_GAS_MONITOR_INPUT_CO2
/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/incinerator_input
	name = "incinerator chamber input injector"
	id = ATMOS_GAS_MONITOR_INPUT_INCINERATOR
/obj/machinery/atmospherics/component/unary/outlet_injector/atmos/toxins_mixing_input
	name = "toxins mixing input injector"
	id = ATMOS_GAS_MONITOR_INPUT_TOXINS_LAB
