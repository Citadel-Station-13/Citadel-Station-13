/**
 * Persists panic bunker whitelisting for a configured period of time
 */
/datum/controller/subsystem/persistence/LoadServerPersistence()
	. = ..()
	LoadPanicBunker()

/datum/controller/subsystem/persistence/SaveServerPersistence()
	. = ..()
	SavePanicBunker()

/datum/controller/subsystem/persistence/proc/LoadPanicBunker()
	var/bunker_path = file("data/bunker_passthrough.json")
	if(fexists(bunker_path))
		var/list/json = json_decode(file2text(bunker_path))
		GLOB.bunker_passthrough = json["data"]
		for(var/ckey in GLOB.bunker_passthrough)
			if(daysSince(GLOB.bunker_passthrough[ckey]) >= CONFIG_GET(number/max_bunker_days))
				GLOB.bunker_passthrough -= ckey

/datum/controller/subsystem/persistence/proc/SavePanicBunker()
	var/json_file = file("data/bunker_passthrough.json")
	var/list/file_data = list()
	file_data["data"] = GLOB.bunker_passthrough
	fdel(json_file)
	WRITE_FILE(json_file,json_encode(file_data))
