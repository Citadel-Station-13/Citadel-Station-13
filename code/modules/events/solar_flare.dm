/datum/round_event_control/solar_flare
	name = "Solar Flare"
	typepath = /datum/round_event/solar_flare
	max_occurrences = 1

/datum/round_event/solar_flare

/datum/round_event/solar_flare/setup()
	startWhen = 3
	endWhen = startWhen + 1
	announceWhen	= 1

/datum/round_event/solar_flare/announce()
	priority_announce("Incoming solar flare detected near the station. Expect power outages in all exposed areas for a short duration.", "Anomaly Alert", 'sound/effects/alert.ogg')
	//sound not longer matches the text, but an audible warning is probably good

/datum/round_event/solar_flare/start()
	SSweather.run_weather("solar flare",1)
