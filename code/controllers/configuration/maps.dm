/datum/controller/configuration
	/// loaded map data, keyed by id and associated to a /datum/map_settings
	var/list/datum/map_settings/map_data
	/// allowed away missions
	var/list/away_data
	/// allowed vr missions
	var/list/vr_data

	/// id of default map
	var/default_map

/**
 * Gets currently configured map IDs
 */
/datum/controller/configuration/proc/GetMapIDs()
	. = list()
	for(var/i in map_data)
		. += i

/**
 * Gets the settings for a map ID
 */
/datum/controller/configuration/proc/GetMapSettings(id)
	RETURN_TYPE(/datum/map_settings)
	return map_data[id]

/datum/controller/configuration/proc/LoadAwayConfig(filename)
	away_data = ParseSimpleMapList(filename)

/datum/controller/configuration/proc/LoadVRConfig(filename)
	vr_data = ParseSimpleMapList(filename)

/**
 * All this proc does is filter out comment lines beginning with #
 * Also, lines are trimmed
 * Anything else goes
 */
/datum/controller/configuration/proc/ParseSimpleMapList(filename, lowertext = TRUE, allow_spaces = FALSE)
	log_config("Parsing simple map list [filename]...")
	. = list()
	var/list/lines = world.file2list(filename)
	if(!lines.len)
		return
	for(var/line in lines)
		line = trim(line)
		if(!length_char(line) || (line[1] == "#"))
			continue
		if(lowertext)
			line = lowertext(line)
		if(!allow_spaces)
			line = replacetext_char(line, " ", "")
		. += line

/datum/controller/configuration/proc/LoadMapConfig(filename, wipe = TRUE)
	if(wipe)
		QDEL_LIST(map_data)
		map_data = list()
		default_map = null
	log_config("Loading map config [filename]...")
	var/list/lines = world.file2list(filename)
	var/datum/map_settings/current
	for(var/line in lines)
		line = trim(line)
		if(!length_char(line) || line[1] == "#")
			continue
		var/pos = findtext_char(line, " ")
		var/command = pos? lowertext(copytext_char(line, 1, pos)) : line
		var/data = pos? copytext_char(line, pos + 1) : null
		if(!command)
			continue
		if(!current && (command != "map"))
			continue
		switch(command)
			if("map")
				if(map_data[data])
					log_config("ignoring duplicate map id [data].")
					continue
				current = new
				current.map_id = data
			if("endmap")
				map_data[current.map_id] = current
				current = null
			if("minplayers", "minplayer")
				current.minplayers = text2num(data)
			if("maxplayers", "maxplayer")
				current.maxplayers = text2num(data)
			if("default")
				if(default_map)
					log_config("Ignoring duplicate default command for [current.map_id] - default is already [default_map]")
					continue
				default_map = current.map_id
			if("rotation")
				current.rotation = TRUE
			if("disabled")
				current.disabled = TRUE
			if("weight", "voteweight")
				current.voteweight = text2num(data)
			if("max_rounds_played", "max_round_played")
				current.max_rounds_played = text2num(data)
			if("max_round_search_span", "max_rounds_search_span")
				current.max_rounds_search_span = text2num(data)
		if(current)
			log_config("Unterminated map [current.map_id] ignored.")
			qdel(current)

/datum/map_settings
	/// id of map we corrospond to
	var/map_id
	/// minplayers
	var/minplayers
	/// maxplayers
	var/maxplayers
	/// vote weight
	var/voteweight = 1
	/// disabled - admins can't use this
	var/disabled = FALSE
	/// rotation - in map voting/rotation
	var/rotation = FALSE
	/// max rounds played in max round search span before this is disabled
	var/max_rounds_played = 2
	/// max rounds search span
	var/max_rounds_search_span = 3
