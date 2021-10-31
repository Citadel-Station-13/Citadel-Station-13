// File contains standard helpers for things like radiation pulses, lighting strikes, etc.

/datum/weather/proc/std_random_turf()


/datum/weather/proc/std_lightning_strike(turf/target, intensity = 50000, range = 5)
	if(!target)
		target = std_random_turf()

/datum/weather/proc/std_radiation_pulse(turf/target, intensity = 100, range = 7)


/datum/weather/proc/std_radiation_contamination(turf/target, intensity = 500, range = 7, amt = 10)



