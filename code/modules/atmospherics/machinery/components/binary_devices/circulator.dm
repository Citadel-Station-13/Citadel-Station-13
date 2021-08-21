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

	// raise volume to 1000 - prevents see-sawing when engineers put pumps right after it, rather than after a pipenet.
	volume = 200

	/// J energy stored
	var/stored_energy
	/// static friction in the turbine in kpa
	var/static_friction = 10
	/// under this rpm, we're assumed stagnant
	var/stagnant_rpm = (2/3) * 50
	/// max RPM - at this speed, <volume> is exchanged per process.
	var/max_rpm = 600
	/// J energy release per revolution - at maximum rate this will cancel out *some* of the energy required to circulate the loops.
	var/generation_rate = (15000 / 600)
	/// current RPM
	var/rpm = 0
	/// mass of the turbine - affects inertia. 1 means change is instant, 2 means half of desired change goes at once, 3 is 1/3, etc.
	var/turbine_mass = 5
	/// minimum rpm change - this way we don't need too much complex math to ensure it always "overshoots" max rpm so turbine_mass doesn't complettely screw over changes
	var/mass_lenience = 2
	/// linked generator
	var/obj/machinery/power/generator/generator
	/// last process
	var/last_process_cycle = 0
	/// air currently inside - what the generator reads
	var/datum/gas_mixture/gas_held
	/// volume to "pump" with gas_held at max RPM
	var/max_flow = 200
	/// kpa difference needed per RPM of speed - this is because we really do not want to make this so complicated as to have to model force based on molar mass and pressure!
	var/kinetic_friction = (2/3)

/obj/machinery/atmospherics/component/binary/circulator/process_atmos(seconds, times_fired)
	if(times_fired >= last_process_cycle)
		return
	last_process_cycle = times_fired
	// first, process inertia and turbine force
	// 2 is "output", 1 is "input"
	// if rpm is positive, gas is flowing forwards
	// else, gas is flowing backwards
	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]
	var/pressure_difference = air1.return_pressure() - air2.return_pressure()
	// first, check if we're spinning fast enough to overcome static friction
	// we do this because we don't want to math it later to "stop" at 0 when reversing
	if(abs(rpm) < stagnant_rpm && pressure_difference < static_friction)
		rpm = rpm > 0? max(0, rpm - 1) : min(0, rpm + 1)
	// if positive, we have a momentum push towards air2
	// else, we have reverse
	else
		var/desired_rpm = pressure_difference / kinetic_friction
		var/difference = abs(desired_rpm - rpm)
		// increase or decrease based on mass
		if(desired_rpm > rpm)
			rpm = clamp(rpm + max(difference / turbine_mass, min(mass_lenience, difference)), -max_rpm, max_rpm)
		else
			rpm = clamp(rpm - max(difference / turbine_mass, min(mass_lenience, difference)), -max_rpm, max_rpm)

	// expel previous air and darw in new air
	if(rpm > 0)
		air2.merge(gas_held)
		gas_held = air1.remove_ratio(max_flow / air1.return_volume())
	else
		air1.merge(gas_held)
		gas_held = air2.remove_ratio(max_flow / air2.return_volume())

	// generate power based on turbine RPM
	stored_energy += generation_rate * rpm
	// if no generator to output our energy, get rid of it ourselves
	stored_energy *= 0.9

	// update icon based on generation
	update_appearance()

/obj/machinery/atmospherics/component/binary/circulator/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS )

/obj/machinery/atmospherics/component/binary/circulator/Destroy()
	DisconnectGenerator()
	return ..()

/obj/machinery/atmospherics/component/binary/circulator/examine(mob/user)
	. = ..()
	. += "These are bidirectional devices. The internal turbine acts both as a flywheel to stabilize gas flow as well as to generate some energy to offset the cost of powering a hot/cold loop's pumps."
	. += "The turbine will spin in the direction of pressure - higher pressures result in faster speeds. It will slow down while pressure is insufficient, but the inertia of the turbine's mass will continue to \"pump\" gas in that direction until all of its energy is lost."
	. += "You can see which way the gas is moving by looking at which way it's spinning - The gas will <b>always</b> flow in the direction that the turbine is spinning on the <b>inside</b> (e.g. closest to the attached TEG)."
	. += "Example: If a TEG and 2 circulators are attached in a horizontal fashion (west-center-east), and both turbines are spinning clockwise, the left side is going north to south, and the right side is going south to north."

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
	if(generator?.last_output > 500)
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
