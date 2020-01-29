/datum/song/proc/do_play_lines_synth()
	compile_lines()
	var/terminate = FALSE
	while(repeats)
		for(var/_chord in compiled_chords)
			var/list/chord = _chord
			var/tempodiv = chord[chord.len]
			for(var/i in 1 to chord.len - 1)
				var/key = chord[i]
				playkey_synth(key)
			if(should_stop_playing())
				terminate = TRUE
				break
			sleep(sanitize_tempo_ds(tempo_ds / tempodiv))
		if(should_stop_playing())
			terminate = TRUE
		if(terminate)
			break
		updateUsrDialog()
	if(!debug_mode)
		compiled_chords = null
	terminate_sound_all()
	SSsounds.release_channel_datum(src)

/datum/song/proc/compile_lines()
	compiled_chords = list()
	var/list/octaves = list()
	var/list/accents = list()
	for(var/i in 1 to 7)
		octaves += 3
		accents += "n"
	for(var/line in lines)
		var/list/beats = splittext(lowertext(line), ",")
		for(var/beat in beats)
			var/list/contents = splittext(beat, "/")
			var/tempo_divisor = 1
			var/contents_length = length(contents)
			var/list/newchord = list()
			if(contents_length)
				if(contents_length >= 2)
					var/newdiv = text2num(contents[2])
					if(isnum(newdiv))
						tempo_divisor = newdiv
				for(var/note in contents[1])
					var/key = note_to_key(note, octaves, accents, TRUE)
					if(key)
						newchord += key
			newchord += tempo_divisor
			compiled_chords += newchord
		CHECK_TICK

/datum/song/proc/note_to_key(notestring, list/octaves, list/accents, change_lists = FALSE)
	//For the sake of performance, we're not going to check for octaves/accents existing.
	var/notelen
	if((!(notelen = length(notestring))))
		return
	var/cur_note = text2ascii(note, 1) - 96
	//a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7
	if(cur_note < 1 || cur_note > 7)
		return
	var/accent
	var/octave
	for(var/i in 2 to notelen)
		var/text = copytext(notestring, i)
		if((text == "s") || (text == "#"))
			if(change_lists)
				accents[cur_note] = "#"
			accent = "#"
		else if(text == "n")
			if(change_lists)
				accents[cur_note] = "n"
			accent = "n"
		else if(text == "b")
			if(change_lists)
				accents[cur_note] = "b"
			accent = "b"
		else
			var/n = text2num(text)
			if(n && (n >= max(INSTRUMENT_MIN_OCTAVE, octave_min)) && (n <= min(INSTRUMENT_MAX_OCTAVE, octave_max)))
				if(change_lists)
					octaves[cur_note] = n
				oactave = n
	accent = accent || accents[cur_note]
	octave = octave || octaves[cur_note]
	return ((octave * 12) + (accent_lookup[accent]) + (note_offset_lookup[cur_note]))

/datum/song/proc/playkey_synth(key)
	var/datum/sample_pair/S = using_instrument.samples["[key]"]			//See how fucking easy it is to make a number text? You don't need a complicated 9 line proc!
	//Should probably add channel limiters here at some point but I don't care right now.
	var/channel = key_channel_reserve(key)
	if(!channel)
		return
	keys_playing["[key]"] = volume
	for(var/i in hearing_mobs)
		var/mob/M = i
		M.playsound_local(get_turf(parent), S.sample, volume, FALSE, S.frequency, 0, FALSE, channel)			WIP_TAG - ENVIRONMENT AND ECHO

/datum/song/proc/terminate_sound_all(clear_channels = TRUE)
	for(var/i in hearing_mobs)
		terminate_sound_mob(i)
	if(clear_channels)
		SSsounds.release_channel_datum(src)
		channels_reserved.Cut()
		keys_playing.Cut()

/datum/song/proc/terminate_sound_mob(var/mob/M)
	for(var/i in channels_reserved)
		var/channel = channels_reserved[i]
		M.stop_sound_channel(channel)

/datum/song/proc/key_channel_lookup(key)
	return channels_reserved["[key]"]

/datum/song/proc/key_channel_reserve(key)
	if(channels_reserved["[key]"])
		return channels_reserved["[key]"]
	var/channel = SSsound.reserve_sound_channel(src)
	if(channel)
		channels_reserved["[key]"] = channel
	return channel

/datum/song/proc/process_decay(wait_ds)
	var/linear_delta = (volume / sustain_linear) * wait_ds
	var/exponential_multiplier = sustain_exponential ** wait_ds
	for(var/key in keys_playing)
		var/amount_left = keys_playing[key]
		switch(sustain_mode)
			if(SUSTAIN_LINEAR)
				amount_left -= linear_delta
			if(SUSTAIN_EXPONENTIAL)
				amount_left /= exponential_multiplier
		keys_playing[key] = amount_left
		var/dead = amount_left <= SUSTAIN_DROP
		if(dead)
			keys_playing -= key
		var/channel = key_channel_lookup(key)
		if(!channel)
			continue
		if(dead)
			for(var/i in hearing_mobs)
				var/mob/M = i
				M.stop_sound_channel(channel)
		else
			for(var/i in hearing_mobs)
				var/mob/M = i
				M.set_sound_channel_volume(channel, amount_left)
