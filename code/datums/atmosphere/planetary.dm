// Atmos types used for planetary airs
/datum/atmosphere/lavaland
	id = LAVALAND_DEFAULT_ATMOS

	base_gases = list(
		GAS_O2=5,
		GAS_N2=10,
	)
	normal_gases = list(
		GAS_O2=5,
		GAS_N2=5,
		GAS_CO2=5,
	)
	restricted_gases = list(
		GAS_BZ=0.1,
		GAS_BROMINE=0.1
	)

	minimum_pressure = HAZARD_LOW_PRESSURE + 10
	maximum_pressure = LAVALAND_EQUIPMENT_EFFECT_PRESSURE - 1

	minimum_temp = 281
	maximum_temp = 320

/datum/atmosphere/lavaland/generate_gas_string()
	if(prob(restricted_chance))
		base_gases = list(
			GAS_METHANE=5,
			GAS_N2=10
		)
		normal_gases = list(
			GAS_METHANE=5,
			GAS_N2=5,
		)
		restricted_gases = list(
			GAS_AMMONIA = 0.1,
			GAS_METHYL_BROMIDE = 0.1,
			GAS_HYDROGEN = 0.1
		)
	return ..()

/datum/atmosphere/lavaland/check_for_sanity(datum/gas_mixture/mix)
	if(mix.get_moles(GAS_METHANE) < 0.1)
		var/datum/breathing_class/o2_class = GLOB.gas_data.breathing_classes[BREATH_OXY]
		while(o2_class.get_effective_pp(mix) < 10)
			mix.adjust_moles(GAS_CO2, -0.5)
			mix.adjust_moles(GAS_O2, 0.5)

/datum/atmosphere/icemoon
	id = ICEMOON_DEFAULT_ATMOS

	base_gases = list(
		GAS_METHANE=5,
		GAS_N2=10,
	)
	normal_gases = list(
		GAS_METHANE=5,
		GAS_N2=10
	)
	restricted_gases = list(
		GAS_METHYL_BROMIDE=0.1,
		GAS_HYDROGEN=0.1
	)
	restricted_chance = 5

	minimum_pressure = HAZARD_LOW_PRESSURE + 10
	maximum_pressure = LAVALAND_EQUIPMENT_EFFECT_PRESSURE - 1

	minimum_temp = 180
	maximum_temp = 180

/datum/atmosphere/icemoon/generate_gas_string()
	if(prob(restricted_chance))
		base_gases = list(
			GAS_O2=5,
			GAS_N2=10,
		)
		normal_gases = list(
			GAS_O2=5,
			GAS_N2=10,
		)
		restricted_gases = list(
			GAS_BZ = 0.1,
			GAS_METHYL_BROMIDE = 0.1,
		)
	return ..()
