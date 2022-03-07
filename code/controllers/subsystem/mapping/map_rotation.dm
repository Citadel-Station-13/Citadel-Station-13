/datum/controller/subsystem/mapping
	/// next map datum - only set via SetNextMap, as GetNextMap can be called roundstart before rotation happens
	var/datum/map_config/station/next_map

/datum/controller/subsystem/mapping/proc/MapRotate()
	var/players = GLOB.clients.len
	var/list/mapvotes = list()
	var/list/possible = config.GetMapIDs()
	//count votes
	var/amv = CONFIG_GET(flag/allow_map_voting)
	if(amv)
		for (var/client/c in GLOB.clients)
			var/vote = c.prefs.preferred_map
			if (!vote || !(vote in possible))
				if (global.config.default_map)
					mapvotes[global.config.default_map] += 1
				continue
			mapvotes[vote] += 1
	else
		for(var/M in global.config.map_data)
			mapvotes[M] = 1

	//filter votes
	for (var/map in mapvotes)
		if (!map)
			subsystem_log("Removing null from mapvotes")
			mapvotes.Remove(map)
			continue
		if (!(map in global.config.map_data))
			subsystem_log("Removing invalid map id [map] from mapvotes")
			mapvotes.Remove(map)
			continue
		var/datum/map_settings/VM = global.config.GetMapSettings(map)
		if (!VM || VM.disabled || !VM.rotation)
			mapvotes.Remove(map)
			continue
		if (VM.voteweight <= 0)
			mapvotes.Remove(map)
			continue
		if (VM.minplayers > 0 && players < VM.minplayers)
			mapvotes.Remove(map)
			continue
		if (VM.maxplayers > 0 && players > VM.maxplayers)
			mapvotes.Remove(map)
			continue
		if(amv)
			mapvotes[map] = mapvotes[map]*VM.voteweight

	var/pickedmap = pickweight(mapvotes)
	if (!pickedmap)
		message_admins("Failed to MapRotate() - no maps.")
		subsystem_log("Failed to rotate maps due to no maps.")
		return
	var/datum/map_config/station/VM = map_datums[pickedmap]
	if(!VM)
		subsystem_log("MapRotate failed to locate map ID [pickedmap]. Exiting.")
		message_admins("WARNING: Failed to proc map rotation due to [pickedmap] being missing from map datums.")
		return
	message_admins("Randomly rotating map to [VM.name]")
	subsystem_log("Rotating map to [pickedmap].")
	. = SetNextMap(pickedmap)
	if (. && VM.name != src.map.name)
		to_chat(world, "<span class='boldannounce'>Map rotation has chosen [VM.name] for next round!</span>")

/datum/controller/subsystem/mapping/proc/SetNextMap(id, force = FALSE)
	if(!map_datums)
		InitMapDatums()
	if(!force && !map_datums[id])
		stack_trace("Failed to locate [id] in map datums.")
		return FALSE
	var/list/json_list = list()
	json_list["id"] = id
	if(fexists("data/next_map.json"))
		fdel("data/next_map.json")
	text2file(safe_json_encode(json_list), "data/next_map.json")
	next_map = map_datums[id]
	stat_map_name = "[map.name] (Next: [next_map.name])"
	return TRUE

/datum/controller/subsystem/mapping/proc/GetNextMap()
	if(!map_datums)
		InitMapDatums()
	if(next_map)
		return next_map.id
	var/list/json_list = safe_json_decode(file2text(file("data/next_map.json")))
	if(!json_list)
		return pick(map_datums)
	. = json_list["id"]
	if(!config.map_data[.] || config.map_data[.].disabled)
		. = config.default_map
