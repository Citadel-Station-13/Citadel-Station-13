/datum/instrument_key
	var/key			//1 to 127
	var/sample		//file
	var/frequency	//frequency generated
	var/deviation	//deviation up/down towards pivot from sample (??)

/datum/instrument_key/New(sample = src.sample, key = src.key, deviation = src.deviation, frequency = src.frequency)
	src.sample = sample
	src.key = key
	src.deviation = deviation
	src.frequency = frequency
	if(!frequency && deviation)
		calculate()

/datum/instrument_key/proc/calculate()
	if(!deviation)
		CRASH("Invalid calculate call: No deviation or sample in instrument_key")
	#define KEY_TWELTH (1/12)
	frequency = 2 ** (KEY_TWELTH * deviation)
	#undef KEY_TWELTH
