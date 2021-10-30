/**
 * Gas pumps
 *
 * Has settings for
 * - max pressure to pressurize to
 * - max volume to allow flow
 * - max power to use in watts
 */
ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/binary/pump, "volpump_map")
/obj/machinery/atmospherics/component/binary/pump
	icon = 'icons/modules/atmospherics/components/pump.dmi'
	icon_state = "volpump_map"
	name = "gas pump"
	desc = "A powered gas pump."

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

/obj/machinery/atmospherics/component/binary/pump/Destroy()
	SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/atmospherics/component/binary/pump/update_icon_state()
	. = ..()
	icon_state = on && is_operational() ? "volpump_on" : "volpump_off"

/obj/machinery/atmospherics/component/binary/pump/process_atmos()
	active_power_usage = idle_power_usage
	last_power_draw = last_transfer_rate = 0
	if(!on || !is_operational())
		return

	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]
	if(air2.return_pressure() > pressure_setting)
		return
	var/old_moles = air1.total_moles()
	var/pressure_delta = pressure_setting - air1.return_pressure()
	var/transfer_moles = pressure_delta*air2.return_volume()/(air1.return_temperature() * R_IDEAL_GAS_EQUATION)
	active_power_usage = last_power_draw = pump_gas(air1, air2, clamp((rate_setting / air1.return_volume()) * air1.total_moles(), 0, transfer_moles), power_setting, power_efficiency)
	MarkDirty()
	last_transfer_rate = round((1 - (air1.total_moles() / old_moles)) * air2.return_volume(), 0.1)

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
		ui = new(user, src, "AtmosPowerControl", name)
		ui.open()

/obj/machinery/atmospherics/component/binary/pump/ui_data()
	var/data = list()
	data["on"] = on
	data["rate"] = round(transfer_rate)
	data["max_rate"] = round(MAX_TRANSFER_RATE)
	return data

/obj/machinery/atmospherics/component/binary/pump/atmosinit()
	. = ..()
	set_frequency(frequency)

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
