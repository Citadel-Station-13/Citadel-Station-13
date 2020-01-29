/proc/path_to_instrument_ids(path)
	if(!ispath(path))
		path = text2path(path)
		if(!ispath(path))
			return
	if(!ispath(path, /datum/instrument))
		return
	. = list()
	for(var/i in typesof(path))
		var/datum/instrument/I = i
		var/init_id = initial(I.id)
		if(init_id)
			. |= init_id

/datum/instrument
	var/name = "Generic instrument" 		// Name of the instrument
	var/id			 						// Used everywhere to distinguish between categories and actual data and to identify instruments
	var/category = "Unsorted"				// Used to categorize instruments
	var/abstract_type = /datum/instrument
	var/list/real_samples					// Write here however many samples, follow this syntax: "%note num%"='%sample file%' eg. "27"='synthesizer/e2.ogg'. Key must never be lower than 0 and higher than 127
	var/list/samples						// assoc list key = /datum/instrument_key. do not fill this yourself!
	var/instrument_flags = NONE
	var/legacy_instrument_path
	var/legacy_instrument_ext
	var/list/datum/song/songs_using = list()	//gc purposes

/datum/instrument/proc/Initialize()
	calculate_samples()

/datum/instrument/proc/ready()
	if(CHECK_BITFIELD(instrument_flags, INSTRUMENT_LEGACY))
		return legacy_instrument_path && legacy_instrument_ext
	else if(CHECK_BITFIELD(instrument_flags, INSTRUMENT_DO_NOT_AUTOSAMPLE))
		return samples.len
	return samples.len == 127

/datum/instrument/Destroy()
	SSinstruments.instrument_data -= id
	for(var/i in songs_using)
		var/datum/song/S = i
		S.stop_playing()
		S.using_instrument = null
	return ..()

/datum/instrument/proc/calculate_samples()
	if(CHECK_BITFIELD(instrument_flags, INSTRUMENT_DO_NOT_AUTOSAMPLE | INSTRUMENT_LEGACY))
		return
	if(!islist(real_samples) || !real_samples.len)
		CRASH("No real_samples defined in instrument [id] ([type]) or real_samples was not a list!")
	var/list/num_keys = list()
	for(var/key in samples)
		num_keys += key
	sortTime(num_keys, associative = FALSE)

	//Fill in inbetween real samples
	for(var/i in 1 to num_keys.len - 1)
		var/from_key = num_keys[i]
		var/to_key = num_keys[i+1]
		var/sample1 = real_samples["[from_key]"]
		var/sample2 = real_samples["[to_key]"]
		var/pivot = round((from_key + to_key) / 2)		//Is this a round or a floor? Nobody knows! Thanks, Baystation.
		for(var/key in from_key to pivot)
			sample_map["[key]"] = new /datum/instrument_key(sample1, key, key - from_key)
		for(var/key in pivot + 1 to to_key)
			sample_map["[key]"] = new /datum/instrument_key(sample2, key, key - to_key)

	//Fill in 0 to the lowest sample, and the highest sample to 127
	var/first_key = num_keys[1]
	var/last_key = num_keys[num_keys.len]
	var/first_sample = samples["[first_key]"]
	var/last_sample = samples["[last_key]"]
	for(var/key in 0 to first_key - 1)
		sample_map["[key]"] = new /datum/instrument_key(first_sample, key, key - first_key)
	for(var/key in last_key to 127)
		sample_map["[key]"] = new /datum/instrument_key(first_sample, key, key - last_key)
	return samples
