//As a brief warning to all those who dare tread upon these grounds:
//The bulk of this code here was written years ago, back in the days of 512.
//We were incredibly drunk back then. And nowadays, we've found that being drunk is a hard requirement for working with this code.
//So if you're here to make changes? Brandish a glass. There are many sins here, but it's exactly as engineered as it needs to be.
//We physically won't be able to tell you what half of this code does. The only thing that'll help you here is the ballmer peak.
//Bottoms up, friend. And be sure to drink responsibly. Be sure to fetch some water, too; it eases the hangover. - Bhijn & Myr


// Jukelist indices
#define JUKE_TRACK 1
#define JUKE_CHANNEL 2
#define JUKE_BOX 3
#define JUKE_FALLOFF 4
#define JUKE_SOUND 5

// Track data
/// Name of the track
#define TRACK_NAME 1
/// Length of the track (in deciseconds)
#define TRACK_LENGTH 2
/// BPM of the track (in deciseconds)
#define TRACK_BEAT 3
/// Unique code-facing identifier for this track
#define TRACK_ID 4


SUBSYSTEM_DEF(jukeboxes)
	name = "Jukeboxes"
	wait = 5
	var/list/songs = list()
	var/list/activejukeboxes = list()
	var/list/freejukeboxchannels = list()

/datum/track
	var/song_name = "generic"
	var/song_path = null
	var/song_length = 0
	var/song_beat = 0
	var/song_associated_id = null

/datum/track/New(name, path, length, beat, assocID)
	song_name = name
	song_path = path
	song_length = length
	song_beat = beat
	song_associated_id = assocID

/datum/controller/subsystem/jukeboxes/proc/addjukebox(obj/jukebox, datum/track/T, jukefalloff = 1)
	if(!istype(T))
		CRASH("[src] tried to play a song with a nonexistant track")
	var/channeltoreserve = pick(freejukeboxchannels)
	if(!channeltoreserve)
		return FALSE
	var/sound/song_to_init = sound(T.song_path)
	freejukeboxchannels -= channeltoreserve
	var/list/youvegotafreejukebox = list(T, channeltoreserve, jukebox, jukefalloff, song_to_init)

	song_to_init.status = SOUND_MUTE
	song_to_init.environment = 7
	song_to_init.channel = channeltoreserve
	song_to_init.volume = 1
	song_to_init.falloff = jukefalloff
	song_to_init.echo = list(0, null, -10000, null, null, null, null, null, null, null, null, null, null, 1, 1, 1, null, null)

	activejukeboxes.len++
	activejukeboxes[activejukeboxes.len] = youvegotafreejukebox

	for(var/mob/M in GLOB.player_list)
		if(!M.client)
			continue
		if(!(M.client.prefs.toggles & SOUND_INSTRUMENTS))
			continue

		SEND_SOUND(M, song_to_init)
	return activejukeboxes.len


//Updates jukebox by transferring to different object or modifying falloff.
/datum/controller/subsystem/jukeboxes/proc/updatejukebox(IDtoupdate, obj/jukebox, jukefalloff)
	if(islist(activejukeboxes[IDtoupdate]))
		if(istype(jukebox))
			activejukeboxes[IDtoupdate][JUKE_BOX] = jukebox
		if(!isnull(jukefalloff))
			activejukeboxes[IDtoupdate][JUKE_FALLOFF] = jukefalloff

/datum/controller/subsystem/jukeboxes/proc/removejukebox(IDtoremove)
	if(islist(activejukeboxes[IDtoremove]))
		var/jukechannel = activejukeboxes[IDtoremove][JUKE_CHANNEL]
		for(var/mob/M in GLOB.player_list)
			if(!M.client)
				continue
			M.stop_sound_channel(jukechannel)
		freejukeboxchannels |= jukechannel
		activejukeboxes.Cut(IDtoremove, IDtoremove+1)
		return TRUE
	else
		CRASH("Tried to remove jukebox with invalid ID")

/datum/controller/subsystem/jukeboxes/proc/findjukeboxindex(obj/jukebox)
	if(activejukeboxes.len)
		for(var/list/jukeinfo in activejukeboxes)
			if(jukebox in jukeinfo)
				return activejukeboxes.Find(jukeinfo)
	return FALSE

/datum/controller/subsystem/jukeboxes/Initialize()
	init_channels()

	var/list/tracks = flist("config/jukebox_music/sounds/")
	for(var/track in tracks)
		var/datum/track/track_datum = add_track(track)
		if(!track_datum)
			continue
		songs |= track_datum

	return ..()

/// Creates audio channels for jukeboxes to use, run first to prevent init failing to fill this
/datum/controller/subsystem/jukeboxes/proc/init_channels()
	for(var/i in CHANNEL_JUKEBOX_START to CHANNEL_JUKEBOX)
		freejukeboxchannels |= i

/datum/controller/subsystem/jukeboxes/proc/add_track(track)
	var/datum/track/track_datum = new()
	track_datum.song_path = file("config/jukebox_music/sounds/[track]")

	var/list/track_data = splittext(track,"+")
	if(!LAZYLEN(track_data))
		stack_trace("Invalid track: [track]")
		return FALSE
	var/track_name = LAZYACCESS(track_data, TRACK_NAME)
	if(!track_name)
		stack_trace("Track [track] lacks name???")
		return FALSE
	track_datum.song_name = track_name
	var/track_length = LAZYACCESS(track_data, TRACK_LENGTH)
	if(!track_length)
		stack_trace("Track [track] lacks length.")
		return FALSE
	track_length = text2num(track_length)
	if(!isnum(track_length))
		stack_trace("Track [track]'s length value is not a number")
		return FALSE
	track_datum.song_length = track_length
	var/track_beat = LAZYACCESS(track_data, TRACK_BEAT)
	if(!track_beat)
		stack_trace("Track [track] lacks BPM.")
		return FALSE
	track_beat = text2num(track_beat)
	if(!isnum(track_beat))
		stack_trace("Track [track]'s beat value is not a number")
		return FALSE
	track_datum.song_beat = track_beat
	var/track_id = LAZYACCESS(track_data, TRACK_ID)
	if(!track_id)
		stack_trace("Track [track] lacks an unique identifier.")
		return FALSE
	track_datum.song_associated_id = track_id
	return track_datum


/datum/controller/subsystem/jukeboxes/fire()
	if(!activejukeboxes.len)
		return
	for(var/list/jukeinfo in activejukeboxes)
		if(!jukeinfo.len)
			stack_trace("Active jukebox without any associated metadata.")
			continue
		var/datum/track/juketrack = jukeinfo[JUKE_TRACK]
		if(!istype(juketrack))
			stack_trace("Invalid jukebox track datum.")
			continue
		var/obj/jukebox = jukeinfo[JUKE_BOX]
		if(!istype(jukebox))
			stack_trace("Nonexistant or invalid object associated with jukebox.")
			continue

		var/list/audible_zlevels = get_multiz_accessible_levels(jukebox.z) //TODO - for multiz refresh, this should use the cached zlevel connections var in SSMapping. For now this is fine!

		var/sound/song_played = jukeinfo[JUKE_SOUND]
		var/turf/currentturf = get_turf(jukebox)
		var/area/currentarea = get_area(jukebox)
		var/list/hearerscache = hearers(7, jukebox)
		var/targetfalloff = jukeinfo[JUKE_FALLOFF]
		var/mixes = ((targetfalloff*250)-750)
		var/inrange
		var/pressure_factor


		var/datum/gas_mixture/source_env = (istype(currentturf) ? currentturf.return_air() : null)
		var/datum/gas_mixture/hearer_env //We init this var outside of the mob loop for the sake of performance
		var/turf/hearerturf //ditto

		var/source_pressure = (istype(source_env) ? source_env.return_pressure() : 0)

		song_played.falloff = targetfalloff
		song_played.volume = min((targetfalloff * 50), 100)

		for(var/mob/M in GLOB.player_list)
			if(!M.client)
				continue
			if(!(M.client.prefs.toggles & SOUND_INSTRUMENTS))
				M.stop_sound_channel(jukeinfo[JUKE_CHANNEL])
				continue

			inrange = FALSE
			song_played.status = SOUND_MUTE | SOUND_UPDATE

			if(source_pressure)
				hearerturf = get_turf(M)
				hearer_env = (istype(hearerturf) ? hearerturf.return_air() : null)
				if(istype(hearer_env))
					pressure_factor = min(source_pressure, hearer_env.return_pressure())

				if(pressure_factor && targetfalloff && M.can_hear() && (hearerturf.z in audible_zlevels))
					if(get_area(hearerturf) == currentarea)
						inrange = TRUE
					else if(M in hearerscache)
						inrange = TRUE

					song_played.x = (currentturf.x - hearerturf.x) * SOUND_DEFAULT_DISTANCE_MULTIPLIER
					song_played.z = (currentturf.y - hearerturf.y) * SOUND_DEFAULT_DISTANCE_MULTIPLIER
					song_played.y = (((currentturf.z - hearerturf.z) * 10 * SOUND_DEFAULT_DISTANCE_MULTIPLIER) + ((currentturf.z < hearerturf.z) ? -5 : 5))

					if(pressure_factor < ONE_ATMOSPHERE)
						song_played.volume = (min((targetfalloff * 50), 100) * max((pressure_factor - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 1))

					song_played.echo[1] = (inrange ? 0 : -10000)
					song_played.echo[3] = (inrange ? mixes : max(mixes, 0))
					song_played.status = SOUND_UPDATE
			SEND_SOUND(M, song_played)
			CHECK_TICK
	return

#undef TRACK_NAME
#undef TRACK_LENGTH
#undef TRACK_BEAT
#undef TRACK_ID

#undef JUKE_TRACK
#undef JUKE_CHANNEL
#undef JUKE_BOX
#undef JUKE_FALLOFF
#undef JUKE_SOUND
