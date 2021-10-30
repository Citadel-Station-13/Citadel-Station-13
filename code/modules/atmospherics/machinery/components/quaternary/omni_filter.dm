ATMOS_MAPPING_LAYERS_PX(/obj/machinery/atmospherics/component/quaternary/filters)

/obj/machinery/atmospherics/component/quaternary/filter
	name = "omni filter"
	desc = "A 4 way filter. Can be configured to have up to 2 filtered outputs."
	icon = 'icons/modules/atmospherics/machinery/omni_filter.dmi'
	icon_state = "filter-map"
	allow_alt_click_max_rate = TRUE
	allow_ctrl_click_toggle_power = TRUE
	ui_pump_control_capabilities = ATMOS_UI_CONTROL_POWER | ATMOS_UI_CONTROL_VOLUME | ATMOS_UI_CONTROL_PRESSURE | ATMOS_UI_CONTROL_ACTIVE | ATMOS_UI_POWER_USAGE | ATMOS_UI_FLOW_RATE

	// note: indexes NESW 1234.
	/// input index
	var/input_index
	/// output index
	var/output_index
	/// index to gasid - "[index]" = gasid
	var/list/filtering
	/// preset for mapping
	var/input_preset
	/// preset for mapping
	var/output_preset
	/// initial gasid north
	var/north_gasid_preset
	/// initial gasid south
	var/south_gasid_preset
	/// initial gasid east
	var/east_gasid_preset
	/// initial gasid west
	var/west_gasid_preset

/obj/machinery/atmospherics/component/quaternary/filter/Initialize()
	set_filter_dir(NORTH, north_gasid_preset)
	set_filter_dir(SOUTH, south_gasid_preset)
	set_filter_dir(EAST, east_gasid_preset)
	set_filter_dir(WEST, west_gasid_preset)
	set_input_dir(input_preset)
	set_output_dir(output_preset)
	return ..()

/obj/machinery/atmospherics/component/quaternary/filter/proc/set_input(index)
	if(!isnum(index))
		return
	input_index = index
	if(output_index == index)
		output_index = null
	filtering -= "[index]"

/obj/machinery/atmospherics/component/quaternary/filter/proc/set_input_dir(dir)
	if(isnull(dir))
		return
	return set_input(DirToIndex(dir))

/obj/machinery/atmospherics/component/quaternary/filter/proc/set_output(index)
	if(!isnum(index))
		return
	ASSERT(isnum(index))
	output_index = index
	if(input_index == index)
		input_index = null
	filtering -= "[index]"

/obj/machinery/atmospherics/component/quaternary/filter/proc/set_output_dir(dir)
	if(isnull(dir))
		return
	return set_output(DirToIndex(dir))

/obj/machinery/atmospherics/component/quaternary/filter/proc/set_filter(index, gasid)
	if(!isnum(index) || !istext(gasid))
		return
	filtering["[index]"] = gasid
	for(var/other in filter)
		if(filtering[other] == gasid)
			filtering -= other
	if(input_index == index)
		input_index = null
	if(output_index == index)
		output_index = null

/obj/machinery/atmospherics/component/quaternary/filter/proc/set_filter_dir(dir, gasid)
	if(!isnum(dir))
		return
	return set_filter(DirToIndex(dir), gasid)

/obj/machinery/atmospherics/component/quaternary/filter/update_overlays()
	. = ..()
	var/on = src.on && input_index && output_index
	var/mutable_appearance/out = mutable_appearance(icon, "output[on? "":"-off"]")
	out.dir = IndexToDir(output_index)
	var/mutable_appearance/in = mutable_appearance(icon, "input[on?"":"-off"]")
	in.dir = IndexToDir(input_index)
	for(var/i in filtering)
		var/mutable_appearance/filt = mutable_appearance(icon, "filter[on? "":"-off"]")
		filt.dir = IndexToDir(text2num(i))

/obj/machinery/atmospherics/component/quaternary/filter/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OmniFilter")
		ui.open()

/obj/machinery/atmospherics/component/quaternary/filter/ui_static_data(mob/user)
	. = ..()
	.["gasids"] = GLOB.gas_data.ids
	.["north"] = DirToIndex(NORTH)
	.["south"] = DirToIndex(SOUTH)
	.["east"] = DirToIndex(EAST)
	.["west"] = DirToIndex(WEST)

/obj/machinery/atmospherics/component/quaternary/filter/ui_data(mob/user)
	. = ..()
	.["input"] = input_index
	.["output"] = output_index

/obj/machinery/atmospherics/component/quaternary/filter/ui_act(action, params)
	. = ..()
	switch(action)
		if("set_input")
			set_input(text2num(params["side"]))
			#warn log
		if("set_output")
			set_output(text2num(params["side"]))
			#warn log
		if("set_side")
			set_filter(text2num(params["side"]), params["gasid"])
			#warn log

/obj/machinery/atmospherics/component/quaternary/filter/process_atmos(seconds, times_fired)
	. = ..()
	active_power_usage = idle_power_usage
	last_power_draw = last_transfer_rate = 0
	if(!on || !is_operational() || !output_side || !input_side)
		return
	var/datum/gas_mixture/output_air = airs[output_side]
	var/datum/gas_mixture/input_air = airs[input_side]
	if(output_air.return_pressure() > pressure_setting)
		return
	var/list/directed = list()
	for(var/indexstr in filtering)
		var/index = text2num(indexstr)
		directed[airs[index]] = filtering[indexstr]
	for(var/i in directed)
		var/datum/gas_mixture/GM = i
		if(GM.return_pressure() > pressure_setting)
			return
	last_power_draw = active_power_usage = filter_gas(
		directed,
		intput_air,
		output_air,
		(rate_setting / source_air.return_volume()) * source_air.total_moles(),
		power_setting,
		power_efficiency
	)
	MarkDirty()
	last_transfer_rate = round((1 - (source_air.total_moles() / old_moles)) * source_air.return_volume(), 0.1)
