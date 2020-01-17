/datum/round_event_control/anomaly/anomaly_grav
	name = "Anomaly: Gravitational"
	typepath = /datum/round_event/anomaly/anomaly_grav
	max_occurrences = 5
	weight = 20
	gamemode_blacklist = list("dynamic")


/datum/round_event/anomaly/anomaly_grav
	startWhen = 3
	announceWhen = 20

/datum/round_event/anomaly/anomaly_grav/announce(fake)
	if(prob(90))
		priority_announce("Gravitational anomaly detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")
	else
		print_command_report("Gravitational anomaly detected on long range scanners. Expected location: [impact_area.name].", "Gravitational anomaly")

/datum/round_event/anomaly/anomaly_grav/start()
	var/turf/T = safepick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/grav(T)
