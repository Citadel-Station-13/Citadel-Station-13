/datum/song
	var/name = "Untitled"

	var/debug_mode = FALSE

	var/interface_help = FALSE		//help is open
	var/interface_edit = TRUE		//editing mode
	var/list/lines = list()
	var/sustain_mode = SUSTAIN_LINEAR
	var/sustain_exponential = 1.07
	var/sustain_linear = 10
	var/volume = 100
	var/octave_shift = 0
	var/tempo_ds = 5			//delay between notes in deciseconds
	var/repeat_current = 0		//current repeats left
	var/playing = FALSE			//whether we should be playing. Setting this to FALSE will halt the playing proc ASAP.

	var/obj/parent			//The object in the world we're attached to. Can theoretically support datums in the future, but this should probably stay as an atom at the least.

	var/max_repeats = 10		//max repeats
	var/list/allowed_instrument_ids = list("r3grand")		//Ones the built in switcher is allowed to use.
	var/datum/instrument/using_instrument

	var/now_playing = FALSE		//Whether we actually are playing.
	var/last_hearcheck = 0		//last world.time we checked for hearing mobs.
	var/list/hearing_mobs		//list of mobs that can hear us
	var/list/channels_reserved		//key = channel
	var/list/keys_playing			//key = volume

	//Cache for hyper speed!
	var/cached_legacy_ext
	var/cached_legacy_dir
	var/list/cached_samples
	var/legacy_mode = FALSE
	var/list/compiled_chords 	//non assoc list of lists : index = list(key1, key2, key3... , tempo_divisor). tempo divisor always exists, key1 doesn't have to if it's a rest.
	////////////////////////

	//Don't touch this.
	var/octave_min = INSTRUMENTS_MIN_OCTAVE
	var/octave_max = INSTRUMENTS_MAX_OCTAVE
	var/static/list/note_offset_lookup = list(9, 11, 0, 2, 4, 5, 7)
	var/static/list/accent_lookup = list("b" = -1, "s" = 1, "#" = 1, "n" = 0)
	///////////////////////

/datum/song/New(atom/parent, datum/instrument/instrument_or_id)
	src.parent = parent
	SSinstruments.on_song_new(src)
	set_instrument(instrument_or_id || ((islist(allowed_instrument_ids) && length(allowed_instrument_ids))? allowed_instrument_ids[1] : allowed_instrument_ids))
	channels_reserved = list()
	keys_playing = list()

/datum/song/Destroy()
	stop_playing()
	var/time = world.time
	UNTIL(!now_playing || ((world.time - time) > 20))
	if((world.time - time) > 20)
		crash_with("WARNING: datum/song [src] failed to stop playing more than 20 deciseconds after being instructed to stop by Destroy()!")
	SSinstruments.on_song_del(src)
	parent = null
	lines = null
	using_instrument = null
	allowed_instrument_ids = null
	hearing_mobs = null
	cached_samples = null
	compiled_chords = null
	return ..()

/datum/song/proc/set_bpm(bpm)
	tempo_ds = round(600 / bpm, world.tick_lag)

/datum/song/proc/get_bpm()
	return (600 / tempo_ds)

/datum/song/proc/set_instrument(datum/instrument/I)
	if(istext(I))
		I = SSinstruments.instrument_data[I]
	if(istype(I))
		if(istype(using_instrument))
			LAZYOR(using_instruments.songs_using, src)
		using_instrument = I
		LAZYOR(I.songs_using, src)
		return TRUE
	if(isnull(I))
		if(istype(using_instrument))
			LAZYREMOVE(using_instruments.songs_using, src)
		using_instrument = null
		cached_samples = null
		cached_legacy_ext = null
		cached_legacy_dir = null
		return TRUE
	return FALSE

/datum/song/proc/sanitize_tempo(new_tempo)
	return max(round(abs(new_tempo), world.tick_lag), world.tick_lag)

/datum/song/proc/stop_playing()
	hearing_mobs.Cut()
	playing = FALSE
	terminate_sound_all(TRUE)

/datum/song/proc/start_playing()
	set waitfor = FALSE
	if(!instrument || !instrument.ready())
		return FALSE
	playing = TRUE
	legacy = CHECK_BITFIELD(instrument.instrument_flags, INSTRUMENT_LEGACY)
	do_hearcheck(TRUE)
	play_lines()
	return TRUE

/datum/song/proc/do_hearcheck(force = FALSE)
	if(((world.time - GLOB.musician_hearcheck_mindelay) > last_hearcheck) || force)
		var/list/old = hearing_mobs.Copy()
		LAZYCLEARLIST(hearing_mobs)
		for(var/mob/M in hearers(15, source))
			if(!M.client || !(M.is_preference_enabled(/datum/client_preference/instrument_toggle)))
				continue
			LAZYSET(hearing_mobs, M, TRUE)
		var/list/diff = old - hearing_mobs
		for(var/i in diff)
			var/mob/M = i
			terminate_sound_mob(M)
		last_hearcheck = world.time

/datum/song/proc/play_lines()
	if(now_playing)
		CRASH("WARNING: datum/song attempted to play_lines while it was already now_playing!")
		return FALSE
	now_playing = TRUE
	START_PROCESSING(SSinstruments, src)
	legacy? do_play_lines_legacy() : do_play_lines_synth()
	now_playing = FALSE
	STOP_PROCESSING(SSinstruments, src)
	terminate_sound_all(TRUE)
	updateDialog()
	return TRUE

/datum/song/proc/should_stop_playing()
	return !playing || !using_instrument || QDELETED(parent)

/datum/song/proc/updateDialog(mob/user)
	parent?.updateDialog()		// assumes it's an object in world, override if otherwise

/datum/song/process(wait)
	if(!now_playing)
		return PROCESS_KILL
	process_decay()
