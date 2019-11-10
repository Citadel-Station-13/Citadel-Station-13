/datum/round_event_control/anomaly/anomaly_bluespace
	name = "Anomaly: Bluespace"
	typepath = /datum/round_event/anomaly/anomaly_bluespace
	max_occurrences = 1
	weight = 5

/datum/round_event/anomaly/anomaly_bluespace
	startWhen = 3
	announceWhen = 10


/datum/round_event/anomaly/anomaly_bluespace/announce(fake)
	if(prob(90))
		priority_announce("Unstable bluespace anomaly detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")
	else
		priority_announce("A report has been downloaded and printed out at all communications consoles.", "Incoming Classified Message", "commandreport") // CITADEL EDIT metabreak
		for(var/obj/machinery/computer/communications/C in GLOB.machines)
			if(!(C.stat & (BROKEN|NOPOWER)) && is_station_level(C.z))
				var/obj/item/paper/P = new(C.loc)
				P.name = "Unstable bluespace anomaly"
				P.info = "Unstable bluespace anomaly detected on long range scanners. Expected location: [impact_area.name]."
				P.update_icon()

/datum/round_event/anomaly/anomaly_bluespace/start()
	var/turf/T = safepick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/bluespace(T)
