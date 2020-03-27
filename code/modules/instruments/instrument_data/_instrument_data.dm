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
	/// Name of the instrument
	var/name = "Generic instrument"
	/// Uniquely identifies this instrument so runtime changes are possible as opposed to paths
	var/id
	/// Category
	var/category = "Unsorted"
	/// Used for categorization subtypes
	var/abstract_type = /datum/instrument
	/// Write here however many samples, follow this syntax: "%note num%"='%sample file%' eg. "27"='synthesizer/e2.ogg'. Key must never be lower than 0 and higher than 127
	var/list/real_samples
	/// assoc list key = /datum/instrument_key. do not fill this yourself!
	var/list/samples
	/// See __DEFINES/flags/instruments.dm
	var/instrument_flags = NONE
	/// For legacy instruments, the path to our notes
	var/legacy_instrument_path
	/// For legacy instruments, our file extension
	var/legacy_instrument_ext
	/// What songs are using us
	var/list/datum/song/songs_using = list()

/datum/instrument/proc/Initialize()
	calculate_samples()

/datum/instrument/proc/ready()
	if(CHECK_BITFIELD(instrument_flags, INSTRUMENT_LEGACY))
		return legacy_instrument_path && legacy_instrument_ext
	else if(CHECK_BITFIELD(instrument_flags, INSTRUMENT_DO_NOT_AUTOSAMPLE))
		return length(samples)
	return (length(samples) == 127)

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
	sortTim(num_keys)

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


/datum/instrument
	var/list/datum/sample_pair/sample_map = list() // Used to modulate sounds, don't fill yourself

/datum/instrument/proc/create_full_sample_deviation_map()
	// Obtain samples
	if (!src.samples.len)
		CRASH("No samples were defined in [src.type]")

	var/list/delta_1 = list()
	for (var/key in samples)
		delta_1 += text2num(key)
	sortTim(delta_1, associative=0)

	for (var/indx1=1 to delta_1.len-1)
		var/from_key = delta_1[indx1]
		var/to_key   = delta_1[indx1+1]
		var/sample1  = src.samples[GLOB.musical_config.n2t(from_key)]
		var/sample2  = src.samples[GLOB.musical_config.n2t(to_key)]
		var/pivot    = round((from_key+to_key)/2)
		for (var/key = from_key to pivot)
			src.sample_map[GLOB.musical_config.n2t(key)] = new /datum/sample_pair(sample1, key-from_key) // [55+56] / 2 -> 55.5 -> 55 so no changes will occur
		for (var/key = pivot+1 to to_key)
			src.sample_map[GLOB.musical_config.n2t(key)] = new /datum/sample_pair(sample2, key-to_key)

	// Fill in 0 -- first key and last key -- 127
	var/first_key = delta_1[1]
	var/last_key  = delta_1[delta_1.len]
	var/first_sample = src.samples[GLOB.musical_config.n2t(first_key)]
	var/last_sample = src.samples[GLOB.musical_config.n2t(last_key)]
	for (var/key=0 to first_key-1)
		src.sample_map[GLOB.musical_config.n2t(key)] = new /datum/sample_pair(first_sample, key-first_key)
	for (var/key=last_key to 127)
		src.sample_map[GLOB.musical_config.n2t(key)] = new /datum/sample_pair(last_sample,  key-last_key)
	return src.samples
