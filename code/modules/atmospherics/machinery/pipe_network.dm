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
	var/update = FALSE
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
		// now, if they have any potentially valve components
		for(var/i in P.valve_components)
			// expand through them
			var/obj/machinery/atmospherics/components/C = i
			expand_through |= C.directly_connected_pipenets(P)
	air.volume = total_volume
	invalid = TRUE

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

/datum/pipe_network/process()
	if(invalid)
		return
	if(update)
		update = FALSE
		equalization_tick()
	update = air.react(src)
