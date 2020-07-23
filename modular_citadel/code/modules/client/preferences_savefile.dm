/datum/preferences/proc/cit_character_pref_load(savefile/S)
	//ipcs
	S["feature_ipc_screen"] >> features["ipc_screen"]
	S["feature_ipc_antenna"] >> features["ipc_antenna"]

	features["ipc_screen"] 	= sanitize_inlist(features["ipc_screen"], GLOB.ipc_screens_list)
	features["ipc_antenna"] 	= sanitize_inlist(features["ipc_antenna"], GLOB.ipc_antennas_list)
	//Citadel
	features["flavor_text"]		= sanitize_text(features["flavor_text"], initial(features["flavor_text"]))
	if(!features["mcolor2"] || features["mcolor"] == "#000000")
		features["mcolor2"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	if(!features["mcolor3"] || features["mcolor"] == "#000000")
		features["mcolor3"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	features["mcolor2"]	= sanitize_hexcolor(features["mcolor2"], 6, FALSE)
	features["mcolor3"]	= sanitize_hexcolor(features["mcolor3"], 6, FALSE)

	//Skyrat
	S["enable_personal_chat_color"]			>> enable_personal_chat_color
	S["personal_chat_color"]			>> personal_chat_color
	//skyrat begin
	erppref = sanitize_text(S["erp_pref"], "Ask")
	if(!length(erppref)) erppref = "Ask"
	nonconpref = sanitize_text(S["noncon_pref"], "Ask")
	if(!length(nonconpref)) nonconpref = "Ask"
	vorepref = sanitize_text(S["vore_pref"], "Ask")
	if(!length(vorepref)) vorepref = "Ask"
	extremepref = sanitize_text(S["extremepref"], "No") //god has forsaken me
	if(!length(extremepref))
		extremepref = "No"
	extremeharm = sanitize_text(S["extremeharm"], "No")
	if(!length(extremeharm) || (extremepref = "No"))
		extremeharm = "No"
	//skyrat end
	//skyrat extras
	enable_personal_chat_color	= sanitize_integer(enable_personal_chat_color, 0, 1, initial(enable_personal_chat_color))
	personal_chat_color	= sanitize_hexcolor(personal_chat_color, 6, 1, "#FFFFFF")

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
	WRITE_FILE(S["silicon_feature_flavor_text"], features["silicon_flavor_text"])

	//skyrat stuff
	WRITE_FILE(S["erp_pref"], erppref)
	WRITE_FILE(S["noncon_pref"], nonconpref)
	WRITE_FILE(S["vore_pref"], vorepref)
	WRITE_FILE(S["extremepref"], extremepref)
	WRITE_FILE(S["extremeharm"], extremeharm)
	WRITE_FILE(S["enable_personal_chat_color"], enable_personal_chat_color)
	WRITE_FILE(S["personal_chat_color"], personal_chat_color)
