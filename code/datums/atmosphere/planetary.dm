// Atmos types used for planetary airs
/datum/atmosphere/lavaland
	id = LAVALAND_DEFAULT_ATMOS

	base_gases = list(
		GAS_O2=5,
		GAS_N2=10,
	)
	normal_gases = list(
		GAS_O2=10,
		GAS_N2=10,
		GAS_CO2=10,
	)
	restricted_gases = list(
		GAS_BZ=0.1,
		GAS_METHYL_BROMIDE=0.1,
	)
	restricted_chance = 30

	minimum_pressure = HAZARD_LOW_PRESSURE + 10
	maximum_pressure = LAVALAND_EQUIPMENT_EFFECT_PRESSURE - 1

	minimum_temp = 270
	maximum_temp = 320

/datum/atmosphere/lavaland/check_for_sanity(datum/gas_mixture/mix)
	var/datum/breathing_class/o2_class = GLOB.gas_data.breathing_classes[BREATH_OXY]
	while(o2_class.get_effective_pp(mix) < 10)
		mix.adjust_moles(GAS_CO2, -0.5)
		mix.adjust_moles(GAS_O2, 0.5)

/datum/atmosphere/icemoon
	id = ICEMOON_DEFAULT_ATMOS

	base_gases = list(
		GAS_O2=5,
		GAS_N2=10,
	)
	normal_gases = list(
		GAS_O2=10,
		GAS_N2=10,
		GAS_CO2=10,
	)
	restricted_gases = list(
		GAS_METHYL_BROMIDE=0.1,
	)
	restricted_chance = 10

	minimum_pressure = HAZARD_LOW_PRESSURE + 10
	maximum_pressure = LAVALAND_EQUIPMENT_EFFECT_PRESSURE - 1

	minimum_temp = 180
	maximum_temp = 180

