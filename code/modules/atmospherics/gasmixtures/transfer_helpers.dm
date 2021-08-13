// Helpers for machine transfer, taking into account power draws, max pressures, max volumes, etc.
// All of these also, if provided with machine parameter, set the machine's last_power_draw and last_transfer_rate.

/**
 * Gas pumping proc
 * Moves gas from source to sink.
 * Returns the amount of power needed in watts
 *
 * @params
 * * source - Source mixture
 * * sink - Destination mixture
 * * transfer_moles - moles to try to transfer
 * * available_power - power able to be used.
 * * efficiency_multiplier - amplify available power by this much
 */
/proc/pump_gas(datum/gas_mixture/source, datum/gas_mixture/sink, transfer_moles, available_power = INFINITY, efficiency_multiplier = 1)
	efficiency_multiplier *= (ATMOSMECH_GLOBAL_EFFICIENCY_MULTIPLIER * ATMOSMECH_PUMP_EFFICIENCY_MULTIPLIER)
	var/source_moles = source.total_moles()
	if(source_moles < ATMOSMECH_INSTANT_PUMP_MOLES || source.return_pressure() < ATMOSMECH_INSTANT_PUMP_PRESSURE)
		source.transfer_ratio_to(sink, 1)
		return 0
	transfer_moles = isnull(transfer_moles)? source_moles : min(transfer_moles, source_moles)
	var/specific_power = calculate_specific_power(source, sink) / efficiency_multiplier
	if(!isnull(available_power) && specific_power > 0)
		transfer_moles = min(transfer_moles, (available_power / specific_power) + (source_moles * (ATMOSMECH_PUMP_FREE_VOLUME / source.return_volume())))
	if(QUANTIZE(transfer_moles) <= 0)
		return 0
	source.transfer_to(sink, min(source_moles, transfer_moles))
	return specific_power * transfer_moles

/**
 * Gas scrubbing proc
 * Moves scrubbing gasids from source to sink.
 * Returns the amount of power needed in watts
 *
 * @params
 * * gasids - list of gas ids to scrub.
 * * source - Source mixture
 * * sink - Destination mixture
 * * transfer_moles - moles to try to transfer
 * * available_power - power able to be used.
 * * efficiency_multiplier - amplify available power by this much
 */
/proc/scrub_gas(list/gasids, datum/gas_mixture/source, datum/gas_mixture/sink, transfer_moles, available_power = INFINITY, efficiency_multiplier = 1)
	efficiency_multiplier *= (ATMOSMECH_GLOBAL_EFFICIENCY_MULTIPLIER * ATMOSMECH_SCRUB_EFFICIENCY_MULTIPLIER)

	var/source_moles = source.total_moles()
	if(source_moles < ATMOSMECH_INSTANT_PUMP_MOLES || source.return_pressure() < ATMOSMECH_INSTANT_PUMP_PRESSURE)
		source.scrub_into(sink, 1, gasids)
		return 0
	gasids = gasids & source.get_gases()
	var/total_filterable_moles = 0
	var/list/specific_power_gas = list()
	for(var/gasid in gasids)
		var/source_gas_moles = source.get_moles(gasid)
		total_filterable_moles += source_gas_moles
		if(source_gas_moles < ATMOSMECH_INSTANT_PUMP_MOLES)
			specific_power_gas[gasid] = 0
			continue
		specific_power_gas[gasid] = calculate_specific_power_gas(gasid, source, sink) / efficiency_multiplier

	if(QUANTIZE(total_filterable_moles) <= 0)
		return 0
	transfer_moles = isnull(transfer_moles)? total_filterable_moles : min(transfer_moles, total_filterable_moles)
	var/mole_ratio = transfer_moles / total_filterable_moles
	var/power_needed = 0
	for(var/gasid in gasids)
		power_needed += specific_power_gas[gasid] * source.get_moles(gasid) * mole_ratio
	if(!isnull(available_power) && power_needed > 0)
		clamp(mole_ratio, 0, min((power_needed / available_power) + (ATMOSMECH_PUMP_FREE_VOLUME / source.return_volume()), 1))
	. = min(available_power, power_needed)
	source.scrub_into(sink, mole_ratio, gasids)

/**
 * Gas filtering proc
 * Moves gas from source to sink, except filtered gasids, which goes into associated filter
 * Returns the amount of power needed in watts
 *
 * @params
 * * gasids - gasids to filter out **associated to gas mixtures to filter them into**
 * * source - Source mixture
 * * sink - Destination mixture
 * * transfer_moles - moles to try to transfer
 * * available_power - power able to be used.
 * * efficiency_multiplier - amplify available power by this much
 */
/proc/filter_gas(list/gasids, datum/gas_mixture/source, datum/gas_mixture/sink, transfer_moles, available_power = INFINITY, efficiency_multiplier = 1)
	efficiency_multiplier *= (ATMOSMECH_GLOBAL_EFFICIENCY_MULTIPLIER * ATMOSMECH_FILTER_EFFICIENCY_MULTIPLIER)
	var/source_moles = source.total_moles()
	if(source.return_pressure() < ATMOSMECH_INSTANT_PUMP_PRESSURE || source_moles < ATMOSMECH_INSTANT_PUMP_MOLES)
		for(var/gasid in gasids)
			var/moles = source.get_moles(gasid)
			if(moles)
				source.adjust_moles(gasid, -moles)
				var/datum/gas_mixture/GM = gasids[gasid]
				GM.adjust_moles(gasid, moles)
		source.transfer_ratio_to(sink, 1)
		return 0

	var/total_specific_power = 0
	for(var/gasid in source.get_gases())
		if(source.get_moles(gasid) < ATMOSMECH_INSTANT_PUMP_MOLES)
			continue
		if(gasids[gasid])
			var/datum/gas_mixture/GM = gasids[gasid]
			total_specific_power += calculate_specific_power_gas(gasid, source, GM)
		else
			total_specific_power += calculate_specific_power_gas(source, sink)
	transfer_moles = isnull(transfer_moles)? source_moles : min(transfer_moles, source_moles)
	var/power_needed = total_specific_power * transfer_moles
	var/ratio = (isnull(available_power) || !total_specific_power)? 1 : clamp(power_needed / available_power + (ATMOSMECH_PUMP_FREE_VOLUME / source.return_volume()), 0, 1)
	. = min(available_power, power_needed)
	for(var/gasid in source.get_gases())
		var/moles = source.get_moles(gasid) * ratio
		source.adjust_moles(gasid, -moles)
		if(gasids[gasid])
			var/datum/gas_mixture/GM = gasids[gasid]
			GM.adjust_moles(gasid, moles)
		else
			sink.adjust_moles(gasid, moles)

/**
 * Gas mixing proc
 * Moves gas from sources to sink.
 * Returns the amount of power needed in watts
 *
 * WARNING WARNING WARNING: THIS PROC DOES NOT ENSURE SOURCES ADDS UP TO 1! It's simply too expensive a computation to do all the time.
 * The caller is EXPECTED to ensure it does.
 *
 * @params
 * * sources - Source mixtures associated by a ratio (0 to 1). Must add up to 1 or horrible things happen.
 * * sink - Destination mixture
 * * transfer_moles - moles to try to transfer
 * * available_power - power able to be used.
 * * efficiency_multiplier - amplify available power by this much
 */
/proc/mix_gas(list/datum/gas_mixture/sources, datum/gas_mixture/sink, transfer_moles, available_power = INFINITY, efficiency_multiplier = 1)
	efficiency_multiplier *= (ATMOSMECH_GLOBAL_EFFICIENCY_MULTIPLIER * ATMOSMECH_MIX_EFFICIENCY_MULTIPLIER)

	// the power needed to mix one mole gas INTO the sink, no matter which source it's from
	var/total_specific_power = 0
	var/total_mixable_moles = 0

	for(var/datum/gas_mixture/GM in sources)
		if(GM.total_moles() < ATMOSMECH_INSTANT_PUMP_MOLES || GM.return_pressure() < ATMOSMECH_INSTANT_PUMP_PRESSURE)
			continue
		total_specific_power += calculate_specific_power(GM, sink) * sources[GM]
		total_mixable_moles += GM.total_moles()

	transfer_moles = isnull(transfer_moles)? total_mixable_moles : min(total_mixable_moles, transfer_moles)
	var/power_needed = transfer_moles * total_specific_power
	var/ratio = (isnull(available_power) || !power_needed)? 1 : clamp(power_needed / available_power + (ATMOSMECH_PUMP_FREE_VOLUME / sink.return_volume()), 0, 1)
	. = min(available_power, power_needed)
	for(var/datum/gas_mixture/GM as anything in sources)
		GM.transfer_ratio_to(sink, sources[GM] * ratio)

/**
 * Gas flow proc
 * Passively flows gas from source to sink as long as there's a pressure gradient.
 * One way
 * Returns the moles transferred.
 *
 * @params
 * * source - Source mixture
 * * sink - Destination mixture
 * * transfer_moles - moles to try to transfer
 */
/proc/flow_gas(datum/gas_mixture/source, datum/gas_mixture/sink, transfer_moles, additional_volume = 0)
	transfer_moles = min(calculate_equalize_moles(source, sink, FALSE, additional_volume), isnull(transfer_moles)? source.total_moles() : (min(source.total_moles(), transfer_moles)))
	if(transfer_moles <= 0)		// no quantize, auxmos does that
		return
	source.transfer_to(sink, transfer_moles)
	return transfer_moles

/**
 * Heat exchange proc gas <--> gas
 *
 * Returns thermal energy in joules transferred
 *
 * @params
 * * gas1
 * * gas2
 * * volume - volume exposed
 * * dt - seconds to simulate
 * * conductivity - ratio of thermal energy difference exchanged
 * * minimum - Minimum joules to exchange, regardless of conductivity
 */
/proc/heat_exchange_gas_to_gas(datum/gas_mixture/gas1, datum/gas_mixture/gas2, volume = 200, conductivity = 0.8, minimum = ATMOSMECH_MINIMUM_HEAT_EXCHANGE_JOULES)

	update_cycle = SSair.times_fired
	partner.update_cycle = SSair.times_fired

	var/datum/gas_mixture/air_contents = airs[1]
	var/datum/gas_mixture/partner_air_contents = partner.airs[1]

	var/air_heat_capacity = air_contents.heat_capacity()
	var/other_air_heat_capacity = partner_air_contents.heat_capacity()
	var/combined_heat_capacity = other_air_heat_capacity + air_heat_capacity


	var/old_temperature = air_contents.return_temperature()
	var/other_old_temperature = partner_air_contents.return_temperature()

	if(combined_heat_capacity > 0)
		var/combined_energy = partner_air_contents.return_temperature()*other_air_heat_capacity + air_heat_capacity*air_contents.return_temperature()

		var/new_temperature = combined_energy/combined_heat_capacity
		air_contents.set_temperature(new_temperature)
		partner_air_contents.set_temperature(new_temperature)

	if(abs(old_temperature-air_contents.return_temperature()) > 1)
		update_parents()

	if(abs(other_old_temperature-partner_air_contents.return_temperature()) > 1)
		partner.update_parents()


/**
 * Heat exchange proc gas <--> turf
 *
 * Returns thermal energy in joules transferred
 *
 * @params
 * * gas
 * * T - trf
 * * volume - volume exposed
 * * dt - seconds to simulate
 * * conductivity
 * * minimum - Minimum joules to exchange, regardless of conductivity
 */
/proc/heat_exchange_gas_to_turf(datum/gas_mixture/gas1, turf/T, volume = 200, conductivity = 0.8, minimum = ATMOSMECH_MINIMUM_HEAT_EXCHANGE_JOULES)
	var/total_heat_capacity = air.heat_capacity()
	var/partial_heat_capacity = total_heat_capacity*(share_volume/air.return_volume())
	var/target_temperature
	var/target_heat_capacity

	if(isopenturf(target))

		var/turf/open/modeled_location = target
		target_temperature = modeled_location.GetTemperature()
		target_heat_capacity = modeled_location.GetHeatCapacity()

		if(modeled_location.blocks_air)

			if((modeled_location.heat_capacity>0) && (partial_heat_capacity>0))
				var/delta_temperature = air.return_temperature() - target_temperature

				var/heat = thermal_conductivity*delta_temperature* \
					(partial_heat_capacity*target_heat_capacity/(partial_heat_capacity+target_heat_capacity))

				air.set_temperature(air.return_temperature() - heat/total_heat_capacity)
				modeled_location.TakeTemperature(heat/target_heat_capacity)

		else
			var/delta_temperature = 0
			var/sharer_heat_capacity = 0

			delta_temperature = (air.return_temperature() - target_temperature)
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

			air.set_temperature(air.return_temperature() + self_temperature_delta)
			modeled_location.TakeTemperature(sharer_temperature_delta)


	else
		if((target.heat_capacity>0) && (partial_heat_capacity>0))
			var/delta_temperature = air.return_temperature() - target.return_temperature()

			var/heat = thermal_conductivity*delta_temperature* \
				(partial_heat_capacity*target.heat_capacity/(partial_heat_capacity+target.heat_capacity))

			air.set_temperature(air.return_temperature() - heat/total_heat_capacity)
	update = TRUE


/**
 * Calculates the power in watts needed to move in one second one mole of gas from source to sink.
 */
/proc/calculate_specific_power(datum/gas_mixture/source, datum/gas_mixture/sink)
	var/air_temperature = sink.return_temperature() || source.return_temperature()
	var/specific_entropy = sink.specific_entropy() - source.specific_entropy()
	// if entropy is less than 0, power is needed to move gas in this direction.
	return (specific_entropy < 0) && (-specific_entropy * air_temperature)

/**
 * Calculates the power needed, in watts, to move one mole of gas from source to sink per second.
 */
/proc/calculate_specific_power_gas(var/gasid, datum/gas_mixture/source, datum/gas_mixture/sink)
	var/air_temperature = sink.return_temperature() || source.return_temperature()
	var/specific_entropy = sink.specific_entropy_gas(gasid) - source.specific_entropy_gas(gasid)
	// if entropy is less than 0, power is needed to move gas in this direction.
	return (specific_entropy < 0) && (-specific_entropy * air_temperature)

/**
 * Calculates the approximate number of moles that need to be transferred from source to sink to change the pressure of sink by pressure_delta
 *
 * @params
 * source - Source
 * sink - Destination
 * pressure_delta - Pressure to try to change by
 * additional_volume - Assume the sink has this much additional volume. Used when you're pumping into a pipe network (as it's far bigger than its component airs usually) or when you're pumping into the air for ZAS
 */
/proc/calculate_transfer_moles(datum/gas_mixture/source, datum/gas_mixture/sink, pressure_delta, additional_volume = 0)
	var/source_moles = source.total_moles()
	if(!source.return_temperature() || !source_moles)
		return 0
	var/sink_volume = sink.return_volume() + additional_volume
	var/combined_temperature = source.return_temperature()
	var/sink_temperature = sink.return_temperature()
	// if sink isn't empty, estimate temperature change
	if(sink_temperature && sink.total_moles())
		// guess-timation
		var/estimated_moles = pressure_delta * sink_volume / (sink_temperature * R_IDEAL_GAS_EQUATION)
		var/sink_heat_capacity = sink.heat_capacity()
		// a better approximation would calculate thermal capacity and energy moved per mole but i'm not going to go into integration just over a dumb formula - silicons
		var/transfer_heat_capacity = source.heat_capacity() * (estimated_moles / source_moles)
		combined_temperature = (sink.thermal_energy() + source.thermal_energy()) / (sink_heat_capacity + transfer_heat_capacity)

	// get moles to transfer
	return pressure_delta * sink_volume / (combined_temperature * R_IDEAL_GAS_EQUATION)

/**
 * Calculates the approximate number of moles that need to be transferred from source to sink to equalize pressure.
 *
 * Don't use this.
 * Seriously.
 * Just use equalize_all_gases_in_list where possible.
 */
/proc/calculate_equalize_moles(datum/gas_mixture/source, datum/gas_mixture/sink, bidirectional = FALSE, additional_volume = 0)
	if(!source.return_temperature() || (!bidirectional && (source.return_pressure() < sink.return_pressure())))
		return 0
	return calculate_transfer_moles(source, sink, (sink.return_pressure() - source.return_pressure()) * 0.5, additional_volume)
