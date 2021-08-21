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
 * Usually you'd call this proc with transfer_moles set to null and additional_volume set as an argument.
 *
 * @params
 * * source - Source mixture
 * * sink - Destination mixture
 * * transfer_moles - moles to try to transfer
 * * additional_volume - the additional volume passed into calculate_equalize_moles.
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
 * Returns thermal energy in joules transferred **from gas1 to gas2**. Use abs in your own proc if needed, as this can be negative - this proc isn't one-way.
 *
 * no auto calculation parameter for volume given - simply too expensive. find a different way or write a different proc.
 *
 * @params
 * * gas1
 * * gas2
 * * conductivity - ratio of thermal energy difference exchanged
 * * minimum - Minimum joules to exchange, regardless of conductivity
 */
/proc/heat_exchange_gas_to_gas(datum/gas_mixture/gas1, datum/gas_mixture/gas2, conductivity = 1, minimum = ATMOSMECH_MINIMUM_HEAT_EXCHANGE_JOULES)
	// first, get final temperature we'll exchange to assuming 100% conductivity
	// capacities
	var/c1 = gas1.heat_capacity()
	var/c2 = gas2.heat_capacity()
	// temperatures
	var/t1 = gas1.return_temperature()
	var/t2 = gas2.return_temperature()
	// sanity check
	if(!t1 || !t2 || !c1 || !c2)
		return
	// transfer - ideal at 100% conduction, for gas1 to gas2 - we can use either 1 or 2 for this as this'll be the same
	// if this value is negative, gas1 is increasing in temperature, gas2 is decreasing (negative energy from gas1 to gas2)
	// if this value is positive, gas1 is decreasing in temperature, gas2 is increasing (energy going from gas1 to gas2)
	// thanks to bay for this optimized equation - i won't explain how it works, just know that it does.
	var/et = ((t1 - t2) * c1 * c2) / (c1 + c2)
	// actual transfer: minimum if below, but do not exceed initial
	if(conductivity < 1)
		et = min(et, max(minimum, et * conductivity))
	// if above value was positive, gas1 decreases in energy
	gas1.adjust_heat(-et)
	// opposite for gas2
	gas2.adjust_heat(et)
	return et

/**
 * Heat exchange proc gas <--> gas for **energy conversion** in TEG-like devices
 *
 * Returns thermal energy in joules **converted**. this value is already abs'd.
 *
 * internals:
 * this operates the same way as heat_exchange_gas_to_gas but transfer * efficiency is converted
 * the thermal energy transfered is taken away from the hotter gas
 * but, transferred * efficiency is converted. what's left is given to the colder gas
 * this simulates one "cycle" of, say, a TEG
 * as would be obvious you'd immediately notice that this won't result in an equal temperature
 * well, sucks
 * i'm too lazy to grab the pen and paper to do this properly because to do this properly probably takes integration and i'm not smart enough to eyeball it
 * if you want to make it work be my guest.
 *
 * **warning**: this means that efficiency directly impacts cooling power.
 * if you want less realistic but also weaker cooling power (as all of the thermal energy would be transferred while generating power, not just what is left over after conversion),
 * use heat_exchange_gas_to_gas and do your own work for abs() and calculations
 * but with this, if you put in efficiency = 1, the cold side will never heat up, as **all** of the transferred equalization heat would become electricity.
 *
 * no auto calculation parameter for volume given - simply too expensive. find a different way or write a different proc.
 *
 * @params
 * * gas1
 * * gas2
 * * conductivity - ratio of thermal energy difference exchanged
 * * efficiency - ratio of **exchanged** energy converted, rather than being equalized. The converted energy is **not** returned as heat - if you have 100% efficiency, this means the cold side will never heat up!
 * * minimum - Minimum joules to exchange, regardless of conductivity
 */
/proc/thermoelectric_exchange_gas_to_gas(datum/gas_mixture/gas1, datum/gas_mixture/gas2, conductivity = 1, efficiency = 0.5, minimum = ATMOSMECH_MINIMUM_HEAT_EXCHANGE_JOULES)
	// first, get final temperature we'll exchange to assuming 100% conductivity
	// capacities
	var/c1 = gas1.heat_capacity()
	var/c2 = gas2.heat_capacity()
	// temperatures
	var/t1 = gas1.return_temperature()
	var/t2 = gas2.return_temperature()
	// sanity check
	if(!t1 || !t2 || !c1 || !c2)
		return
	// transfer - ideal at 100% conduction, for gas1 to gas2 - we can use either 1 or 2 for this as this'll be the same
	// if this value is negative, gas1 is increasing in temperature, gas2 is decreasing (negative energy from gas1 to gas2)
	// if this value is positive, gas1 is decreasing in temperature, gas2 is increasing (energy going from gas1 to gas2)
	// thanks to bay for this optimized equation - i won't explain how it works, just know that it does.
	var/et = ((t1 - t2) * c1 * c2) / (c1 + c2)
	// actual transfer: minimum if below, but do not exceed initial
	if(conductivity < 1)
		et = min(et, max(minimum, et * conductivity))
	// if et was positive, gas1 was higher in temperature
	if(et > 0)
		gas1.adjust_heat(-et)
		gas2.adjust_heat(et * (1 - efficiency))
	// else, gas2 was
	else
		gas2.adjust_heat(-et)
		gas1.adjust_heat(et * (1 - efficiency))
	// return abs of efficiency * et
	return abs(efficiency * et)

/**
 * Heat exchange proc gas <--> turf
 *
 * Returns thermal energy in joules transferred
 *
 * @params
 * * gas1 - gas
 * * T - turf in question
 * * volume - volume exposed
 * * conductivity - ratio of thermal energy difference to exchange
 * * minimum - Minimum joules to exchange, regardless of conductivity
 */
/proc/heat_exchange_gas_to_turf(datum/gas_mixture/gas1, turf/T, volume = 200, conductivity = 0.8, minimum = ATMOSMECH_MINIMUM_HEAT_EXCHANGE_JOULES)
	var/self_energy = isnull(volume)? (gas1.thermal_energy()) : (gas1.thermal_energy() * clamp(volume / gas1.return_volume(), 0, 1))
	if(isopenturf(T))
		var/turf/open/O = T
		var/turf_temperature = O.GetTemperature()
		var/turf_capacity = O.GetHeatCapacity()
		if(!turf_temperature || !turf_capacity)
			return 0
		var/other_energy = (turf_temperature * turf_capacity) * (isnull(volume)? 1 : (volume / CELL_VOLUME))
		var/transfer_to_self = (other_energy - self_energy) * 0.5
		gas1.adjust_heat(transfer_to_self)
		O.TakeTemperature((-transfer_to_self) / turf_capacity)
		return abs(transfer_to_self)
	else
		var/turf_temperature = T.return_temperature()
		var/turf_capacity = T.heat_capacity
		if(!turf_temperature || !turf_capacity)
			return 0
		var/other_energy = (turf_temperature * turf_capacity) * (isnull(volume)? 1 : (volume / CELL_VOLUME))
		var/transfer_to_self = (other_energy - self_energy) * 0.5
		gas1.adjust_heat(transfer_to_self)
		return abs(transfer_to_self)

/**
 * Proc for radiating heat using something akin to blackbody radiation
 * Cheers and love to Putnam for helping <3
 *
 * We don't take into account gas density directly like on baycode but we do care about heat capacity
 *
 * @param
 * * temperature - gas temperature
 * * surface_arae - surface area of radiation
 * * heat_capacity - heat capacity of the gas in question
 * * env_temperature - environment temperaure of the surrounding gas
 *
 * @return the new temperature
 */
/proc/radiate_heat_to_space(temperature, surface_area = 1, heat_capacity, env_temperature)
	CRASH("radiate_heat not hooked")

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
