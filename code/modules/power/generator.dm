/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "A high-efficiency thermoelectric generator."
	icon = 'icons/obj/machinery/power/teg.dmi'
	icon_state = "teg"
	density = TRUE
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/machine/generator

	/// first circulator
	var/obj/machinery/atmospherics/component/binary/circulator/left
	/// second circulator
	var/obj/machinery/atmospherics/component/binary/circulator/right
	/// stored energy to release per tick - lower values are smoother, higher values are more immediate
	var/energy_release_ratio = 0.1
	/// last energy output
	var/last_output = 0
	/// last energy output from left turbine
	var/last_left_turbine_output = 0
	/// last energy output from right turbine
	var/last_right_turbine_output = 0
	/// maximum output - not actually limited, but above this, annoying things can start to happen. 1 megawatt by default.
	var/maximum_output = 1000000
	/// stored energy
	var/stored_energy = 0
	/// current hot side
	var/obj/machinery/atmospherics/component/binary/circulator/hot_side

	/// required temperature differential for full efficiency
	var/optimal_temperature_difference = 500
	/// minimum efficiency
	var/efficiency_min = 0.25
	/// full efficiency
	var/efficiency = 0.65
	/// thermal conductivity - higher is better
	var/conductivity = 1

	// bad things happening
	/// chance of spark per process when above maximum
	var/spark_chance = 5
	/// ratio of stored energy lost per spark
	var/spark_loss_ratio = 0.35

/obj/machinery/power/generator/Initialize(mapload)
	. = ..()
	Detect()
	connect_to_network()
	SSair.atmos_machinery += src
	update_appearance()

/obj/machinery/power/generator/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS )

/obj/machinery/power/generator/Destroy()
	left?.DisconnectGenerator()
	right?.DisconnectGenerator()
	hot_side = null
	SSair.atmos_machinery -= src
	return ..()

/obj/machinery/power/examine(mob/user)
	. = ..()
	. += "This device is rated for a maximum output of [DisplayPower(maximum_output)]. Above this, it will spark and lose some of its efficiency."
	. += "This device requires a [optimal_temperature_difference]K difference in temperature for optimal efficiency."
	. += "This device has a baseline efficiency of [efficiency_min*100]% and an optimal efficiency of [efficiency*100]%."

/obj/machinery/power/generator/update_icon_state()
	. = ..()
	icon_state = anchored? "teg" : "teg_u"

/obj/machinery/power/generator/update_overlays()
	. = ..()
	if(!anchored)
		return
	if(stat & (BROKEN))
		return
	. += "teg_gen_[CEILING(last_output / (maximum_output / 5), 1)]"

/obj/machinery/power/generator/process()
	var/output = round(stored_energy * energy_release_ratio)
	last_output = output
	stored_energy -= output
	if(left)
		last_left_turbine_output = left.stored_energy * energy_release_ratio
		left.stored_energy -= last_left_turbine_output
		output += last_left_turbine_output
	else
		last_left_turbine_output = 0
	if(right)
		last_right_turbine_output = right.stored_energy * energy_release_ratio
		right.stored_energy -= last_right_turbine_output
		output += last_right_turbine_output
	else
		last_right_turbine_output = 0
	add_avail(output)
	if(output > maximum_output && prob(spark_chance))
		stored_energy -= stored_energy * spark_loss_ratio
		do_sparks(3, FALSE, src)
	..()

/obj/machinery/power/generator/process_atmos(seconds, times_fired)
	if(!left?.gas_held || !right?.gas_held)
		return	// nope
	// ensure both circulators are synced on tick
	left.process_atmos(seconds, times_fired)
	right.process_atmos(seconds, times_fired)
	// do the funny TEG action
	var/effective_efficiency = efficiency_min + ((efficiency - efficiency_min) * (abs(right.gas_held.return_temperature() - left.gas_held.return_temperature()) / optimal_temperature_difference))
	var/generated = thermoelectric_exchange_gas_to_gas(left.gas_held, right.gas_held, conductivity, effective_efficiency)
	stored_energy += generated
	if(left.gas_held.return_temperature() > right.gas_held.return_temperature())
		hot_side = left
	else
		hot_side = right

/obj/machinery/power/generator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ThermoelectricGenerator", name)
		ui.open()
	#warn make the tgui

/obj/machinery/power/generator/ui_static_data(mob/user)
	. = ..()
	.["left"] = !!left
	.["right"] = !!right
	.["left_max_rpm"] = left?.max_rpm
	.["right_max_rpm"] = right?.max_rpm

/obj/machinery/power/generator/ui_data(mob/user)
	. = ..()
	.["output"] = last_output
	.["left_gas"] = gas_data_for(left?.gas_held)
	.["right_gas"] = gas_data_for(right?.gas_held)
	.["left_rpm"] = left.rpm
	.["right_rpm"] = right.rpm
	.["left_gen"] = last_left_turbine_output
	.["right_gen"] = last_right_turbine_output

/obj/machinery/power/generator/proc/gas_data_for(datum/gas_mixture/GM)
	if(!GM)
		return null
	. = list()
	.["temp"] = GM.return_temperature()
	.["pressure"] = GM.return_pressure()

/obj/machinery/power/generator/proc/Detect()
	if(!left)
		var/obj/machinery/atmospherics/component/binary/circulator/L = locate() in get_step(src, turn(dir, 90))
		if(L)
			L.ConnectGenerator(src)
	if(!right)
		var/obj/machinery/atmospherics/component/binary/circulator/R = locate() in get_step(src, turn(dir, -90))
		if(R)
			R.ConnectGenerator(src)

/obj/machinery/power/generator/proc/Connect(obj/machinery/atmospherics/component/binary/circulator/C)
	if(!anchored)
		// no crash - someone detected us when we were just passing through
		return FALSE
	if(C.generator)
		// this is never okay
		. = FALSE
		CRASH("Attempted to connect a circulator with a generator")
	var/d = get_dir(src, C)
	if(d == turn(dir, 90))
		if(left)
			// no crash - some dumbass probably spawned two circulators
			return FALSE
		left = C
		return TRUE
	else if(d == turn(dir, -90))
		if(right)
			// no crash - some dumbass probably spawned two circulators
			return FALSE
		right = C
		return TRUE
	else
		// crash - someone fucked up
		. = FALSE
		CRASH("Attempted to connect a generator that wasn't in a proper direction - expected left or right, got [d].")
	addtimer(CALLBACK(SStgui, /datum/controller/subsystem/tgui/proc/update_static_data_for, src), 0, TIMER_UNIQUE)

/obj/machinery/power/generator/proc/Disconnect(obj/machinery/atmospherics/component/binary/circulator/C)
	if(C == left)
		left = null
		. = TRUE
	else if(C == right)
		right = null
		. = TRUE
	if(C == hot_side)
		hot_side = null
	if(!.)
		CRASH("Attempted to disconnect a non-connected circulator")
	addtimer(CALLBACK(SStgui, /datum/controller/subsystem/tgui/proc/update_static_data_for, src), 0, TIMER_UNIQUE)

/obj/machinery/power/generator/wrench_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return
	anchored = !anchored
	I.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You [anchored? "secure": "unsecure"] [src].</span>")
	if(!anchored)
		disconnect_from_network()
		left?.DisconnectGenerator(src)
		right?.DisconnectGenerator(src)
	else
		connect_to_network()
		Detect()
	return TRUE

/obj/machinery/power/generator/screwdriver_act(mob/user, obj/item/I)
	if(..())
		return TRUE
	panel_open = !panel_open
	I.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You [panel_open?"open":"close"] the panel on [src].</span>")
	return TRUE

/obj/machinery/power/generator/crowbar_act(mob/user, obj/item/I)
	default_deconstruction_crowbar(I)
	return TRUE
