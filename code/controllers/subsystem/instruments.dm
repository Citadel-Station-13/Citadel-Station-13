SUBSYSTEM_DEF(SSinstruments)
	name = "Instruments"
	wait = 1
	flags = SS_TICKER
	priority = FIRE_PRIORITY_INSTRUMENTS
	var/static/list/datum/instrument/instrument_data = list()		//id = datum
	var/static/list/datum/song/songs = list()
	var/list/datum/song/processing = list()
	var/static/musician_maxlines = 600
	var/static/musician_maxlinechars = 200
	var/static/musician_hearcheck_mindelay = 5

/datum/controller/subsystem/instruments/Initialize()
	initialize_instrument_data()

/datum/controller/subsystem/instruments/proc/on_song_new(datum/song/S)
	songs += S

/datum/controller/subsystem/instruments/proc/on_song_del(datum/song/S)
	songs -= S

/datum/controller/subsystem/instruments/proc/initialize_instrument_data()
	for(var/path in subtypesof(/datum/instrument))
		var/datum/instrument/I = path
		if(initial(I.abstract_type) == path)
			continue
		if(!istext(initial(I.id)))
			continue
		if(instrument_data[initial(I.id)])
			crash_with("Skipping duplicate instrument ID [initial(I.id)]")
			continue
		I = new
		instrument_data[I.id] = I
	for(var/id in instrument_data)
		var/datum/instrument/I = instrument_data[id]
		I.Initialize()
		CHECK_TICK

/datum/controller/subsystem/instruments/fire()
	var/delay = world.time - last_fire
	for(var/i in processing)
		var/datum/song/S = i
		if(S.process(delay) == PROCESS_KILL)
			processing -= S
