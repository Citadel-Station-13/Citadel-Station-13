/**
  * Pipes. They are expected to always directly exist on a pipeline, rather than holding its own air.
  */
/obj/machinery/atmospherics/pipe
	/// Used to reconstruct a pipeline that was broken/separated.
	var/datum/gas_mixture/temporary_air
	/// Our volume, in liters. ALL DYNAMIC VOLUME CHANGES MUST USE set_volume()!
	PRIVATE_VAR(volume)
	/// The pipeline that we belong to.
	var/datum/pipeline/pipeline

	level = 1

	use_power = NO_POWER_USE
	can_unwrench = 1

	//Buckling
	can_buckle = 1
	buckle_requires_restraints = 1
	buckle_lying = -1

/obj/machinery/atmospherics/pipe/Initialize(mapload)
	add_atom_colour(pipe_color, FIXED_COLOUR_PRIORITY)
	if(isnull(volume))
		volume = 35 * device_type
	return ..()

/obj/machinery/atmospherics/pipe/form_networks()
	if(parent)
		return
	parent = new
	parent.build_network(src)

/obj/machinery/atmospherics/pipe/breakdown_networks()
	QDEL_NULL(parent)

/obj/machinery/atmospherics/pipe/on_disconnect(obj/machinery/atmospherics/other)
	. = ..()
	QueuePipenetRebuild()		// they probably destroyed our network. i should probably have a better system than this but eh.

/obj/machinery/atmospherics/pipe/atmosinit()
	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	return ..()

/**
  * Sets our volume and updates our pipenet accordingly if necessary.
  */
/obj/machinery/atmospherics/pipe/proc/set_volume(new_volume)
	var/diff = new_volume - volume
	volume = new_volume
	parent?.adjustDirectVolume(diff)

/obj/machinery/atmospherics/pipe/temporarily_store_air(datum/pipeline/from)
	var/datum/gas_mixture/parent_air = parent.temporary_air
	temporary_air = new(volume)
	temporary_air.copy_from(parent_air)
	var/list/temp_gases = temporary_air.gases
	for(var/gasid in temp_gases)
		temp_gases[gasid] *= (volume / parent_air.volume

/obj/machinery/atmospherics/pipe/PropEdit(var_name, var_value)
	if(var_name == NAMEOF(src, volume))
		set_volume(var_value)
		return
	return ..()

/obj/machinery/atmospherics/pipe/hide(i)
	if(level == 1 && isturf(loc))
		invisibility = i ? INVISIBILITY_MAXIMUM : 0
	update_icon()

/obj/machinery/atmospherics/pipe/proc/ReleaseAirToTurf()
	if(air_temporary)
		var/turf/T = loc
		T.assume_air(air_temporary)
		air_update_turf()

/obj/machinery/atmospherics/pipe/return_air()
	return return_pipenet_air()

/obj/machinery/atmospherics/pipe/remove_air(amount)
	var/datum/gas_mixture/GM = return_pipenet_air()
	return GM?.remove(amount)

/obj/machinery/atmospherics/pipe/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pipe_meter))
		var/obj/item/pipe_meter/meter = W
		user.dropItemToGround(meter)
		meter.setAttachLayer(piping_layer)
	else
		return ..()

/obj/machinery/atmospherics/pipe/analyzer_act(mob/living/user, obj/item/I)
	atmosanalyzer_scan(parent.air, user, src)

/obj/machinery/atmospherics/pipe/return_pipenets()
	return list(parent)

/obj/machinery/atmospherics/pipe/return_pipenet()
	return parent

/obj/machinery/atmospherics/pipe/return_pipenet_air()
	return parent.return_air()

/obj/machinery/atmospherics/pipe/on_pipeline_join(obj/machinery/atmospherics/expanded_from, datum/pipeline/line)
	if(parent)
		line.merge(parent)
	else
		line.add_member(expanded_from, src)
		for(var/obj/machinery/atmospherics/A in pipeline_expansion())
			parent.expand_to(src, A)

/obj/machinery/atmospherics/pipe/on_pipeline_replace(datum/pipeline/old, datum/pipeline/with)
	if(old != parent)
		stack_trace("Pipeline replacement proc called with an old pipeline that wasn't ours! SOMETHING HAS GONE HORRIBLY WRONG!")
	parent = with

/obj/machinery/atmospherics/pipe/QueuePipenetRebuild(node = 1)
	parent?.invalid = TRUE
	SSair.add_to_rebuild_queue(src)

/obj/machinery/atmospherics/pipe/RebuildNodePipenet(node = 1)
	return RebuildAllPipenets()

/obj/machinery/atmospherics/pipe/RebuildAllPipenets()
	breakdown_networks()
	form_networks()

/obj/machinery/atmospherics/pipe/expand_pipeline_to(obj/machinery/atmospherics/expand_to)
	parent.expand_to(src, expand_to)

/obj/machinery/atmospherics/pipe/Destroy()
	var/turf/T = loc
	for(var/obj/machinery/meter/meter in T)
		if(meter.target == src)
			var/obj/item/pipe_meter/PM = new (T)
			meter.transfer_fingerprints_to(PM)
			qdel(meter)
	return ..()

/obj/machinery/atmospherics/pipe/update_alpha()
	alpha = invisibility ? 64 : 255

/obj/machinery/atmospherics/pipe/proc/update_node_icon()
	for(var/i in 1 to device_type)
		if(nodes[i])
			var/obj/machinery/atmospherics/N = nodes[i]
			N.update_icon()

/obj/machinery/atmospherics/pipe/returnPipenets()
	. = list(parent)

/obj/machinery/atmospherics/pipe/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == "melee" && damage_amount < 12)
		return 0
	. = ..()

/obj/machinery/atmospherics/pipe/proc/paint(paint_color)
	add_atom_colour(paint_color, FIXED_COLOUR_PRIORITY)
	pipe_color = paint_color
	update_node_icon()
	return TRUE
