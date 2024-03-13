/turf
	//used for temperature calculations
	//conductivity is divided by 10 when interacting with air for balance purposes
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//list of open turfs adjacent to us
	var/list/atmos_adjacent_turfs
	//bitfield of dirs in which we thermal conductivity is blocked
	var/conductivity_blocked_directions = NONE

	//used for mapping and for breathing while in walls (because that's a thing that needs to be accounted for...)
	//string parsed by /datum/gas/proc/copy_from_turf
	var/initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	//approximation of MOLES_O2STANDARD and MOLES_N2STANDARD pending byond allowing constant expressions to be embedded in constant strings
	// If someone will place 0 of some gas there, SHIT WILL BREAK. Do not do that.

/turf/open
	//used for spacewind
	var/pressure_difference = 0
	var/pressure_direction = 0
	var/turf/pressure_specific_target

	var/datum/gas_mixture/turf/air

	var/obj/effect/hotspot/active_hotspot
	var/planetary_atmos = FALSE //air will revert to initial_gas_mix over time

	var/list/atmos_overlay_types //gas IDs of current active gas overlays

/turf/open/Initialize(mapload)
	if(!blocks_air)
		air = new(2500,src)
		air.copy_from_turf(src)
		if(planetary_atmos && !(initial_gas_mix in SSair.planetary))
			var/datum/gas_mixture/mix = new
			mix.parse_gas_string(initial_gas_mix)
			mix.mark_immutable()
			SSair.planetary[initial_gas_mix] = mix
		update_air_ref(planetary_atmos ? 1 : 2)
	. = ..()

/turf/open/Destroy()
	if(active_hotspot)
		QDEL_NULL(active_hotspot)
	return ..()

/////////////////GAS MIXTURE PROCS///////////////////

/turf/open/assume_air(datum/gas_mixture/giver) //use this for machines to adjust air
	return assume_air_ratio(giver, 1)

/turf/open/assume_air_moles(datum/gas_mixture/giver, moles)
	if(!giver)
		return FALSE
	giver.transfer_to(air, moles)
	return TRUE

/turf/open/assume_air_ratio(datum/gas_mixture/giver, ratio)
	if(!giver)
		return FALSE
	giver.transfer_ratio_to(air, ratio)
	return TRUE

/turf/open/transfer_air(datum/gas_mixture/taker, moles)
	if(!taker || !return_air()) // shouldn't transfer from space
		return FALSE
	air.transfer_to(taker, moles)
	return TRUE

/turf/open/transfer_air_ratio(datum/gas_mixture/taker, ratio)
	if(!taker || !return_air())
		return FALSE
	air.transfer_ratio_to(taker, ratio)
	return TRUE

/turf/open/remove_air(amount)
	var/datum/gas_mixture/ours = return_air()
	var/datum/gas_mixture/removed = ours.remove(amount)
	return removed

/turf/open/remove_air_ratio(ratio)
	var/datum/gas_mixture/ours = return_air()
	var/datum/gas_mixture/removed = ours.remove_ratio(ratio)
	return removed

/turf/open/proc/copy_air_with_tile(turf/open/T)
	if(istype(T))
		air.copy_from(T.air)

/turf/open/proc/copy_air(datum/gas_mixture/copy)
	if(copy)
		air.copy_from(copy)

/turf/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	var/datum/gas_mixture/GM = new
	GM.copy_from_turf(src)
	return GM

/turf/open/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	return air

/turf/temperature_expose()
	if(return_temperature() > heat_capacity)
		to_be_destroyed = TRUE

/turf/open/proc/eg_reset_cooldowns()
/turf/open/proc/eg_garbage_collect()
/turf/open/proc/get_excited()
/turf/open/proc/set_excited()

/////////////////////////GAS OVERLAYS//////////////////////////////


/turf/open/proc/update_visuals()

	var/list/atmos_overlay_types = src.atmos_overlay_types // Cache for free performance
	var/list/new_overlay_types = list()
	var/static/list/nonoverlaying_gases = typecache_of_gases_with_no_overlays()

	if(!air) // 2019-05-14: was not able to get this path to fire in testing. Consider removing/looking at callers -Naksu
		if (atmos_overlay_types)
			for(var/overlay in atmos_overlay_types)
				vis_contents -= overlay
			src.atmos_overlay_types = null
		return

	for(var/id in air.get_gases())
		if (nonoverlaying_gases[id])
			continue
		var/gas_overlay = GLOB.gas_data.overlays[id]
		if(gas_overlay && air.get_moles(id) > GLOB.gas_data.visibility[id])
			new_overlay_types += gas_overlay[min(FACTOR_GAS_VISIBLE_MAX, CEILING(air.get_moles(id) / MOLES_GAS_VISIBLE_STEP, 1))]

	if (atmos_overlay_types)
		for(var/overlay in atmos_overlay_types-new_overlay_types) //doesn't remove overlays that would only be added
			vis_contents -= overlay

	if (length(new_overlay_types))
		if (atmos_overlay_types)
			vis_contents += new_overlay_types - atmos_overlay_types //don't add overlays that already exist
		else
			vis_contents += new_overlay_types

	UNSETEMPTY(new_overlay_types)
	src.atmos_overlay_types = new_overlay_types

/turf/open/proc/set_visuals(list/new_overlay_types)
	if (atmos_overlay_types)
		for(var/overlay in atmos_overlay_types-new_overlay_types) //doesn't remove overlays that would only be added
			vis_contents -= overlay

	if (length(new_overlay_types))
		if (atmos_overlay_types)
			vis_contents += new_overlay_types - atmos_overlay_types //don't add overlays that already exist
		else
			vis_contents += new_overlay_types
	UNSETEMPTY(new_overlay_types)
	src.atmos_overlay_types = new_overlay_types

/proc/typecache_of_gases_with_no_overlays()
	. = list()
	for (var/gastype in subtypesof(/datum/gas))
		var/datum/gas/gasvar = gastype
		if (!initial(gasvar.gas_overlay))
			.[initial(gasvar.id)] = TRUE

/////////////////////////////SIMULATION///////////////////////////////////

/*#define LAST_SHARE_CHECK \
	var/last_share = our_air.get_last_share();\
	if(last_share > MINIMUM_AIR_TO_SUSPEND){\
		our_excited_group.reset_cooldowns();\
		cached_atmos_cooldown = 0;\
	} else if(last_share > MINIMUM_MOLES_DELTA_TO_MOVE) {\
		our_excited_group.dismantle_cooldown = 0;\
		cached_atmos_cooldown = 0;\
	}
*/
/turf/proc/process_cell(fire_count)

/turf/open/proc/equalize_pressure_in_zone(cyclenum)
/turf/open/proc/consider_firelocks(turf/T2)
	var/reconsider_adj = FALSE
	for(var/obj/machinery/door/firedoor/FD in T2)
		if((FD.flags_1 & ON_BORDER_1) && get_dir(T2, src) != FD.dir)
			continue
		FD.emergency_pressure_stop()
		reconsider_adj = TRUE
	for(var/obj/machinery/door/firedoor/FD in src)
		if((FD.flags_1 & ON_BORDER_1) && get_dir(src, T2) != FD.dir)
			continue
		FD.emergency_pressure_stop()
		reconsider_adj = TRUE
	if(reconsider_adj)
		T2.ImmediateCalculateAdjacentTurfs() // We want those firelocks closed yesterday.

/turf/proc/handle_decompression_floor_rip()
/turf/open/floor/handle_decompression_floor_rip(sum)
	if(sum > 20 && prob(clamp(sum / 10, 0, 30)))
		remove_tile()

/turf/open/process_cell(fire_count)

//////////////////////////SPACEWIND/////////////////////////////

/turf/proc/consider_pressure_difference()
	return

/turf/open/consider_pressure_difference(turf/T, difference)
	if(difference > pressure_difference)
		pressure_direction = get_dir(src, T)
		pressure_difference = difference
		SSair.high_pressure_delta[src] = TRUE

/turf/open/proc/high_pressure_movements()
	var/diff = pressure_difference
	if(locate(/obj/structure/rack) in src)
		diff *= 0.1
	else if(locate(/obj/structure/table) in src)
		diff *= 0.2
	for(var/obj/M in src)
		if(!M.anchored && !M.pulledby && M.last_high_pressure_movement_air_cycle < SSair.times_fired)
			M.experience_pressure_difference(diff, pressure_direction, 0, pressure_specific_target)
	for(var/mob/M in src)
		if(!M.anchored && !M.pulledby && M.last_high_pressure_movement_air_cycle < SSair.times_fired)
			M.experience_pressure_difference(diff, pressure_direction, 0, pressure_specific_target)
	/*
	if(pressure_difference > 100)
		new /obj/effect/temp_visual/dir_setting/space_wind(src, pressure_direction, clamp(round(sqrt(pressure_difference) * 2), 10, 255))
	*/

/atom/movable/var/pressure_resistance = 10
/atom/movable/var/last_high_pressure_movement_air_cycle = 0

/atom/movable/proc/experience_pressure_difference(pressure_difference, direction, pressure_resistance_prob_delta = 0, throw_target)
	var/const/PROBABILITY_OFFSET = 25
	var/const/PROBABILITY_BASE_PRECENT = 75
	var/max_force = sqrt(pressure_difference)*(MOVE_FORCE_DEFAULT / 5)
	set waitfor = 0
	var/move_prob = 100
	if (pressure_resistance > 0)
		move_prob = (pressure_difference/pressure_resistance*PROBABILITY_BASE_PRECENT)-PROBABILITY_OFFSET
	move_prob += pressure_resistance_prob_delta
	if (move_prob > PROBABILITY_OFFSET && prob(move_prob) && (move_resist != INFINITY) && (!anchored && (max_force >= (move_resist * MOVE_FORCE_PUSH_RATIO))) || (anchored && (max_force >= (move_resist * MOVE_FORCE_FORCEPUSH_RATIO))))
		step(src, direction)

