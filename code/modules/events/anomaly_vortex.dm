/datum/round_event_control/anomaly/anomaly_vortex
	name = "Anomaly: Vortex"
	typepath = /datum/round_event/anomaly/anomaly_vortex

	min_players = 20
	max_occurrences = 2
	weight = 5

/datum/round_event/anomaly/anomaly_vortex
	startWhen = 10
	announceWhen = 3

/datum/round_event/anomaly/anomaly_vortex/announce(fake)
	if(prob(90))
		priority_announce("Localized high-intensity vortex anomaly detected on long range scanners. Expected location: [impact_area.name]", "Anomaly Alert")
	else
		priority_announce("A report has been downloaded and printed out at all communications consoles.", "Incoming Classified Message", "commandreport") // CITADEL EDIT metabreak
		for(var/obj/machinery/computer/communications/C in GLOB.machines)
			if(!(C.stat & (BROKEN|NOPOWER)) && is_station_level(C.z))
				var/obj/item/paper/P = new(C.loc)
				P.name = "Vortex anomaly"
				P.info = "Localized high-intensity vortex anomaly detected on long range scanners. Expected location: [impact_area.name]."
				P.update_icon()

/datum/round_event/anomaly/anomaly_vortex/start()
	var/turf/T = safepick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/bhole(T)
