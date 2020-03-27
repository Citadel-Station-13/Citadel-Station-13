/datum/round_event_control/anomaly/anomaly_flux
	name = "Anomaly: Hyper-Energetic Flux"
	typepath = /datum/round_event/anomaly/anomaly_flux

	min_players = 10
	max_occurrences = 5
	weight = 20
	gamemode_blacklist = list("dynamic")

/datum/round_event/anomaly/anomaly_flux
	startWhen = 10
	announceWhen = 3

/datum/round_event/anomaly/anomaly_flux/announce(fake)
	if(prob(90))
		priority_announce("Localized hyper-energetic flux wave detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")
	else
		print_command_report("Localized hyper-energetic flux wave detected on long range scanners. Expected location: [impact_area.name].","Localized hyper-energetic flux wave")

/datum/round_event/anomaly/anomaly_flux/start()
	var/turf/T = safepick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/flux(T)
