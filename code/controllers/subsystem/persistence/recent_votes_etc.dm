/**
 * Stores recently played gamemodes, maps, etc.
 */
/datum/controller/subsystem/persistence
	var/list/saved_modes = list(1,2,3)
	var/list/saved_dynamic_rules = list(list(),list(),list())
	var/list/saved_storytellers = list("foo","bar","baz")
	var/list/average_dynamic_threat = 50
	var/list/saved_maps

/datum/controller/subsystem/persistence/SaveServerPersistence()
	. = ..()
	CollectRoundtype()
	if(istype(SSticker.mode, /datum/game_mode/dynamic))
		var/datum/game_mode/dynamic/mode = SSticker.mode
		CollectStoryteller(mode)
		CollectRulesets(mode)
	RecordMaps()

/datum/controller/subsystem/persistence/LoadServerPersistence()
	. = ..()
	LoadRecentModes()
	LoadRecentStorytellers()
	LoadRecentRulesets()
	LoadRecentMaps()

/datum/controller/subsystem/persistence/proc/CollectRoundtype()
	saved_modes[3] = saved_modes[2]
	saved_modes[2] = saved_modes[1]
	saved_modes[1] = SSticker.mode.config_tag
	var/json_file = file("data/RecentModes.json")
	var/list/file_data = list()
	file_data["data"] = saved_modes
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/CollectStoryteller(var/datum/game_mode/dynamic/mode)
	saved_storytellers.len = 3
	saved_storytellers[3] = saved_storytellers[2]
	saved_storytellers[2] = saved_storytellers[1]
	saved_storytellers[1] = mode.storyteller.name
	average_dynamic_threat = (mode.max_threat + average_dynamic_threat) / 2
	var/json_file = file("data/RecentStorytellers.json")
	var/list/file_data = list()
	file_data["data"] = saved_storytellers + average_dynamic_threat
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/CollectRulesets(var/datum/game_mode/dynamic/mode)
	saved_dynamic_rules[3] = saved_dynamic_rules[2]
	saved_dynamic_rules[2] = saved_dynamic_rules[1]
	saved_dynamic_rules[1] = list()
	for(var/r in mode.executed_rules)
		var/datum/dynamic_ruleset/rule = r
		saved_dynamic_rules[1] += rule.config_tag
	var/json_file = file("data/RecentRulesets.json")
	var/list/file_data = list()
	file_data["data"] = saved_dynamic_rules
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/RecordMaps()
	saved_maps = saved_maps?.len ? list("[SSmapping.config.map_name]") | saved_maps : list("[SSmapping.config.map_name]")
	var/json_file = file("data/RecentMaps.json")
	var/list/file_data = list()
	file_data["maps"] = saved_maps
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/LoadRecentModes()
	var/json_file = file("data/RecentModes.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		return
	saved_modes = json["data"]

/datum/controller/subsystem/persistence/proc/LoadRecentRulesets()
	var/json_file = file("data/RecentRulesets.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		return
	saved_dynamic_rules = json["data"]

/datum/controller/subsystem/persistence/proc/LoadRecentStorytellers()
	var/json_file = file("data/RecentStorytellers.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		return
	saved_storytellers = json["data"]
	if(saved_storytellers.len > 3)
		average_dynamic_threat = saved_storytellers[4]
	saved_storytellers.len = 3

/datum/controller/subsystem/persistence/proc/LoadRecentMaps()
	var/json_file = file("data/RecentMaps.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		return
	saved_maps = json["maps"]
