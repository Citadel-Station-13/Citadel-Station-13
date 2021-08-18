// So much of atmospherics.dm was used solely by components, so separating this makes things all a lot cleaner.
// On top of that, now people can add component-speciic procs/vars if they want!

/obj/machinery/atmospherics/component
	/// Welded vents/scrubbers
	var/welded = FALSE
	// Air movement calculations
	// Not all components will use these, but they're pretty much standard.
	/// Maximum power rating - maximum power it can draw for operations in watts.
	var/power_rating = ATMOSMECH_POWER_RATING
	/// Current power rating - defaults to max
	var/power_setting = ATMOSMECH_POWER_RATING
	/// Max operating pressure - cannot pressurize above this, but can accept above this
	var/max_pressure = ATMOSMECH_PUMP_PRESSURE
	/// What the pressure is set to on alt click, and the "nominal" maximum pressure
	var/max_pressure_nominal = ATMOSMECH_PUMP_PRESSURE_SANE
	/// Current pressure setting - defaults to max
	var/pressure_setting = ATMOSMECH_PUMP_PRESSURE
	/// Max operating rate - cannot pump faster than this (L/s)
	var/max_rate = ATMOSMECH_PUMP_RATE
	/// Current rate setting - defaults to max
	var/rate_setting = ATMOSMECH_PUMP_RATE
	/// Efficiency multiplier. This affects all machine ops, whether pumping/thermal operations for coolers/heaters and more.
	var/power_efficiency = 1
	/// Below this in moles, anything left is instantly moved. This ensures you can't require infinite power to drain something.
	var/moles_to_instant_pump = ATMOSMECH_INSTANT_PUMP_MOLES
	/// Below this in pressure, anything left is instantly moved. This ensures you can't require infinite power to drain something.
	var/pressure_to_instant_pump = ATMOSMECH_INSTANT_PUMP_PRESSURE
	/// Last flow rate, set by gas transfer procs [code/modules/atmospherics/gasmixtures/transfer_helpers.dm]. Has different contexts based on what proc you used.
	var/last_transfer_rate
	/// Last power usage, set by gas transfer procs [code/modules/atmospherics/gasmixtures/transfer_helpers.dm].
	var/last_power_draw
	/// Allow alt clicking to max everything out, that is also controllable from the UI. Reads ui_pump_control_capabilities.
	var/allow_alt_click_max_rate = FALSE
	/// Allow ctrl clicking to toggle on/off
	var/allow_ctrl_click_toggle_power = FALSE
	/// UI capabilities for power/pumping control. ALSO USED FOR ALLOW_ALT_CLICK_MAX_RATE!
	var/ui_pump_control_capabilities = NONE

	/// Pipelines this belongs to. This should have the same indices as [connected]
	var/list/datum/pipeline/pipelines
	/// Gas mixtures we contain. This should have the same indices as [connected]
	var/list/datum/gas_mixture/airs

	/// Volume of each of our airs
	var/volume = 200

	/// We shift ourselves to the layer we're on, rather than just rendering the pipe connections while staying static.
	var/shift_to_layer = FALSE
	/// We double-shift to the layer instead of single shift
	var/double_layer_shift = FALSE

	var/showpipe = FALSE

/obj/machinery/atmospherics/component/InitAtmos()
	pipelines = new /list(device_type)
	airs = new /list(device_type)
	for(var/i in 1 to device_type)
		airs[i] = new /datum/gas_mixture(volume)
	return ..()

// Iconnery

/obj/machinery/atmospherics/component/proc/update_icon_nopipes()
	return

/obj/machinery/atmospherics/component/update_overlays()
	. = ..()
	underlays.Cut()
	var/turf/T = loc
	if((level != 2) && (istype(T) && !T.intact))
		return

	if(pipe_flags & PIPE_ALL_LAYER)
		var/obj/machinery/atmospherics/other
		for(var/d in GLOB.cardinals)
			for(var/l in PIPE_LAYER_MIN to PIPE_LAYER_MAX)
				if((other = connected[GetNodeIndex(d, l)]))
					underlays += get_pipe_underlay("pipe_intact", d, other.pipe_color, l)
				else
					underlays += get_pipe_underlay("pipe_exposed", d, layer = l)
	else
		var/dirs_connected = NONE
		// get the connected
		for(var/i in 1 to device_type)
			if(connected[i])
				var/obj/machinery/atmospherics/other = connected[i]
				var/image/I = get_pipe_underlay("pipe_intact", get_dir(src, other), other.pipe_color, layer = shift_to_layer? PIPE_LAYER_DEFAULT : pipe_layer)
				underlays += I
				connected |= I.dir
		// get the disconnected
		for(var/d in GLOB.cardinals)
			if((initialize_directions & d) && !(dirs_connected & d))
				underlays += get_pipe_underlay("pipe_exposed", d, layer = shift_to_layer? PIPE_LAYER_DEFAULT : pipe_layer)

/obj/machinery/atmospherics/component/update_layer()
	. = ..()
	if(shift_to_layer)
		if(double_layer_shift)
			PIPE_LAYER_DOUBLE_SHIFT(src, pipe_layer)
		else
			PIPE_LAYER_SHIFT(src, pipe_layer)
	var/turf/T = loc
	if(level == 2 || (istype(T) && !T.intact))
		showpipe = TRUE
		plane = ABOVE_WALL_PLANE
	else
		showpipe = FALSE
		plane = FLOOR_PLANE

/obj/machinery/atmospherics/component/proc/get_pipe_underlay(state, dir, color, layer)
	if(color)
		. = getpipeimage('icons/obj/atmospherics/component/binary_devices.dmi', state, dir, color, pipe_layer = layer)
	else
		. = getpipeimage('icons/obj/atmospherics/component/binary_devices.dmi', state, dir, pipe_layer = layer)

/obj/machinery/atmospherics/component/Teardown()
	for(var/i in 1 to pipelines.len)
		if(pipelines[i])
			QDEL_NULL(pipelines[i])

/obj/machinery/atmospherics/component/Build()
	for(var/i in 1 to pipelines.len)
		if(!pipelines[i])
			var/datum/pipeline/PL = new
			pipelines[i] = PL
			PL.build_pipeline(src)

/obj/machinery/atmospherics/component/NullifyPipeline(datum/pipeline/removing)
	var/index = pipelines.Find(removing)
	if(!index)
		CRASH("FATAL: NullifyPipeline could not find [removing] in [src] ([COORD(src)])")
	pipelines[index] = null

/obj/machinery/atmospherics/component/SetPipeline(datum/pipeline/setting, obj/machinery/atmospherics/source)
	// We want to set the pipeline index that corrosponds to the node order
	var/index = connected.Find(source)
	if(!index)
		CRASH("FATAL: SetPipeline could not find [source] in [src] ([COORD(src)])")
	pipelines[index] = setting

/obj/machinery/atmospherics/component/ReplacePipeline(datum/pipeline/old, datum/pipeline/replacing)
	var/index = pipelines.Find(old)
	if(!index)
		CRASH("FATAL: ReplacePipeline() could not find [old] in [src] ([COORD(src)])")
	pipelines[index] = replacing

/obj/machinery/atmospherics/component/DirectConnection(datum/pipeline/querying, obj/machinery/atmospherics/source)
	var/index = pipelines.Find(querying)
	if(!index)
		CRASH("FATAL: DirectConnection() could not find [querying] in [src] ([COORD(src)]). Source was [source]")
	. = list()
	if(connected[index])
		. += connected[index]

/**
 * Gets the air that corrosponds to a pipeline
 */
/obj/machinery/atmospherics/component/proc/ReturnPipenetAir(datum/pipeline/querying)
	var/index = pipelines.Find(querying)
	if(!index)
		CRASH("FATAL: ReturnPipenetAir() could not find [querying] in [src] ([COORD(src)])")
	return airs[index]

/obj/machinery/atmospherics/component/unsafe_pressure_release(var/mob/user, var/pressures)
	..()

	var/turf/T = get_turf(src)
	if(T)
		//Remove the gas from airs and assume it
		var/datum/gas_mixture/environment = T.return_air()
		var/lost = null
		var/times_lost = 0
		for(var/i in 1 to device_type)
			var/datum/gas_mixture/air = airs[i]
			lost += pressures*environment.return_volume()/(air.return_temperature() * R_IDEAL_GAS_EQUATION)
			times_lost++
		var/shared_loss = lost/times_lost

		for(var/i in 1 to device_type)
			var/datum/gas_mixture/air = airs[i]
			T.assume_air_moles(air, shared_loss)
		air_update_turf(1)

/obj/machinery/atmospherics/component/proc/safe_input(var/title, var/text, var/default_set)
	var/new_value = input(usr,text,title,default_set) as num
	if(usr.canUseTopic(src))
		return new_value
	return default_set

/obj/machinery/atmospherics/component/ReturnPipelines()
	. = list()
	for(var/datum/pipeline/PL in pipelines)
		. += PL

// Helpers

/**
 * Marks all pipelines as needing to update
 */
/obj/machinery/atmospherics/component/proc/MarkDirty()
	for(var/i in 1 to pipelines.len)
		var/datum/pipeline/PL = pipelines[i]
		if(!PL)
			stack_trace("[src] is missing a pipenet. Rebuilding.")
			QueueRebuild()
			return
		PL.update = TRUE

/**
 * Immediately triggers a pipeline update on a parent pipeline
 */
/obj/machinery/atmospherics/component/proc/ImmediatePipelineUpdate(index)
	if(!index)
		for(var/i in 1 to pipelines.len)
			var/datum/pipeline/PL = pipelines[i]
			PL.reconcile_air()
	else
		var/datum/pipeline/PL = pipelines[index]
		PL.reconcile_air()

// UI Stuff

/obj/machinery/atmospherics/component/ui_status(mob/user)
	if(allowed(user))
		return ..()
	to_chat(user, "<span class='danger'>Access denied.</span>")
	return UI_CLOSE

/obj/machinery/atmospherics/component/attack_ghost(mob/dead/observer/O)
	. = ..()
	atmosanalyzer_scan(airs, O, src, FALSE)

// Standard ui_data
/obj/machinery/atmospherics/component/ui_static_data(mob/user)
	. = ..()
	.["power_max"] = power_rating
	.["pressure_max"] = max_pressure
	.["control_flags"] = ui_pump_control_capabilities
	.["pressure_sane_max"] = max_pressure_nominal
	.["rate_max"] = max_rate

// Standard ui_data
/obj/machinery/atmospherics/component/ui_data(mob/user)
	. = ..()
	.["power_setting"] = power_setting
	.["pressure_setting"] = pressure_setting
	.["rate_setting"] = rate_setting
	.["power_current"] = last_power_draw
	.["rate_current"] = last_transfer_rate
	.["on"] = on

/obj/machinery/atmospherics/component/ui_act(action, params)
	. = ..()
	switch(action)
		if("toggle")
			if(!(ui_pump_control_capabilities & ATMOS_UI_CONTROL_ACTIVE))
				return
			on = !on
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("power")
			if(!(ui_pump_control_capabilities & ATMOS_UI_CONTROL_POWER))
				return
			var/power = params["power"]
			if(power == "max")
				power = power_rating
				. = TRUE
			else if(power == "input")
				power = input("New maximum power draw (0-[power_rating] W):", name, power_setting) as num|null
				if(!isnull(power) && !..())
					. = TRUE
			else if(text2num(power) != null)
				. = TRUE
			if(.)
				power_setting = clamp(power, 0, power_rating)
				investigate_log("was set to [power_setting] W by [key_name(usr)]", INVESTIGATE_ATMOS)
		if("volume")
			var/volume = params["volume"]
			if(volume == "max")
				volume = max_rate
				. = TRUE
			else if(volume == "input")
				volume = input("New transfer volume (0-[max_rate] L/s):", name, rate_setting) as num|null
				if(!isnull(volume) && !..())
					. = TRUE
			else if(text2num(volume) != null)
				volume = text2num(volume)
				. = TRUE
			if(.)
				rate_setting = clamp(volume, 0, max_rate)
				investigate_log("was set to [rate_setting] L/s by [key_name(usr)]", INVESTIGATE_ATMOS)
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "max")
				pressure = max_pressure_nominal
				. = TRUE
			else if(pressure == "super")
				pressure = max_pressure
				. = TRUE
			else if(pressure == "input")
				pressure = input("New transfer volume (0-[max_pressure_nominal]-[max_pressure] kPa):", name, pressure_setting) as num|null
				if(!isnull(pressure) && !..())
					. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				pressure_setting = clamp(pressure, 0, max_pressure)
				investigate_log("was set to [pressure_setting] kPa by [key_name(usr)]", INVESTIGATE_ATMOS)

// Tool acts

/obj/machinery/atmospherics/component/analyzer_act(mob/living/user, obj/item/I)
	atmosanalyzer_scan(airs, user, src)
	return TRUE

/obj/machinery/atmospherics/component/AltClick(mob/user)
	. = ..()
	if(allow_alt_click_max_rate)
		var/area/A = get_area(src)
		var/turf/T = get_turf(src)
		// be close, require dexterity, allow TK
		if(user.canUseTopic(src, BE_CLOSE, FALSE, FALSE))
			if(ui_pump_control_capabilities & ATMOS_UI_CONTROL_PRESSURE)
				pressure_setting = max_pressure_nominal
			if(ui_pump_control_capabilities & ATMOS_UI_CONTROL_VOLUME)
				rate_setting = max_rate
			if(ui_pump_control_capabilities & ATMOS_UI_CONTROL_POWER)
				power_setting = power_rating
			to_chat(user,"<span class='notice'>You maximize the settings on \the [src].</span>")
			investigate_log("[src]([type]), was maximized by [key_name(usr)] at [x], [y], [z], [A]", INVESTIGATE_ATMOS)
			message_admins("[src]([type]), was maximized by [ADMIN_LOOKUPFLW(usr)] at [ADMIN_COORDJMP(T)], [A]")
			return TRUE

/obj/machinery/atmospherics/component/CtrlClick(mob/user)
	. = ..()
	if(allow_ctrl_click_toggle_power)
		var/area/A = get_area(src)
		var/turf/T = get_turf(src)
		if(user.canUseTopic(src, BE_CLOSE, FALSE, FALSE))
			on = !on
			update_icon()
			investigate_log("[src]([type]), turned on by [key_name(usr)] at [x], [y], [z], [A]", INVESTIGATE_ATMOS)
			message_admins("[src]([type]), turned [on ? "on" : "off"] by [ADMIN_LOOKUPFLW(usr)] at [ADMIN_COORDJMP(T)], [A]")
			return TRUE
