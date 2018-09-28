//This is the lowest supported version, anything below this is completely obsolete and the entire savefile will be wiped.
#define SAVEJSON_VERSION_MIN	1

//This is the current version, anything below this will attempt to update (if it's not obsolete)
//	You do not need to raise this if you are adding new values that have sane defaults.
//	Only raise this value when changing the meaning/format/name/layout of an existing value
//	where you would want the updater procs below to run
#define SAVEJSON_VERSION_MAX	1

/*
SAVEFILE UPDATING/VERSIONING - 'Simplified', or rather, more coder-friendly ~Carn
	This proc checks if the current directory of the savefile S needs updating
	It is to be used by the load_character and load_preferences procs.
	(S.cd=="/" is preferences, S.cd=="/character[integer]" is a character slot, etc)

	if the current directory's version is below SAVEFILE_VERSION_MIN it will simply wipe everything in that directory
	(if we're at root "/" then it'll just wipe the entire savefile, for instance.)

	if its version is below SAVEFILE_VERSION_MAX but above the minimum, it will load data but later call the
	respective update_preferences() or update_character() proc.
	Those procs allow coders to specify format changes so users do not lose their setups and have to redo them again.

	Failing all that, the standard sanity checks are performed. They simply check the data is suitable, reverting to
	initial() values if necessary.
*/

/datum/preferences/proc/savefile_needs_update(savefile/S)
	var/savefile_version
	S["version"] >> savefile_version

	if(savefile_version < SAVEJSON_VERSION_MIN)
		S.dir.Cut()
		return -2
	if(savefile_version < SAVEJSON_VERSION_MAX)
		return savefile_version
	return -1

//should these procs get fairly long
//just increase SAVEFILE_VERSION_MIN so it's not as far behind
//SAVEFILE_VERSION_MAX and then delete any obsolete if clauses
//from these procs.
//This only really meant to avoid annoying frequent players
//if your savefile is 3 months out of date, then 'tough shit'.

/datum/preferences/proc/update_preferences(current_version, savefile/S)
	return

/datum/preferences/proc/update_character(current_version, savefile/S)
	if(current_version < 19)
		pda_style = "mono"
	if(current_version < 20)
		pda_color = "#808000"

/datum/preferences/proc/load_path(ckey,slot,filename="preferences")
	if(fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/preferences/[filename][slot].json"))
		path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/preferences/[filename][slot].json"

	else if(fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename].sav")) //we've found a legacy sav, probably
		path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename].sav"

/datum/preferences/proc/load_preferences(ckey,slot,filename="preferences")
	if(!parent || !client_ckey)
		return FALSE //No client, how can we save?
	if(!parent.prefs || !parent.prefs.default_slot)
		return FALSE //Need to know what character to load!
	if(fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename].sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]BACKUP.sav")
		S["ooccolor"]			>> ooccolor
		S["lastchangelog"]		>> lastchangelog
		S["UI_style"]			>> UI_style
		S["hotkeys"]			>> hotkeys
		S["tgui_fancy"]			>> tgui_fancy
		S["tgui_lock"]			>> tgui_lock
		S["buttons_locked"]		>> buttons_locked
		S["windowflash"]		>> windowflashing
		S["be_special"] 		>> be_special
		S["default_slot"]		>> default_slot
		S["chat_toggles"]		>> chat_toggles
		S["toggles"]			>> toggles
		S["ghost_form"]			>> ghost_form
		S["ghost_orbit"]		>> ghost_orbit
		S["ghost_accs"]			>> ghost_accs
		S["ghost_others"]		>> ghost_others
		S["preferred_map"]		>> preferred_map
		S["ignoring"]			>> ignoring
		S["ghost_hud"]			>> ghost_hud
		S["inquisitive_ghost"]	>> inquisitive_ghost
		S["uses_glasses_colour"]>> uses_glasses_colour
		S["clientfps"]			>> clientfps
		S["parallax"]			>> parallax
		S["ambientocclusion"]	>> ambientocclusion
		S["auto_fit_viewport"]	>> auto_fit_viewport
		S["menuoptions"]		>> menuoptions
		S["enable_tips"]		>> enable_tips
		S["tip_delay"]			>> tip_delay
		S["pda_style"]			>> pda_style
		S["pda_color"]			>> pda_color
		//Citadel Code
		S["arousable"]			>> arousable
		S["screenshake"]		>> screenshake
		S["damagescreenshake"]	>> damagescreenshake
		S["widescreenpref"]		>> widescreenpref
		S["autostand"]			>> autostand
		S["cit_toggles"]		>> cit_toggles

		//Sanitize just in case
		ooccolor		= sanitize_ooccolor(sanitize_hexcolor(ooccolor, 6, 1, initial(ooccolor)))
		lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
		UI_style		= sanitize_inlist(UI_style, GLOB.available_ui_styles, GLOB.available_ui_styles[1])
		hotkeys			= sanitize_integer(hotkeys, 0, 1, initial(hotkeys))
		tgui_fancy		= sanitize_integer(tgui_fancy, 0, 1, initial(tgui_fancy))
		tgui_lock		= sanitize_integer(tgui_lock, 0, 1, initial(tgui_lock))
		buttons_locked	= sanitize_integer(buttons_locked, 0, 1, initial(buttons_locked))
		windowflashing		= sanitize_integer(windowflashing, 0, 1, initial(windowflashing))
		default_slot	= sanitize_integer(default_slot, 1, max_save_slots, initial(default_slot))
		toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))
		clientfps		= sanitize_integer(clientfps, 0, 1000, 0)
		parallax		= sanitize_integer(parallax, PARALLAX_INSANE, PARALLAX_DISABLE, null)
		ambientocclusion	= sanitize_integer(ambientocclusion, 0, 1, initial(ambientocclusion))
		auto_fit_viewport	= sanitize_integer(auto_fit_viewport, 0, 1, initial(auto_fit_viewport))
		ghost_form		= sanitize_inlist(ghost_form, GLOB.ghost_forms, initial(ghost_form))
		ghost_orbit 	= sanitize_inlist(ghost_orbit, GLOB.ghost_orbits, initial(ghost_orbit))
		ghost_accs		= sanitize_inlist(ghost_accs, GLOB.ghost_accs_options, GHOST_ACCS_DEFAULT_OPTION)
		ghost_others	= sanitize_inlist(ghost_others, GLOB.ghost_others_options, GHOST_OTHERS_DEFAULT_OPTION)
		menuoptions		= SANITIZE_LIST(menuoptions)
		be_special		= SANITIZE_LIST(be_special)
		pda_style		= sanitize_inlist(pda_style, GLOB.pda_styles, initial(pda_style))
		pda_color		= sanitize_hexcolor(pda_color, 6, 1, initial(pda_color))

		screenshake			= sanitize_integer(screenshake, 0, 800, initial(screenshake))
		damagescreenshake	= sanitize_integer(damagescreenshake, 0, 2, initial(damagescreenshake))
		widescreenpref			= sanitize_integer(widescreenpref, 0, 1, initial(widescreenpref))
		autostand			= sanitize_integer(autostand, 0, 1, initial(autostand))
		cit_toggles			= sanitize_integer(cit_toggles, 0, 65535, initial(cit_toggles))

		WRITE_FILE("data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]BACKUP.sav")
		if(fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/preferences/[filename][slot].json"))
			fdel("data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename].sav")
	else
		load_path(client_ckey,slot,filename="preferences")
		if(!fexists(path))
			save_preferences() // let's make sure the file's at least done first
			return TRUE
		var/list/json_from_file = json_decode(file2text(path))
		if(!json_from_file)
			return FALSE //My concern grows
		var/version = json_from_file["version"]
		json_from_file = patch_version(json_from_file,version)

		ooccolor				= json_from_file["ooccolor"]
		lastchangelog			= json_from_file["lastchangelog"]
		UI_style				= json_from_file["UI_style"]
		hotkeys					= json_from_file["hotkeys"]
		tgui_fancy				= json_from_file["tgui_fancy"]
		tgui_lock				= json_from_file["tgui_lock"]
		buttons_locked			= json_from_file["buttons_locked"]
		windowflashing			= json_from_file["windowflash"]
		be_special				= json_from_file["be_special"]
		default_slot			= json_from_file["default_slot"]
		chat_toggles			= json_from_file["chat_toggles"]
		toggles					= json_from_file["toggles"]
		ghost_form				= json_from_file["ghost_form"]
		ghost_orbit				= json_from_file["ghost_orbit"]
		ghost_accs				= json_from_file["ghost_accs"]
		ghost_others			= json_from_file["ghost_others"]
		preferred_map			= json_from_file["preferred_map"]
		ignoring				= json_from_file["ignoring"]
		ghost_hud				= json_from_file["ghost_hud"]
		inquisitive_ghost		= json_from_file["inquisitive_ghost"]
		uses_glasses_colour		= json_from_file["uses_glasses_colour"]
		clientfps				= json_from_file["clientfps"]
		parallax				= json_from_file["parallax"]
		ambientocclusion		= json_from_file["ambientocclusion"]
		auto_fit_viewport		= json_from_file["auto_fit_viewport"]
		menuoptions				= json_from_file["menuoptions"]
		enable_tips				= json_from_file["enable_tips"]
		tip_delay				= json_from_file["tip_delay"]
		pda_style				= json_from_file["pda_style"]
		pda_color				= json_from_file["pda_color"]
		//Citadel Code
		arousable				= json_from_file["arousable"]
		screenshake				= json_from_file["screenshake"]
		damagescreenshake		= json_from_file["damagescreenshake"]
		widescreenpref			= json_from_file["widescreenpref"]
		autostand				= json_from_file["autostand"]
		cit_toggles				= json_from_file["cit_toggles"]

		//Sanitize
		if(isnull(ooccolor))
			sanitize_ooccolor(sanitize_hexcolor(ooccolor, 6, 1, initial(ooccolor)))
		if(isnull(lastchangelog))
			sanitize_text(lastchangelog, initial(lastchangelog))
		if(isnull(UI_style))
			sanitize_inlist(UI_style, GLOB.available_ui_styles, GLOB.available_ui_styles[1])
		if(isnull(hotkeys))
			sanitize_integer(hotkeys, 0, 1, initial(hotkeys))
		if(isnull(tgui_fancy))
			sanitize_integer(tgui_fancy, 0, 1, initial(tgui_fancy))
		if(isnull(tgui_lock))
			sanitize_integer(tgui_lock, 0, 1, initial(tgui_lock))
		if(isnull(buttons_locked))
			sanitize_integer(buttons_locked, 0, 1, initial(buttons_locked))
		if(isnull(windowflashing))
			sanitize_integer(windowflashing, 0, 1, initial(windowflashing))
		if(isnull(default_slot))
			sanitize_integer(default_slot, 1, max_save_slots, initial(default_slot))
		if(isnull(toggles))
			sanitize_integer(toggles, 0, 65535, initial(toggles))
		if(isnull(clientfps))
			sanitize_integer(clientfps, 0, 1000, 0)
		if(isnull(parallax))
			sanitize_integer(parallax, PARALLAX_INSANE, PARALLAX_DISABLE, null)
		if(isnull(ambientocclusion))
			sanitize_integer(ambientocclusion, 0, 1, initial(ambientocclusion))
		if(isnull(auto_fit_viewport))
			sanitize_integer(auto_fit_viewport, 0, 1, initial(auto_fit_viewport))
		if(isnull(ghost_form))
			sanitize_inlist(ghost_form, GLOB.ghost_forms, initial(ghost_form))
		if(isnull(ghost_orbit))
			sanitize_inlist(ghost_orbit, GLOB.ghost_orbits, initial(ghost_orbit))
		if(isnull(ghost_accs))
			sanitize_inlist(ghost_accs, GLOB.ghost_accs_options, GHOST_ACCS_DEFAULT_OPTION)
		if(isnull(ghost_others))
			sanitize_inlist(ghost_others, GLOB.ghost_others_options, GHOST_OTHERS_DEFAULT_OPTION)
		if(isnull(menuoptions))
			menuoptions = list()
		if(isnull(be_special))
			be_special = list()
		if(isnull(pda_style))
			sanitize_inlist(pda_style, GLOB.pda_styles, initial(pda_style))
		if(isnull(pda_color))
			sanitize_hexcolor(pda_color, 6, 1, initial(pda_color))

		if(isnull(screenshake))
			sanitize_integer(screenshake, 0, 800, initial(screenshake))
		if(isnull(damagescreenshake))
			sanitize_integer(damagescreenshake, 0, 2, initial(damagescreenshake))
		if(isnull(widescreenpref))
			sanitize_integer(widescreenpref, 0, 1, initial(widescreenpref))
		if(isnull(autostand))
			sanitize_integer(autostand, 0, 1, initial(autostand))
		if(isnull(cit_toggles))
			sanitize_integer(cit_toggles, 0, 65535, initial(cit_toggles))

	return TRUE

/datum/preferences/proc/save_preferences()
	if(!path)
		return FALSE

	var/version = SAVEJSON_VERSION_MAX	//For "good times" use in the future
	var/list/preferences_list = list(
			"version"				= version,
			"ooccolor"				= ooccolor,
			"lastchangelog"			= lastchangelog,
			"UI_style"				= UI_style,
			"hotkeys"				= hotkeys,
			"tgui_fancy"			= tgui_fancy,
			"tgui_lock"				= tgui_lock,
			"buttons_locked"		= buttons_locked,
			"windowflash"			= windowflashing,
			"be_special" 			= be_special,
			"default_slot"			= default_slot,
			"chat_toggles"			= chat_toggles,
			"toggles"				= toggles,
			"ghost_form"			= ghost_form,
			"ghost_orbit"			= ghost_orbit,
			"ghost_accs"			= ghost_accs,
			"ghost_others"			= ghost_others,
			"preferred_map"			= preferred_map,
			"ignoring"				= ignoring,
			"ghost_hud"				= ghost_hud,
			"inquisitive_ghost"		= inquisitive_ghost,
			"uses_glasses_colour"	= uses_glasses_colour,
			"clientfps"				= clientfps,
			"parallax"				= parallax,
			"ambientocclusion"		= ambientocclusion,
			"auto_fit_viewport"		= auto_fit_viewport,
			"menuoptions"			= menuoptions,
			"enable_tips"			= enable_tips,
			"tip_delay"				= tip_delay,
			"pda_style"				= pda_style,
			"pda_color"				= pda_color,
			"arousable"				= arousable,
			"screenshake"			= screenshake,
			"damagescreenshake"		= damagescreenshake,
			"widescreenpref"		= widescreenpref,
			"autostand"				= autostand,
			"cit_toggles"			= cit_toggles,
		)

	//List to JSON
	var/json_to_file = json_encode(preferences_list)
	if(!json_to_file)
		testing("Saving: [path] failed jsonencode")
		return FALSE

#ifdef RUST_G
	call(RUST_G, "file_write")(json_to_file, path)
#else
	// Fall back to using old format if we are not using rust-g
	if(fexists(path))
		fdel(path) //Byond only supports APPENDING to files, not replacing.
	WRITE_FILE(json_to_file, path)
#endif
	if(!fexists(path))
		testing("Saving: [path] failed file write")
		return FALSE

	return TRUE

/datum/preferences/proc/load_character(ckey,slot,filename="preferences")
	if(!ckey)
		return
	if(fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename].sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/player_saves/[copytext(ckey,1,2)]/[ckey]/BACKUP[filename].sav")
		//Species
		var/species_id
		S["species"]			>> species_id
		if(species_id)
			var/newtype = GLOB.species_list[species_id]
			if(newtype)
				pref_species = new newtype
		S["real_name"]			>> real_name
		S["name_is_always_random"] >> be_random_name
		S["body_is_always_random"] >> be_random_body
		S["gender"]				>> gender
		S["age"]				>> age
		S["hair_color"]			>> hair_color
		S["facial_hair_color"]	>> facial_hair_color
		S["eye_color"]			>> eye_color
		S["skin_tone"]			>> skin_tone
		S["hair_style_name"]	>> hair_style
		S["facial_style_name"]	>> facial_hair_style
		S["underwear"]			>> underwear
		S["undershirt"]			>> undershirt
		S["socks"]				>> socks
		S["backbag"]			>> backbag
		S["uplink_loc"]			>> uplink_spawn_loc
		S["feature_mcolor"]					>> features["mcolor"]
		S["feature_lizard_tail"]			>> features["tail_lizard"]
		S["feature_lizard_snout"]			>> features["snout"]
		S["feature_lizard_horns"]			>> features["horns"]
		S["feature_lizard_frills"]			>> features["frills"]
		S["feature_lizard_spines"]			>> features["spines"]
		S["feature_lizard_body_markings"]	>> features["body_markings"]
		S["feature_lizard_legs"]			>> features["legs"]
		S["feature_moth_wings"]				>> features["moth_wings"]
		S["feature_human_tail"]				>> features["tail_human"]
		S["feature_human_ears"]				>> features["ears"]
		//Custom names
		for(var/custom_name_id in GLOB.preferences_custom_names)
			var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
			S[savefile_slot_name] >> custom_names[custom_name_id]
		S["prefered_security_department"] >> prefered_security_department
		//Jobs
		S["joblessrole"]		>> joblessrole
		S["job_civilian_high"]	>> job_civilian_high
		S["job_civilian_med"]	>> job_civilian_med
		S["job_civilian_low"]	>> job_civilian_low
		S["job_medsci_high"]	>> job_medsci_high
		S["job_medsci_med"]		>> job_medsci_med
		S["job_medsci_low"]		>> job_medsci_low
		S["job_engsec_high"]	>> job_engsec_high
		S["job_engsec_med"]		>> job_engsec_med
		S["job_engsec_low"]		>> job_engsec_low
		//Quirks
		S["all_quirks"]			>> all_quirks
		S["positive_quirks"]	>> positive_quirks
		S["negative_quirks"]	>> negative_quirks
		S["neutral_quirks"]		>> neutral_quirks
		//Citadel code
		S["feature_genitals_use_skintone"]	>> features["genitals_use_skintone"]
		S["feature_exhibitionist"]			>> features["exhibitionist"]
		S["feature_mcolor2"]				>> features["mcolor2"]
		S["feature_mcolor3"]				>> features["mcolor3"]
		S["feature_mam_body_markings"]		>> features["mam_body_markings"]
		S["feature_mam_tail"]				>> features["mam_tail"]
		S["feature_mam_ears"]				>> features["mam_ears"]
		S["feature_mam_tail_animated"]		>> features["mam_tail_animated"]
		S["feature_taur"]					>> features["taur"]
		S["feature_xeno_tail"]				>> features["xenotail"]
		S["feature_xeno_dors"]				>> features["xenodorsal"]
		S["feature_xeno_head"]				>> features["xenohead"]
		S["feature_has_cock"]				>> features["has_cock"]
		S["feature_cock_shape"]				>> features["cock_shape"]
		S["feature_cock_color"]				>> features["cock_color"]
		S["feature_cock_length"]			>> features["cock_length"]
		S["feature_cock_girth"]				>> features["cock_girth"]
		S["feature_has_sheath"]				>> features["sheath_color"]
		S["feature_has_balls"]				>> features["has_balls"]
		S["feature_balls_color"]			>> features["balls_color"]
		S["feature_balls_size"]				>> features["balls_size"]
		S["feature_balls_sack_size"]		>> features["balls_sack_size"]
		S["feature_balls_fluid"]			>> features["balls_fluid"]
		S["feature_has_breasts"]			>> features["has_breasts"]
		S["feature_breasts_size"]			>> features["breasts_size"]
		S["feature_breasts_shape"]			>> features["breasts_shape"]
		S["feature_breasts_color"]			>> features["breasts_color"]
		S["feature_breasts_fluid"]			>> features["breasts_fluid"]
		S["feature_has_vag"]				>> features["has_vag"]
		S["feature_vag_shape"]				>> features["vag_shape"]
		S["feature_vag_color"]				>> features["vag_color"]
		S["feature_has_womb"]				>> features["has_womb"]
		S["feature_flavor_text"]			>> features["flavor_text"]

		var/text_to_load
		S["loadout"]						>> text_to_load
		var/list/saved_loadout_paths = splittext(text_to_load, "|")
		LAZYCLEARLIST(chosen_gear)
		gear_points = initial(gear_points)
		for(var/i in saved_loadout_paths)
			var/datum/gear/path = text2path(i)
			if(path)
				LAZYADD(chosen_gear, path)
				gear_points -= initial(path.cost)

		//Sanitize
		real_name = reject_bad_name(real_name)
		gender = sanitize_gender(gender)
		if(!real_name)
			real_name = random_unique_name(gender)

		for(var/custom_name_id in GLOB.preferences_custom_names)
			var/namedata = GLOB.preferences_custom_names[custom_name_id]
			custom_names[custom_name_id] = reject_bad_name(custom_names[custom_name_id],namedata["allow_numbers"])
			if(!custom_names[custom_name_id])
				custom_names[custom_name_id] = get_default_name(custom_name_id)

		if(!features["mcolor"] || features["mcolor"] == "#000")
			features["mcolor"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")

		be_random_name	= sanitize_integer(be_random_name, 0, 1, initial(be_random_name))
		be_random_body	= sanitize_integer(be_random_body, 0, 1, initial(be_random_body))

		if(gender == MALE)
			hair_style			= sanitize_inlist(hair_style, GLOB.hair_styles_male_list)
			facial_hair_style			= sanitize_inlist(facial_hair_style, GLOB.facial_hair_styles_male_list)
			underwear		= sanitize_inlist(underwear, GLOB.underwear_m)
			undershirt 		= sanitize_inlist(undershirt, GLOB.undershirt_m)
		else
			hair_style			= sanitize_inlist(hair_style, GLOB.hair_styles_female_list)
			facial_hair_style			= sanitize_inlist(facial_hair_style, GLOB.facial_hair_styles_female_list)
			underwear		= sanitize_inlist(underwear, GLOB.underwear_f)
			undershirt		= sanitize_inlist(undershirt, GLOB.undershirt_f)
		socks			= sanitize_inlist(socks, GLOB.socks_list)
		age				= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
		hair_color			= sanitize_hexcolor(hair_color, 3, 0)
		facial_hair_color			= sanitize_hexcolor(facial_hair_color, 3, 0)
		eye_color		= sanitize_hexcolor(eye_color, 3, 0)
		skin_tone		= sanitize_inlist(skin_tone, GLOB.skin_tones)
		backbag			= sanitize_inlist(backbag, GLOB.backbaglist, initial(backbag))
		uplink_spawn_loc = sanitize_inlist(uplink_spawn_loc, GLOB.uplink_spawn_loc_list, initial(uplink_spawn_loc))
		features["mcolor"]	= sanitize_hexcolor(features["mcolor"], 3, 0)
		features["tail_lizard"]	= sanitize_inlist(features["tail_lizard"], GLOB.tails_list_lizard)
		features["tail_human"] 	= sanitize_inlist(features["tail_human"], GLOB.tails_list_human, "None")
		features["snout"]	= sanitize_inlist(features["snout"], GLOB.snouts_list)
		features["horns"] 	= sanitize_inlist(features["horns"], GLOB.horns_list)
		features["ears"]	= sanitize_inlist(features["ears"], GLOB.ears_list, "None")
		features["frills"] 	= sanitize_inlist(features["frills"], GLOB.frills_list)
		features["spines"] 	= sanitize_inlist(features["spines"], GLOB.spines_list)
		features["body_markings"] 	= sanitize_inlist(features["body_markings"], GLOB.body_markings_list)
		features["feature_lizard_legs"]	= sanitize_inlist(features["legs"], GLOB.legs_list, "Normal Legs")
		features["moth_wings"] 	= sanitize_inlist(features["moth_wings"], GLOB.moth_wings_list, "Plain")

		joblessrole	= sanitize_integer(joblessrole, 1, 3, initial(joblessrole))
		job_civilian_high = sanitize_integer(job_civilian_high, 0, 65535, initial(job_civilian_high))
		job_civilian_med = sanitize_integer(job_civilian_med, 0, 65535, initial(job_civilian_med))
		job_civilian_low = sanitize_integer(job_civilian_low, 0, 65535, initial(job_civilian_low))
		job_medsci_high = sanitize_integer(job_medsci_high, 0, 65535, initial(job_medsci_high))
		job_medsci_med = sanitize_integer(job_medsci_med, 0, 65535, initial(job_medsci_med))
		job_medsci_low = sanitize_integer(job_medsci_low, 0, 65535, initial(job_medsci_low))
		job_engsec_high = sanitize_integer(job_engsec_high, 0, 65535, initial(job_engsec_high))
		job_engsec_med = sanitize_integer(job_engsec_med, 0, 65535, initial(job_engsec_med))
		job_engsec_low = sanitize_integer(job_engsec_low, 0, 65535, initial(job_engsec_low))

		all_quirks = SANITIZE_LIST(all_quirks)
		positive_quirks = SANITIZE_LIST(positive_quirks)
		negative_quirks = SANITIZE_LIST(negative_quirks)
		neutral_quirks = SANITIZE_LIST(neutral_quirks)
		//Citadel
		features["ipc_screen"] 	= sanitize_inlist(features["ipc_screen"], GLOB.ipc_screens_list)
		features["ipc_antenna"] 	= sanitize_inlist(features["ipc_antenna"], GLOB.ipc_antennas_list)
		features["flavor_text"]		= sanitize_text(features["flavor_text"], initial(features["flavor_text"]))
		if(!features["mcolor2"] || features["mcolor"] == "#000")
			features["mcolor2"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
		if(!features["mcolor3"] || features["mcolor"] == "#000")
			features["mcolor3"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
		features["mcolor2"]	= sanitize_hexcolor(features["mcolor2"], 3, 0)
		features["mcolor3"]	= sanitize_hexcolor(features["mcolor3"], 3, 0)

	else
		load_path(client_ckey,slot,"character")
		if(!fexists(path))
			save_preferences() // let's make sure the file's at least done first
			return TRUE
		var/list/json_from_file = json_decode(file2text(path))
		if(!json_from_file)
			return FALSE //My concern grows
		var/version = json_from_file["version"]
		json_from_file = patch_version(json_from_file,version)
		var/species_id
		species_id						= json_from_file["species_id"]
		if(species_id)
			var/newtype = GLOB.species_list[species_id]
			if(newtype)
				pref_species = new newtype

		real_name						= json_from_file["real_name"]
		be_random_name					= json_from_file["name_is_always_random"]
		be_random_body					= json_from_file["body_is_always_random"]
		gender							= json_from_file["gender"]
		age								= json_from_file["age"]
		hair_color						= json_from_file["hair_color"]
		facial_hair_color				= json_from_file["facial_hair_color"]
		eye_color						= json_from_file["eye_color"]
		skin_tone						= json_from_file["skin_tone"]
		hair_style						= json_from_file["hair_style_name"]
		facial_hair_style				= json_from_file["facial_style_name"]
		underwear						= json_from_file["underwear"]
		undershirt						= json_from_file["undershirt"]
		socks							= json_from_file["socks"]
		backbag							= json_from_file["backbag"]
		uplink_spawn_loc				= json_from_file["uplink_loc"]
		features						= json_from_file["features"]

		//Custom names
		for(var/custom_name_id in GLOB.preferences_custom_names)
			var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
			custom_names[custom_name_id] = json_from_file[savefile_slot_name]

		prefered_security_department	= json_from_file["prefered_security_department"]
		joblessrole						= json_from_file["joblessrole"]
		job_civilian_high				= json_from_file["job_civilian_high"]
		job_civilian_med				= json_from_file["job_civilian_med"]
		job_civilian_low				= json_from_file["job_civilian_low"]
		job_medsci_high					= json_from_file["job_medsci_high"]
		job_medsci_med					= json_from_file["job_medsci_med"]
		job_medsci_low					= json_from_file["job_medsci_low"]
		job_engsec_high					= json_from_file["job_engsec_high"]
		job_engsec_med					= json_from_file["job_engsec_med"]
		job_engsec_low					= json_from_file["job_engsec_low"]
		all_quirks						= json_from_file["all_quirks"]
		positive_quirks					= json_from_file["positive_quirks"]
		negative_quirks					= json_from_file["negative_quirks"]
		neutral_quirks					= json_from_file["neutral_quirks"]

		//Sanitize

		real_name = reject_bad_name(real_name)
		if(isnull(gender))
			sanitize_gender(gender)
		if(isnull(real_name))
			real_name = random_unique_name(gender)

		for(var/custom_name_id in GLOB.preferences_custom_names)
			var/namedata = GLOB.preferences_custom_names[custom_name_id]
			custom_names[custom_name_id] = reject_bad_name(custom_names[custom_name_id],namedata["allow_numbers"])
			if(isnull(custom_names[custom_name_id]))
				custom_names[custom_name_id] = get_default_name(custom_name_id)

		if(isnull(be_random_name))
			sanitize_integer(be_random_name, 0, 1, initial(be_random_name))
		if(isnull(be_random_body))
			sanitize_integer(be_random_body, 0, 1, initial(be_random_body))

		if(gender == MALE)
			if(isnull(hair_style))
				sanitize_inlist(hair_style, GLOB.hair_styles_male_list)
			if(isnull(facial_hair_style))
				sanitize_inlist(facial_hair_style, GLOB.facial_hair_styles_male_list)
			if(isnull(underwear))
				sanitize_inlist(underwear, GLOB.underwear_m)
			if(isnull(undershirt))
				sanitize_inlist(undershirt, GLOB.undershirt_m)
		else if(gender == FEMALE)
			if(isnull(hair_style))
				sanitize_inlist(hair_style, GLOB.hair_styles_female_list)
			if(isnull(facial_hair_style))
				sanitize_inlist(facial_hair_style, GLOB.facial_hair_styles_female_list)
			if(isnull(underwear))
				sanitize_inlist(underwear, GLOB.underwear_f)
			if(isnull(undershirt))
				sanitize_inlist(undershirt, GLOB.undershirt_f)
		if(isnull(socks))
			sanitize_inlist(socks, GLOB.socks_list)
		if(isnull(age))
			sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
		if(isnull(hair_color))
			sanitize_hexcolor(hair_color, 3, 0)
		if(isnull(facial_hair_color))
			sanitize_hexcolor(facial_hair_color, 3, 0)
		if(isnull(eye_color))
			sanitize_hexcolor(eye_color, 3, 0)
		if(isnull(skin_tone))
			sanitize_inlist(skin_tone, GLOB.skin_tones)
		if(isnull(backbag))
			sanitize_inlist(backbag, GLOB.backbaglist, initial(backbag))
		if(isnull(uplink_spawn_loc))
			sanitize_inlist(uplink_spawn_loc, GLOB.uplink_spawn_loc_list, initial(uplink_spawn_loc))
		if(isnull(features))
			features = list()
		if(isnull(joblessrole))
			sanitize_integer(joblessrole, 1, 3, initial(joblessrole))
		if(isnull(job_civilian_high))
			sanitize_integer(job_civilian_high, 0, 65535, initial(job_civilian_high))
		if(isnull(job_civilian_med))
			sanitize_integer(job_civilian_med, 0, 65535, initial(job_civilian_med))
		if(isnull(job_civilian_low))
			sanitize_integer(job_civilian_low, 0, 65535, initial(job_civilian_low))
		if(isnull(job_medsci_high))
			sanitize_integer(job_medsci_high, 0, 65535, initial(job_medsci_high))
		if(isnull(job_medsci_med))
			sanitize_integer(job_medsci_med, 0, 65535, initial(job_medsci_med))
		if(isnull(job_medsci_low))
			sanitize_integer(job_medsci_low, 0, 65535, initial(job_medsci_low))
		if(isnull(job_engsec_high))
			sanitize_integer(job_engsec_high, 0, 65535, initial(job_engsec_high))
		if(isnull(job_engsec_med))
			sanitize_integer(job_engsec_med, 0, 65535, initial(job_engsec_med))
		if(isnull(job_engsec_low))
			sanitize_integer(job_engsec_low, 0, 65535, initial(job_engsec_low))
		if(isnull(all_quirks))
			all_quirks = list()
		if(isnull(positive_quirks))
			positive_quirks = list()
		if(isnull(negative_quirks))
			negative_quirks = list()
		if(isnull(neutral_quirks))
			neutral_quirks = list()
	return TRUE

/datum/preferences/proc/save_character()
	if(!path)
		return FALSE
	var/version = SAVEJSON_VERSION_MAX	//For "good times" use in the future
	var/list/character_list = list(
			"version"				= version,
			"real_name"				= real_name,
			"name_is_always_random" = be_random_name,
			"body_is_always_random" = be_random_body,
			"gender" 				= gender,
			"age" 					= age,
			"hair_color" 			= hair_color,
			"facial_hair_color"		= facial_hair_color,
			"eye_color"				= eye_color,
			"skin_tone"				= skin_tone,
			"hair_style_name"		= hair_style,
			"facial_style_name"		= facial_hair_style,
			"underwear"				= underwear,
			"undershirt"			= undershirt,
			"socks"					= socks,
			"backbag"				= backbag,
			"uplink_loc"			= uplink_spawn_loc,
			"species"				= pref_species.id,
			"features"				= features,
			"custom_names"			= custom_names,
			"prefered_security_department" = prefered_security_department,
			"joblessrole" = joblessrole,
			"job_civilian_high" = job_civilian_high,
			"job_civilian_med" = job_civilian_med,
			"job_civilian_low" = job_civilian_low,
			"job_medsci_high" = job_medsci_high,
			"job_medsci_med" = job_medsci_med,
			"job_medsci_low" = job_medsci_low,
			"job_engsec_high" = job_engsec_high,
			"job_engsec_med" = job_engsec_med,
			"job_engsec_low" = job_engsec_low,
			"all_quirks" = all_quirks,
			"positive_quirks" = positive_quirks,
			"negative_quirks" = negative_quirks,
			"neutral_quirks" = neutral_quirks
			)

	//List to JSON
	var/json_to_file = json_encode(character_list)
	if(!json_to_file)
		testing("Saving: [path] failed jsonencode")
		return FALSE

	//Write it out
#ifdef RUST_G
	call(RUST_G, "file_write")(json_to_file, path)
#else
	// Fall back to using old format if we are not using rust-g
	if(fexists(path))
		fdel(path) //Byond only supports APPENDING to files, not replacing.
	text2file(json_to_file, path)
#endif
	if(!fexists(path))
		testing("Saving: [path] failed file write")
		return FALSE

	return TRUE


//Can do conversions here
/datum/preferences/proc/patch_version(var/list/json_from_file,var/version)
	return json_from_file

#undef SAVEJSON_VERSION_MAX
#undef SAVEJSON_VERSION_MIN



#ifdef TESTING
//DEBUG
//Some crude tools for testing savefiles
//path is the savefile path
/client/verb/savefile_export(path as text)
	var/savefile/S = new /savefile(path)
	S.ExportText("/",file("[path].txt"))
//path is the savefile path
/client/verb/savefile_import(path as text)
	var/savefile/S = new /savefile(path)
	S.ImportText("/",file("[path].txt"))

#endif
