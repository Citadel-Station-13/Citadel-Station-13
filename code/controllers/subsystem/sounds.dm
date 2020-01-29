SUBSYSTEM_DEF(sounds)
	name = "sounds"
	flags = SS_NO_FIRE
	var/static/sound_channels_max = 1024		//BYOND max channels
	var/list/sound_channels						//Assoc list of sound channels. "[channel]" = datum_using_or_TRUE
	var/list/sound_channels_by_datum			//assoc list : datum = list(channel1, channel2)
	var/datum/stack/channel_stack				//Uses a stack for super-fast channel allocation.

/datum/controller/subsystem/sounds/Initialize()
	sound_channels = list()
	build_stack(CHANNEL_HIGHEST_AVAILABLE)

/datum/controller/subsystem/sounds/proc/build_stack(number)
	channel_stack = new
	channel_stack.max_elements = number
	for(var/i in 1 to number)
		channel_stack.Push("[i]")

/datum/controller/subsystem/sounds/proc/free_sound_channel(channel)
	channel = "[channel]"
	if(!sound_channels.Find(channel))
		return
	var/using = sound_channels[channel]
	sound_channels -= channel
	if(sound_channels_by_datum[using])
		sound_channels_by_datum[using] -= channel
		if(!length(sound_channels_by_datum[using]))
			sound_channels_by_datum -= using
	channel_stack.Push(channel)

/datum/controller/subsystem/sounds/proc/free_datumless_channels()
	free_sound_channel_datum("NO_DATUM")

/datum/controller/subsystem/sounds/proc/free_sound_channel_datum(datum/D)
	var/list/L = sound_channels_by_datum[D]
	if(istype(L))
		for(var/i in L)
			free_sound_channel(i)
	sound_channels_by_datum -= D

//Don't use this unless ABSOLUTELY necessary!
/datum/controller/subsystem/sounds/proc/reserve_sound_channel_unsafe()
	var/channel = "[get_available_channel()]"
	if(!channel)
		return FALSE
	sound_channels[channel] = "NO_DATUM"
	LAZYINITLIST(sound_channels_by_datum["NO_DATUM"])
	sound_channels_by_datum["NO_DATUM"] += channel
	return channel

/datum/controller/subsystem/sounds/proc/reserve_sound_channel(datum/D)
	if(!istype(D))
		return FALSE
	var/channel = "[channel_stack.Pop]"
	if(!channel)
		return FALSE
	sound_channels["[channel]"] = D
	LAZYINITLIST(sound_channels_by_datum[D])
	sound_channels_by_datum[D] += channel
	return channel

/datum/controller/subsystem/sounds/proc/get_available_channel()
	return pick(sound_stack.stack)
