/datum/sabotage_objective
	var/name = "Free Objective"
	var/sabotage_type = "nothing"
	var/special_equipment = list()
	var/list/excludefromjob = list()

/datum/sabotage_objective/New()
	..()
	if(sabotage_type!="nothing")
		GLOB.possible_sabotages += src

/datum/sabotage_objective/proc/check_conditions()
	return TRUE

/datum/sabotage_objective/processing
	var/won = FALSE

/datum/sabotage_objective/processing/New()
	..()
	START_PROCESSING(SSprocessing, src)

/datum/sabotage_objective/processing/proc/check_condition_processing()
	return TRUE

/datum/sabotage_objective/processing/process()
	won = check_condition_processing()
	if(won)
		STOP_PROCESSING(SSprocessing,src)

/datum/sabotage_objective/processing/power_sink
	name = "Drain at least 1 gigajoule of power using a power sink."
	sabotage_type = "powersink"
	special_equipment = list(/obj/item/powersink)
	var/sink_found = FALSE
	var/count = 0

/datum/sabotage_objective/processing/power_sink/check_condition_processing()
	count += 1
	if(count==10 || sink_found) // doesn't need to fire that often unless a sink exists
		var/sink_found_this_time = FALSE
		for(var/datum/powernet/PN in GLOB.powernets)
			for(var/obj/powersink/sink in PN.nodes)
				sink_found_this_time = TRUE
				if(sink.power_drained>1e9)
					return TRUE
		sink_found = sink_found_this_time
		count = 0
	return FALSE

/obj/item/paper/guides/antag/supermatter_sabotage
	info = "Ways to sabotage a supermatter:<br>\
	<ul>\
	<li>Set the air alarm's operating mode to anything that isn't 'draught' (yes, anything, though 'off' works best). Or just smash the air alarm, that works too.</li>\
	<li>Wrench a pipe (the junction to the cold loop is most effective, but some setups will robust through this no issue; best to try for multiple)</li>\
	<li>Pump in as much carbon dioxide, oxygen, plasma or tritium as you can find (this will likely also cause a singularity or tesla delamination, so watch out!)</li>\
	<li>Unset the filters on the cooling loop, or, perhaps more insidious, set them to oxygen/plasma.</li>\
	<li>Deactivate the digital valve that sends the exhaust gases to space (note: only works on box station; others you must unwrench).</li>\
	<li>There are many other ways; be creative!</li>\
	</ul>"

/datum/sabotage_objective/processing/supermatter
	name = "Sabotage the supermatter so that it goes under 50% integrity."
	sabotage_type = "supermatter"
	special_equipement = list(/obj/item/paper/guides/antag/supermatter_sabotage)
	var/supermatters = list()
	excludefromjob = list("Chief Engineer", "Station Engineer", "Atmospheric Technician")

/datum/sabotage_objective/processing/supermatter/check_condition_processing()
	if(!supermatters.len)
		supermatters = list()
		for(var/obj/machinery/power/supermatter_crystal/S in GLOB.machines)
			// Delaminating, not within coverage, not on a tile.
			if (!isturf(S.loc) || !(is_station_level(S.z) || is_mining_level(S.z)))
				continue
			supermatters.Add(S)

		if(!(active in supermatters))
			active = null
	for(var/obj/machinery/power/supermatter_crystal/S in supermatters)
		if(S.integrity < 50)
			return TRUE
	return FALSE

/datum/sabotage_objective/station_integrity
	name = "Make sure the station is at less than 80% integrity by the end. Smash walls, windows etc. to reach this goal."
	sabotage_type = "integrity"

/datum/sabotage_objective/station_integrity/check_conditions()
	return SSticker.station_integrity < 80

/datum/sabotage_objective/cloner
	name = "Destroy all Nanotrasen cloning machines."
	sabotage_type = "cloner"

/datum/sabotage_objective/cloner/check_conditions()
	return !(locate(/obj/machinery/clonepod) in GLOB.machines)

/datum/sabotage_objective/ai_law
	name = "Upload a hacked law to the AI."
	sabotage_type = "ailaw"
	special_equipment = list(/obj/item/aiModule/syndicate)
	excludefromjob = list("Chief Engineer","Research Director","Head of Personnel","Captain","Chief Medical Officer","Head Of Security")

/datum/sabotage_objective/ai_law/check_conditions()
	for (var/i in GLOB.ai_list)
		var/mob/living/silicon/ai/aiPlayer = i
		if(aiPlayer.mind && aiPlayer.laws.hacked.len)
			return TRUE
	return FALSE
