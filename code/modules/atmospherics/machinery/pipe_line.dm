/**
  * Pipeline datums, consisting of directly connected pipes and components.
  * Merges into pipe network datums.
  */
/datum/pipeline
	/// Our temporarily stored air, consisting of all pipes and directly connected components to us. Used to hold air before we build our pipe network.
	var/datum/gas_mixture/temporary_air
	// Machinery are either in pipes, direct components, or indirect components.

	/// Pipes. They are all directly attached, with no gas mixtures of their own.
	var/list/obj/machinery/atmospherics/pipe/pipes
	/// Components that are directly attached.
	var/list/obj/machinery/atmospherics/components/direct_components
	/// Components that are not directly attached - These split air with us using reconcile_air().
	var/list/obj/machinery/atmospherics/components/indirect_components
	/// Components that can potentially directly connect us to other pipelines when building a pipe network. These are checked rather than all components. This is a LAZY LIST. This is also the only list that contains duplicates from the other lists.
	var/list/obj/machinery/atmospherics/components/valve_components
	/// Our volume, consisting of all pipes and directly attached components, in liters.
	var/volume = 0
	/// The total volume of all of our components plus us
	var/total_volume = 0
	/// Our parent pipe network.
	var/datum/pipe_network/parent
	/// The gas mixtures of indirectly attached components.
	var/list/datum/gas_mixture/component_airs
	/// Marks us as being destroyed or otherwise broken down or rebuilt. This means we should be invalid for air operations.
	var/invalid = TRUE

/datum/pipeline/New()
	volume = 0
	total_volume = 0
	pipes = list()
	direct_components = list()
	indirect_components = list()
	component_airs = list()
	SSair.pipelines += src

/datum/pipeline/Destroy()
	invalid = TRUE
	SSair.pipelines -= src
	breakdown()
	return ..()

/**
  * Disassembles us, storing our air into our resulting directly connected pipes.
  */
/datum/pipeline/proc/breakdown()
	breakdown_parent()
	var/obj/machinery/atmospherics/pipe/P
	for(var/i in pipes)
		P = i
		P.temporarily_store_air(src)
		P.parent = null
	var/obj/machinery/atmospherics/components/C
	for(var/i in direct_components)
		C = i
		C.temporarily_store_air(src)
		C.nullifyPipenet(src)
	for(var/i in indirect_components)
		C = i
		C.nullifyPipenet(src)
	pipes.len = 0
	direct_components.len = 0
	indirect_components.len = 0
	valve_components = null
	volume = 0
	total_volume = 0
	QDEL_NULL(air_temporary)

/**
  * Breakdowns our parent pipe network if it exists.
  */
/datum/pipeline/proc/breakdown_parent()
	parent?.breakdown()

/**
  * Temporarily stores air when our parent pipe network breaks down.
  */
/datum/pipeline/proc/temporarily_store_air()
	var/datum/gas_mixture/parent_air = parent.air
	temporary_air = new(volume)
	temporary_air.copy_from(parent_air)
	var/list/temp_gases = temporary_air.gases
	for(var/gasid in temp_gases)
		temp_gases[gasid] *= (volume / parent_air.volume

/**
  * Builds our network, expanding through whatever pipes we need to.
  * Here's what happens:
  * We disassemble ourselves
  * We go from our base node, call pipeline_expansion() to get stuff it's connected to, and disassemble that if it has a parent that isn't us
  * Depending on what it is, it's either a pipe, directly connected component, or indirectly connected component.
  * Components can also be valves, and it's added if necessary
  * This goes on for the things we just scanned with the first pipeline expansion
  * After all this is done, we now know our total volume.
  * We take all the air into our temporary_air.
  * We build our pipe_network datum from ourselves, and it handles taking the air from us and connected pipenets into it.
  */
/datum/pipeline/proc/build_network(obj/machinery/atmospherics/base, build_pipe_network = TRUE)
	breakdown()		// make sure we're empty, even if reusing pipelines isn't and probably shouldn't be a thing.
	total_volume = 0
	volume = 0
	air_temporary = new
	add_member(base, base)
	var/list/possible = list(base)
	var/list/gathered = list()			//lmfao we have like 4 lists this is faster
	while(length(possible))
		var/obj/machinery/atmospherics/A = possible[1]
		possible.Cut(1, 2)
		var/list/result = A.pipeline_expansion(src)
		for(var/obj/machinery/atmospherics/A in result)
			if(gathered[A])
				continue
			gathered[A] = TRUE
			add_member(A)
	if(build_pipe_network)
		build_parent()
	invalid = FALSE

/**
  * Builds our pipe network.
  */
/datum/pipeline/proc/build_parent()
	if(parent)
		return
	parent = new
	parent.build_network(src)

/datum/pipeline/proc/join_air(datum/gas_mixture/other)
	if(parent)
		parent.air.merge(other)
	else
		air_temporary.merge(other)

/datum/pipeline/proc/add_member(obj/machinery/atmospherics/from, obj/machinery/atmospherics/A)
	if(istype(A, /obj/machinery/atmospherics/pipe))
		var/obj/machinery/atmospherics/pipe/P = A
		if(P.parent && (P.parent != src))
			CRASH("Attempted to add a new member [A] from [from] with a different pipeline than us! SOMETHING HAS GONE TERRIBLY WRONG!")
		pipes += P
		adjustDirectVolume(P.volume)
		join_air(P.air_temporary)
		P.air_temporary = null
		P.parent = src
	else if(istype(A, /obj/machinery/atmospherics/components))
		var/obj/machinery/atmospherics/components/C = A
		var/nodeindex = A.nodes.Find(from) || A.node_pipelines.Find(src)
		if(!nodeindex)
			CRASH("Attempted to add an atmospherics component but could not find the index we're expanding into or from!")
		var/their_volume
		if(C.aircomponent_flags & AIRCOMPONENT_DIRECT_ATTACH)
			direct_components += C
			their_volume = (C.node_volumes && !isnull(C.node_volumes[nodeindex]))? C.node_volumes[nodeindex] : 200
			adjustDirectVolume(their_volume)
			if(C.temporary_node_airs && C.temporary_node_airs[nodeindex])
				join_air(C.temporary_node_airs[nodeindex])
				QDEL_NULL(C.temporary_node_airs[nodeindex])
				var/empty = TRUE
				for(var/i in 1 to length(C.temporary_node_airs))
					if(C.temporary_node_airs[i])
						empty = FALSE
						break
				C.temporary_node_airs = null
		else
			indirect_components += C
			their_volume = C.node_airs[nodeindex]
			component_airs += C.node_airs[nodeindex]
			adjustIndirectVolume(their_volume)
		C.node_pipelines[nodeindex] = src
		if(C.aircomponent_flags & AIRCOMPONENT_POTENTIAL_VALVE)
			valve_components += C
	else
		CRASH("Attempted to add member that wasn't a pipe or a component: [A].")

/**
  * Expands to expansion from source.
  * expansion.on_pipeline_join handles adding them to us.
  * This is probably bad code as we optimally should handle everything in here instead of having something else handle addition but eh.
  */
/datum/pipeline/proc/expand_to(obj/machinery/atmospherics/source, obj/machinery/atmospherics/expansion)
	expansion.on_pipeline_join(source, src)

/**
  * Adjusts our direct total volume.
  */
/datum/pipeline/proc/adjustDirectVolume(amount)
	volume += amount
	total_volume += amount
	parent?.adjustDirectVolume(amount)

/**
  * Adjusts our indirect total volume.
  */
/datum/pipeline/proc/adjustIndirectVolume(amount)
	total_volume += amount

/**
  * Merges with another pipeline, taking all of them into us.
  */
/datum/pipeline/proc/merge(datum/pipeline/P)
	if(E == src)
		return
	// simple heuristic
	if(length(pipes) < length(P.pipes))
		return P.merge(src)
	breakdown_parent()
	P.breakdown_parent()
	volume += P.volume
	total_volume += P.volume
	temporay_air.merge(P.temporary_air)
	for(var/obj/machinery/atmospherics/A in P.pipes | P.direct_components | P.indirect_components)
		A.on_pipeline_replace(P, src)
	pipes += P.pipes
	direct_components |= P.direct_components		// components can be on two networks at once. pipes can't.
	indirect_components |= P.indirect_components
	P.pipes.len = 0
	P.direct_components.len = 0
	P.indirect_components.len = 0
	component_airs += P.component_airs
	P.component_airs.len = 0
	valve_components |= P.valve_components
	P.valve_components.len = 0
	parent = new
	parent.build_network(src)
	update = TRUE

/datum/pipeline/proc/temperature_interact(turf/target, share_volume, thermal_conductivity)
	return parent.temperature_interact(target, share_volume, thermal_conductivity)
