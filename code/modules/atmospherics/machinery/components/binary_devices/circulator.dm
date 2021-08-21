/obj/machinery/atmospherics/component/binary/circulator
	name = "circulator/heat exchanger"
	desc = "A combination turbine and thermal exchanger usually part of a TEG."
	icon = 'icons/obj/machinery/power/teg.dmi'
	icon_state = "circ"
	plane = GAME_PLANE
	pipe_flags = PIPE_ONE_PER_TURF | PIPE_DEFAULT_LAYER_ONLY
	density = TRUE

	circuit = /obj/item/circuitboard/machine/circulator

	// Circulators don't just exchange heat
	// They're now fully simulated turbines.
	// We generate power off gas movement,
	// and store momentum.
	// we obviously can't easily do this so, we'll just do friction as "kpa" and store turbine rotation speed

	// this also lets us have circulators be bidirectional, as the friction + momentum will make it not flip-flop as hard.
	// we'll assume that each revolution of the mechanism transfers <volume> of air.

	/// J energy stored
	var/stored_energy
	/// static friction in the turbine in kpa
	var/static_friction = 10
	/// max RPM - at this speed, <volume> is exchanged per process.
	var/max_rpm = 600
	/// J energy release per revolution
	var/generation_rate = (15000 / 600)
	/// current RPM
	var/rpm = 0
	/// mass of the turbine - affects resistance.
	var/turbine_mass = 10000
	/// linked generator
	var/obj/machinery/power/generator/generator
	/// last process
	var/last_process_cycle = 0
	/// air currently inside - what the generator reads
	var/datum/gas_mixture/gas_held
	/// kpa difference needed per RPM of speed - this is because we really do not want to make this so complicated as to have to model force based on molar mass and pressure!
	var/kinetic_friction = (2/3)

/obj/machinery/atmospherics/component/binary/circulator/process_atmos(seconds, times_fired)
	if(times_fired >= last_process_cycle)
		return
	last_process_cycle = times_fired
	#warn impl
	update_appearance()

/obj/machinery/atmospherics/component/binary/circulator/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS )

/obj/machinery/atmospherics/component/binary/circulator/Destroy()
	DisconnectGenerator()
	return ..()

/obj/machinery/atmospherics/component/binary/circulator/GetNodeIndex(dir, layer)
	if(dir == src.dir)
		return 2
	else if(dir == turn(src.dir, 180))
		return 1
	else
		CRASH("Invalid node index for TEG")

/obj/machinery/atmospherics/component/binary/circulator/GetInitDirections()
	return dir | turn(dir, 180)

/obj/machinery/atmospherics/component/binary/circulator/proc/GetGeneratorDirection()
	// always RHS from dir
	return turn(dir, -90)

/obj/machinery/atmospherics/component/binary/circulator/update_icon_state()
	. = ..()
	icon_state = anchored? "circ" : "circ_u"

/obj/machinery/atmospherics/component/binary/circulator/update_overlays()
	. = ..()
	// first, spin speed
	if(rpm)
		. += "circ_spin_[CEILING(max_rpm / (max_rpm / 10), 1)]_[rpm > 0? "f":"r"]"
	// then, temperature
	if(generator?.last_thermal_differential > 500)
		. += generator.hot_side == src? "circ_hot" : "circ_cold"

/obj/machinery/atmospherics/component/binary/circulator/wrench_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return
	anchored = !anchored
	move_resist = anchored? INFINITY : 100
	I.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You [anchored?"secure":"unsecure"] [src].</span>")
	if(!anchored)
		Leave()
	else
		Join()
	return TRUE

/obj/machinery/atmospherics/component/binary/circulator/CanConnect(obj/machinery/atmospherics/other, node)
	return anchored? ..() : FALSE

/obj/machinery/atmospherics/component/binary/circulator/proc/IsReady()
	return anchored

/obj/machinery/atmospherics/component/binary/circulator/proc/DisconnectGenerator()
	if(!generator)
		return
	generator.Disconnect(src)
	generator = null

/obj/machinery/atmospherics/component/binary/circulator/proc/ConnectGenerator()
	if(!(pipe_flags & PIPE_NETWORK_JOINED))
		return
	var/obj/machinery/power/generator/G = locate() in get_step(src, GetGeneratorDirection())
	if(!G)
		return
	if(!G.Connect(src))
		return
	generator = G

/obj/machinery/atmospherics/component/binary/circulator/Leave()
	. = ..()
	DisconnectGenerator()

/obj/machinery/atmospherics/component/binary/circulator/Join()
	. = ..()
	ConnectGenerator()

/obj/machinery/atmospherics/component/binary/circulator/screwdriver_act(mob/user, obj/item/I)
	if(..())
		return TRUE
	panel_open = !panel_open
	I.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You [panel_open?"open":"close"] the panel on [src].</span>")
	return TRUE

/obj/machinery/atmospherics/component/binary/circulator/crowbar_act(mob/user, obj/item/I)
	default_deconstruction_crowbar(I)
	return TRUE
