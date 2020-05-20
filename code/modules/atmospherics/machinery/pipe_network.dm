/**
  * Pipe network datums.
  * With the new pipeline handling system, we're presented an interesting challenge.
  * The new system requires that pipelines can hold the resultant air of pipes AND some of its directly connected components. This means that
  * in equalization_tick(), components cannot access the equivalent air of the entire pipeline at once when valves are involved,
  * as valves only "flow" air by using equalization ticks.
  * Instead, we're going to rethink how it works and make it so all directly connected pipelines are built into a pipe_network, which is read
  * from when something wants a pipeline's air instead.
  * This is faster than rebuild an entire pipenet whenever we open/close a valve, as we just have to rebuild the pipe networks instead of all
  * pipes and components.
  */
/datum/pipe_network
	/// The combined direct air of all pipenets under us.
	var/datum/gas_mixture/air
	/// All pipenets that are in us.
	var/list/datum/pipeline/pipelines
	/// Has our air changed? If so, we'll need to equalization_tick().
	var/update = TRUE		// true on first run
	/// Marks us as being invalid for air operations due to being mid-rebuild or destroy.
	var/invalid = TRUE

/datum/pipe_network/New(datum/pipeline/from)
	SSair.pipenets += src
	pipelines = list()

/datum/pipe_network/Destroy()
	invalid = FALSE
	SSair.pipenets -= src
	breakdown()
	return ..()

/**
  * Disassembles us, breaking our air into our pipelines.
  */
/datum/pipe_network/proc/breakdown()
	if(!length(pipelines))
		return
	var/datum/pipeline/p
	for(var/i in pipelines)
		p = i
		p.temporarily_store_air()
		p.parent = null
	QDEL_NULL(air)
	pipelines = list()

/datum/pipe_network/proc/build_network(datum/pipeline/base)
	breakdown()		//make sure we break down (even though reusing networks is a bad idea)
	pipelines = list()
	var/total_volume = 0
	air = new
	var/list/datum/pipeline/expand_through = list(base)
	for(var/i = 1; i <= length(expand_through); i++)
		var/datum/pipeline/P = expand_through[i]
		// null safe
		if(!P)
			continue
		// take their direct pipeline volume
		total_volume += P.volume
		// if they have a parent that isn't us, break them down
		if(P.parent && (P.parent != src))
			P.parent.breakdown()
		// it's now safe to steal their air.
		if(P.temporary_air)
			air.merge(P.temporary_air)
			QDEL_NULL(P.temporary_air)
		// finally, add them to us.
		pipelines += P
		P.parent = src
		// now, if they have any potentially valve components
		for(var/i in P.valve_components)
			// expand through them
			var/obj/machinery/atmospherics/components/C = i
			expand_through |= C.directly_connected_pipenets(P)
	air.volume = total_volume
	invalid = TRUE

/datum/pipe_network/proc/adjustDirectVolume(amount)
	air.volume += amount

/**
  * Equalizes our air across all components inside us based on volumes.
  */
/datum/pipe_network/proc/equalization_tick()
	var/list/datum/gas_mixture/other_airs = list()
	var/total_volume = air.volume
	var/total_thermal_energy = THERMAL_ENERGY(air)
	var/total_heat_capacity = air.heat_capacity()
	var/datum/pipeline/P
	var/list/total_gases = list()
	for(var/i in pipelines)
		P = i
		other_airs += P.component_airs
	var/datum/gas_mixture/G
	var/list/gaslist
	for(var/i in other_airs)
		G = i
		total_volume += G.volume
		total_thermal_energy = THERMAL_ENERGY(G)
		total_heat_capacity = G.heat_capacity()
		gaslist = G.gases
		for(var/gasid in gaslist)
			total_gases += G.gases[gasid]
	var/temperature = total_heat_capacity ? total_thermal_capacity / total_heat_capacity : 0
	if(total_volume > 0)
		// first, update ourselves.
		air.gases = gaslist = list()
		air.temperature = temperature
		for(var/gasid in total_gases)
			gaslist[gasid] = (air.volume / total_volume) * total_gases[gasid]
		// then, update everyone else.
		for(var/i in other_airs)
			G = i
			G.temperature = temperature
			G.gases = gaslist = list()
			for(var/gasid in total_gases)
				gaslist[gasid] = (air.volume / total_volume) * total_gases[gasid]

#warn wip below

/datum/pipeline/proc/reconcile_air()
	var/list/datum/gas_mixture/GL = list()
	var/list/datum/pipeline/PL = list()
	PL += src

	for(var/i = 1; i <= PL.len; i++) //can't do a for-each here because we may add to the list within the loop
		var/datum/pipeline/P = PL[i]
		if(!P)
			continue
		GL += P.return_air()
		for(var/atmosmch in P.other_atmosmch)
			if (istype(atmosmch, /obj/machinery/atmospherics/components/binary/valve))
				var/obj/machinery/atmospherics/components/binary/valve/V = atmosmch
				if(V.on)
					PL |= V.parents[1]
					PL |= V.parents[2]
			else if (istype(atmosmch,/obj/machinery/atmospherics/components/binary/relief_valve))
				var/obj/machinery/atmospherics/components/binary/relief_valve/V = atmosmch
				if(V.opened)
					PL |= V.parents[1]
					PL |= V.parents[2]
			else if (istype(atmosmch, /obj/machinery/atmospherics/components/unary/portables_connector))
				var/obj/machinery/atmospherics/components/unary/portables_connector/C = atmosmch
				if(C.connected_device)
					GL += C.portableConnectorReturnAir()

/datum/pipe_network/process()
	if(invalid)
		return
	if(update)
		update = FALSE
		equalization_tick()
	update = air.react(src)

/datum/pipe_network/proc/temperature_interact(turf/target, share_volume, thermal_conductivity)
	var/total_heat_capacity = air.heat_capacity()
	var/partial_heat_capacity = total_heat_capacity*(share_volume/air.volume)
	var/target_temperature
	var/target_heat_capacity

	if(isopenturf(target))

		var/turf/open/modeled_location = target
		target_temperature = modeled_location.GetTemperature()
		target_heat_capacity = modeled_location.GetHeatCapacity()

		if(modeled_location.blocks_air)

			if((modeled_location.heat_capacity>0) && (partial_heat_capacity>0))
				var/delta_temperature = air.temperature - target_temperature

				var/heat = thermal_conductivity*delta_temperature* \
					(partial_heat_capacity*target_heat_capacity/(partial_heat_capacity+target_heat_capacity))

				air.temperature -= heat/total_heat_capacity
				modeled_location.TakeTemperature(heat/target_heat_capacity)

		else
			var/delta_temperature = 0
			var/sharer_heat_capacity = 0

			delta_temperature = (air.temperature - target_temperature)
			sharer_heat_capacity = target_heat_capacity

			var/self_temperature_delta = 0
			var/sharer_temperature_delta = 0

			if((sharer_heat_capacity>0) && (partial_heat_capacity>0))
				var/heat = thermal_conductivity*delta_temperature* \
					(partial_heat_capacity*sharer_heat_capacity/(partial_heat_capacity+sharer_heat_capacity))

				self_temperature_delta = -heat/total_heat_capacity
				sharer_temperature_delta = heat/sharer_heat_capacity
			else
				return 1

			air.temperature += self_temperature_delta
			modeled_location.TakeTemperature(sharer_temperature_delta)


	else
		if((target.heat_capacity>0) && (partial_heat_capacity>0))
			var/delta_temperature = air.temperature - target.temperature

			var/heat = thermal_conductivity*delta_temperature* \
				(partial_heat_capacity*target.heat_capacity/(partial_heat_capacity+target.heat_capacity))

			air.temperature -= heat/total_heat_capacity
	update = TRUE
