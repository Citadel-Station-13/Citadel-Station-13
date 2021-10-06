ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/filter)
/obj/machinery/atmospherics/component/trinary/filter
	name = "gas filter"
	desc = "Very useful for filtering gasses."
	icon = 'icons/modules/atmospherics/filter.dmi'
	icon_state = "filter-map"
	density = FALSE
	can_unwrench = TRUE
	var/filter_type = null
	var/frequency = 0
	var/datum/radio_frequency/radio_connection

	construction_type = /obj/item/pipe/trinary/flippable
	pipe_state = "filter"

	allow_alt_click_max_rate = TRUE
	allow_ctrl_click_toggle_power = TRUE
	ui_pump_control_capabilities = ATMOS_UI_CONTROL_POWER | ATMOS_UI_CONTROL_VOLUME | ATMOS_UI_CONTROL_PRESSURE | ATMOS_UI_CONTROL_ACTIVE | ATMOS_UI_POWER_USAGE | ATMOS_UI_FLOW_RATE

ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/filter/t_section)
/obj/machinery/atmospherics/component/trinary/filter/t_section
	icon_state = "filter_off_t_map"
	t_layout = TRUE

/obj/machinery/atmospherics/component/trinary/filter/examine(mob/user)
	. = ..()
	. += "<span class='notice'>You can hold <b>Ctrl</b> and click on it to toggle it on and off.</span>"
	. += "<span class='notice'>You can hold <b>Alt</b> and click on it to maximize its flow rate.</span>"

/obj/machinery/atmospherics/component/trinary/filter/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/component/trinary/filter/Destroy()
	SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/atmospherics/component/trinary/filter/update_overlays()
	. = ..()
	var/list/connected_dirs = list()
	for(var/i in connected)
		connected_dirs |= get_dir(src, i)
	for(var/direction in GLOB.cardinals)
		if(!(direction in connected_dirs))
			continue
		var/obj/machinery/atmospherics/pipe/node = connected[GetNodeIndex(direction, pipe_layer)]
		var/image/cap
		if(node)
			cap = getpipeimage(icon, "cap", direction, node.pipe_color, pipe_layer = pipe_layer)
		else
			cap = getpipeimage(icon, "cap", direction, pipe_layer = pipe_layer)
		. += cap

/obj/machinery/atmospherics/component/trinary/filter/update_icon_state()
	var/on_state = on && connected[1] && connected[2] && connected[3] && is_operational()
	icon_state = "filter_[on_state ? "on" : "off"][t_layout? "_t" : ""][flipped ? "_f" : ""]"

/obj/machinery/atmospherics/component/trinary/filter/process_atmos()
	active_power_usage = idle_power_usage
	last_power_draw = last_transfer_rate = 0
	if(!on || !(connected[1] && connected[2] && connected[3]) || !is_operational())
		return

	var/datum/gas_mixture/sink_air = airs[3]
	var/datum/gas_mixture/filter_air = airs[2]
	// cheaper check. only pumps have precise checks
	if(sink_air.return_pressure() > pressure_setting || filter_air.return_pressure() > pressure_setting)
		return
	var/datum/gas_mixture/source_air = airs[1]
	var/old_moles = source_air.total_moles()
	last_power_draw = active_power_usage = filter_gas(
		list(filter_type = filter_air),
		source_air,
		sink_air,
		(rate_setting / source_air.return_volume()) * source_air.total_moles(),
		power_setting,
		power_efficiency
	)
	MarkDirty()
	last_transfer_rate = round((1 - (source_air.total_moles() / old_moles)) * source_air.return_volume(), 0.1)

/obj/machinery/atmospherics/component/trinary/filter/InitAtmos()
	set_frequency(frequency)
	return ..()

/obj/machinery/atmospherics/component/trinary/filter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosFilter", name)
		ui.open()

/obj/machinery/atmospherics/component/trinary/filter/ui_data()
	. = ..()
	.["filter_types"] = list()
	.["filter_types"] += list(list("name" = "Nothing", "id" = "", "selected" = !filter_type))
	for(var/id in GLOB.gas_data.ids)
		.["filter_types"] += list(list("name" = GLOB.gas_data.names[id], "id" = id, "selected" = (id == filter_type)))

/obj/machinery/atmospherics/component/trinary/filter/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("filter")
			filter_type = null
			var/filter_name = "nothing"
			var/gas = params["mode"]
			if(gas in GLOB.gas_data.names)
				filter_type = gas
				filter_name	= GLOB.gas_data.names[gas]
			investigate_log("was set to filter [filter_name] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
	update_appearance()

/obj/machinery/atmospherics/component/trinary/filter/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational())
		to_chat(user, "<span class='warning'>You cannot unwrench [src], turn it off first!</span>")
		return FALSE

// Mapping

ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/filter/on)
/obj/machinery/atmospherics/component/trinary/filter/on
	on = TRUE
	icon_state = "filter_on_map"

ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/filter/flipped)
/obj/machinery/atmospherics/component/trinary/filter/flipped
	icon_state = "filter_off_f_map"
	flipped = TRUE

ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/filter/flipped/on)
/obj/machinery/atmospherics/component/trinary/filter/flipped/on
	on = TRUE
	icon_state = "filter_on_f"

ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/filter/t_section/on)
/obj/machinery/atmospherics/component/trinary/filter/t_section/on
	on = TRUE

/obj/machinery/atmospherics/component/trinary/filter/atmos //Used for atmos waste loops
	on = TRUE
	icon_state = "filter_on_map"

/obj/machinery/atmospherics/component/trinary/filter/atmos/n2
	name = "nitrogen filter"
	filter_type = "n2"

/obj/machinery/atmospherics/component/trinary/filter/atmos/o2
	name = "oxygen filter"
	filter_type = "o2"

/obj/machinery/atmospherics/component/trinary/filter/atmos/co2
	name = "carbon dioxide filter"
	filter_type = "co2"

/obj/machinery/atmospherics/component/trinary/filter/atmos/n2o
	name = "nitrous oxide filter"
	filter_type = "n2o"

/obj/machinery/atmospherics/component/trinary/filter/atmos/plasma
	name = "plasma filter"
	filter_type = "plasma"

/obj/machinery/atmospherics/component/trinary/filter/atmos/flipped //This feels wrong, I know
	icon_state = "filter_on_f"
	flipped = TRUE

/obj/machinery/atmospherics/component/trinary/filter/atmos/flipped/n2
	name = "nitrogen filter"
	filter_type = "n2"

/obj/machinery/atmospherics/component/trinary/filter/atmos/flipped/o2
	name = "oxygen filter"
	filter_type = "o2"

/obj/machinery/atmospherics/component/trinary/filter/atmos/flipped/co2
	name = "carbon dioxide filter"
	filter_type = "co2"

/obj/machinery/atmospherics/component/trinary/filter/atmos/flipped/n2o
	name = "nitrous oxide filter"
	filter_type = "n2o"

/obj/machinery/atmospherics/component/trinary/filter/atmos/flipped/plasma
	name = "plasma filter"
	filter_type = "plasma"

// These two filter types have critical_machine flagged to on and thus causes the area they are in to be exempt from the Grid Check event.

/obj/machinery/atmospherics/component/trinary/filter/critical
	critical_machine = TRUE

/obj/machinery/atmospherics/component/trinary/filter/flipped/critical
	critical_machine = TRUE
