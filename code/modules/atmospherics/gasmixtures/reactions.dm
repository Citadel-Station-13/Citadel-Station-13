//All defines used in reactions are located in ..\__DEFINES\reactions.dm
/*priority so far, check this list to see what are the numbers used. Please use a different priority for each reaction(higher number are done first)
miaster = -10 (this should always be under all other fires)
freonfire = -5
plasmafire = -4
h2fire = -3
tritfire = -2
halon_o2removal = -1
nitrous_decomp = 0
water_vapor = 1
pluox_formation = 2
nitrylformation = 3
bzformation = 4
freonformation = 5
stimformation = 5
nobiliumformation = 6
stimball = 7
ammoniacrystals = 8
hexane_plasma_filtering = 9
hexane_n2o_filtering = 10
zauker_decomp = 11
healium_production = 12
proto_nitrate_production = 13
zauker_production = 14
halon_formation = 15
hexane_formation = 16
healium_crystal_production = 17
proto_nitrate_crystal_production = 18
zauker_crystal_production = 19
proto_nitrate_response = 20 - 25
fusion = 26
metallic_hydrogen = 27
nobiliumsuppression = INFINITY
*/
/proc/init_gas_reactions()
	. = list()

	for(var/r in subtypesof(/datum/gas_reaction))
		var/datum/gas_reaction/reaction = r
		if(initial(reaction.exclude))
			continue
		reaction = new r
		var/datum/gas/reaction_key
		for (var/req in reaction.min_requirements)
			if (ispath(req))
				var/datum/gas/req_gas = req
				if (!reaction_key || initial(reaction_key.rarity) > initial(req_gas.rarity))
					reaction_key = req_gas
		reaction.major_gas = reaction_key
		. += reaction
	sortTim(., /proc/cmp_gas_reaction)

/proc/cmp_gas_reaction(datum/gas_reaction/a, datum/gas_reaction/b) // compares lists of reactions by the maximum priority contained within the list
	return b.priority - a.priority

/datum/gas_reaction
	//regarding the requirements lists: the minimum or maximum requirements must be non-zero.
	//when in doubt, use MINIMUM_MOLE_COUNT.
	var/list/min_requirements
	var/list/max_requirements
	var/major_gas //the highest rarity gas used in the reaction.
	var/exclude = FALSE //do it this way to allow for addition/removal of reactions midmatch in the future
	var/priority = 100 //lower numbers are checked/react later than higher numbers. if two reactions have the same priority they may happen in either order
	var/name = "reaction"
	var/id = "r"

/datum/gas_reaction/New()
	init_reqs()

/datum/gas_reaction/proc/init_reqs()

/datum/gas_reaction/proc/react(datum/gas_mixture/air, atom/location)
	return NO_REACTION

/datum/gas_reaction/proc/test()
	return list("success" = TRUE)

/datum/gas_reaction/nobliumsupression
	priority = INFINITY
	name = "Hyper-Noblium Reaction Suppression"
	id = "nobstop"

/datum/gas_reaction/nobliumsupression/init_reqs()
	min_requirements = list(/datum/gas/hypernoblium = REACTION_OPPRESSION_THRESHOLD)

/datum/gas_reaction/nobliumsupression/react()
	return STOP_REACTIONS

//water vapor: puts out fires?
/datum/gas_reaction/water_vapor
	priority = 1
	name = "Water Vapor"
	id = "vapor"

/datum/gas_reaction/water_vapor/init_reqs()
	min_requirements = list(/datum/gas/water_vapor = MOLES_GAS_VISIBLE)

/datum/gas_reaction/water_vapor/react(datum/gas_mixture/air, datum/holder)
	var/turf/open/location = isturf(holder) ? holder : null
	. = NO_REACTION
	if (air.return_temperature() <= WATER_VAPOR_FREEZE)
		if(location && location.freon_gas_act())
			. = REACTING
	else if(air.return_temperature() <= T20C + 10 && location && location.water_vapor_gas_act())
		air.adjust_moles(/datum/gas/water_vapor,-MOLES_GAS_VISIBLE)
		. = REACTING

// no test cause it's entirely based on location

/datum/gas_reaction/nitrous_decomp
	priority = 0
	name = "Nitrous Oxide Decomposition"
	id = "nitrous_decomp"

/datum/gas_reaction/nitrous_decomp/init_reqs()
	min_requirements = list(
		"TEMP" = N2O_DECOMPOSITION_MIN_ENERGY,
		/datum/gas/nitrous_oxide = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/nitrous_decomp/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/temperature = air.return_temperature()
	var/old_energy = air.thermal_energy()
	var/burned_fuel = 0


	burned_fuel = max(0,0.00002 * (temperature - (0.00001 * (temperature**2)))) * air.get_moles(/datum/gas/nitrous_oxide)
	if(air.get_moles(/datum/gas/nitrous_oxide) - burned_fuel < 0)
		return NO_REACTION
	air.adjust_moles(/datum/gas/nitrous_oxide, -burned_fuel)

	if(burned_fuel)
		energy_released += (N2O_DECOMPOSITION_ENERGY_RELEASED * burned_fuel)

		air.adjust_moles(/datum/gas/oxygen, burned_fuel * 0.5)
		air.adjust_moles(/datum/gas/nitrogen, burned_fuel)

		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)
		return REACTING
	return NO_REACTION

/datum/gas_reaction/nitrous_decomp/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/nitrous_oxide,50)
	G.set_temperature(50000)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/nitrous_oxide) > 30)
		return list("success" = FALSE, "message" = "Nitrous oxide is not decomposing!")
	return ..()

//tritium combustion: combustion of oxygen and tritium (treated as hydrocarbons). creates hotspots. exothermic
/datum/gas_reaction/tritfire
	priority = -2 //fire should ALWAYS be last, but tritium fires happen before plasma fires
	name = "Tritium Combustion"
	id = "tritfire"

/datum/gas_reaction/tritfire/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST,
		/datum/gas/tritium = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/tritfire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	var/list/cached_results = air.reaction_results
	cached_results["fire"] = 0
	var/turf/open/location = isturf(holder) ? holder : null

	var/burned_fuel = 0
	if(air.get_moles(/datum/gas/oxygen) < air.get_moles(/datum/gas/tritium))
		burned_fuel = air.get_moles(/datum/gas/oxygen)/TRITIUM_BURN_OXY_FACTOR
		air.adjust_moles(/datum/gas/tritium, -burned_fuel)
	else
		burned_fuel = air.get_moles(/datum/gas/tritium)*TRITIUM_BURN_TRIT_FACTOR
		air.adjust_moles(/datum/gas/tritium, -air.get_moles(/datum/gas/tritium)/TRITIUM_BURN_TRIT_FACTOR)
		air.adjust_moles(/datum/gas/oxygen,-air.get_moles(/datum/gas/tritium))

	if(burned_fuel)
		energy_released += (FIRE_HYDROGEN_ENERGY_RELEASED * burned_fuel)
		if(location && prob(10) && burned_fuel > TRITIUM_MINIMUM_RADIATION_ENERGY) //woah there let's not crash the server
			radiation_pulse(location, energy_released/TRITIUM_BURN_RADIOACTIVITY_FACTOR)

		air.adjust_moles(/datum/gas/water_vapor, burned_fuel/TRITIUM_BURN_OXY_FACTOR)

		cached_results["fire"] += burned_fuel

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released)/new_heat_capacity)

	//let the floor know a fire is happening
	if(istype(location))
		var/temperature = air.return_temperature()
		if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			location.hotspot_expose(temperature, CELL_VOLUME)
			for(var/I in location)
				var/atom/movable/item = I
				item.temperature_expose(air, temperature, CELL_VOLUME)
			location.temperature_expose(air, temperature, CELL_VOLUME)

	return cached_results["fire"] ? REACTING : NO_REACTION

/datum/gas_reaction/tritfire/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/tritium,50)
	G.set_moles(/datum/gas/oxygen,50)
	G.set_temperature(500)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(!G.reaction_results["fire"])
		return list("success" = FALSE, "message" = "Trit fires aren't setting fire results correctly!")
	return ..()

//plasma combustion: combustion of oxygen and plasma (treated as hydrocarbons). creates hotspots. exothermic
/datum/gas_reaction/plasmafire
	priority = -4 //fire should ALWAYS be last, but plasma fires happen after tritium fires
	name = "Plasma Combustion"
	id = "plasmafire"

/datum/gas_reaction/plasmafire/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST,
		/datum/gas/plasma = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/plasmafire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	var/temperature = air.return_temperature()
	var/list/cached_results = air.reaction_results
	cached_results["fire"] = 0
	var/turf/open/location = isturf(holder) ? holder : null

	//Handle plasma burning
	var/plasma_burn_rate = 0
	var/oxygen_burn_rate = 0
	//more plasma released at higher temperatures
	var/temperature_scale = 0
	//to make tritium
	var/super_saturation = FALSE

	if(temperature > PLASMA_UPPER_TEMPERATURE)
		temperature_scale = 1
	else
		temperature_scale = (temperature-PLASMA_MINIMUM_BURN_TEMPERATURE)/(PLASMA_UPPER_TEMPERATURE-PLASMA_MINIMUM_BURN_TEMPERATURE)
	if(temperature_scale > 0)
		oxygen_burn_rate = OXYGEN_BURN_RATE_BASE - temperature_scale
		if(air.get_moles(/datum/gas/oxygen) / air.get_moles(/datum/gas/plasma) > SUPER_SATURATION_THRESHOLD) //supersaturation. Form Tritium.
			super_saturation = TRUE
		if(air.get_moles(/datum/gas/oxygen) > air.get_moles(/datum/gas/plasma)*PLASMA_OXYGEN_FULLBURN)
			plasma_burn_rate = (air.get_moles(/datum/gas/plasma)*temperature_scale)/PLASMA_BURN_RATE_DELTA
		else
			plasma_burn_rate = (temperature_scale*(air.get_moles(/datum/gas/oxygen)/PLASMA_OXYGEN_FULLBURN))/PLASMA_BURN_RATE_DELTA

		if(plasma_burn_rate > MINIMUM_HEAT_CAPACITY)
			plasma_burn_rate = min(plasma_burn_rate,air.get_moles(/datum/gas/plasma),air.get_moles(/datum/gas/oxygen)/oxygen_burn_rate) //Ensures matter is conserved properly
			air.set_moles(/datum/gas/plasma, QUANTIZE(air.get_moles(/datum/gas/plasma) - plasma_burn_rate))
			air.set_moles(/datum/gas/oxygen, QUANTIZE(air.get_moles(/datum/gas/oxygen) - (plasma_burn_rate * oxygen_burn_rate)))
			if (super_saturation)
				air.adjust_moles(/datum/gas/tritium, plasma_burn_rate)
			else
				air.adjust_moles(/datum/gas/carbon_dioxide, plasma_burn_rate)

			energy_released += FIRE_PLASMA_ENERGY_RELEASED * (plasma_burn_rate)

			cached_results["fire"] += (plasma_burn_rate)*(1+oxygen_burn_rate)

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released)/new_heat_capacity)

	//let the floor know a fire is happening
	if(istype(location))
		temperature = air.return_temperature()
		if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			location.hotspot_expose(temperature, CELL_VOLUME)
			for(var/I in location)
				var/atom/movable/item = I
				item.temperature_expose(air, temperature, CELL_VOLUME)
			location.temperature_expose(air, temperature, CELL_VOLUME)

	return cached_results["fire"] ? REACTING : NO_REACTION

/datum/gas_reaction/plasmafire/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/plasma,50)
	G.set_moles(/datum/gas/oxygen,50)
	G.set_volume(1000)
	G.set_temperature(500)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(!G.reaction_results["fire"])
		return list("success" = FALSE, "message" = "Plasma fires aren't setting fire results correctly!")
	if(!G.get_moles(/datum/gas/carbon_dioxide))
		return list("success" = FALSE, "message" = "Plasma fires aren't making CO2!")
	G.clear()
	G.set_moles(/datum/gas/plasma,10)
	G.set_moles(/datum/gas/oxygen,1000)
	G.set_temperature(500)
	result = G.react()
	if(!G.get_moles(/datum/gas/tritium))
		return list("success" = FALSE, "message" = "Plasma fires aren't making trit!")
	return ..()

//freon reaction (is not a fire yet)
/datum/gas_reaction/freonfire
	priority = -5
	name = "Freon combustion"
	id = "freonfire"

/datum/gas_reaction/freonfire/init_reqs()
	min_requirements = list(
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT,
		/datum/gas/freon = MINIMUM_MOLE_COUNT,
		"TEMP" = FREON_LOWER_TEMPERATURE,
		"MAX_TEMP" = FREON_MAXIMUM_BURN_TEMPERATURE
		)

/datum/gas_reaction/freonfire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	var/temperature = air.return_temperature()
	if(!isturf(holder))
		return NO_REACTION
	var/turf/open/location = holder

	//Handle freon burning (only reaction now)
	var/freon_burn_rate = 0
	var/oxygen_burn_rate = 0
	//more freon released at lower temperatures
	var/temperature_scale = 1

	if(temperature < FREON_LOWER_TEMPERATURE) //stop the reaction when too cold
		temperature_scale = 0
	else
		temperature_scale = (FREON_MAXIMUM_BURN_TEMPERATURE - temperature) / (FREON_MAXIMUM_BURN_TEMPERATURE - FREON_LOWER_TEMPERATURE) //calculate the scale based on the temperature
	if(temperature_scale >= 0)
		oxygen_burn_rate = OXYGEN_BURN_RATE_BASE - temperature_scale
		if(air.get_moles(/datum/gas/oxygen) > air.get_moles(/datum/gas/freon) * FREON_OXYGEN_FULLBURN)
			freon_burn_rate = (air.get_moles(/datum/gas/freon) * temperature_scale) / FREON_BURN_RATE_DELTA
		else
			freon_burn_rate = (temperature_scale * (air.get_moles(/datum/gas/oxygen) / FREON_OXYGEN_FULLBURN)) / FREON_BURN_RATE_DELTA

		if(freon_burn_rate > MINIMUM_HEAT_CAPACITY)
			freon_burn_rate = min(freon_burn_rate, air.get_moles(/datum/gas/freon) , air.get_moles(/datum/gas/oxygen) / oxygen_burn_rate) //Ensures matter is conserved properly
			air.adjust_moles(/datum/gas/freon, -freon_burn_rate)
			air.adjust_moles(/datum/gas/oxygen, -(freon_burn_rate * oxygen_burn_rate))
			air.adjust_moles(/datum/gas/carbon_dioxide, freon_burn_rate)

			if(temperature < 160 && temperature > 120 && prob(2))
				new /obj/item/stack/sheet/hot_ice(location)

			energy_released += FIRE_FREON_ENERGY_RELEASED * (freon_burn_rate)

	if(energy_released < 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)

/datum/gas_reaction/h2fire
	priority = -3 //fire should ALWAYS be last, but tritium fires happen before plasma fires
	name = "Hydrogen Combustion"
	id = "h2fire"

/datum/gas_reaction/h2fire/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST,
		/datum/gas/hydrogen = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/h2fire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/energy = air.thermal_energy()
	var/list/cached_results = air.reaction_results
	cached_results["fire"] = 0
	var/turf/open/location = isturf(holder) ? holder : null
	var/burned_fuel = 0
	if(air.get_moles(/datum/gas/oxygen) < air.get_moles(/datum/gas/hydrogen) || MINIMUM_H2_OXYBURN_ENERGY > energy)
		burned_fuel = air.get_moles(/datum/gas/oxygen) /HYDROGEN_BURN_OXY_FACTOR
		air.adjust_moles(/datum/gas/hydrogen, -burned_fuel)
	else
		burned_fuel = air.get_moles(/datum/gas/hydrogen) * HYDROGEN_BURN_H2_FACTOR
		air.adjust_moles(/datum/gas/hydrogen,-air.get_moles(/datum/gas/hydrogen) / HYDROGEN_BURN_H2_FACTOR)
		air.adjust_moles(/datum/gas/oxygen, -air.get_moles(/datum/gas/hydrogen))

	if(burned_fuel)
		energy_released += (FIRE_HYDROGEN_ENERGY_RELEASED * burned_fuel)

		air.adjust_moles(/datum/gas/water_vapor, burned_fuel / HYDROGEN_BURN_OXY_FACTOR)

		cached_results["fire"] += burned_fuel

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((energy + energy_released) / new_heat_capacity)

	//let the floor know a fire is happening
	if(istype(location))
		var/temperature = air.return_temperature()
		if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			location.hotspot_expose(temperature, CELL_VOLUME)
			for(var/I in location)
				var/atom/movable/item = I
				item.temperature_expose(air, temperature, CELL_VOLUME)
			location.temperature_expose(air, temperature, CELL_VOLUME)

	return cached_results["fire"] ? REACTING : NO_REACTION

/datum/gas_reaction/h2fire/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/hydrogen,50)
	G.set_moles(/datum/gas/oxygen,50)
	G.set_volume(1000)
	G.set_temperature(1200)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(!G.reaction_results["fire"])
		return list("success" = FALSE, "message" = "Hydrogen fires aren't setting fire results correctly!")
	if(!G.get_moles(/datum/gas/water_vapor))
		return list("success" = FALSE, "message" = "Hydrogen fires aren't making H2O!")
	return ..()

/datum/gas_reaction/methanefire
	priority = -6 //methane's the last fire that happens
	name = "Methane Combustion"
	id = "methanefire"

/datum/gas_reaction/methanefire/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST,
		/datum/gas/methane = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/methanefire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	var/list/cached_results = air.reaction_results
	cached_results["fire"] = 0
	var/turf/open/location = isturf(holder) ? holder : null
	var/burned_fuel = min(air.get_moles(/datum/gas/methane),air.get_moles(/datum/gas/oxygen)*0.5)
	air.adjust_moles(/datum/gas/methane,-burned_fuel)
	air.adjust_moles(/datum/gas/oxygen, -burned_fuel * 2)
	if(burned_fuel)
		energy_released += (FIRE_METHANE_ENERGY_RELEASED * burned_fuel)

		air.adjust_moles(/datum/gas/carbon_dioxide, burned_fuel)
		air.adjust_moles(/datum/gas/water_vapor, burned_fuel * 2)

		cached_results["fire"] += burned_fuel

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)

	//let the floor know a fire is happening
	if(istype(location))
		var/temperature = air.return_temperature()
		if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			location.hotspot_expose(temperature, CELL_VOLUME)
			for(var/I in location)
				var/atom/movable/item = I
				item.temperature_expose(air, temperature, CELL_VOLUME)
			location.temperature_expose(air, temperature, CELL_VOLUME)

	return cached_results["fire"] ? REACTING : NO_REACTION

/datum/gas_reaction/methanefire/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/methane,50)
	G.set_moles(/datum/gas/oxygen,50)
	G.set_volume(1000)
	G.set_temperature(1200)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(!G.reaction_results["fire"])
		return list("success" = FALSE, "message" = "Methane fires aren't setting fire results correctly!")
	if(!G.get_moles(/datum/gas/water_vapor))
		return list("success" = FALSE, "message" = "Hydrogen fires aren't making H2O!")
	if(!G.get_moles(/datum/gas/carbon_dioxide))
		return list("success" = FALSE, "message" = "Hydrogen fires aren't making Co2!")
	return ..()

/datum/gas_reaction/ammoniacrystals
	priority = 8
	name = "Ammonia crystals formation"
	id = "nh4crystals"

/datum/gas_reaction/ammoniacrystals/init_reqs()
	min_requirements = list(
		/datum/gas/hydrogen = MINIMUM_MOLE_COUNT,
		/datum/gas/nitrogen = MINIMUM_MOLE_COUNT,
		"TEMP" = 150,
		"MAX_TEMP" = 273
	)

/datum/gas_reaction/ammoniacrystals/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	if(!isturf(holder))
		return NO_REACTION
	var/turf/open/location = holder
	var/consumed_fuel = 0
	if(air.get_moles(/datum/gas/nitrogen) > air.get_moles(/datum/gas/hydrogen) )
		consumed_fuel = (air.get_moles(/datum/gas/hydrogen) / AMMONIA_FORMATION_FACTOR)
		if(air.get_moles(/datum/gas/nitrogen) - consumed_fuel < 0 || air.get_moles(/datum/gas/hydrogen) - consumed_fuel * 4 < 0)
			return NO_REACTION
		air.adjust_moles(/datum/gas/nitrogen, -consumed_fuel)
		air.adjust_moles(/datum/gas/hydrogen, -consumed_fuel * 4)
		if(prob(30 * consumed_fuel))
			new /obj/item/stack/ammonia_crystals(location)
		energy_released += consumed_fuel * AMMONIA_FORMATION_ENERGY
	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released)/new_heat_capacity)

//fusion: a terrible idea that was fun but broken. Now reworked to be less broken and more interesting. Again (and again, and again). Again!
//Fusion Rework Counter: Please increment this if you make a major overhaul to this system again.
//6 reworks

/datum/gas_reaction/fusion
	exclude = FALSE
	priority = 2
	name = "Plasmic Fusion"
	id = "fusion"

/datum/gas_reaction/fusion/init_reqs()
	min_requirements = list(
		"TEMP" = FUSION_TEMPERATURE_THRESHOLD,
		/datum/gas/tritium = FUSION_TRITIUM_MOLES_USED,
		/datum/gas/plasma = FUSION_MOLE_THRESHOLD,
		/datum/gas/hydrogen = FUSION_MOLE_THRESHOLD)

/datum/gas_reaction/fusion/react(datum/gas_mixture/air, datum/holder)
	var/turf/open/location
	if (istype(holder,/datum/pipeline)) //Find the tile the reaction is occuring on, or a random part of the network if it's a pipenet.
		var/datum/pipeline/fusion_pipenet = holder
		location = get_turf(pick(fusion_pipenet.members))
	else
		location = get_turf(holder)
	if(!air.analyzer_results)
		air.analyzer_results = new
	var/list/cached_scan_results = air.analyzer_results
	var/old_energy = air.thermal_energy()
	var/reaction_energy = 0 //Reaction energy can be negative or positive, for both exothermic and endothermic reactions.
	var/initial_plasma = air.get_moles(/datum/gas/plasma)
	var/initial_hydrogen = air.get_moles(/datum/gas/hydrogen)
	var/scale_factor = (air.return_volume())/(PI) //We scale it down by volume/Pi because for fusion conditions, moles roughly = 2*volume, but we want it to be based off something constant between reactions.
	var/toroidal_size = (2*PI)+TORADIANS(arctan((air.return_volume()-TOROID_VOLUME_BREAKEVEN)/TOROID_VOLUME_BREAKEVEN)) //The size of the phase space hypertorus
	var/gas_power = 0
	var/list/gas_fusion_powers = GLOB.meta_gas_fusions
	for (var/gas_id in air.get_gases())
		gas_power += (gas_fusion_powers[gas_id]*air.get_moles(gas_id))
	var/instability = MODULUS((gas_power*INSTABILITY_GAS_POWER_FACTOR)**2,toroidal_size) //Instability effects how chaotic the behavior of the reaction is
	cached_scan_results["fusion"] = instability//used for analyzer feedback

	var/plasma = (initial_plasma-FUSION_MOLE_THRESHOLD)/(scale_factor) //We have to scale the amounts of carbon and plasma down a significant amount in order to show the chaotic dynamics we want
	var/hydrogen = (initial_hydrogen-FUSION_MOLE_THRESHOLD)/(scale_factor) //We also subtract out the threshold amount to make it harder for fusion to burn itself out.

	//The reaction is a specific form of the Kicked Rotator system, which displays chaotic behavior and can be used to model particle interactions.
	plasma = MODULUS(plasma - (instability*sin(TODEGREES(hydrogen))), toroidal_size)
	hydrogen = MODULUS(hydrogen - plasma, toroidal_size)


	air.set_moles(/datum/gas/plasma, plasma*scale_factor + FUSION_MOLE_THRESHOLD) //Scales the gases back up
	air.set_moles(/datum/gas/hydrogen , hydrogen*scale_factor + FUSION_MOLE_THRESHOLD)
	var/delta_plasma = initial_plasma - air.get_moles(/datum/gas/plasma)

	reaction_energy += delta_plasma*PLASMA_BINDING_ENERGY //Energy is gained or lost corresponding to the creation or destruction of mass.
	if(instability < FUSION_INSTABILITY_ENDOTHERMALITY)
		reaction_energy = max(reaction_energy,0) //Stable reactions don't end up endothermic.
	else if (reaction_energy < 0)
		reaction_energy *= (instability-FUSION_INSTABILITY_ENDOTHERMALITY)**0.5

	if(air.thermal_energy() + reaction_energy < 0) //No using energy that doesn't exist.
		air.set_moles(/datum/gas/plasma,initial_plasma)
		air.set_moles(/datum/gas/hydrogen, initial_hydrogen)
		return NO_REACTION
	air.adjust_moles(/datum/gas/tritium, -FUSION_TRITIUM_MOLES_USED)
	//The decay of the tritium and the reaction's energy produces waste gases, different ones depending on whether the reaction is endo or exothermic
	if(reaction_energy > 0)
		air.adjust_moles(/datum/gas/carbon_dioxide, FUSION_TRITIUM_MOLES_USED*(reaction_energy*FUSION_TRITIUM_CONVERSION_COEFFICIENT))
		air.adjust_moles(/datum/gas/water_vapor, FUSION_TRITIUM_MOLES_USED*(reaction_energy*FUSION_TRITIUM_CONVERSION_COEFFICIENT))
	else
		air.adjust_moles(/datum/gas/carbon_dioxide, FUSION_TRITIUM_MOLES_USED*(reaction_energy*-FUSION_TRITIUM_CONVERSION_COEFFICIENT))

	if(reaction_energy)
		if(location)
			var/particle_chance = ((PARTICLE_CHANCE_CONSTANT)/(reaction_energy-PARTICLE_CHANCE_CONSTANT)) + 1//Asymptopically approaches 100% as the energy of the reaction goes up.
			if(prob(PERCENT(particle_chance)))
				location.fire_nuclear_particle()
			var/rad_power = max((FUSION_RAD_COEFFICIENT/instability) + FUSION_RAD_MAX,0)
			radiation_pulse(location,rad_power)

		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(clamp(((old_energy + reaction_energy)/new_heat_capacity),TCMB,INFINITY))
		return REACTING

/datum/gas_reaction/fusion/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/hydrogen,300)
	G.set_moles(/datum/gas/plasma,1000)
	G.set_moles(/datum/gas/tritium,100.61)
	G.set_moles(/datum/gas/nitryl,61)
	G.set_temperature(15000)
	G.set_volume(1000)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(abs(G.analyzer_results["fusion"] - 3) > 0.0000001)
		var/instability = G.analyzer_results["fusion"]
		return list("success" = FALSE, "message" = "Fusion is not calculating analyzer results correctly, should be 3.000000045, is instead [instability]")
	if(abs(G.get_moles(/datum/gas/plasma) - 850.616) > 0.5)
		var/plas = G.get_moles(/datum/gas/plasma)
		return list("success" = FALSE, "message" = "Fusion is not calculating plasma correctly, should be 850.616, is instead [plas]")
	if(abs(G.get_moles(/datum/gas/hydrogen) - 1699.384) > 0.5)
		var/co2 = G.get_moles(/datum/gas/hydrogen)
		return list("success" = FALSE, "message" = "Fusion is not calculating h2 correctly, should be 1699.384, is instead [co2]")
	if(abs(G.return_temperature() - 27600) > 200) // calculating this manually sucks dude
		var/temp = G.return_temperature()
		return list("success" = FALSE, "message" = "Fusion is not calculating temperature correctly, should be around 27600, is instead [temp]")
	return ..()

/datum/gas_reaction/nitrousformation //formationn of n2o, esothermic, requires bz as catalyst
	priority = 3
	name = "Nitrous Oxide formation"
	id = "nitrousformation"

/datum/gas_reaction/nitrousformation/init_reqs()
	min_requirements = list(
		/datum/gas/oxygen = 10,
		/datum/gas/nitrogen = 20,
		/datum/gas/bz = 5,
		"TEMP" = 200,
		"MAX_TEMP" = 250
	)

/datum/gas_reaction/nitrousformation/react(datum/gas_mixture/air)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.get_moles(/datum/gas/oxygen) , air.get_moles(/datum/gas/nitrogen) )
	var/energy_used = heat_efficency * NITROUS_FORMATION_ENERGY
	if ((air.get_moles(/datum/gas/oxygen) - heat_efficency < 0 ) || (air.get_moles(/datum/gas/nitrogen) - heat_efficency * 2 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/oxygen, -heat_efficency)
	air.adjust_moles(/datum/gas/nitrogen, -heat_efficency * 2)
	air.adjust_moles(/datum/gas/nitrous_oxide, heat_efficency)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy + energy_used) / new_heat_capacity), TCMB)) //the air heats up when reacting)
		return REACTING

/datum/gas_reaction/nitrousformation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/oxygen,20)
	G.set_moles(/datum/gas/nitrogen,40)
	G.set_moles(/datum/gas/bz,10)
	G.set_temperature(225)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/nitrous_oxide) < 18)
		return list("success" = FALSE, "message" = "Nitrous oxide isn't being generated correctly!")
	return ..()

/datum/gas_reaction/nitrylformation //The formation of nitryl. Endothermic. Requires N2O as a catalyst.
	priority = 3.5
	name = "Nitryl formation"
	id = "nitrylformation"

/datum/gas_reaction/nitrylformation/init_reqs()
	min_requirements = list(
		/datum/gas/oxygen = 20,
		/datum/gas/nitrogen = 20,
		/datum/gas/nitrous_oxide = 5,
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST,
		"ENER" = NITRYL_FORMATION_ENERGY*100
	)

/datum/gas_reaction/nitrylformation/react(datum/gas_mixture/air)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.return_temperature()/(FIRE_MINIMUM_TEMPERATURE_TO_EXIST*10),air.get_moles(/datum/gas/oxygen),air.get_moles(/datum/gas/nitrogen))
	var/energy_used = heat_efficency*NITRYL_FORMATION_ENERGY
	if ((air.get_moles(/datum/gas/oxygen) - heat_efficency < 0 )|| (air.get_moles(/datum/gas/nitrogen) - heat_efficency < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/oxygen, heat_efficency)
	air.adjust_moles(/datum/gas/nitrogen, heat_efficency)
	air.adjust_moles(/datum/gas/nitryl, heat_efficency*2)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy - energy_used)/new_heat_capacity),TCMB))
		return REACTING

/datum/gas_reaction/nitrylformation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/oxygen,30)
	G.set_moles(/datum/gas/nitrogen,30)
	G.set_moles(/datum/gas/nitrous_oxide,10)
	G.set_volume(1000)
	G.set_temperature(13000)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(!G.get_moles(/datum/gas/nitryl) < 0.5)
		return list("success" = FALSE, "message" = "Nitryl isn't being generated correctly!")
	return ..()

/datum/gas_reaction/bzformation //Formation of BZ by combining plasma and tritium at low pressures. Exothermic.
	priority = 4
	name = "BZ Gas formation"
	id = "bzformation"

/datum/gas_reaction/bzformation/init_reqs()
	min_requirements = list(
		/datum/gas/nitrous_oxide = 10,
		/datum/gas/plasma = 10
	)


/datum/gas_reaction/bzformation/react(datum/gas_mixture/air)
	var/pressure = air.return_pressure()
	var/old_energy = air.thermal_energy()
	var/reaction_efficency = min(1/((pressure/(0.1*ONE_ATMOSPHERE))*(max(air.get_moles(/datum/gas/plasma)/air.get_moles(/datum/gas/nitrous_oxide),1))),air.get_moles(/datum/gas/nitrous_oxide),air.get_moles(/datum/gas/plasma)/2)
	var/energy_released = 2*reaction_efficency*FIRE_CARBON_ENERGY_RELEASED
	if ((air.get_moles(/datum/gas/nitrous_oxide) - reaction_efficency < 0 )|| (air.get_moles(/datum/gas/plasma) - (2*reaction_efficency) < 0) || energy_released <= 0) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/bz, reaction_efficency)
	if(reaction_efficency == air.get_moles(/datum/gas/nitrous_oxide))
		air.adjust_moles(/datum/gas/bz, -min(pressure,1))
		air.adjust_moles(/datum/gas/oxygen, min(pressure,1))
	air.adjust_moles(/datum/gas/nitrous_oxide, -reaction_efficency)
	air.adjust_moles(/datum/gas/plasma, -2*reaction_efficency)

	SSresearch.science_tech.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, min((reaction_efficency**2)*BZ_RESEARCH_SCALE),BZ_RESEARCH_MAX_AMOUNT)

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy + energy_released)/new_heat_capacity),TCMB))
		return REACTING

/datum/gas_reaction/bzformation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/plasma,15)
	G.set_moles(/datum/gas/nitrous_oxide,15)
	G.set_volume(1000)
	G.set_temperature(10)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(!G.get_moles(/datum/gas/bz) < 4) // efficiency is 4.0643 and bz generation == efficiency
		return list("success" = FALSE, "message" = "Nitryl isn't being generated correctly!")
	return ..()

/datum/gas_reaction/metalhydrogen
	priority = 27
	name = "Metal Hydrogen formation"
	id = "metalhydrogen"

/datum/gas_reaction/metalhydrogen/init_reqs()
	min_requirements = list(
		/datum/gas/hydrogen = 100,
		/datum/gas/bz		= 5,
		"TEMP" = METAL_HYDROGEN_MINIMUM_HEAT
		)

/datum/gas_reaction/metalhydrogen/react(datum/gas_mixture/air, datum/holder)
	var/temperature = air.return_temperature()
	var/old_energy = air.thermal_energy()
	if(!isturf(holder))
		return NO_REACTION
	var/turf/open/location = holder
	///the more heat you use the higher is this factor
	var/increase_factor = min((temperature / METAL_HYDROGEN_MINIMUM_HEAT), 5)
	///the more moles you use and the higher the heat, the higher is the efficiency
	var/heat_efficency = air.get_moles(/datum/gas/hydrogen) * 0.01 * increase_factor
	var/pressure = air.return_pressure()
	var/energy_used = heat_efficency * METAL_HYDROGEN_FORMATION_ENERGY

	if(pressure >= METAL_HYDROGEN_MINIMUM_PRESSURE && temperature >= METAL_HYDROGEN_MINIMUM_HEAT)
		air.adjust_moles(/datum/gas/bz, -heat_efficency * 0.01)
		if (prob(20 * increase_factor))
			air.adjust_moles(/datum/gas/hydrogen, -heat_efficency * 3.5)
			if (prob(100 / increase_factor))
				new /obj/item/stack/sheet/mineral/metal_hydrogen(location)
				SSresearch.science_tech.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, min((heat_efficency * increase_factor * 0.5), METAL_HYDROGEN_RESEARCH_MAX_AMOUNT))

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy - energy_used) / new_heat_capacity), TCMB))
		return REACTING

/datum/gas_reaction/freonformation
	priority = 5
	name = "Freon formation"
	id = "freonformation"

/datum/gas_reaction/freonformation/init_reqs() //minimum requirements for freon formation
	min_requirements = list(
		/datum/gas/plasma = 40,
		/datum/gas/carbon_dioxide = 20,
		/datum/gas/bz = 20,
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST + 100
		)

/datum/gas_reaction/freonformation/react(datum/gas_mixture/air)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.return_temperature() / (FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 10), air.get_moles(/datum/gas/plasma) , air.get_moles(/datum/gas/carbon_dioxide) , air.get_moles(/datum/gas/bz) )
	var/energy_used = heat_efficency * 100
	if ((air.get_moles(/datum/gas/plasma) - heat_efficency * 1.5 < 0 ) || (air.get_moles(/datum/gas/carbon_dioxide) - heat_efficency * 0.75 < 0) || (air.get_moles(/datum/gas/bz) - heat_efficency * 0.25 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/plasma, -heat_efficency * 1.5)
	air.adjust_moles(/datum/gas/carbon_dioxide, -heat_efficency * 0.75)
	air.adjust_moles(/datum/gas/bz, -heat_efficency * 0.25)
	air.adjust_moles(/datum/gas/freon, heat_efficency * 2.5)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy - energy_used)/new_heat_capacity), TCMB))
		return REACTING

/datum/gas_reaction/freonformation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/plasma,40)
	G.set_moles(/datum/gas/carbon_dioxide,20)
	G.set_moles(/datum/gas/bz,20)
	G.set_temperature(50000)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/freon) < 25)
		return list("success" = FALSE, "message" = "Freon isn't being generated correctly!")
	return ..()

/datum/gas_reaction/stimformation //Stimulum formation follows a strange pattern of how effective it will be at a given temperature, having some multiple peaks and some large dropoffs. Exo and endo thermic.
	priority = 5
	name = "Stimulum formation"
	id = "stimformation"

/datum/gas_reaction/stimformation/init_reqs()
	min_requirements = list(
		/datum/gas/tritium = 30,
		/datum/gas/plasma = 10,
		/datum/gas/bz = 20,
		/datum/gas/nitryl = 30,
		"TEMP" = STIMULUM_HEAT_SCALE/2)

/datum/gas_reaction/stimformation/react(datum/gas_mixture/air)
	var/old_energy = air.thermal_energy()
	var/heat_scale = min(air.return_temperature()/STIMULUM_HEAT_SCALE,air.get_moles(/datum/gas/tritium),air.get_moles(/datum/gas/plasma),air.get_moles(/datum/gas/nitryl))
	var/stim_energy_change = heat_scale + STIMULUM_FIRST_RISE*(heat_scale**2) - STIMULUM_FIRST_DROP*(heat_scale**3) + STIMULUM_SECOND_RISE*(heat_scale**4) - STIMULUM_ABSOLUTE_DROP*(heat_scale**5)

	if ((air.get_moles(/datum/gas/tritium) - heat_scale < 0 )|| (air.get_moles(/datum/gas/plasma) - heat_scale < 0) || (air.get_moles(/datum/gas/nitryl) - heat_scale < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/stimulum, heat_scale/10)
	air.adjust_moles(/datum/gas/tritium, -heat_scale)
	air.adjust_moles(/datum/gas/plasma, -heat_scale)
	air.adjust_moles(/datum/gas/nitryl, -heat_scale)

	SSresearch.science_tech.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, STIMULUM_RESEARCH_AMOUNT*max(stim_energy_change,0))
	if(stim_energy_change)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy + stim_energy_change)/new_heat_capacity),TCMB))
		return REACTING

/datum/gas_reaction/stimformation/test()
	//above mentioned "strange pattern" is a basic quintic polynomial, it's fine, can calculate it manually
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/bz,30)
	G.set_moles(/datum/gas/plasma,1000)
	G.set_moles(/datum/gas/tritium,1000)
	G.set_moles(/datum/gas/nitryl,1000)
	G.set_volume(1000)
	G.set_temperature(12998000) // yeah, really

	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(!G.get_moles(/datum/gas/stimulum) < 900)
		return list("success" = FALSE, "message" = "Stimulum isn't being generated correctly!")
	return ..()

/datum/gas_reaction/nobliumformation //Hyper-Noblium formation is extrememly endothermic, but requires high temperatures to start. Due to its high mass, hyper-nobelium uses large amounts of nitrogen and tritium. BZ can be used as a catalyst to make it less endothermic.
	priority = 6
	name = "Hyper-Noblium condensation"
	id = "nobformation"

/datum/gas_reaction/nobliumformation/init_reqs()
	min_requirements = list(
		/datum/gas/nitrogen = 10,
		/datum/gas/tritium = 5,
		"TEMP" = 10000,
		"ENER" = NOBLIUM_FORMATION_ENERGY)

/datum/gas_reaction/nobliumformation/react(datum/gas_mixture/air)
	var/old_energy = air.thermal_energy()
	var/nob_formed = min((air.get_moles(/datum/gas/nitrogen)+air.get_moles(/datum/gas/tritium))/100,air.get_moles(/datum/gas/tritium)/10,air.get_moles(/datum/gas/nitrogen)/20)
	var/energy_taken = nob_formed*(NOBLIUM_FORMATION_ENERGY/(max(air.get_moles(/datum/gas/bz)/10,1)))
	if ((air.get_moles(/datum/gas/tritium) - 10*nob_formed < 0) || (air.get_moles(/datum/gas/nitrogen) - 20*nob_formed < 0))
		return NO_REACTION
	air.adjust_moles(/datum/gas/tritium, -10*nob_formed)
	air.adjust_moles(/datum/gas/nitrogen, -20*nob_formed)
	air.adjust_moles(/datum/gas/hypernoblium,nob_formed)

	SSresearch.science_tech.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, nob_formed*NOBLIUM_RESEARCH_AMOUNT)

	if (nob_formed)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy - energy_taken)/new_heat_capacity),TCMB))

/datum/gas_reaction/nobliumformation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/nitrogen,100)
	G.set_moles(/datum/gas/tritium,500)
	G.set_volume(1000)
	G.set_temperature(5000000) // yeah, really
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(abs(G.thermal_energy() - 23000000000) > 1000000) // god i hate floating points
		return list("success" = FALSE, "message" = "Hyper-nob formation isn't removing the right amount of heat! Should be 23,000,000,000, is instead [G.thermal_energy()]")
	return ..()


/datum/gas_reaction/miaster	//dry heat sterilization: clears out pathogens in the air
	priority = -10 //after all the heating from fires etc. is done
	name = "Dry Heat Sterilization"
	id = "sterilization"

/datum/gas_reaction/miaster/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST+70,
		/datum/gas/miasma = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/miaster/react(datum/gas_mixture/air, datum/holder)
	// As the name says it, it needs to be dry
	if(air.get_moles(/datum/gas/water_vapor) && air.get_moles(/datum/gas/water_vapor)/air.total_moles() > 0.1)
		return

	//Replace miasma with oxygen
	var/cleaned_air = min(air.get_moles(/datum/gas/miasma), 20 + (air.return_temperature() - FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 70) / 20)
	air.adjust_moles(/datum/gas/miasma, -cleaned_air)
	air.adjust_moles(/datum/gas/methane, cleaned_air)

	//Possibly burning a bit of organic matter through maillard reaction, so a *tiny* bit more heat would be understandable
	air.set_temperature(air.return_temperature() + cleaned_air * 0.002)
	SSresearch.science_tech.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, cleaned_air*MIASMA_RESEARCH_AMOUNT)//Turns out the burning of miasma is kinda interesting to scientists

/datum/gas_reaction/miaster/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/miasma,1)
	G.set_volume(1000)
	G.set_temperature(450)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(!G.get_moles(/datum/gas/methane))
		return list("success" = FALSE, "message" = "Reaction didn't properly make methane!")
	G.clear()
	G.set_moles(/datum/gas/miasma,1)
	G.set_temperature(450)
	G.set_moles(/datum/gas/water_vapor,0.5)
	result = G.react()
	if(result != NO_REACTION)
		return list("success" = FALSE, "message" = "Miasma sterilization not stopping due to water vapor correctly!")
	return ..()

/datum/gas_reaction/stim_ball
	priority = 7
	name ="Stimulum Energy Ball"
	id = "stimball"

/datum/gas_reaction/stim_ball/init_reqs()
	min_requirements = list(
		/datum/gas/pluoxium = STIM_BALL_GAS_AMOUNT,
		/datum/gas/stimulum = STIM_BALL_GAS_AMOUNT,
		/datum/gas/nitryl = MINIMUM_MOLE_COUNT,
		/datum/gas/plasma = MINIMUM_MOLE_COUNT,
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	)
/datum/gas_reaction/stim_ball/react(datum/gas_mixture/air, datum/holder)
	var/turf/open/location
	var/old_energy = air.thermal_energy()
	if(istype(holder,/datum/pipeline)) //Find the tile the reaction is occuring on, or a random part of the network if it's a pipenet.
		var/datum/pipeline/pipenet = holder
		location = get_turf(pick(pipenet.members))
	else
		location = get_turf(holder)
	var/ball_shot_angle = 180 * cos(air.get_moles(/datum/gas/water_vapor) / air.get_moles(/datum/gas/nitryl) ) + 180
	var/stim_used = min(STIM_BALL_GAS_AMOUNT / air.get_moles(/datum/gas/plasma) , air.get_moles(/datum/gas/stimulum) )
	var/pluox_used = min(STIM_BALL_GAS_AMOUNT / air.get_moles(/datum/gas/plasma) , air.get_moles(/datum/gas/pluoxium) )
	if ((air.get_moles(/datum/gas/pluoxium) - pluox_used < 0 ) || (air.get_moles(/datum/gas/stimulum) - stim_used < 0) || (air.get_moles(/datum/gas/plasma) - min(stim_used * pluox_used, 30) < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	var/energy_released = stim_used * STIMULUM_HEAT_SCALE//Stimulum has a lot of stored energy, and breaking it up releases some of it
	location.fire_nuclear_particle(ball_shot_angle)
	air.adjust_moles(/datum/gas/carbon_dioxide, 0.5 * pluox_used)
	air.adjust_moles(/datum/gas/nitrogen, 2 * stim_used)
	air.adjust_moles(/datum/gas/pluoxium, -pluox_used)
	air.adjust_moles(/datum/gas/stimulum, -stim_used)
	air.adjust_moles(/datum/gas/plasma, -min(stim_used * pluox_used, 30))
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(clamp((old_energy + energy_released) / new_heat_capacity, TCMB, INFINITY))
		return REACTING

/datum/gas_reaction/halon_formation
	priority = 15
	name = "Halon formation"
	id = "halon_formation"

/datum/gas_reaction/halon_formation/init_reqs()
	min_requirements = list(
		/datum/gas/bz = MINIMUM_MOLE_COUNT,
		/datum/gas/tritium = MINIMUM_MOLE_COUNT,
		"TEMP" = 30,
		"MAX_TEMP" = 55
	)

/datum/gas_reaction/halon_formation/react(datum/gas_mixture/air, datum/holder)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.return_temperature() * 0.01, air.get_moles(/datum/gas/tritium) , air.get_moles(/datum/gas/bz) )
	var/energy_used = heat_efficency * 300
	if ((air.get_moles(/datum/gas/tritium) - heat_efficency * 4 < 0 ) || (air.get_moles(/datum/gas/bz) - heat_efficency * 0.25 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/tritium, -heat_efficency * 4)
	air.adjust_moles(/datum/gas/bz, -heat_efficency * 0.25)
	air.adjust_moles(/datum/gas/halon, heat_efficency * 4.25)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy + energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/halon_formation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/bz,1)
	G.set_moles(/datum/gas/tritium,1)
	G.set_temperature(40)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/halon) < 1.5)
		return list("success" = FALSE, "message" = "Halon isn't being generated correctly!")
	return ..()

/datum/gas_reaction/hexane_formation
	priority = 16
	name = "Hexane formation"
	id = "hexane_formation"

/datum/gas_reaction/hexane_formation/init_reqs()
	min_requirements = list(
		/datum/gas/bz = MINIMUM_MOLE_COUNT,
		/datum/gas/hydrogen = MINIMUM_MOLE_COUNT,
		"TEMP" = 450,
		"MAX_TEMP" = 465
	)

/datum/gas_reaction/hexane_formation/react(datum/gas_mixture/air, datum/holder)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.return_temperature() * 0.01, air.get_moles(/datum/gas/hydrogen) , air.get_moles(/datum/gas/bz) )
	var/energy_used = heat_efficency * 600
	if ((air.get_moles(/datum/gas/hydrogen) - heat_efficency * 5 < 0 ) || (air.get_moles(/datum/gas/bz) - heat_efficency * 0.25 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/hydrogen, -heat_efficency * 5)
	air.adjust_moles(/datum/gas/bz, -heat_efficency * 0.25)
	air.adjust_moles(/datum/gas/hexane, heat_efficency * 5.25)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy - energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/hexane_formation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/bz,2)
	G.set_moles(/datum/gas/hydrogen,30)
	G.set_temperature(460)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/hexane) < 20)
		return list("success" = FALSE, "message" = "Hexane isn't being generated correctly!")
	return ..()

/datum/gas_reaction/healium_formation
	priority = 12
	name = "Healium formation"
	id = "healium_formation"

/datum/gas_reaction/healium_formation/init_reqs()
	min_requirements = list(
		/datum/gas/bz = MINIMUM_MOLE_COUNT,
		/datum/gas/freon = MINIMUM_MOLE_COUNT,
		"TEMP" = 25,
		"MAX_TEMP" = 300
	)

/datum/gas_reaction/healium_formation/react(datum/gas_mixture/air, datum/holder)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.return_temperature() * 0.3, air.get_moles(/datum/gas/freon) , air.get_moles(/datum/gas/bz) )
	var/energy_used = heat_efficency * 9000
	if ((air.get_moles(/datum/gas/freon) - heat_efficency * 2.75 < 0 ) || (air.get_moles(/datum/gas/bz) - heat_efficency * 0.25 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/freon, -heat_efficency * 2.75)
	air.adjust_moles(/datum/gas/bz, -heat_efficency * 0.25)
	air.adjust_moles(/datum/gas/healium, heat_efficency * 3)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy + energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/healium_formation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/bz,90)
	G.set_moles(/datum/gas/freon,10)
	G.set_temperature(100)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/healium) < 80)
		return list("success" = FALSE, "message" = "Healium isn't being generated correctly!")
	return ..()

/datum/gas_reaction/proto_nitrate_formation
	priority = 13
	name = "Proto Nitrate formation"
	id = "proto_nitrate_formation"

/datum/gas_reaction/proto_nitrate_formation/init_reqs()
	min_requirements = list(
		/datum/gas/pluoxium = MINIMUM_MOLE_COUNT,
		/datum/gas/hydrogen = MINIMUM_MOLE_COUNT,
		"TEMP" = 5000,
		"MAX_TEMP" = 10000
	)

/datum/gas_reaction/proto_nitrate_formation/react(datum/gas_mixture/air, datum/holder)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.return_temperature() * 0.005, air.get_moles(/datum/gas/pluoxium) , air.get_moles(/datum/gas/hydrogen) )
	var/energy_used = heat_efficency * 650
	if ((air.get_moles(/datum/gas/pluoxium) - heat_efficency * 0.2 < 0 ) || (air.get_moles(/datum/gas/hydrogen) - heat_efficency * 2 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/hydrogen, -heat_efficency * 2)
	air.adjust_moles(/datum/gas/pluoxium, -heat_efficency * 0.2)
	air.adjust_moles(/datum/gas/proto_nitrate, heat_efficency * 2.2)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy + energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/proto_nitrate_formation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/pluoxium,100)
	G.set_moles(/datum/gas/hydrogen,100)
	G.set_temperature(7500)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/proto_nitrate) < 80)
		return list("success" = FALSE, "message" = "Proto-nitrate isn't being generated correctly!")
	return ..()

/datum/gas_reaction/zauker_formation
	priority = 14
	name = "Zauker formation"
	id = "zauker_formation"

/datum/gas_reaction/zauker_formation/init_reqs()
	min_requirements = list(
		/datum/gas/hypernoblium = MINIMUM_MOLE_COUNT,
		/datum/gas/stimulum = MINIMUM_MOLE_COUNT,
		"TEMP" = 50000,
		"MAX_TEMP" = 75000
	)

/datum/gas_reaction/zauker_formation/react(datum/gas_mixture/air, datum/holder)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.return_temperature() * 0.000005, air.get_moles(/datum/gas/hypernoblium) , air.get_moles(/datum/gas/stimulum) )
	var/energy_used = heat_efficency * 5000
	if ((air.get_moles(/datum/gas/hypernoblium) - heat_efficency * 0.01 < 0 ) || (air.get_moles(/datum/gas/stimulum) - heat_efficency * 0.5 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/hypernoblium, -heat_efficency * 0.01)
	air.adjust_moles(/datum/gas/stimulum, -heat_efficency * 0.5)
	air.adjust_moles(/datum/gas/zauker, heat_efficency * 0.5)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy - energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/zauker_formation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/hypernoblium,1)
	G.set_moles(/datum/gas/stimulum,1)
	G.set_temperature(60000)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/zauker) < 0.1)
		return list("success" = FALSE, "message" = "Proto-nitrate isn't being generated correctly!")
	return ..()

/datum/gas_reaction/halon_o2removal
	priority = -1
	name = "Halon o2 removal"
	id = "halon_o2removal"

/datum/gas_reaction/halon_o2removal/init_reqs()
	min_requirements = list(
		/datum/gas/halon = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT,
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	)

/datum/gas_reaction/halon_o2removal/react(datum/gas_mixture/air, datum/holder)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.return_temperature() / ( FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 10), air.get_moles(/datum/gas/halon) , air.get_moles(/datum/gas/oxygen) )
	var/energy_used = heat_efficency * 2500
	if ((air.get_moles(/datum/gas/halon) - heat_efficency < 0 ) || (air.get_moles(/datum/gas/oxygen) - heat_efficency * 20 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/halon, -heat_efficency)
	air.adjust_moles(/datum/gas/oxygen, -heat_efficency * 20)
	air.adjust_moles(/datum/gas/carbon_dioxide, heat_efficency * 5)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy - energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/halon_o2removal/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/halon,3)
	G.set_moles(/datum/gas/oxygen,3)
	G.set_temperature(400)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/oxygen) > 2)
		return list("success" = FALSE, "message" = "Halon isn't filtering oxygen correctly!")
	return ..()

/datum/gas_reaction/hexane_plasma_filtering
	priority = 9
	name = "Hexane plasma filtering"
	id = "hexane_plasma_filtering"

/datum/gas_reaction/hexane_plasma_filtering/init_reqs()
	min_requirements = list(
		/datum/gas/hexane = MINIMUM_MOLE_COUNT,
		/datum/gas/plasma = MINIMUM_MOLE_COUNT,
		"TEMP" = 150
	)

/datum/gas_reaction/hexane_plasma_filtering/react(datum/gas_mixture/air, datum/holder)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.return_temperature() * 0.01, air.get_moles(/datum/gas/hexane) , air.get_moles(/datum/gas/plasma) )
	var/energy_used = heat_efficency * 250
	if ((air.get_moles(/datum/gas/hexane) - heat_efficency * 0.2 < 0 ) || (air.get_moles(/datum/gas/plasma) - heat_efficency * 0.5 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/hexane, -heat_efficency * 0.2)
	air.adjust_moles(/datum/gas/plasma, -heat_efficency * 0.5)
	air.adjust_moles(/datum/gas/carbon_dioxide, heat_efficency * 0.4)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy - energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/hexane_plasma_filtering/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/hexane,10)
	G.set_moles(/datum/gas/plasma,10)
	G.set_temperature(200)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/plasma) > 9.5)
		return list("success" = FALSE, "message" = "Hexane isn't filtering plasma correctly!")
	return ..()

/datum/gas_reaction/hexane_n2o_filtering
	priority = 10
	name = "Hexane n2o filtering"
	id = "hexane_n2o_filtering"

/datum/gas_reaction/hexane_n2o_filtering/init_reqs()
	min_requirements = list(
		/datum/gas/hexane = MINIMUM_MOLE_COUNT,
		/datum/gas/nitrous_oxide = MINIMUM_MOLE_COUNT,
	)

/datum/gas_reaction/hexane_n2o_filtering/react(datum/gas_mixture/air, datum/holder)
	var/old_energy = air.thermal_energy()
	var/heat_efficency = min(air.return_temperature() * 0.01, air.get_moles(/datum/gas/hexane) , air.get_moles(/datum/gas/nitrous_oxide) )
	var/energy_used = heat_efficency * 100
	if ((air.get_moles(/datum/gas/hexane) - heat_efficency * 0.2 < 0 ) || (air.get_moles(/datum/gas/nitrous_oxide) - heat_efficency * 0.5 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/hexane, -heat_efficency * 0.2)
	air.adjust_moles(/datum/gas/nitrous_oxide, -heat_efficency * 0.6)
	air.adjust_moles(/datum/gas/oxygen, heat_efficency * 0.2)
	air.adjust_moles(/datum/gas/nitrogen, heat_efficency * 0.6)

	if(energy_used)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((old_energy + energy_used) / new_heat_capacity), TCMB))
	return REACTING

/datum/gas_reaction/hexane_n2o_filtering/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/hexane,1)
	G.set_moles(/datum/gas/nitrous_oxide,1)
	G.set_temperature(300)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/nitrous_oxide) > 0.8)
		return list("success" = FALSE, "message" = "Hexane isn't filtering nitrous correctly!")
	return ..()

/datum/gas_reaction/zauker_decomp
	priority = 11
	name = "Zauker decomposition"
	id = "zauker_decomp"

/datum/gas_reaction/zauker_decomp/init_reqs()
	min_requirements = list(
		/datum/gas/nitrogen = MINIMUM_MOLE_COUNT,
		/datum/gas/zauker = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/zauker_decomp/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	var/burned_fuel = 0
	burned_fuel = min(20, air.get_moles(/datum/gas/nitrogen) , air.get_moles(/datum/gas/zauker) )
	if(air.get_moles(/datum/gas/zauker) - burned_fuel < 0)
		return NO_REACTION
	air.adjust_moles(/datum/gas/zauker, -burned_fuel)

	if(burned_fuel)
		energy_released += (460 * burned_fuel)

		air.adjust_moles(/datum/gas/oxygen, burned_fuel * 0.3)
		air.adjust_moles(/datum/gas/nitrogen, burned_fuel * 0.7)

		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)
		return REACTING
	return NO_REACTION

/datum/gas_reaction/zauker_decomp/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/zauker,2)
	G.set_moles(/datum/gas/nitrogen,1)
	G.set_temperature(300)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/zauker) > 0.1)
		return list("success" = FALSE, "message" = "Zauker isn't decomposing correctly!")
	return ..()

/datum/gas_reaction/healium_crystal_formation
	priority = 17
	name = "healium crystal formation"
	id = "healium_crystal_formation"

/datum/gas_reaction/healium_crystal_formation/init_reqs()
	min_requirements = list(
		/datum/gas/oxygen = 50,
		/datum/gas/healium = 10,
		"TEMP" = 1000,
		"MAX_TEMP" = 2500
	)

/datum/gas_reaction/healium_crystal_formation/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	if(!isturf(holder))
		return NO_REACTION
	var/turf/open/location = holder
	var/consumed_fuel = 0
	consumed_fuel = min(air.get_moles(/datum/gas/healium) * 2.5, 20 * (air.return_temperature() * 0.001))
	if ((air.get_moles(/datum/gas/healium) - consumed_fuel * 0.4 < 0 ) || (air.get_moles(/datum/gas/oxygen) - consumed_fuel * 0.1 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/oxygen, -consumed_fuel * 0.1)
	air.adjust_moles(/datum/gas/healium, -consumed_fuel * 0.4)
	if(prob(2 * consumed_fuel))
		new /obj/item/grenade/gas_crystal/healium_crystal(location)
	energy_released += consumed_fuel * 800
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)
	return REACTING

/datum/gas_reaction/proto_nitrate_crystal_formation
	priority = 18
	name = "hydrogen pluoxide crystal formation"
	id = "proto_nitrate_crystal_formation"

/datum/gas_reaction/proto_nitrate_crystal_formation/init_reqs()
	min_requirements = list(
		/datum/gas/nitrogen = 50,
		/datum/gas/proto_nitrate = 10,
		"TEMP" = 100,
		"MAX_TEMP" = 150
	)

/datum/gas_reaction/proto_nitrate_crystal_formation/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	if(!isturf(holder))
		return NO_REACTION
	var/turf/open/location = holder
	var/consumed_fuel = 0
	consumed_fuel = min(air.get_moles(/datum/gas/proto_nitrate) * 0.15, 20 * (air.return_temperature() * 0.01))
	if ((air.get_moles(/datum/gas/proto_nitrate) - consumed_fuel * 0.15 < 0 ) || (air.get_moles(/datum/gas/nitrogen) - consumed_fuel * 0.01 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/nitrogen, -consumed_fuel * 0.01)
	air.adjust_moles(/datum/gas/proto_nitrate, -consumed_fuel * 0.15)
	if(prob(5 * consumed_fuel))
		new /obj/item/grenade/gas_crystal/proto_nitrate_crystal(location)
	energy_released += consumed_fuel * 800
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)
	return REACTING

/datum/gas_reaction/zauker_crystal_formation
	priority = 19
	name = "zauker crystal formation"
	id = "zauker_crystal_formation"

/datum/gas_reaction/zauker_crystal_formation/init_reqs()
	min_requirements = list(
		/datum/gas/plasma = 50,
		/datum/gas/zauker = 10,
		"TEMP" = 270,
		"MAX_TEMP" = 280
	)

/datum/gas_reaction/zauker_crystal_formation/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	if(!isturf(holder))
		return NO_REACTION
	var/turf/open/location = holder
	var/consumed_fuel = 0
	consumed_fuel = min(air.get_moles(/datum/gas/zauker) * 0.1, 20 * (air.return_temperature() * 0.02))
	if ((air.get_moles(/datum/gas/zauker) - consumed_fuel * 0.05 < 0 ) || (air.get_moles(/datum/gas/plasma) - consumed_fuel * 5 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(/datum/gas/plasma, -consumed_fuel * 5)
	air.adjust_moles(/datum/gas/zauker, -consumed_fuel * 0.05)
	if(prob(10 * consumed_fuel))
		new /obj/item/grenade/gas_crystal/zauker_crystal(location)
	energy_released += consumed_fuel * 800
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)
	return REACTING

/datum/gas_reaction/proto_nitrate_plasma_response
	priority = 20
	name = "Proto Nitrate plasma response"
	id = "proto_nitrate_plasma_response"

/datum/gas_reaction/proto_nitrate_plasma_response/init_reqs()
	min_requirements = list(
		/datum/gas/proto_nitrate = MINIMUM_MOLE_COUNT,
		/datum/gas/plasma = MINIMUM_MOLE_COUNT,
		"TEMP" = 250,
		"MAX_TEMP" = 300
	)

/datum/gas_reaction/proto_nitrate_plasma_response/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	if(!isturf(holder))
		return NO_REACTION
	var/turf/open/location = holder
	if(air.get_moles(/datum/gas/plasma) > 10)
		return NO_REACTION
	var produced_amount = min(5, air.get_moles(/datum/gas/plasma) , air.get_moles(/datum/gas/proto_nitrate) )
	if(air.get_moles(/datum/gas/plasma) - produced_amount < 0 || air.get_moles(/datum/gas/proto_nitrate) - produced_amount * 0.1 < 0)
		return NO_REACTION
	air.adjust_moles(/datum/gas/plasma, -produced_amount)
	air.adjust_moles(/datum/gas/proto_nitrate, -produced_amount * 0.1)
	energy_released -= produced_amount * 1500
	if(prob(produced_amount * 15))
		new/obj/item/stack/sheet/mineral/plasma(location)
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)
	return REACTING

/datum/gas_reaction/proto_nitrate_bz_response
	priority = 21
	name = "Proto Nitrate bz response"
	id = "proto_nitrate_bz_response"

/datum/gas_reaction/proto_nitrate_bz_response/init_reqs()
	min_requirements = list(
		/datum/gas/proto_nitrate = MINIMUM_MOLE_COUNT,
		/datum/gas/bz = MINIMUM_MOLE_COUNT,
		"TEMP" = 260,
		"MAX_TEMP" = 280
	)

/datum/gas_reaction/proto_nitrate_bz_response/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	var/turf/open/location
	if(istype(holder,/datum/pipeline)) //Find the tile the reaction is occuring on, or a random part of the network if it's a pipenet.
		var/datum/pipeline/pipenet = holder
		location = get_turf(pick(pipenet.members))
	else
		location = get_turf(holder)
	var consumed_amount = min(5, air.get_moles(/datum/gas/bz) , air.get_moles(/datum/gas/proto_nitrate) )
	if(air.get_moles(/datum/gas/bz) - consumed_amount < 0)
		return NO_REACTION
	if(air.get_moles(/datum/gas/bz) < 30)
		radiation_pulse(location, consumed_amount * 20, 2.5, TRUE, FALSE)
		air.adjust_moles(/datum/gas/bz, -consumed_amount)
	else
		for(var/mob/living/carbon/L in location)
			L.hallucination += air.get_moles(/datum/gas/bz) * 0.7
	energy_released += 100
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)
	return REACTING

/datum/gas_reaction/proto_nitrate_freon_fire_response
	priority = 22
	name = "Proto Nitrate freon fire response"
	id = "proto_nitrate_freon_fire_response"

/datum/gas_reaction/proto_nitrate_freon_fire_response/init_reqs()
	min_requirements = list(
		/datum/gas/proto_nitrate = MINIMUM_MOLE_COUNT,
		/datum/gas/freon = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT,
		"TEMP" = 270,
		"MAX_TEMP" = 310
	)

/datum/gas_reaction/proto_nitrate_freon_fire_response/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	if(air.get_moles(/datum/gas/freon) > 100 && air.get_moles(/datum/gas/oxygen) > 100)
		var/fuel_consumption = min(5, air.return_temperature() * 0.03, air.get_moles(/datum/gas/freon) , air.get_moles(/datum/gas/proto_nitrate) )
		if(air.get_moles(/datum/gas/proto_nitrate) - fuel_consumption < 0)
			return NO_REACTION
		air.adjust_moles(/datum/gas/proto_nitrate, -fuel_consumption)
		air.adjust_moles(/datum/gas/freon, fuel_consumption * 0.01)
		energy_released -= fuel_consumption * 1500
		if(energy_released)
			var/new_heat_capacity = air.heat_capacity()
			if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
				air.set_temperature((old_energy + energy_released) / new_heat_capacity)
		return REACTING
	return NO_REACTION

/datum/gas_reaction/proto_nitrate_tritium_response
	priority = 23
	name = "Proto Nitrate tritium response"
	id = "proto_nitrate_tritium_response"

/datum/gas_reaction/proto_nitrate_tritium_response/init_reqs()
	min_requirements = list(
		/datum/gas/proto_nitrate = MINIMUM_MOLE_COUNT,
		/datum/gas/tritium = MINIMUM_MOLE_COUNT,
		"TEMP" = 150,
		"MAX_TEMP" = 340
	)

/datum/gas_reaction/proto_nitrate_tritium_response/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	var/turf/open/location = isturf(holder) ? holder : null
	var produced_amount = min(5, air.get_moles(/datum/gas/tritium) , air.get_moles(/datum/gas/proto_nitrate) )
	if(air.get_moles(/datum/gas/tritium) - produced_amount < 0 || air.get_moles(/datum/gas/proto_nitrate) - produced_amount * 0.01 < 0)
		return NO_REACTION
	location.rad_act(produced_amount * 2.4)
	air.adjust_moles(/datum/gas/tritium, -produced_amount)
	air.adjust_moles(/datum/gas/hydrogen, produced_amount)
	air.adjust_moles(/datum/gas/proto_nitrate, -produced_amount * 0.01)
	energy_released += 50
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)
	return REACTING

/datum/gas_reaction/proto_nitrate_hydrogen_response
	priority = 24
	name = "Proto Nitrate hydrogen response"
	id = "proto_nitrate_hydrogen_response"

/datum/gas_reaction/proto_nitrate_hydrogen_response/init_reqs()
	min_requirements = list(
		/datum/gas/proto_nitrate = MINIMUM_MOLE_COUNT,
		/datum/gas/hydrogen = 150,
	)

/datum/gas_reaction/proto_nitrate_hydrogen_response/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	var produced_amount = min(5, air.get_moles(/datum/gas/hydrogen) , air.get_moles(/datum/gas/proto_nitrate) )
	if(air.get_moles(/datum/gas/hydrogen) - produced_amount < 0)
		return NO_REACTION
	air.adjust_moles(/datum/gas/hydrogen, -produced_amount)
	air.adjust_moles(/datum/gas/proto_nitrate, produced_amount * 0.5)
	energy_released -= produced_amount * 2500
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)
	return REACTING

/datum/gas_reaction/proto_nitrate_zauker_response
	priority = 25
	name = "Proto Nitrate Zauker response"
	id = "proto_nitrate_zauker_response"

/datum/gas_reaction/proto_nitrate_zauker_response/init_reqs()
	min_requirements = list(
		/datum/gas/proto_nitrate = MINIMUM_MOLE_COUNT,
		/datum/gas/zauker = MINIMUM_MOLE_COUNT,
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	)

/datum/gas_reaction/proto_nitrate_zauker_response/react(datum/gas_mixture/air, datum/holder)
	var/turf/open/location = isturf(holder) ? holder : null
	var max_power = min(5, air.get_moles(/datum/gas/zauker) )
	air.set_moles(/datum/gas/zauker,  0)
	explosion(location, max_power * 0.55, max_power * 0.95, max_power * 1.25, max_power* 3)
	return REACTING

/datum/gas_reaction/pluox_formation
	priority = 2
	name = "Pluoxium formation"
	id = "pluox_formation"

/datum/gas_reaction/pluox_formation/init_reqs()
	min_requirements = list(
		/datum/gas/carbon_dioxide = MINIMUM_MOLE_COUNT,
		/datum/gas/oxygen = MINIMUM_MOLE_COUNT,
		/datum/gas/tritium = MINIMUM_MOLE_COUNT,
		"TEMP" = 50,
		"MAX_TEMP" = T0C
	)

/datum/gas_reaction/pluox_formation/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_energy = air.thermal_energy()
	var/produced_amount = min(5, air.get_moles(/datum/gas/carbon_dioxide) , air.get_moles(/datum/gas/oxygen) )
	if(air.get_moles(/datum/gas/carbon_dioxide) - produced_amount < 0 || air.get_moles(/datum/gas/oxygen) - produced_amount * 0.5 < 0 || air.get_moles(/datum/gas/tritium) - produced_amount * 0.01 < 0)
		return NO_REACTION
	air.adjust_moles(/datum/gas/carbon_dioxide, -produced_amount)
	air.adjust_moles(/datum/gas/oxygen, -produced_amount * 0.5)
	air.adjust_moles(/datum/gas/tritium, -produced_amount * 0.01)
	air.adjust_moles(/datum/gas/pluoxium, produced_amount)
	air.adjust_moles(/datum/gas/hydrogen, produced_amount * 0.01)
	energy_released += produced_amount * 250
	if(energy_released)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((old_energy + energy_released) / new_heat_capacity)
	return REACTING

/datum/gas_reaction/pluox_formation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(/datum/gas/carbon_dioxide,100)
	G.set_moles(/datum/gas/oxygen,50)
	G.set_moles(/datum/gas/tritium,1)
	G.set_temperature(200)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(G.get_moles(/datum/gas/pluoxium) < 4)
		return list("success" = FALSE, "message" = "Zauker isn't decomposing correctly!")
	return ..()
