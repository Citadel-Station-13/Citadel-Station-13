/datum/preferences/proc/cit_character_pref_load(savefile/S)
	//ipcs
	S["feature_ipc_screen"] >> features["ipc_screen"]
	S["feature_ipc_antenna"] >> features["ipc_antenna"]

	features["ipc_screen"] 	= sanitize_inlist(features["ipc_screen"], GLOB.ipc_screens_list)
	features["ipc_antenna"] 	= sanitize_inlist(features["ipc_antenna"], GLOB.ipc_antennas_list)
	//Citadel
	features["flavor_text"]		= sanitize_text(features["flavor_text"], initial(features["flavor_text"]))
	if(!features["mcolor2"] || features["mcolor"] == "#000")
		features["mcolor2"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	if(!features["mcolor3"] || features["mcolor"] == "#000")
		features["mcolor3"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	features["mcolor2"]	= sanitize_hexcolor(features["mcolor2"], 3, 0)
	features["mcolor3"]	= sanitize_hexcolor(features["mcolor3"], 3, 0)

	//gear loadout
	var/text_to_load
	S["loadout"] >> text_to_load
	var/list/saved_loadout_paths = splittext(text_to_load, "|")
	LAZYCLEARLIST(chosen_gear)
	gear_points = initial(gear_points)
	for(var/i in saved_loadout_paths)
		var/datum/gear/path = text2path(i)
		if(path)
			LAZYADD(chosen_gear, path)
			gear_points -= initial(path.cost)

/datum/preferences/proc/cit_character_pref_save(savefile/S)
	//ipcs
	WRITE_FILE(S["feature_ipc_screen"], features["ipc_screen"])
	WRITE_FILE(S["feature_ipc_antenna"], features["ipc_antenna"])
	//Citadel
	WRITE_FILE(S["feature_genitals_use_skintone"], features["genitals_use_skintone"])
	WRITE_FILE(S["feature_mcolor2"], features["mcolor2"])
	WRITE_FILE(S["feature_mcolor3"], features["mcolor3"])
	WRITE_FILE(S["feature_mam_body_markings"], features["mam_body_markings"])
	WRITE_FILE(S["feature_mam_tail"], features["mam_tail"])
	WRITE_FILE(S["feature_mam_ears"], features["mam_ears"])
	WRITE_FILE(S["feature_mam_tail_animated"], features["mam_tail_animated"])
	WRITE_FILE(S["feature_taur"], features["taur"])
	WRITE_FILE(S["feature_mam_snouts"],	features["mam_snouts"])
	//Xeno features
	WRITE_FILE(S["feature_xeno_tail"], features["xenotail"])
	WRITE_FILE(S["feature_xeno_dors"], features["xenodorsal"])
	WRITE_FILE(S["feature_xeno_head"], features["xenohead"])
	//flavor text
	WRITE_FILE(S["feature_flavor_text"], features["flavor_text"])

	//gear loadout
	if(islist(chosen_gear))
		if(chosen_gear.len)
			var/text_to_save = chosen_gear.Join("|")
			S["loadout"] << text_to_save
		else
			S["loadout"] << "" //empty string to reset the value
