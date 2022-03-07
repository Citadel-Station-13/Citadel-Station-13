/client/proc/forcerandomrotate()
	set category = "Server"
	set name = "Trigger Random Map Rotation"
	var/rotate = alert("Force a random map rotation to trigger?", "Rotate map?", "Yes", "Cancel")
	if (rotate != "Yes")
		return
	message_admins("[key_name_admin(usr)] is forcing a random map rotation.")
	log_admin("[key_name(usr)] is forcing a random map rotation.")
	SSticker.maprotatechecked = 1
	SSmapping.MapRotate()

/client/proc/adminchangemap()
	set category = "Server"
	set name = "Change Map"
	var/list/maprotatechoices = list()
	for(var/id in config.map_data)
		var/datum/map_settings/S = config.map_data[id]
		var/mapname = S.map_id
		if(id == config.default_map)
			mapname += " (Default)"
		if(S.maxplayers > 0 || S.minplayers> 0)
			mapname += " \[[S.minplayers > 0? S.minplayers : "inf"]-[S.maxplayers > 0? S.maxplayers : "inf"]]"
		maprotatechoices[mapname] = S
	var/chosenmap = input("Choose a map to change to", "Change Map")  as null|anything in maprotatechoices
	if (!chosenmap)
		return
	SSticker.maprotatechecked = 1
	var/datum/map_settings/S = maprotatechoices[chosenmap]
	message_admins("[key_name_admin(usr)] is changing the map to [S.map_id]")
	log_admin("[key_name(usr)] is changing the map to [S.map_id]")
	if(!SSmapping.SetNextMap(S.map_id))
		message_admins("Map change to [S.map_id] failed.")
		CRASH("Map change failed.")
