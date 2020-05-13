/**
  * Pipeline datums, consisting of directly connected pipes and components.
  * Merges into pipe network datums.
  */
/datum/pipeline
	/// Our temporarily stored air, consisting of all pipes and directly connected components to us. Used to hold air before we build our pipe network.
	var/datum/gas_mixture/temporary_air
	/// Pipes. They are all directly attached, with no gas mixtures of their own.
	var/list/obj/machinery/atmospherics/pipe/pipes
	/// Components that are directly attached.
	var/list/obj/machinery/atmospherics/components/direct_components
	/// Components that are not directly attached - These split air with us using reconcile_air().
	var/list/obj/machinery/atmospherics/components/indirect_components
	/// Components that can potentially directly connect us to other pipelines when building a pipe network. These are checked rather than all components. This is a LAZY LIST.
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
	if(parent)
		parent.breakdown()
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

	var/volume = 0
	if(istype(base, /obj/machinery/atmospherics/pipe))
		var/obj/machinery/atmospherics/pipe/E = base
		volume = E.volume
		members += E
		if(E.air_temporary)
			air = E.air_temporary
			E.air_temporary = null
	else
		addMachineryMember(base)
	if(!air)
		air = new
	var/list/possible_expansions = list(base)
	while(possible_expansions.len>0)
		for(var/obj/machinery/atmospherics/borderline in possible_expansions)

			var/list/result = borderline.pipeline_expansion(src)

			if(result.len>0)
				for(var/obj/machinery/atmospherics/P in result)
					if(istype(P, /obj/machinery/atmospherics/pipe))
						var/obj/machinery/atmospherics/pipe/item = P
						if(!members.Find(item))

							if(item.parent)
								var/static/pipenetwarnings = 10
								if(pipenetwarnings > 0)
									log_mapping("build_pipeline(): [item.type] added to a pipenet while still having one. (pipes leading to the same spot stacking in one turf) Nearby: ([item.x], [item.y], [item.z]).")
									pipenetwarnings -= 1
									if(pipenetwarnings == 0)
										log_mapping("build_pipeline(): further messages about pipenets will be suppressed")
							members += item
							possible_expansions += item

							volume += item.volume
							item.parent = src

							if(item.air_temporary)
								air.merge(item.air_temporary)
								item.air_temporary = null
					else
						P.setPipenet(src, borderline)
						addMachineryMember(P)

			possible_expansions -= borderline

	air.volume = volume
	invalid = FALSE

/datum/pipeline/proc/addMachineryMember(obj/machinery/atmospherics/components/C)
	other_atmosmch |= C
	var/datum/gas_mixture/G = C.returnPipenetAir(src)
	if(!G)
		stack_trace("addMachineryMember: Null gasmix added to pipeline datum from [C] which is of type [C.type]. Nearby: ([C.x], [C.y], [C.z])")
	other_airs |= G

/**
  * Add an atmospherics machinery to us.
  */
/datum/pipeline/proc/(obj/machinery/atmospherics/FROM, obj/machinery/atmospherics/TO)

/datum/pipeline/proc/addMember(obj/machinery/atmospherics/A, obj/machinery/atmospherics/N)
	if(istype(A, /obj/machinery/atmospherics/pipe))
		var/obj/machinery/atmospherics/pipe/P = A
		if(P.parent)
			merge(P.parent)
		P.parent = src
		var/list/adjacent = P.pipeline_expansion()
		for(var/obj/machinery/atmospherics/pipe/I in adjacent)
			if(I.parent == src)
				continue
			var/datum/pipeline/E = I.parent
			merge(E)
		if(!members.Find(P))
			members += P
			air.volume += P.volume
	else
		A.setPipenet(src, N)
		addMachineryMember(A)

/datum/pipeline/proc/merge(datum/pipeline/E)
	if(E == src)
		return
	air.volume += E.air.volume
	members.Add(E.members)
	for(var/obj/machinery/atmospherics/pipe/S in E.members)
		S.parent = src
	air.merge(E.air)
	for(var/obj/machinery/atmospherics/components/C in E.other_atmosmch)
		C.replacePipenet(E, src)
	other_atmosmch.Add(E.other_atmosmch)
	other_airs.Add(E.other_airs)
	E.members.Cut()
	E.other_atmosmch.Cut()
	update = TRUE
	qdel(E)

/obj/machinery/atmospherics/proc/addMember(obj/machinery/atmospherics/A)
	return

/obj/machinery/atmospherics/pipe/addMember(obj/machinery/atmospherics/A)
	parent.addMember(A, src)

/obj/machinery/atmospherics/components/addMember(obj/machinery/atmospherics/A)
	var/datum/pipeline/P = returnPipenet(A)
	if(!P)
		CRASH("null.addMember() called by [type] on [COORD(src)]")
	P.addMember(A, src)

/datum/pipeline/proc/temperature_interact(turf/target, share_volume, thermal_conductivity)
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
