/datum/preferences/proc/cit_character_pref_load(savefile/S)
	//ipcs
	S["feature_ipc_screen"] >> features[FEAT_IPC_SCREEN]
	S["feature_ipc_antenna"] >> features[FEAT_IPC_ANTENNA]

	features[FEAT_IPC_SCREEN] 	= sanitize_inlist(features[FEAT_IPC_SCREEN], GLOB.mutant_features_list[FEAT_IPC_SCREEN])
	features[FEAT_IPC_ANTENNA] 	= sanitize_inlist(features[FEAT_IPC_ANTENNA], GLOB.mutant_features_list[FEAT_IPC_ANTENNA])
	//Citadel
	features["flavor_text"]		= sanitize_text(features["flavor_text"], initial(features["flavor_text"]))
	if(!features[FEAT_MUTCOLOR2] || features[FEAT_MUTCOLOR] == "#000")
		features[FEAT_MUTCOLOR2] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	if(!features[FEAT_MUTCOLOR3] || features[FEAT_MUTCOLOR] == "#000")
		features[FEAT_MUTCOLOR3] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	features[FEAT_MUTCOLOR2]	= sanitize_hexcolor(features[FEAT_MUTCOLOR2], 3, 0)
	features[FEAT_MUTCOLOR3]	= sanitize_hexcolor(features[FEAT_MUTCOLOR3], 3, 0)

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
	WRITE_FILE(S["feature_ipc_screen"], features[FEAT_IPC_SCREEN])
	WRITE_FILE(S["feature_ipc_antenna"], features[FEAT_IPC_ANTENNA])
	//Citadel
	WRITE_FILE(S["feature_genitals_use_skintone"], features["genitals_use_skintone"])
	WRITE_FILE(S["feature_mcolor2"], features[FEAT_MUTCOLOR2])
	WRITE_FILE(S["feature_mcolor3"], features[FEAT_MUTCOLOR3])
	WRITE_FILE(S["feature_mam_body_markings"], features[FEAT_MAM_MARKINGS])
	WRITE_FILE(S["feature_mam_tail"], features[FEAT_TAIL_MAM])
	WRITE_FILE(S["feature_mam_ears"], features[FEAT_MAM_EARS])
	WRITE_FILE(S["feature_mam_tail_animated"], features["mam_tail_animated"])
	WRITE_FILE(S["feature_taur"], features[FEAT_TAUR])
	WRITE_FILE(S["feature_mam_snouts"],	features[FEAT_MAM_SNOUT])
	//Xeno features
	WRITE_FILE(S["feature_xeno_tail"], features[FEAT_XENO_TAIL])
	WRITE_FILE(S["feature_xeno_dors"], features[FEAT_XENO_DORSAL])
	WRITE_FILE(S["feature_xeno_head"], features[FEAT_XENO_HEAD])
	//cock features
	WRITE_FILE(S["feature_has_cock"], features["has_cock"])
	WRITE_FILE(S["feature_cock_shape"], features["cock_shape"])
	WRITE_FILE(S["feature_cock_color"], features["cock_color"])
	WRITE_FILE(S["feature_cock_length"], features["cock_length"])
	WRITE_FILE(S["feature_cock_girth"], features["cock_girth"])
	WRITE_FILE(S["feature_has_sheath"], features["sheath_color"])
	//balls features
	WRITE_FILE(S["feature_has_balls"], features["has_balls"])
	WRITE_FILE(S["feature_balls_color"], features["balls_color"])
	WRITE_FILE(S["feature_balls_size"], features["balls_size"])
	WRITE_FILE(S["feature_balls_shape"], features["balls_shape"])
	WRITE_FILE(S["feature_balls_sack_size"], features["balls_sack_size"])
	WRITE_FILE(S["feature_balls_fluid"], features["balls_fluid"])
	//breasts features
	WRITE_FILE(S["feature_has_breasts"], features["has_breasts"])
	WRITE_FILE(S["feature_breasts_size"], features["breasts_size"])
	WRITE_FILE(S["feature_breasts_shape"], features["breasts_shape"])
	WRITE_FILE(S["feature_breasts_color"], features["breasts_color"])
	WRITE_FILE(S["feature_breasts_fluid"], features["breasts_fluid"])
	WRITE_FILE(S["feature_breasts_producing"], features["breasts_producing"])
	//vagina features
	WRITE_FILE(S["feature_has_vag"], features["has_vag"])
	WRITE_FILE(S["feature_vag_shape"], features["vag_shape"])
	WRITE_FILE(S["feature_vag_color"], features["vag_color"])
	//womb features
	WRITE_FILE(S["feature_has_womb"], features["has_womb"])
	//flavor text
	WRITE_FILE(S["feature_flavor_text"], features["flavor_text"])

	//gear loadout
	if(islist(chosen_gear))
		if(chosen_gear.len)
			var/text_to_save = chosen_gear.Join("|")
			S["loadout"] << text_to_save
		else
			S["loadout"] << "" //empty string to reset the value
