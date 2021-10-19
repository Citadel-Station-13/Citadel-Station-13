ATMOS_MAPPING_LAYERS_IX(/obj/machinery/atmospherics/component/unary/thermomachine, "freezer_map")

/obj/machinery/atmospherics/component/unary/thermomachine
	icon = 'icons/modules/atmospherics/components/thermomachine.dmi'
	icon_state = "freezer"

	name = "thermomachine"
	desc = "Heats or cools gas in connected pipes."

	density = TRUE
	max_integrity = 300
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 100, "bomb" = 0, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 30)
	layer = OBJ_LAYER
	plane = GAME_PLANE
	circuit = /obj/item/circuitboard/machine/thermomachine

	pipe_flags = PIPE_ONE_PER_TURF
	ui_pump_control_capabilities = ATMOS_UI_CONTROL_ACTIVE | ATMOS_UI_CONTROL_POWER | ATMOS_UI_POWER_USAGE

	var/icon_state_off = "freezer"
	var/icon_state_on = "freezer_1"
	var/icon_state_open = "freezer-o"

	var/min_temperature = 0
	var/max_temperature = 0
	var/target_temperature = T20C
	var/heat_capacity = 0
	var/interactive = TRUE // So mapmakers can disable interaction.

/obj/machinery/atmospherics/component/unary/thermomachine/SetInitDirections()
	initialize_directions = dir

/obj/machinery/atmospherics/component/unary/thermomachine/InitConstructed(set_color, set_dir, set_layer)
	var/obj/item/circuitboard/machine/thermomachine/board = circuit
	if(board)
		pipe_layer = board.pipe_layer
		set_layer = board.pipe_layer
	return ..()

/obj/machinery/atmospherics/component/unary/thermomachine/RefreshParts()
	var/B = 0
	var/B_count = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		B += M.rating
		B_count++
	B /= B_count
	power_efficiency = ATMOSMECH_THERMOMACHINE_BIN_FACTOR(B)
	var/laser_total = 0
	var/laser_count = 0
	for(var/obj/item/stock_parts/micro_laser/L in component_parts)
		laser_total += L.rating
		laser_count++
	power_rating = ATMOSMECH_THERMOMACHINE_LASER_POWER(laser_total / laser_count)
	power_setting = min(power_setting, power_rating)

/obj/machinery/atmospherics/component/unary/thermomachine/update_icon_state()
	. = ..()
	if(panel_open)
		icon_state = icon_state_open
	else if(on && is_operational())
		icon_state = icon_state_on
	else
		icon_state = icon_state_off

/obj/machinery/atmospherics/component/unary/thermomachine/update_overlays()
	. = ..()
	if(connected[1])
		add_overlay(getpipeimage(icon, "pipe", dir, , pipe_layer))
	else if(showpipe)
		add_overlay(getpipeimage(icon, "scrub_cap", initialize_directions))

/obj/machinery/atmospherics/component/unary/thermomachine/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The thermostat is set to [target_temperature]K ([(T0C-target_temperature)*-1]C).</span>"
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Efficiency <b>[(heat_capacity/5000)*100]%</b>.</span>"
		. += "<span class='notice'>Temperature range <b>[min_temperature]K - [max_temperature]K ([(T0C-min_temperature)*-1]C - [(T0C-max_temperature)*-1]C)</b>.</span>"

/obj/machinery/atmospherics/component/unary/thermomachine/process_atmos()
	last_power_draw = 0
	if(!on || !connected[1])
		return
	var/datum/gas_mixture/air_contents = airs[1]
	if(!QUANTIZE(air_contents.return_temperature() - target_temperature))
		return
	var/heat_capacity = air_contents.heat_capacity()
	var/energy_needed = ((target_temperature - air_contents.return_temperature()) * heat_capacity) / (ATMOSMECH_THERMOMACHINE_CHEAT_FACTOR * power_efficiency)
	energy_needed = min(energy_needed, power_setting)
	last_power_draw = active_power_usage = energy_needed
	air_contents.adjust_heat(energy_needed * (ATMOSMECH_THERMOMACHINE_CHEAT_FACTOR * power_efficiency))
	MarkDirty()

/obj/machinery/atmospherics/component/unary/thermomachine/attackby(obj/item/I, mob/user, params)
	if(!on)
		if(default_deconstruction_screwdriver(user, icon_state_open, icon_state_off, I))
			return
	if(default_change_direction_wrench(user, I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/atmospherics/component/unary/thermomachine/ui_status(mob/user)
	if(interactive)
		return ..()
	return UI_CLOSE

/obj/machinery/atmospherics/component/unary/thermomachine/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ThermoMachine", name)
		ui.open()

/obj/machinery/atmospherics/component/unary/thermomachine/ui_data(mob/user)
	. = ..()
	.["min"] = min_temperature
	.["max"] = max_temperature
	.["target"] = target_temperature
	.["initial"] = initial(target_temperature)

	var/datum/gas_mixture/air1 = airs[1]
	.["temperature"] = air1.return_temperature()
	.["pressure"] = air1.return_pressure()

/obj/machinery/atmospherics/component/unary/thermomachine/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("target")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "input")
				target = input("Set new target ([min_temperature]-[max_temperature] K):", name, target_temperature) as num|null
				if(!isnull(target))
					. = TRUE
			else if(adjust)
				target = target_temperature + adjust
				. = TRUE
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				target_temperature = clamp(target, min_temperature, max_temperature)
				investigate_log("was set to [target_temperature] K by [key_name(usr)]", INVESTIGATE_ATMOS)
	update_appearance()

/obj/machinery/atmospherics/component/unary/thermomachine/freezer
	name = "freezer"
	icon_state = "freezer"
	icon_state_off = "freezer"
	icon_state_on = "freezer_1"
	icon_state_open = "freezer-o"
	max_temperature = T20C
	min_temperature = TCMB
	circuit = /obj/item/circuitboard/machine/thermomachine/freezer

/obj/machinery/atmospherics/component/unary/thermomachine/freezer/on
	on = TRUE
	icon_state = "freezer_1"

/obj/machinery/atmospherics/component/unary/thermomachine/freezer/on/Initialize()
	. = ..()
	if(target_temperature == initial(target_temperature))
		target_temperature = min_temperature

/obj/machinery/atmospherics/component/unary/thermomachine/freezer/on/coldroom
	name = "cold room freezer"

/obj/machinery/atmospherics/component/unary/thermomachine/freezer/on/coldroom/Initialize()
	. = ..()
	target_temperature = T0C - 80

/obj/machinery/atmospherics/component/unary/thermomachine/freezer/AltClick(mob/living/user)
	. = ..()
	var/area/A = get_area(src)
	var/turf/T = get_turf(src)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	target_temperature = min_temperature
	to_chat(user,"<span class='notice'>You minimize the temperature on the [src].</span>")
	investigate_log("was set to [target_temperature] K by [key_name(usr)]", INVESTIGATE_ATMOS)
	message_admins("[src.name] was minimized by [ADMIN_LOOKUPFLW(usr)] at [ADMIN_COORDJMP(T)], [A]")
	return TRUE

/obj/machinery/atmospherics/component/unary/thermomachine/heater
	name = "heater"
	icon_state = "heater"
	icon_state_off = "heater"
	icon_state_on = "heater_1"
	icon_state_open = "heater-o"
	max_temperature = ATMOSMECH_THERMOMACHINE_MAX_TEMP
	min_temperature = T20C
	circuit = /obj/item/circuitboard/machine/thermomachine/heater

/obj/machinery/atmospherics/component/unary/thermomachine/heater/on
	on = TRUE
	icon_state = "heater_1"

/obj/machinery/atmospherics/component/unary/thermomachine/heater/AltClick(mob/living/user)
	. = ..()
	var/area/A = get_area(src)
	var/turf/T = get_turf(src)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	target_temperature = max_temperature
	to_chat(user,"<span class='notice'>You maximize the temperature on the [src].</span>")
	investigate_log("was set to [target_temperature] K by [key_name(usr)]", INVESTIGATE_ATMOS)
	message_admins("[src.name] was maximized by [ADMIN_LOOKUPFLW(usr)] at [ADMIN_COORDJMP(T)], [A]")
	return TRUE
