ATMOS_MAPPING_LAYERS_PX(/obj/machinery/atmospherics/component/quaternary/filter)

/obj/machinery/atmospherics/component/quaternary/mixer
	name = "omni mixer"
	icon = 'icons/modules/atmospherics/machinery/omni_mixer.dmi'
	desc = "A 4-way mixer. Can be configured to take up to 3 inputs."
	icon_state = "mixer-map"
	allow_alt_click_max_rate = TRUE
	allow_ctrl_click_toggle_power = TRUE
	ui_pump_control_capabilities = ATMOS_UI_CONTROL_POWER | ATMOS_UI_CONTROL_VOLUME | ATMOS_UI_CONTROL_PRESSURE | ATMOS_UI_CONTROL_ACTIVE | ATMOS_UI_POWER_USAGE | ATMOS_UI_FLOW_RATE

	// note: indexes NESW 1234.

	/// output index
	var/output_side
	/// inputs - "[index]" to concentration
	var/list/inputs
	/// locked input index - don't ever change this concentration while auto-rebalancing
	var/locked_input

	// mappers
	/// initial output side - direction, not index
	var/output_preset
	/// initial concentration north
	var/input_north_preset
	/// initial concentration south
	var/input_south_preset
	/// initial concentration east
	var/input_east_preset
	/// initial concentration west
	var/input_west_preset

/obj/machinery/atmospherics/component/quaternary/mixer/Initialize()
	set_input_dir(NORTH, input_north_preset)
	set_input_dir(SOUTH, input_south_preset)
	set_input_dir(EAST, input_east_preset)
	set_input_dir(WEST, input_west_preset)
	set_output_dir(output_preset)
	. = ..()
	auto_balance()

/obj/machinery/atmospherics/component/quaternary/mixer/update_overlays()
	. = ..()
	var/on = src.on && output_side && length(inputs)
	var/mutable_appearance/out = mutable_appearance(icon, "output[on? "":"-off"]")
	out.dir = IndexToDir(output_side)
	for(var/i in inputs)
		var/mutable_appearance/in = mutable_appearance(icon, "input[on? "":"-off"]")
		in.dir = IndexToDir(text2num(i))

/obj/machinery/atmospherics/component/quaternary/mixer/proc/set_output(index)
	if(index < 0 || index > MaximumPossibleNodes())
		return
	output_side = index
	inputs -= "[index]"
	auto_balance()

/obj/machinery/atmospherics/component/quaternary/mixer/proc/set_output_dir(dir)
	return set_output(DirToIndex(dir))

/obj/machinery/atmospherics/component/quaternary/mixer/proc/set_input(index, concentration)
	if(index < 0 || index > MaximumPossibleNodes())
		return
	inputs["[index]"] = concentration
	auto_balance()

/obj/machinery/atmospherics/component/quaternary/mixer/proc/set_input_dir(dir, concentration)
	return set_input(DirToIndex(dir, concentration))

/obj/machinery/atmospherics/component/quaternary/mixer/proc/set_locked_input(index)
	if(index < 0 || index > MaximumPossibleNodes())
		return
	locked_input = index

/obj/machinery/atmospherics/component/quaternary/mixer/proc/set_locked_input_dir(dir)
	return set_locked_input(DirToIndex(dir))

/obj/machinery/atmospherics/component/quaternary/mixer/proc/auto_balance()
	if(!(flags_1 & INITIALIZED_1))
		return		// we do this at end of init
	inputs -= "[output_side]"
	for(var/index in inputs)
		var/i = text2num(index)
		if(i < 0 || i > MaximumPossibleNodes())
			inputs -= index
			stack_trace("removed invalid input index [index] from inputs")
			continue
#warn finish this sigh

/obj/machinery/atmospherics/component/quaternary/mixer/process_atmos(seconds, times_fired)
	active_power_usage = idle_power_usage
	last_power_draw = last_transfer_rate = 0
	if(!on || !is_operational() || !output_side || !length(inputs))
		return
	var/datum/gas_mixture/output_air = airs[output_side]
	if(output_air.return_pressure() > pressure_setting)
		return
	var/list/input_airs = list()
	for(var/str in inputs)
		input_airs[airs[text2num(str)]] = inputs[str]
	last_power_draw = active_power_usage = mix_gas()
		input_airs,
		output_air,
		(rate_setting / source_air.return_volume()) * source_air.total_moles(),
		power_setting,
		power_efficiency
	)
	MarkDirty()
	last_transfer_rate = round((1 - (source_air.total_moles() / old_moles)) * source_air.return_volume(), 0.1)

/obj/machinery/atmospherics/component/quaternary/mixer/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OmniMixer")
		ui.open()

/obj/machinery/atmospherics/component/quaternary/mixer/ui_static_data(mob/user)
	. = ..()
	.["gasids"] = GLOB.gas_data.ids
	.["north"] = DirToIndex(NORTH)
	.["south"] = DirToIndex(SOUTH)
	.["east"] = DirToIndex(EAST)
	.["west"] = DirToIndex(WEST)

/obj/machinery/atmospherics/component/quaternary/mixer/ui_data(mob/user)
	. = ..()
	.["output"] = output_side
	.["locked"] = locked_input
	.["north_con"] = inputs["[DirToIndex(NORTH)]"] || 0
	.["south_con"] = inputs["[DirToIndex(SOUTH)]"] || 0
	.["east_con"] = inputs["[DirToIndex(EAST)]"] || 0
	.["west_con"] = inputs["[DirToIndex(WEST)]"] || 0

/obj/machinery/atmospherics/component/quaternary/mixer/ui_act(action, params)
	. = ..()
	switch(action)
		if("set_output")
			set_output(text2num(params["side"]))
			#warn log
		if("set_input")
			set_input(text2num(params["side"]), text2num(params["concentration"]))
			#warn log
		if("lock")
			set_locked_input(text2num(params["side"]))
