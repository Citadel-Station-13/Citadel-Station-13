ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/mixer)

/obj/machinery/atmospherics/component/trinary/mixer
	icon_state = "mixer_off_map"
	density = FALSE

	name = "gas mixer"
	desc = "Very useful for mixing gasses."

	can_unwrench = TRUE

	var/target_pressure = ONE_ATMOSPHERE
	var/node1_concentration = 0.5
	var/node2_concentration = 0.5

	construction_type = /obj/item/pipe/trinary/flippable
	pipe_state = "mixer"

	allow_alt_click_max_rate = TRUE
	allow_ctrl_click_toggle_power = TRUE
	ui_pump_control_capabilities = ATMOS_UI_CONTROL_POWER | ATMOS_UI_CONTROL_PRESSURE | ATMOS_UI_CONTROL_ACTIVE | ATMOS_UI_POWER_USAGE | ATMOS_UI_FLOW_RATE
	//node 3 is the outlet, nodes 1 & 2 are intakes

/obj/machinery/atmospherics/component/trinary/mixer/t_section
	t_layout = TRUE
	icon_state = "mixer_off_t_map"

/obj/machinery/atmospherics/component/trinary/mixer/update_overlays()
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

/obj/machinery/atmospherics/component/trinary/mixer/update_icon_state()
	var/on_state = on && connected[1] && connected[2] && connected[3] && is_operational()
	icon_state = "mixer_[on_state ? "on" : "off"][t_layout? "_t" : (flipped ? "_f" : "")]"

/obj/machinery/atmospherics/component/trinary/mixer/InitAtmos()
	. = ..()
	var/datum/gas_mixture/air3 = airs[3]
	air3.set_volume(volume * 2)		// give output a volume bias

/obj/machinery/atmospherics/component/trinary/mixer/process_atmos()
	active_power_usage = idle_power_usage
	last_power_draw = 0
	if(!on || !(connected[1] && connected[2] && connected[3]) || !is_operational())
		return
	var/datum/gas_mixture/output_air = airs[3]
	var/datum/gas_mixture/input_one = airs[1]
	var/old_moles = input_one.total_moles()
	// cheap calculation instead of transfer_moles calculation
	if(output_air.return_pressure() < pressure_setting)
		return
	last_power_draw = active_power_usage = mix_gas(list(input_one = node1_concentration, airs[2] = node2_concentration), output_air, null, power_rating, power_efficiency)
	last_transfer_rate = round((1 - (input_one.total_moles() / old_moles)) * input_one.return_volume(), 0.1)

/obj/machinery/atmospherics/component/trinary/mixer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosMixer", name)
		ui.open()

/obj/machinery/atmospherics/component/trinary/mixer/ui_data()
	. = ..()
	.["node1_concentration"] = round(node1_concentration*100, 1)
	.["node2_concentration"] = round(node2_concentration*100, 1)

/obj/machinery/atmospherics/component/trinary/mixer/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("node1")
			var/value = text2num(params["concentration"])
			adjust_node1_value(value)
			investigate_log("was set to [node1_concentration] % on node 1 by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("node2")
			var/value = text2num(params["concentration"])
			adjust_node1_value(100 - value)
			investigate_log("was set to [node2_concentration] % on node 2 by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
	update_icon()

/obj/machinery/atmospherics/component/trinary/mixer/proc/adjust_node1_value(newValue)
	node1_concentration = newValue / 100
	node2_concentration = 1 - node1_concentration

/obj/machinery/atmospherics/component/trinary/mixer/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational())
		to_chat(user, "<span class='warning'>You cannot unwrench [src], turn it off first!</span>")
		return FALSE

// mapping

ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/mixer/on)
/obj/machinery/atmospherics/component/trinary/mixer/on
	on = TRUE
	icon_state = "mixer_on_map"

ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/mixer/flipped)
/obj/machinery/atmospherics/component/trinary/mixer/flipped
	icon_state = "mixer_off_f_map"
	flipped = TRUE

ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/mixer/flipped/on)
/obj/machinery/atmospherics/component/trinary/mixer/flipped/on
	on = TRUE
	icon_state = "mixer_on_f_map"

ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/trinary/mixer/t_section/on)
/obj/machinery/atmospherics/component/trinary/mixer/t_section/on
	on = TRUE
	icon_state = "mixer_on_t_map"

/obj/machinery/atmospherics/component/trinary/mixer/airmix //For standard airmix to distro
	name = "air mixer"
	icon_state = "mixer_on_map"
	node1_concentration = N2STANDARD
	node2_concentration = O2STANDARD
	pressure_setting = ATMOSMECH_PUMP_PRESSURE_SANE
	on = TRUE

/obj/machinery/atmospherics/component/trinary/mixer/airmix/inverse
	node1_concentration = O2STANDARD
	node2_concentration = N2STANDARD

/obj/machinery/atmospherics/component/trinary/mixer/airmix/flipped
	icon_state = "mixer_on_f"
	flipped = TRUE

/obj/machinery/atmospherics/component/trinary/mixer/airmix/flipped/inverse
	node1_concentration = O2STANDARD
	node2_concentration = N2STANDARD
