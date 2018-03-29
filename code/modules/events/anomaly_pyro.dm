/datum/round_event_control/anomaly/anomaly_pyro
	name = "Anomaly: Pyroclastic"
	typepath = /datum/round_event/anomaly/anomaly_pyro
	max_occurrences = 5
	weight = 20

/datum/round_event/anomaly/anomaly_pyro
	startWhen = 3
	announceWhen = 10

/datum/round_event/anomaly/anomaly_pyro/announce(fake)
	if(prob(90))
		priority_announce("Pyroclastic anomaly detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")
	else
		priority_announce("A report has been downloaded and printed out at all communications consoles.", "Incoming Classified Message", 'sound/ai/commandreport.ogg') // CITADEL EDIT metabreak
		for(var/obj/machinery/computer/communications/C in GLOB.machines)
			if(!(C.stat & (BROKEN|NOPOWER)) && is_station_level(C.z))
				var/obj/item/paper/P = new(C.loc)
				P.name = "Pyroclastic anomaly"
				P.info = "Pyroclastic anomaly detected on long range scanners. Expected location: [impact_area.name]."
				P.update_icon()

/datum/round_event/anomaly/anomaly_pyro/start()
	var/turf/T = safepick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/pyro(T)
