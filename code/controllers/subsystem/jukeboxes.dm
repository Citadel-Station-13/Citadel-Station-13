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
	freejukeboxchannels -= channeltoreserve
	var/list/youvegotafreejukebox = list(T, channeltoreserve, jukebox, jukefalloff)
	activejukeboxes.len++
	activejukeboxes[activejukeboxes.len] = youvegotafreejukebox

	//Due to changes in later versions of 512, SOUND_UPDATE no longer properly plays audio when a file is defined in the sound datum. As such, we are now required to init the audio before we can actually do anything with it.
	//Downsides to this? This means that you can *only* hear the jukebox audio if you were present on the server when it started playing, and it means that it's now impossible to add loops to the jukebox track list.
	var/sound/song_to_init = sound(T.song_path)
	song_to_init.status = SOUND_MUTE
	for(var/mob/M in GLOB.player_list)
		if(!M.client)
			continue
		if(!(M.client.prefs.toggles & SOUND_INSTRUMENTS))
			continue

		M.playsound_local(M, null, 100, channel = youvegotafreejukebox[JUKE_CHANNEL], S = song_to_init)
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
	var/list/tracks = flist("config/jukebox_music/sounds/")
	for(var/S in tracks)
		var/datum/track/T = new()
		T.song_path = file("config/jukebox_music/sounds/[S]")
		var/list/L = splittext(S,"+")
		T.song_name = L[1]
		T.song_length = text2num(L[2])
		T.song_beat = text2num(L[3])
		T.song_associated_id = L[4]
		songs |= T
	for(var/i in CHANNEL_JUKEBOX_START to CHANNEL_JUKEBOX)
		freejukeboxchannels |= i
	return ..()

/datum/controller/subsystem/jukeboxes/fire()
	if(!activejukeboxes.len)
		return
	for(var/list/jukeinfo in activejukeboxes)
		if(!jukeinfo.len)
			stack_trace("Active jukebox without any associated metadata.")
			continue
		var/datum/track/juketrack = jukeinfo[1]
		if(!istype(juketrack))
			stack_trace("Invalid jukebox track datum.")
			continue
		var/obj/jukebox = jukeinfo[3]
		if(!istype(jukebox))
			stack_trace("Nonexistant or invalid object associated with jukebox.")
			continue

		var/list/audible_zlevels = get_multiz_accessible_levels(jukebox.z) //TODO - for multiz refresh, this should use the cached zlevel connections var in SSMapping. For now this is fine!

		var/sound/song_played = sound(juketrack.song_path)
		var/turf/currentturf = get_turf(jukebox)
		var/area/currentarea = get_area(jukebox)
		var/list/hearerscache = hearers(7, jukebox)
		var/targetfalloff = jukeinfo[JUKE_FALLOFF]
		var/mixes = ((targetfalloff*250)-750)
		var/inrange

		for(var/mob/M in GLOB.player_list)
			if(!M.client)
				continue
			if(!(M.client.prefs.toggles & SOUND_INSTRUMENTS))
				M.stop_sound_channel(jukeinfo[JUKE_CHANNEL])
				continue

			inrange = FALSE
			if(targetfalloff && M.can_hear() && (M.z in audible_zlevels))
				if(get_area(M) == currentarea)
					inrange = TRUE
				else if(M in hearerscache)
					inrange = TRUE
				song_played.status = SOUND_UPDATE
			else
				song_played.status = SOUND_MUTE | SOUND_UPDATE
			song_played.falloff = (inrange ? targetfalloff : targetfalloff * targetfalloff) //The wet channel uses a sqrt falloff by default. Exponentially increasing the falloff when muffled cancels out that sqrt falloff
			M.playsound_local(currentturf, null, (targetfalloff ? min((targetfalloff * 50), 100) : 1), channel = jukeinfo[JUKE_CHANNEL], S = song_played, envwet = ((inrange) ? mixes : max(mixes, 0)), envdry = (inrange ? max(mixes, 0) : -10000))
			CHECK_TICK
	return

#undef JUKE_TRACK
#undef JUKE_CHANNEL
#undef JUKE_BOX
#undef JUKE_FALLOFF
