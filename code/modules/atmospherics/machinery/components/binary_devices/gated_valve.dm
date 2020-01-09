/*
Like a manual valve, except it has some resistance that makes it open up only at a given pressure.
*/

/obj/machinery/atmospherics/components/binary/gated_valve
	icon_state = "mvalve_map"
	name = "gated valve"
	desc = "A valve with a resistor inside that doesn't open until there's a certain amount of pressure on either side."
	can_unwrench = TRUE
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON | INTERACT_MACHINE_SET_MACHINE
	construction_type = /obj/item/pipe/binary
	pipe_state = "mvalve"

	var/switching = FALSE
	var/cur_open = FALSE
	var/target_pressure = ONE_ATMOSPHERE

/obj/machinery/atmospherics/components/binary/gated_valve/update_icon_nopipes(animation = 0)
	normalize_dir()
	if(animation)
		flick("mvalve_[cur_open][!cur_open]",src)
	icon_state = "mvalve_[cur_open?"on":"off"]"

/obj/machinery/atmospherics/components/binary/gated_valve/proc/open()
	cur_open = TRUE
	update_icon_nopipes()
	update_parents()
	var/datum/pipeline/parent1 = parents[1]
	parent1.reconcile_air()

/obj/machinery/atmospherics/components/binary/gated_valve/proc/close()
	cur_open = FALSE
	update_icon_nopipes()

/obj/machinery/atmospherics/components/binary/gated_valve/proc/normalize_dir()
	if(dir==SOUTH)
		setDir(NORTH)
	else if(dir==WEST)
		setDir(EAST)

/obj/machinery/atmospherics/components/binary/gated_valve/layer1 // SHIT IS FUCKED
	piping_layer = PIPING_LAYER_MIN
	pixel_x = -PIPING_LAYER_P_X
	pixel_y = -PIPING_LAYER_P_Y

/obj/machinery/atmospherics/components/binary/gated_valve/layer3
	piping_layer = PIPING_LAYER_MAX
	pixel_x = PIPING_LAYER_P_X
	pixel_y = PIPING_LAYER_P_Y

/obj/machinery/atmospherics/components/binary/gated_valve/on
	on = TRUE

/obj/machinery/atmospherics/components/binary/gated_valve/on/layer1
	piping_layer = PIPING_LAYER_MIN
	pixel_x = -PIPING_LAYER_P_X
	pixel_y = -PIPING_LAYER_P_Y

/obj/machinery/atmospherics/components/binary/gated_valve/on/layer3
	piping_layer = PIPING_LAYER_MAX
	pixel_x = PIPING_LAYER_P_X
	pixel_y = PIPING_LAYER_P_Y

/obj/machinery/atmospherics/components/binary/gated_valve/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
																		datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "atmos_pump", name, 335, 115, master_ui, state)
		ui.open()

/obj/machinery/atmospherics/components/binary/gated_valve/ui_data()
	var/data = list()
	data["on"] = on
	data["pressure"] = round(target_pressure)
	data["max_pressure"] = round(MAX_OUTPUT_PRESSURE)
	return data

/obj/machinery/atmospherics/components/binary/gated_valve/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("power")
			on = !on
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "max")
				pressure = MAX_OUTPUT_PRESSURE
				. = TRUE
			else if(pressure == "input")
				pressure = input("New output pressure (0-[MAX_OUTPUT_PRESSURE] kPa):", name, target_pressure) as num|null
				if(!isnull(pressure) || !..())
					. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				target_pressure = CLAMP(pressure, 0, MAX_OUTPUT_PRESSURE)
				investigate_log("was set to [target_pressure] kPa by [key_name(usr)]", INVESTIGATE_ATMOS)
	update_icon()

/obj/machinery/atmospherics/components/binary/gated_valve/process_atmos()
	..()
	if(!on)
		if(cur_open)
			close()
		return
	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]

	var/starting_pressure1 = air1.return_pressure()
	var/starting_pressure2 = air2.return_pressure()
	var/pressure_difference = abs(starting_pressure1 - starting_pressure2)

	if(!cur_open && pressure_difference > target_pressure)
		open()
	else if(cur_open && (starting_pressure1 < target_pressure) && (starting_pressure2 < target_pressure))
		close()
