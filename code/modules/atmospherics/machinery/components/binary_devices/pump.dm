/**
 * Gas pumps
 *
 * Has settings for
 * - max pressure to pressurize to
 * - max volume to allow flow
 * - max power to use in watts
 */


# warn implement everything

ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/binary/pump, "volpump_map")
/obj/machinery/atmospherics/component/binary/pump
	icon = 'icons/modules/atmospherics/components/pump.dmi'
	icon_state = "volpump_map"
	name = "volumetric gas pump"
	desc = "A pump that moves gas by volume."

	can_unwrench = TRUE
	shift_to_layer = TRUE

	var/transfer_rate = MAX_TRANSFER_RATE

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

	construction_type = /obj/item/pipe/directional
	pipe_state = "volumepump"

	allow_alt_click_max_rate = TRUE
	ui_pump_control_capabilities = ATMOS_UI_CONTROL_POWER | ATMOS_UI_CONTROL_VOLUME | ATMOS_UI_CONTROL_PRESSURE | ATMOS_UI_CONTROL_ACTIVE | ATMOS_UI_POWER_USAGE | ATMOS_UI_FLOW_RATE
	allow_ctrl_click_toggle_power = TRUE

/obj/machinery/atmospherics/component/binary/pump/examine(mob/user)
	. = ..()
	. += "<span class='notice'>You can hold <b>Ctrl</b> and click on it to toggle it on and off.</span>"
	. += "<span class='notice'>You can hold <b>Alt</b> and click on it to maximize its pressure.</span>"

/obj/machinery/atmospherics/component/binary/pump/Destroy()
	SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/atmospherics/component/binary/pump/update_icon_nopipes()
	icon_state = on && is_operational() ? "volpump_on" : "volpump_off"

/obj/machinery/atmospherics/component/binary/pump/process_atmos()
//	..()
	if(!on || !is_operational())
		return

	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]

// Pump mechanism just won't do anything if the pressure is too high/too low

	var/input_starting_pressure = air1.return_pressure()
	var/output_starting_pressure = air2.return_pressure()

	if((input_starting_pressure < 0.01) || (output_starting_pressure > 9000))
		return

	var/transfer_ratio = transfer_rate/air1.return_volume()

	air1.transfer_ratio_to(air2,transfer_ratio)

	update_parents()

/obj/machinery/atmospherics/component/binary/pump/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency)

/obj/machinery/atmospherics/component/binary/pump/proc/broadcast_status()
	if(!radio_connection)
		return

	var/datum/signal/signal = new(list(
		"tag" = id,
		"device" = "APV",
		"power" = on,
		"transfer_rate" = transfer_rate,
		"sigtype" = "status"
	))
	radio_connection.post_signal(src, signal)

/obj/machinery/atmospherics/component/binary/pump/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosPump", name)
		ui.open()

/obj/machinery/atmospherics/component/binary/pump/ui_data()
	var/data = list()
	data["on"] = on
	data["rate"] = round(transfer_rate)
	data["max_rate"] = round(MAX_TRANSFER_RATE)
	return data

/obj/machinery/atmospherics/component/binary/pump/atmosinit()
	..()

	set_frequency(frequency)

/obj/machinery/atmospherics/component/binary/pump/ui_act(action, params)
	if(..())
		return
	var/turf/T = get_turf(src)
	var/area/A = get_area(src)
	switch(action)
		if("power")
			on = !on
			message_admins("Pump, [src.name], turned [on ? "on" : "off"] by [ADMIN_LOOKUPFLW(usr)] at [ADMIN_COORDJMP(T)], [A]")
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("rate")
			var/rate = params["rate"]
			if(rate == "max")
				rate = MAX_TRANSFER_RATE
				. = TRUE
			else if(rate == "input")
				rate = input("New transfer rate (0-[MAX_TRANSFER_RATE] L/s):", name, transfer_rate) as num|null
				if(!isnull(rate) && !..())
					. = TRUE
			else if(text2num(rate) != null)
				rate = text2num(rate)
				. = TRUE
			if(.)
				transfer_rate = clamp(rate, 0, MAX_TRANSFER_RATE)
				investigate_log("was set to [transfer_rate] L/s by [key_name(usr)]", INVESTIGATE_ATMOS)
	update_icon()

/obj/machinery/atmospherics/component/binary/pump/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return

	var/old_on = on //for logging

	if("power" in signal.data)
		on = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		on = !on

	if("set_transfer_rate" in signal.data)
		var/datum/gas_mixture/air1 = airs[1]
		transfer_rate = clamp(text2num(signal.data["set_transfer_rate"]),0,air1.return_volume())

	if(on != old_on)
		investigate_log("was turned [on ? "on" : "off"] by a remote signal", INVESTIGATE_ATMOS)

	if("status" in signal.data)
		broadcast_status()
		return //do not update_icon

	broadcast_status()
	update_icon()

/obj/machinery/atmospherics/component/binary/pump/power_change()
	..()
	update_icon()

/obj/machinery/atmospherics/component/binary/pump/can_unwrench(mob/user)
	. = ..()
	var/area/A = get_area(src)
	if(. && on && is_operational())
		to_chat(user, "<span class='warning'>You cannot unwrench [src], turn it off first!</span>")
		return FALSE
	else
		investigate_log("Pump, [src.name], was unwrenched by [key_name(usr)] at [x], [y], [z], [A]", INVESTIGATE_ATMOS)
		message_admins("Pump, [src.name], was unwrenched by [ADMIN_LOOKUPFLW(user)] at [A]")
		return TRUE

// Mapping

ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/binary/pump/on, "volpump_on_map")
/obj/machinery/atmospherics/component/binary/pump/on
	on = TRUE
	icon_state = "volpump_on_map"


// Every cycle, the pump uses the air in air_in to try and make air_out the perfect pressure.
//
// node1, air1, network1 correspond to input
// node2, air2, network2 correspond to output
//
// Thus, the two variables affect pump operation are set in New():
//   air1.volume
//     This is the volume of gas available to the pump that may be transfered to the output
//   air2.volume
//     Higher quantities of this cause more air to be perfected later
//     but overall network volume is also increased as this increases...

/obj/machinery/atmospherics/component/binary/pump
	icon_state = "pump_map-2"
	name = "gas pump"
	desc = "A pump that moves gas by pressure."

	can_unwrench = TRUE
	shift_to_layer = TRUE

	var/target_pressure = ONE_ATMOSPHERE

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

	construction_type = /obj/item/pipe/directional
	pipe_state = "pump"

	allow_alt_click_max_rate = TRUE
	allow_ctrl_click_toggle_power = TRUE

/obj/machinery/atmospherics/component/binary/pump/examine(mob/user)
	. = ..()
	. += "<span class='notice'>You can hold <b>Ctrl</b> and click on it to toggle it on and off.</span>"
	. += "<span class='notice'>You can hold <b>Alt</b> and click on it to maximize its pressure.</span>"

/obj/machinery/atmospherics/component/binary/pump/Destroy()
	SSradio.remove_object(src,frequency)
	if(radio_connection)
		radio_connection = null
	return ..()

/obj/machinery/atmospherics/component/binary/pump/update_icon_nopipes()
	icon_state = (on && is_operational()) ? "pump_on" : "pump_off"

/obj/machinery/atmospherics/component/binary/pump/process_atmos()
//	..()
	if(!on || !is_operational())
		return

	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]

	var/output_starting_pressure = air2.return_pressure()

	if((target_pressure - output_starting_pressure) < 0.01)
		//No need to pump gas if target is already reached!
		return

	//Calculate necessary moles to transfer using PV=nRT
	if((air1.total_moles() > 0) && (air1.return_temperature()>0))
		var/pressure_delta = target_pressure - output_starting_pressure
		var/transfer_moles = pressure_delta*air2.return_volume()/(air1.return_temperature() * R_IDEAL_GAS_EQUATION)

		air1.transfer_to(air2,transfer_moles)

		update_parents()

//Radio remote control
/obj/machinery/atmospherics/component/binary/pump/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/component/binary/pump/proc/broadcast_status()
	if(!radio_connection)
		return

	var/datum/signal/signal = new(list(
		"tag" = id,
		"device" = "AGP",
		"power" = on,
		"target_output" = target_pressure,
		"sigtype" = "status"
	))
	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/component/binary/pump/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosPump", name)
		ui.open()

/obj/machinery/atmospherics/component/binary/pump/ui_data()
	var/data = list()
	data["on"] = on
	data["pressure"] = round(target_pressure)
	data["max_pressure"] = round(MAX_OUTPUT_PRESSURE)
	return data

/obj/machinery/atmospherics/component/binary/pump/ui_act(action, params)
	if(..())
		return
	var/turf/T = get_turf(src)
	var/area/A = get_area(src)
	switch(action)
		if("power")
			on = !on
			message_admins("Pump, [src.name], turned [on ? "on" : "off"] by [ADMIN_LOOKUPFLW(usr)] at [ADMIN_COORDJMP(T)], [A]")
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "max")
				pressure = MAX_OUTPUT_PRESSURE
				. = TRUE
			else if(pressure == "input")
				pressure = input("New output pressure (0-[MAX_OUTPUT_PRESSURE] kPa):", name, target_pressure) as num|null
				if(!isnull(pressure) && !..())
					. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				target_pressure = clamp(pressure, 0, MAX_OUTPUT_PRESSURE)
				investigate_log("was set to [target_pressure] kPa by [key_name(usr)]", INVESTIGATE_ATMOS)
	update_icon()

/obj/machinery/atmospherics/component/binary/pump/atmosinit()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/component/binary/pump/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return

	var/old_on = on //for logging

	if("power" in signal.data)
		on = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		on = !on

	if("set_output_pressure" in signal.data)
		target_pressure = clamp(text2num(signal.data["set_output_pressure"]),0,ONE_ATMOSPHERE*50)

	if(on != old_on)
		investigate_log("was turned [on ? "on" : "off"] by a remote signal", INVESTIGATE_ATMOS)

	if("status" in signal.data)
		broadcast_status()
		return

	broadcast_status()
	update_icon()

/obj/machinery/atmospherics/component/binary/pump/power_change()
	..()
	update_icon()

/obj/machinery/atmospherics/component/binary/pump/can_unwrench(mob/user)
	. = ..()
	var/area/A = get_area(src)
	if(. && on && is_operational())
		to_chat(user, "<span class='warning'>You cannot unwrench [src], turn it off first!</span>")
		return FALSE
	else
		investigate_log("Pump, [src.name], was unwrenched by [key_name(usr)] at [x], [y], [z], [A]", INVESTIGATE_ATMOS)
		message_admins("Pump, [src.name], was unwrenched by [ADMIN_LOOKUPFLW(user)] at [A]")
		return TRUE

// Every cycle, the pump uses the air in air_in to try and make air_out the perfect pressure.
//
// node1, air1, network1 correspond to input
// node2, air2, network2 correspond to output
//
// Thus, the two variables affect pump operation are set in New():
//   air1.volume
//     This is the volume of gas available to the pump that may be transfered to the output
//   air2.volume
//     Higher quantities of this cause more air to be perfected later
//     but overall network volume is also increased as this increases...
