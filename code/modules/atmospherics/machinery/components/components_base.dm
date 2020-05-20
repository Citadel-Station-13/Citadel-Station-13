// So much of atmospherics.dm was used solely by components, so separating this makes things all a lot cleaner.
// On top of that, now people can add component-speciic procs/vars if they want!

/obj/machinery/atmospherics/components
	/// Pipenet flags for how we behave when connected to a pipenet. THIS SHOULD NEVER BE CHANGED IN RUNTIME.
	VAR_FINAL/aircomponent_flags = NONE
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
	var/datum/gas_mixture/temporary_air = new /datum/gas_mixture(node_volumes? (node_volumes[i] || 200) : 200)
	temporary_node_airs[nodeindex] = temporary_air
	temporary_air.copy_from(parent_air)
	var/list/temp_gases = temporary_air.gases
	for(var/gasid in temp_gases)
		temp_gases[gasid] *= temporary_air.volume / parent_air.volume

// Pipenet stuff; housekeeping

/obj/machinery/atmospherics/components/form_networks(build_pipe_networks = TRUE)
	var/datum/pipeline/P
	for(var/i in 1 to device_type)
		P = node_pipelines[i]
		if(!QDELETED(P))
			continue
		P = new
		node_pipelines[i] = P
		P.build_network(src, build_pipe_networks)
	update_parents()

/obj/machinery/atmospherics/components/breakdown_networks()
	if(aircomponent_flags & AIRCOMPONENT_DIRECT_ATTACH)
		QDEL_LIST(node_pipelines)
		node_pipelines.len = device_type
	else
		for(var/i in 1 to device_type)
			var/datum/pipeline/P = node_pipelines[i]
			P.component_airs -= node_airs[i]
			P.indirect_components -= src
			P.total_volume -= node_airs[i].volume
		node_pipelines = new(4)

/obj/machinery/atmospherics/components/return_pipenet_air(node = 1)
	var/datum/pipeline/PL = node_pipelines[node]
	return PL.return_air()

/obj/machinery/atmospherics/components/return_all_pipenet_airs()
	. = list()
	var/datum/pipeline/PL
	for(var/i in 1 to device_type)
		PL = node_pipelines[i]
		. += PL.return_air()

/obj/machinery/atmospherics/components/pipeline_expansion(datum/pipeline/from)
	if(from)
		return list(nodes[parents.Find(from)])
	return ..()

/obj/machinery/atmospherics/components/pipeline_join(obj/machinery/atmospherics/expanded_from, datum/pipeline/line)
	var/nodeindex = nodes.Find(expanded_from) || node_pipelines.Find(line)
	if(!nodeindex)
		CRASH("pipeline join on component couldn't find nodeindex.")
	if(node_pipelines[nodeindex])
		var/datum/pipeline/P = node_pipelines[nodeindex]
		P.merge(line)
	else
		line.add_member(expanded_from, src)
		for(var/obj/machinery/atmospherics/A in pipeline_expansion())
			line.expand_to(src, A)

/obj/machinery/atmospherics/components/on_pipeline_replace(datum/pipeline/old, datum/pipeline/with)
	var/pl_index = node_pipelines.Find(old)
	if(!pl_index)
		CRASH("Attempted to pipeline replace and could not find the old pipeline as ours! SOMETHING HAS GONE TERRIBLY WRONG!")
	node_pipelines[pl_index] = with

/obj/machinery/atmospherics/components/return_pipenet(node = 1)
	return node_pipelines[node]

/obj/machinery/atmospherics/components/return_pipenets()
	return node_pipelines

/obj/machinery/atmospherics/components/QueuePipenetRebuild(node = 1)
	for(var/datum/pipeline/PL in node_pipelines)
		PL.invalid = TRUE
	SSair.add_to_rebuild_queue(src)

/obj/machinery/atmospherics/components/RebuildNodePipenet(node = 1)
	var/datum/pipeline/PL = node_pipelines[node]
	if(PL)
		PL.invalid = TRUE
	node_pipelines[node] = PL = new /datum/pipeline
	PL.build_network(src)

/obj/machinery/atmospherics/components/RebuildAllPipenets()
	breakdown_networks()
	form_networks()

/obj/machinery/atmospherics/components/ReleaseAirToTurf()
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/release = new
	for(var/i in 1 to length(temporary_node_airs))
		var/datum/gas_mixture/G = temporary_node_airs[i]
		if(!G)
			continue
		release.merge(G)
	temporary_node_airs = null
	T.assume_air(release)
	air_update_turf()

/obj/machinery/atmospherics/components/proc/safe_input(var/title, var/text, var/default_set)
	var/new_value = input(usr,text,title,default_set) as num
	if(usr.canUseTopic(src))
		return new_value
	return default_set

/**
  * Returns pipelines that are directly connected to each other through us
  */
/obj/machinery/atmospherics/components/proc/directly_connected_pipelines(datum/pipeline/from)
	ensure_pipelines_exists_for_network_build()
	return list(from)

/**
  * Ensures all pipelines are built. Doesn't build overarching pipe network.
  */
/obj/machinery/atmospherics/components/proc/ensure_pipelines_exists_for_network_build()
	form_networks(FALSE)

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
	atmosanalyzer_scan((flags & ATMOSCOMPONENT_DIRECT_ATTACH)? return_all_pipenet_airs() : node_airs, user, src)

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
