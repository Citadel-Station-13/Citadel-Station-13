/datum/round_event_control/anomaly/anomaly_flux
	name = "Anomaly: Hyper-Energetic Flux"
	typepath = /datum/round_event/anomaly/anomaly_flux

	min_players = 10
	max_occurrences = 5
	weight = 20

/datum/round_event/anomaly/anomaly_flux
	startWhen = 10
	announceWhen = 3

/datum/round_event/anomaly/anomaly_flux/announce(fake)
	if(prob(90))
		priority_announce("Localized hyper-energetic flux wave detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")
	else
		priority_announce("A report has been downloaded and printed out at all communications consoles.", "Incoming Classified Message", "commandreport") // CITADEL EDIT metabreak
		for(var/obj/machinery/computer/communications/C in GLOB.machines)
			if(!(C.stat & (BROKEN|NOPOWER)) && is_station_level(C.z))
				var/obj/item/paper/P = new(C.loc)
				P.name = "Localized hyper-energetic flux wave"
				P.info = "Localized hyper-energetic flux wave detected on long range scanners. Expected location: [impact_area.name]."
				P.update_icon()

/datum/round_event/anomaly/anomaly_flux/start()
	var/turf/T = safepick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/flux(T)
