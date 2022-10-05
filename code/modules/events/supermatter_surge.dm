/datum/round_event_control/supermatter_surge
	name = "Supermatter Surge"
	typepath = /datum/round_event/supermatter_surge
	weight = 20
	max_occurrences = 5
	earliest_start = 10 MINUTES

/datum/round_event_control/supermatter_surge/canSpawnEvent()
	if(GLOB.main_supermatter_engine?.has_been_powered)
		return ..()

/datum/round_event/supermatter_surge
	var/power = 2000

/datum/round_event/supermatter_surge/setup()
	if(prob(70))
		power = rand(200,100000)
	else
		power = rand(200,200000)

/datum/round_event/supermatter_surge/announce()
	var/severity = ""
	var/important = FALSE
	switch(power)
		if(-INFINITY to 100000)
			var/low_threat_perc = 100-round(100*((power-200)/(100000-200)))
			if(prob(low_threat_perc))
				if(prob(low_threat_perc))
					severity = "low; the supermatter should return to normal operation shortly."
				else
					severity = "medium; the supermatter should return to normal operation, but regardless, check if the emitters may need to be turned off temporarily."
			else
				severity = "high; the emitters likely need to be turned off, and if the supermatter's cooling loop is not fortified, pre-cooled gas may need to be added."
				important = TRUE
		if(100000 to INFINITY)
			severity = "extreme; emergency action is likely to be required even if coolant loop is fine. Turn off the emitters and make sure the loop is properly cooling gases."
			important = TRUE
	if(power > 20000 || prob(round(power/200)))
		priority_announce("Supermatter surge detected. Estimated severity is [severity]", "Anomaly Alert", has_important_message = important)

/datum/round_event/supermatter_surge/start()
	var/obj/machinery/power/supermatter_crystal/supermatter = GLOB.main_supermatter_engine
	var/power_proportion = supermatter.powerloss_inhibitor * 0.75 // what % of the power goes into matter power, at most 50%
	// we reduce the proportion that goes into actual matter power based on powerloss inhibitor
	// primarily so the supermatter doesn't tesla the instant these happen
	supermatter.matter_power += power * power_proportion
	var/datum/gas_mixture/methane_puff = new
	var/selected_gas = pick(4;GAS_CO2, 10;GAS_METHANE, 4;GAS_H2O, 1;GAS_BZ, 1;GAS_METHYL_BROMIDE)
	methane_puff.set_moles(selected_gas, 500)
	methane_puff.set_temperature(500)
	var/energy_ratio = (power * 500 * (1-power_proportion)) / methane_puff.thermal_energy()
	if(energy_ratio < 1) // energy output we want is lower than current energy, reduce the amount of gas we puff out
		methane_puff.set_moles(GAS_METHANE, energy_ratio * 500)
	else // energy output we want is higher than current energy, increase its actual heat
		methane_puff.set_temperature(energy_ratio * 500)
	supermatter.assume_air(methane_puff)
