/*
 * This sound system was based off the sound.dm found in the public Goonstation release
 * https://github.com/goonstation/goonstation-2016/blob/d8a2d60915fd3b74653a1b7d4b8a0910c6fc2f19/code/sound.dm
 */

/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, surround = 1, frequency = null)

	var/area/source_area = get_area(source)
	var/turf/source_turf = get_turf(source)

	var/source_area_root

	if(source_area)
		source_area_root = get_top_ancestor(source_area, /area)

	var/sound/S = generate_sound(source, soundin, vol, vary, extrarange, frequency)

	if(S && source)
		for (var/P in player_list)
			var/mob/M = P
			if(!M || !M.client)
				continue
			var/turf/mob_loc = get_turf(M)
			if(!isnull(mob_loc) && M.client && source && mob_loc.z == source.z)
				var/area/listener_location = get_area(mob_loc)
				if(listener_location)
					var/listener_location_root = get_top_ancestor(listener_location, /area)
					if(listener_location_root != source_area_root && !(listener_location != /area && source_area != /area))
						continue
					if(source_area && source_area.sound_group && source_area.sound_group != listener_location.sound_group)
						continue
					if(listener_location != source_area)
						S.echo = list(0,0,0,0,0,0,-10000,1.0,1.5,1.0,0,1.0,0,0,0,0,1.0,7)
					else
						S.echo = list(0,0,0,0,0,0,0,0.25,1.5,1.0,0,1.0,0,0,0,0,1.0,7)

					var/pressure_factor = 1

					var/datum/gas_mixture/hearer_env = mob_loc.return_air()
					var/datum/gas_mixture/source_env = source_turf.return_air()

					if(hearer_env && source_env)
						var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
						if(pressure < ONE_ATMOSPHERE)
							pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
					else //space
						pressure_factor = 0

					var/distance = get_dist(mob_loc, source_turf)

					if(distance <= 1)
						pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

					S.volume *= pressure_factor

					if(isliving(M))
						var/mob/living/L = M
						if (L.hallucination)
							S.environment = SOUND_ENVIRONMENT_PSYCHOTIC
						else if (L.druggy)
							S.environment = SOUND_ENVIRONMENT_DRUGGED
						else if (L.drowsyness)
							S.environment = SOUND_ENVIRONMENT_DIZZY
						else if (L.confused)
							S.environment = SOUND_ENVIRONMENT_DIZZY
						else if (L.sleeping)
							S.environment = SOUND_ENVIRONMENT_UNDERWATER
						else if (pressure_factor < 0.5)
							S.environment = SOUND_ENVIRONMENT_UNDERWATER

					if(S.volume <= 0)
						return

				S.x = source.x - mob_loc.x
				S.z = source.y - mob_loc.y
				S.y = 0
				M << S
				S.volume = vol

/atom/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff, surround = 1)

	var/sound/S = generate_sound(turf_source, soundin, vol, vary, 0, frequency)
	S.volume = vol

	if (vary)
		S.frequency = rand(725, 1250) / 1000 * frequency
	else
		S.frequency = frequency

	if(isturf(turf_source))
		var/turf/T = get_turf(src)

		var/pressure_factor = 1
		var/datum/gas_mixture/hearer_env = T.return_air()
		var/datum/gas_mixture/source_env = turf_source.return_air()

		if(hearer_env && source_env)
			var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
			if(pressure < ONE_ATMOSPHERE)
				pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
		else
			pressure_factor = 0

		var/distance = get_dist(T, turf_source)
		if(distance <= 1)
			pressure_factor = max(pressure_factor, 0.15)

		S.volume *= pressure_factor

		if(S.volume <= 0)
			return

		var/dx = turf_source.x - src.x
		S.pan = max(-100, min(100, dx/8.0 * 100))

	src << S

/proc/generate_sound(var/atom/source, soundin, vol as num, vary, extrarange as num, frequency = 1)

	var/sound/S = get_sound(soundin)

	S.falloff = (world.view + extrarange) / 10
	S.wait = 0
	S.channel = 0
	S.volume = vol
	S.priority = 5
	S.environment = 0

	var/location = null

	if(source)
		location = source.loc

	if(location != null && isturf(location))
		var/turf/T = location
		location = T.loc

	if(location != null && isarea(location))
		var/area/A = location
		S.environment = A.sound_environment

	if (vary)
		S.frequency = rand(725, 1250) / 1000 * frequency
	else
		S.frequency = frequency

	return S

/mob/proc/stopLobbySound()
	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

/client/proc/playtitlemusic()
	if(!ticker || !ticker.login_music)
		return
	if(prefs && (prefs.toggles & SOUND_LOBBY))
		src << sound(ticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS

/mob/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff, surround = 1)
	if(!client || ear_deaf > 0)
		return
	..()

/proc/playsound_global(file, repeat=0, wait, channel, volume)
	for(var/V in clients)
		V << sound(file, repeat, wait, channel, volume)

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter")
				soundin = pick("sound/effects/Glassbr1.ogg","sound/effects/Glassbr2.ogg","sound/effects/Glassbr3.ogg")
			if ("explosion")
				soundin = pick("sound/effects/Explosion1.ogg","sound/effects/Explosion2.ogg")
			if ("sparks")
				soundin = pick("sound/effects/sparks1.ogg","sound/effects/sparks2.ogg","sound/effects/sparks3.ogg","sound/effects/sparks4.ogg")
			if ("rustle")
				soundin = pick("sound/effects/rustle1.ogg","sound/effects/rustle2.ogg","sound/effects/rustle3.ogg","sound/effects/rustle4.ogg","sound/effects/rustle5.ogg")
			if ("bodyfall")
				soundin = pick("sound/effects/bodyfall1.ogg","sound/effects/bodyfall2.ogg","sound/effects/bodyfall3.ogg","sound/effects/bodyfall4.ogg")
			if ("punch")
				soundin = pick("sound/weapons/punch1.ogg","sound/weapons/punch2.ogg","sound/weapons/punch3.ogg","sound/weapons/punch4.ogg")
			if ("clownstep")
				soundin = pick("sound/effects/clownstep1.ogg","sound/effects/clownstep2.ogg")
			if ("swing_hit")
				soundin = pick("sound/weapons/genhit1.ogg", "sound/weapons/genhit2.ogg", "sound/weapons/genhit3.ogg")
			if ("hiss")
				soundin = pick("sound/voice/hiss1.ogg","sound/voice/hiss2.ogg","sound/voice/hiss3.ogg","sound/voice/hiss4.ogg")
			if ("pageturn")
				soundin = pick("sound/effects/pageturn1.ogg", "sound/effects/pageturn2.ogg","sound/effects/pageturn3.ogg")
			if ("gunshot")
				soundin = pick("sound/weapons/Gunshot.ogg", "sound/weapons/Gunshot2.ogg","sound/weapons/Gunshot3.ogg","sound/weapons/Gunshot4.ogg")
			if ("ricochet")
				soundin = pick(	"sound/weapons/effects/ric1.ogg", "sound/weapons/effects/ric2.ogg","sound/weapons/effects/ric3.ogg","sound/weapons/effects/ric4.ogg","sound/weapons/effects/ric5.ogg")
			if ("terminal_type")
				soundin = pick("sound/machines/terminal_button01.ogg", "sound/machines/terminal_button02.ogg", "sound/machines/terminal_button03.ogg", \
								"sound/machines/terminal_button04.ogg", "sound/machines/terminal_button05.ogg", "sound/machines/terminal_button06.ogg", \
								"sound/machines/terminal_button07.ogg", "sound/machines/terminal_button08.ogg")
	return soundin

/proc/get_rand_frequency()
	return rand(32000, 55000)

/proc/get_sound(soundin)

	if(islist(soundin))
		soundin = pick(soundin)
	else
		soundin = get_sfx(soundin)

	var/sound/S

	if(istext(soundin))
		S = new /sound
		S.file = csound(soundin)
	else if (isfile(soundin))
		S = new /sound
		S.file = soundin
	else if (istype(soundin, /sound))
		S = soundin

	return S

/proc/csound(var/name)
	return sound_cache[name]

/proc/get_top_ancestor(var/datum/object, var/ancestor_of_ancestor=/datum)
	if(!object || !ancestor_of_ancestor)
		CRASH("Null value parameters in get top ancestor.")
	if(!ispath(ancestor_of_ancestor))
		CRASH("Non-Path ancestor of ancestor parameter supplied.")
	var/stringancestor = "[ancestor_of_ancestor]"
	var/stringtype = "[object.type]"
	var/ancestorposition = findtextEx(stringtype, stringancestor)
	if(!ancestorposition)
		return null
	var/parentstart = ancestorposition + length(stringancestor) + 1
	var/parentend = findtextEx(stringtype, "/", parentstart)
	var/stringtarget = copytext(stringtype, 1, parentend ? parentend : 0)
	return text2path(stringtarget)