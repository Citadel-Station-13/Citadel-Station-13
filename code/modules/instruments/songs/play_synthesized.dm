/datum/song/proc/do_play_lines_synthesized(mob/user)
	compile_lines()
	while(repeat >= 0)
		if(should_stop_playing(user))
			return
		for(var/_chord in compiled_chords)
			if(should_stop_playing(user))
				return
			var/list/chord = _chord
			var/tempodiv = chord[chord.len]
			for(var/i in 1 to chord.len - 1)
				var/key = chord[i]
				if(!playkey_synth(key))
					to_chat(user, "<span class='userdanger'>BUG: [src] failed to play a note. This likely means that the entire channel spectrum available to instruments has been saturated, or it can mean some unknown error.</span>")
					return
			to_chat(world, "Played [english_list(chord)] at tempodiv [tempodiv] tempo [sanitize_tempo(tempo/tempodiv)]")
			sleep(sanitize_tempo(tempo / tempodiv))
		updateDialog()
		repeat--
	repeat = 0

/// C-Db2-A-A4/2,A-B#4-C/3,/4,A,A-B-C as an example
/datum/song/proc/compile_lines()
	if(!length(src.lines))
		return
	var/list/lines = src.lines		//cache for hyepr speed!
	compiled_chords = list()
	var/list/octaves = list(3, 3, 3, 3, 3, 3, 3)
	var/list/accents = list("n", "n", "n", "n", "n", "n", "n")
	for(var/line in lines)
		var/list/chords = splittext(lowertext(line), ",")
		for(var/chord in chords)
			var/list/compiled_chord = list()
			var/tempodiv = 1
			var/list/notes_tempodiv = splittext(chord, "/")
			if(length(notes_tempodiv) >= 2)
				tempodiv = text2num(notes_tempodiv[2])
			var/list/notes = splittext(notes_tempodiv[1], "-")
			for(var/note in notes)
				if(length(note) == 0)
					continue
				// 1-7, A-G
				var/key = text2ascii(note) - 96
				if((key < 1) || (key > 7))
					continue
				for(var/i in 2 to length(note))
					var/oct_acc = copytext(note, i, i + 1)
					var/num = text2num(oct_acc)
					if(!num)		//it's an accidental
						accents[key] = oct_acc		//if they misspelled it/fucked up that's on them lmao, no safety checks.
					else	//octave
						octaves[key] = CLAMP(num, octave_min, octave_max)
				compiled_chord += CLAMP((note_offset_lookup[key] + octaves[key] * 12 + accent_lookup[accents[key]]), key_min, key_max)
			compiled_chord += tempodiv		//this goes last
			if(length(compiled_chord))
				compiled_chords[++compiled_chords.len] = compiled_chord
		CHECK_TICK
	return compiled_chords

/datum/song/proc/playkey_synth(key)
	if(can_noteshift)
		key = clamp(key + note_shift, key_min, key_max)
	if((world.time - MUSICIAN_HEARCHECK_MINDELAY) > last_hearcheck)
		do_hearcheck()
	var/datum/instrument_key/K = using_instrument.samples[num2text(key)]			//See how fucking easy it is to make a number text? You don't need a complicated 9 line proc!
	//Should probably add channel limiters here at some point but I don't care right now.
	var/channel = key_channel_reserve(key)
	if(!channel)
		. = FALSE
		CRASH("Exiting playkey_synth - Unable to reserve channel")
	. = TRUE
	var/sound/copy = sound(K.sample)
	copy.frequency = K.frequency
	copy.volume = volume
	to_chat(world, "Playing sound key [key] frequency [K.frequency]")
	keys_playing[num2text(key)] = volume
	for(var/i in hearing_mobs)
		var/mob/M = i
		M.playsound_local(get_turf(parent), null, volume, FALSE, K.frequency, 0, channel, sound = copy)
		// Could do environment and echo later but not for now

/datum/song/proc/terminate_all_sounds(clear_channels = TRUE)
	for(var/i in hearing_mobs)
		terminate_sound_mob(i)
	if(clear_channels)
		SSsounds.free_datum_channels(src)
		channels_reserved.len = 0
		keys_playing.len = 0

/datum/song/proc/terminate_sound_mob(mob/M)
	for(var/i in channels_reserved)
		M.stop_sound_channel(text2num(i))

/datum/song/proc/key_channel_lookup(key)
	return channels_reserved["[key]"]

/datum/song/proc/key_channel_reserve(key)
	key = num2text(key)
	. = channels_reserved[key]
	if(.)
		return
	. = SSsounds.reserve_sound_channel(src)
	if(!.)
		return
	channels_reserved[key] = .

/datum/song/proc/process_decay(wait_ds)
	var/linear_dropoff = cached_linear_dropoff * wait_ds
	var/exponential_dropoff = cached_exponential_dropoff ** wait_ds
	for(var/key in keys_playing)
		var/current_volume = keys_playing[key]
		switch(sustain_mode)
			if(SUSTAIN_LINEAR)
				current_volume -= linear_dropoff
			if(SUSTAIN_EXPONENTIAL)
				current_volume /= exponential_dropoff
		keys_playing[key] = current_volume
		var/dead = current_volume < sustain_dropoff_volume
		if(dead)
			keys_playing -= key
		var/channel = channels_reserved[key]
		if(!channel)
			continue
		if(dead)
			for(var/i in hearing_mobs)
				var/mob/M = i
				M.stop_sound_channel(channel)
		else
			for(var/i in hearing_mobs)
				var/mob/M = i
				M.set_sound_channel_volume(channel, current_volume)
