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

/datum/sabotage_objective/proc/can_run()
	return TRUE

/datum/sabotage_objective/processing
	var/won = FALSE

/datum/sabotage_objective/processing/New()
	..()
	START_PROCESSING(SSprocessing, src)

/datum/sabotage_objective/processing/proc/check_condition_processing()
	return 1

/datum/sabotage_objective/processing/process()
	check_condition_processing()
	if(won >= 1)
		STOP_PROCESSING(SSprocessing,src)

/datum/sabotage_objective/processing/check_conditions()
	return won

/datum/sabotage_objective/processing/power_sink
	name = "Drain at least 100 megajoules of power using a power sink."
	sabotage_type = "powersink"
	special_equipment = list(/obj/item/sbeacondrop/powersink)
	var/sink_found = FALSE
	var/count = 0

/datum/sabotage_objective/processing/power_sink/check_condition_processing()
	for(var/s in GLOB.power_sinks)
		var/obj/item/powersink/sink = s
		won = max(won,sink.power_drained/1e8)

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
	name = "Sabotage the supermatter so that it goes under 50% integrity. If it is delaminated, you will fail."
	sabotage_type = "supermatter"
	special_equipment = list(/obj/item/paper/guides/antag/supermatter_sabotage)
	var/list/supermatters = list()
	excludefromjob = list("Chief Engineer", "Station Engineer", "Atmospheric Technician")

/datum/sabotage_objective/processing/supermatter/check_condition_processing()
	if(!supermatters.len)
		supermatters = list()
		for(var/obj/machinery/power/supermatter_crystal/S in GLOB.machines)
			// Delaminating, not within coverage, not on a tile.
			if (!isturf(S.loc) || !(is_station_level(S.z) || is_mining_level(S.z)))
				continue
			supermatters.Add(S)
	for(var/obj/machinery/power/supermatter_crystal/S in supermatters) // you can win this with a wishgranter... lol.
		won = max(1-((S.get_integrity()-50)/50),won)
	return FALSE

/datum/sabotage_objective/processing/supermatter/can_run()
	return (locate(/obj/machinery/power/supermatter_crystal) in GLOB.machines)

/datum/sabotage_objective/station_integrity
	name = "Make sure the station is at less than 80% integrity by the end. Smash walls, windows etc. to reach this goal."
	sabotage_type = "integrity"

/datum/sabotage_objective/station_integrity/check_conditions()
	return 5-(max(SSticker.station_integrity*4,320)/80)

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
		if(aiPlayer.mind && length(aiPlayer.laws.hacked))
			return TRUE
	return FALSE
