#define ICE_SPECIFIC_HEAT 40 // joules/mole-kelvin
#define WATER_SPECIFIC_HEAT 75
#define WATER_ENTHALPY_OF_VAPORIZATION		40000
#define WATER_ENTHALPY_OF_FUSION			6000

/datum/component/wetness
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	can_transfer = TRUE
	var/ice = 0
	var/water = 0
	var/ice_temp = T0C
	var/water_temp = T0C
	var/last_process = 0

/datum/component/wetness/Initialize(amt, new_temp)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	if(new_temp > T0C)
		water = amt
		water_temp = new_temp
	else
		ice = amt
		ice_temp = new_temp
	START_PROCESSING(SSwet_floors, src)
	addtimer(CALLBACK(src, .proc/gc, TRUE), 1)
	last_process = world.time

/datum/component/wet_floor/Destroy()
	STOP_PROCESSING(SSwet_floors, src)

/datum/component/wetness/InheritComponent(datum/newcomp, amt, new_temp)
	if(!newcomp)
		add_wet(amt,new_temp)
	else
		var/datum/component/wetness/WF = newcomp
		if(WF.gc())						//See if it's even valid, still. Also does LAZYLEN and stuff for us.
			CRASH("Wetness component tried to inherit another, but the other was able to garbage collect while being inherited! What a waste of time!")
		add_wet(WF.ice,WF.ice_temp)
		add_wet(WF.water,WF.water_temp)

/datum/component/wetness/process()
	var/diff = (world.time - last_process) / SSwet_floors.time_ratio
	var/delta_temperature = water_temp - ice_temp
	var/water_cap = water * WATER_SPECIFIC_HEAT
	var/ice_cap = ice * ICE_SPECIFIC_HEAT
	var/heat_transfer = 0.1 * delta_temperature * diff * ((ice_cap * water_cap) / (ice_cap + water_cap))
	water_temp -= heat_transfer / water_cap
	ice_temp += heat_transfer / ice_cap
	var/atom/A = parent
	var/datum/gas_mixture/air = A.return_air()
	if(istype(air))
		water_temp = air.temperature_share(null, 0.05 * diff, water_temp, water_cap)
		ice_temp = air.temperature_share(null, 0.05 * diff, ice_temp, ice_cap)
	if(water_temp <= T0C)
		var/old_temp = water_temp
		water_temp = T0C
		var/amount_frozen = ((water_temp - old_temp) * water_cap) / WATER_ENTHALPY_OF_FUSION
		water -= amount_frozen
		ice += amount_frozen
	if(ice_temp > T0C)
		var/old_temp = ice_temp
		ice_temp = T0C
		var/amount_melted = ((ice_temp - old_temp) * ice_cap) / WATER_ENTHALPY_OF_FUSION
		water += amount_melted
		ice -= amount_melted
	if(istype(air))
		var/T = water_temp - T0C
		// https://en.wikipedia.org/wiki/Arden_Buck_equation
		var/saturation_pressure = 0.61121 * NUM_E ** ((18.678 - T / 234.5) * (T / (257.14 + T)))
		// the pressure of water vapor in the air; not relative humidity, but relative humidity makes less sense in space
		var/vapor_pp = air.return_pressure() * (air.get_moles(/datum/gas/water_vapor) / air.total_moles())
		// divided arbitrarily by 64 so it looks nice, clamped by the amount of vapor in the air and water in the hole
		var/evaporated_amt = clamp((saturation_pressure - vapor_pp) * 0.015625 * diff, \
									-air.get_moles(/datum/gas/water_vapor), water)
		// evaporation/condensation absorb/release heat respectively, so this does that
		var/heat_removed = evaporated_amt * WATER_ENTHALPY_OF_VAPORIZATION
		air.set_temperature(air.return_temperature() - (heat_removed / air.heat_capacity()))
		air.set_moles(air.get_moles(/datum/gas/water_vapor) + evaporated_amt)
	if(isopenturf(parent))
		var/turf/open/T = parent
		if(water > MOLES_GAS_VISIBLE)
			T.MakeSlippery(TURF_WET_WATER, 5 SECONDS, 2 SECONDS, permanent = TRUE)
		else
			T.MakeDry(TURF_WET_WATER, TRUE, 10 SECONDS)
		if(ice > MOLES_GAS_VISIBLE)
			T.MakeSlippery(TURF_WET_ICE, 5 SECONDS, 2 SECONDS, permanent = TRUE)
		else
			T.MakeDry(TURF_WET_ICE, TRUE, 10 SECONDS)
	gc()

/datum/component/wetness/proc/add_wet(amt, new_temp)
	if(new_temp <= T0C)
		var/heat = ice * ICE_SPECIFIC_HEAT * ice_temp
		var/new_heat = amt * ICE_SPECIFIC_HEAT * new_temp
		ice += amt
		ice_temp = (heat + new_heat) / (ICE_SPECIFIC_HEAT * ice)
	else
		var/heat = water * WATER_SPECIFIC_HEAT * water_temp
		var/new_heat = amt * WATER_SPECIFIC_HEAT * new_temp
		water += amt
		water_temp = (heat + new_heat) / (WATER_SPECIFIC_HEAT * ice)

/datum/component/wetness/proc/gc()
	if(ice < 0.001 && water < 0.001)
		qdel(src)
		return TRUE
	return FALSE
