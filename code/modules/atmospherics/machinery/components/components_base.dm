// So much of atmospherics.dm was used solely by components, so separating this makes things all a lot cleaner.
// On top of that, now people can add component-speciic procs/vars if they want!

/obj/machinery/atmospherics/components
	/// Pipenet flags for how we behave when connected to a pipenet. THIS SHOULD NEVER BE CHANGED IN RUNTIME.
	VAR_FINAL(aircomponent_flags) = NONE
	/// The volumes of our nodes. NEVER DIRECTLY EDIT THIS LIST, COPY IT FIRST! THIS IS A TYPELIST.
	var/list/node_volumes
	/// Only valid if we are NOT directly connected: The airs of our nodes.
	var/list/datum/gas_mixture/node_airs
	/// Temporarily stored airs if we are a directly connected component and our pipeline is broken down. THIS IS A LAZY LIST.
	var/list/datum/gas_mixture/temporary_node_airs
	/// The pipelines we are connected to by node.
	var/list/datum/pipeline/node_pipelines

	var/welded = FALSE //Used on pumps and scrubbers
	var/showpipe = FALSE
	var/shift_underlay_only = TRUE //Layering only shifts underlay?

/obj/machinery/atmospherics/components/Initialize(mapload, process = TRUE, setdir)
	node_pipelines = new(device_type)
	if(aircomponent_flags & AIRCOMPONENT_DIRECT_ATTACH)
		node_volumes = typelist("NODE_VOLUMES", node_volumes)
	else
		node_airs = new(device_type)
		for(var/i in 1 to device_type)
			var/datum/gas_mixture/A = new(node_volumes? (node_volumes[i] || 200) : 200)		//defaults to 200 liters.
	return ..()

/obj/machinery/atmospherics/components/temporarily_store_air(datum/pipeline/from)
	if(!(aircomponent_flags & AIRCOMPONENT_DIRECT_ATTACH))
		CRASH("Tried to temporarily store air, but we're not a direct attaching component.")
	var/nodeindex = node_pipelines.Find(from)
	if(!nodeindex)
		CRASH("Couldn't find pipeline in node pipeline list!")
	LAZYINITLIST(temporary_node_airs)
	temporary_node_airs.len = device_type
	var/datum/gas_mixture/parent_air = from.air
	var/datum/gas_mixture/temporary_air = temporary_node_airs[nodeindex] = new /datum/gas_mixture(node_volumes? (node_volumes[i] || 200) : 200)
	temporary_air.copy_from(parent_air)
	var/list/temp_gases = temporary_air.gases
	for(var/gasid in temp_gases)
		temp_gases[gasid] *= temporary_air.volume / parent_air.volume

// Pipenet stuff; housekeeping

/obj/machinery/atmospherics/components/nullifyNode(i)
	if(nodes[i])
		nullifyPipenet(parents[i])
		QDEL_NULL(airs[i])
	..()

/obj/machinery/atmospherics/components/on_construction()
	..()
	update_parents()

/obj/machinery/atmospherics/components/build_network()
	for(var/i in 1 to device_type)
		if(!parents[i])
			parents[i] = new /datum/pipeline()
			var/datum/pipeline/P = parents[i]
			P.build_pipeline(src)

/obj/machinery/atmospherics/components/proc/nullifyPipenet(datum/pipeline/reference)
	if(!reference)
		CRASH("nullifyPipenet(null) called by [type] on [COORD(src)]")
	var/i = parents.Find(reference)
	reference.other_airs -= airs[i]
	reference.other_atmosmch -= src
	parents[i] = null

/obj/machinery/atmospherics/components/return_pipenet_air(node = 1)
	return (aircomponent_flags & AIRCOMPONENT_DIRECT_ATTACH)
	return airs[parents.Find(reference)]

/obj/machinery/atmospherics/components/pipeline_expansion(datum/pipeline/from)
	if(from)
		return list(nodes[parents.Find(from)])
	return ..()

/obj/machinery/atmospherics/components/on_pipeline_join(obj/machinery/atmospherics/expanded_from, datum/pipeline/line)
	parents[nodes.Find(expanded_from)] = line

/obj/machinery/atmospherics/components/on_pipeline_replace(datum/pipeline/old, datum/pipeline/with)
	var/pl_index = node_pipelines.Find(old)
	if(!pl_index)
		CRASH("Attempted to pipeline replace and could not find the old pipeline as ours! SOMETHING HAS GONE TERRIBLY WRONG!")
	node_pipelines[pl_index] = with

/obj/machinery/atmospherics/components/returnPipenet(obj/machinery/atmospherics/A = nodes[1]) //returns parents[1] if called without argument
	return parents[nodes.Find(A)]

/obj/machinery/atmospherics/components/unsafe_pressure_release(var/mob/user, var/pressures)
	..()

	var/turf/T = get_turf(src)
	if(T)
		//Remove the gas from airs and assume it
		var/datum/gas_mixture/environment = T.return_air()
		var/lost = null
		var/times_lost = 0
		for(var/i in 1 to device_type)
			var/datum/gas_mixture/air = airs[i]
			lost += pressures*environment.volume/(air.temperature * R_IDEAL_GAS_EQUATION)
			times_lost++
		var/shared_loss = lost/times_lost

		var/datum/gas_mixture/to_release
		for(var/i in 1 to device_type)
			var/datum/gas_mixture/air = airs[i]
			if(!to_release)
				to_release = air.remove(shared_loss)
				continue
			to_release.merge(air.remove(shared_loss))
		T.assume_air(to_release)
		air_update_turf(1)

/obj/machinery/atmospherics/components/proc/safe_input(var/title, var/text, var/default_set)
	var/new_value = input(usr,text,title,default_set) as num
	if(usr.canUseTopic(src))
		return new_value
	return default_set

/**
  * Returns pipelines that are directly connected to each other through us
  */
/obj/machinery/atmospherics/components/proc/directly_connected_pipelines(datum/pipeline/from)
	return

// Helpers

/obj/machinery/atmospherics/components/proc/update_parents()
	for(var/i in 1 to device_type)
		var/datum/pipeline/parent = parents[i]
		if(!parent)
			stack_trace("Component is missing a pipenet! Rebuilding...")
			SSair.add_to_rebuild_queue(src)
		parent.update = 1

/obj/machinery/atmospherics/components/returnPipenets()
	. = list()
	for(var/i in 1 to device_type)
		. += returnPipenet(nodes[i])

// UI Stuff

/obj/machinery/atmospherics/components/ui_status(mob/user)
	if(allowed(user))
		return ..()
	to_chat(user, "<span class='danger'>Access denied.</span>")
	return UI_CLOSE

// Tool acts

/obj/machinery/atmospherics/components/analyzer_act(mob/living/user, obj/item/I)
	atmosanalyzer_scan(airs, user, src)

// Iconnery

/obj/machinery/atmospherics/components/proc/update_icon_nopipes()
	return

/obj/machinery/atmospherics/components/update_icon()
	update_icon_nopipes()

	underlays.Cut()

	var/turf/T = loc
	if(level == 2 || (istype(T) && !T.intact))
		showpipe = TRUE
		plane = GAME_PLANE
	else
		showpipe = FALSE
		plane = FLOOR_PLANE

	if(!showpipe)
		return //no need to update the pipes if they aren't showing

	var/connected = 0 //Direction bitset

	for(var/i in 1 to device_type) //adds intact pieces
		if(nodes[i])
			var/obj/machinery/atmospherics/node = nodes[i]
			var/image/img = get_pipe_underlay("pipe_intact", get_dir(src, node), node.pipe_color)
			underlays += img
			connected |= img.dir

	for(var/direction in GLOB.cardinals)
		if((initialize_directions & direction) && !(connected & direction))
			underlays += get_pipe_underlay("pipe_exposed", direction)

	if(!shift_underlay_only)
		PIPING_LAYER_SHIFT(src, piping_layer)

/obj/machinery/atmospherics/components/proc/get_pipe_underlay(state, dir, color = null)
	if(color)
		. = getpipeimage('icons/obj/atmospherics/components/binary_devices.dmi', state, dir, color, piping_layer = shift_underlay_only ? piping_layer : 2)
	else
		. = getpipeimage('icons/obj/atmospherics/components/binary_devices.dmi', state, dir, piping_layer = shift_underlay_only ? piping_layer : 2)
