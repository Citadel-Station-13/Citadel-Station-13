ATMOS_MAPPING_LAYERS_PX_DOUBLE(/obj/machinery/atmospherics/component/binary/relief_valve)
/obj/machinery/atmospherics/component/binary/relief_valve
	name = "binary pressure relief valve"
	desc = "Like a manual valve, but opens at a certain pressure rather than being toggleable."
	icon = 'icons/modules/atmospherics/component/relief.dmi'
	icon_state = "relief_valve-t-map"
	can_unwrench = TRUE
	construction_type = /obj/item/pipe/binary
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON | INTERACT_MACHINE_SET_MACHINE
	var/opened = FALSE
	var/open_pressure = ONE_ATMOSPHERE * 3
	var/close_pressure = ONE_ATMOSPHERE
	pipe_state = "relief_valve-t"

/obj/machinery/atmospherics/component/binary/relief_valve/update_icon_state()
	. = ..()
	if(!connected[1] || !opened || !is_operational())
		icon_state = "relief_valve-t"
		return

	icon_state = "relief_valve-t-blown"

/obj/machinery/atmospherics/component/binary/relief_valve/proc/open()
	opened = TRUE
	update_icon()
	MarkDirty()
	ImmediatePipelineUpdate(1)

/obj/machinery/atmospherics/component/binary/relief_valve/proc/close()
	opened = FALSE
	update_icon()

/obj/machinery/atmospherics/component/binary/relief_valve/process_atmos()
	..()

	if(!is_operational())
		return

	var/datum/gas_mixture/air_one = airs[1]
	var/datum/gas_mixture/air_two = airs[2]
	var/air_one_pressure = air_one.return_pressure()
	var/our_pressure = abs(air_one_pressure - air_two.return_pressure())
	if(opened && air_one_pressure < close_pressure)
		close()
	else if(!opened && our_pressure >= open_pressure)
		open()

/obj/machinery/atmospherics/component/binary/relief_valve/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosRelief", name)
		ui.open()

/obj/machinery/atmospherics/component/binary/relief_valve/ui_data()
	. = ..()
	.["open_pressure"] = round(open_pressure)
	.["close_pressure"] = round(close_pressure)
	.["max_pressure"] = round(50*ONE_ATMOSPHERE)

/obj/machinery/atmospherics/component/binary/relief_valve/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("open_pressure")
			var/pressure = params["pressure"]
			if(pressure == "max")
				pressure = 50*ONE_ATMOSPHERE
				. = TRUE
			else if(pressure == "input") // The manual expirience.
				pressure = input("New output pressure ([close_pressure]-[50*ONE_ATMOSPHERE] kPa):", name, open_pressure) as num|null
				if(!isnull(pressure) && !..())
					. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				open_pressure = clamp(pressure, close_pressure, 50*ONE_ATMOSPHERE)
				investigate_log("open pressure was set to [open_pressure] kPa by [key_name(usr)]", INVESTIGATE_ATMOS)
		if("close_pressure")
			var/pressure = params["pressure"]
			if(pressure == "max")
				pressure = open_pressure
				. = TRUE
			else if(pressure == "input")
				pressure = input("New output pressure (0-[open_pressure] kPa):", name, close_pressure) as num|null
				if(!isnull(pressure) && !..())
					. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				close_pressure = clamp(pressure, 0, open_pressure)
				investigate_log("close pressure was set to [close_pressure] kPa by [key_name(usr)]", INVESTIGATE_ATMOS)
	update_icon()
