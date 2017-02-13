/datum/preferences/proc/load_preferences(client/C)

	var/DBQuery/query = dbcon.NewQuery({"SELECT
					ooccolor,
					UI_style,
					hotkeys,
					tgui_fancy,
					tgui_lock,
					be_special,
					chat_toggles,
					default_slot,
					toggles,
					ghost_orbit,
					ghost_form,
					ghost_accs,
					ghost_others,
					preferred_map,
					ignoring,
					ghost_hud,
					inquisitive_ghost,
					uses_glasses_colour
					clientfps,
					parallax,
					uplink_spawn_loc,
					arousable
					FROM [format_table_name("preferences")]
					WHERE ckey='[C.ckey]'"}
					)

	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("SQL ERROR during loading player preferences. Error : \[[err]\]\n")
		message_admins("SQL ERROR during loading player preferences. Error : \[[err]\]\n")
		return


	//general preferences
	while(query.NextRow())
		ooccolor = query.item[1]
		UI_style = query.item[2]
		hotkeys = text2num(query.item[3])
		tgui_fancy = query.item[4]
		tgui_lock = query.item[5]
		be_special = params2list(query.item[6])
		chat_toggles = params2list(query.item[7])
		default_slot = text2num(query.item[8])
		toggles = text2num(query.item[9])
		ghost_orbit = query.item[10]
		ghost_form = query.item[11]
		ghost_accs = query.item[12]
		ghost_others = query.item[13]
		preferred_map = query.item[14]
		ignoring = query.item[15]
		ghost_hud = text2num(query.item[16])
		inquisitive_ghost = text2num(query.item[17])
		uses_glasses_colour = text2num(query.item[18])
		clientfps = text2num(query.item[19])
		parallax = text2num(query.item[20])
		uplink_spawn_loc = query.item[21]
		arousable = query.item[22]



	//Sanitize
	ooccolor		= sanitize_hexcolor(ooccolor, initial(ooccolor))
	UI_style		= sanitize_inlist(UI_style, list("Midnight", "Plasmafire", "Retro", "Slimecore", "Operative", "Clockwork"), initial(UI_style))
	hotkeys			= sanitize_integer(hotkeys, 0, 1, initial(hotkeys))
	tgui_fancy		= sanitize_integer(tgui_fancy, 0, 1, initial(tgui_fancy))
	tgui_lock		= sanitize_integer(tgui_lock, 0, 1, initial(tgui_lock))
	default_slot	= sanitize_integer(default_slot, 1, max_save_slots, initial(default_slot))
	toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))
	ghost_form		= sanitize_inlist(ghost_form, ghost_forms, initial(ghost_form))
	ghost_orbit 	= sanitize_inlist(ghost_orbit, ghost_orbits, initial(ghost_orbit))
	ghost_accs		= sanitize_inlist(ghost_accs, ghost_accs_options, GHOST_ACCS_DEFAULT_OPTION)
	ghost_others	= sanitize_inlist(ghost_others, ghost_others_options, GHOST_OTHERS_DEFAULT_OPTION)
	ghost_hud		= sanitize_integer(ghost_hud, 0, 1, initial(ghost_hud))
	inquisitive_ghost	= sanitize_integer(inquisitive_ghost, 0, 1, initial(inquisitive_ghost))
	uses_glasses_colour		= sanitize_integer(uses_glasses_colour, 0, 1, initial(uses_glasses_colour))
	clientfps		= sanitize_integer(clientfps, 0, 1000, 0)
	parallax		= sanitize_integer(parallax, PARALLAX_INSANE, PARALLAX_DISABLE, PARALLAX_HIGH)
	uplink_spawn_loc = sanitize_inlist(uplink_spawn_loc, uplink_spawn_loc_list, initial(uplink_spawn_loc))
	arousable		= sanitize_integer(arousable, 0, 1, initial(arousable))


	return 1

/datum/preferences/proc/save_preferences(client/C)

	// Might as well scrub out any malformed be_special list entries while we're here
	for(var/role in be_special)
		if(!(role in special_roles))
			CRASH("[C.key] had a malformed role entry: '[role]'")
			be_special -= role

	var/DBQuery/query = dbcon.NewQuery({"UPDATE [format_table_name("player")]
				SET	ooccolor='[ooccolor]',
					UI_style='[UI_style]',
					hotkeys='[hotkeys]',
					tgui_fancy='[tgui_fancy]',
					tgui_lock='[tgui_lock]',
					be_special='[sanitizeSQL(list2params(be_special))]',
					chat_toggles='[chat_toggles]',
					default_slot='[default_slot]',
					toggles='[toggles]',
					ghost_orbit='[ghost_orbit]',
					ghost_form='[ghost_form]',
					ghost_accs='[ghost_accs]',
					ghost_others='[ghost_others]',
					preferred_map='[preferred_map]',
					ignoring='[ignoring]',
					ghost_hud='[ghost_hud]',
					inquisitive_ghost='[inquisitive_ghost]',
					uses_glasses_colour='[uses_glasses_colour]',
					clientfps='[clientfps]',
					parallax='[parallax]',
					uplink_spawn_loc='[uplink_spawn_loc]',
					arousable='[arousable]'
					WHERE ckey='[C.ckey]'"}
					)

	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("SQL ERROR during saving player preferences. Error : \[[err]\]\n")
		message_admins("SQL ERROR during saving player preferences. Error : \[[err]\]\n")
		return
	return 1

/datum/preferences/proc/load_character(client/C,slot)

	if(!slot)	slot = default_slot
	slot = sanitize_integer(slot, 1, max_save_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		var/DBQuery/firstquery = dbcon.NewQuery("UPDATE [format_table_name("characters")] SET default_slot=[slot] WHERE ckey='[C.ckey]'")
		firstquery.Execute()

	// Let's not have this explode if you sneeze on the DB
	var/DBQuery/query = dbcon.NewQuery({"SELECT
					metadata,
					real_name,
					be_random_name,
					be_random_body,
					gender,
					age,
					pref_species,
					features,
					custom_names,
					hair_style,
					facial_hair_style,
					skin_tone,
					facial_hair_color,
					eye_color,
					hair_color,
					socks,
					underwear,
					undershirt,
					backbag,
					joblessrole,
					job_civilian_high,
					job_civilian_med,
					job_civilian_low,
					job_medsci_high,
					job_medsci_med,
					job_medsci_low,
					job_engsec_high,
					job_engsec_med,
					job_engsec_low,
					flavor_text,
					prefered_security_department,
					belly_prefs,
					devourable,
					digestable,
					size_scale,
				 	FROM [format_table_name("characters")] WHERE ckey='[C.ckey]' AND slot='[slot]'"})
	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("SQL ERROR during character slot loading. Error : \[[err]\]\n")
		message_admins("SQL ERROR during character slot loading. Error : \[[err]\]\n")
		return

	while(query.NextRow())
		//Character
		metadata = query.item[1]
		real_name = query.item[2]
		be_random_name = text2num(query.item[3])
		be_random_body = text2num(query.item[4])
		gender = query.item[5]
		age = text2num(query.item[5])
		pref_species = query.item[6]

		//colors to be consolidated into hex strings (requires some work with dna code)
		features = params2list(query.item[7])
		custom_names = query.item[8]
		hair_style = query.item[9]
		facial_hair_style = query.item[10]
		skin_tone = text2num(query.item[11])
		facial_hair_color = text2num(query.item[12])
		eye_color = text2num(query.item[13])
		hair_color = text2num(query.item[14])
		socks = query.item[15]
		underwear = query.item[16]
		undershirt = query.item[17]
		backbag = text2num(query.item[18])
		//Jobs
		joblessrole = text2num(query.item[19])
		job_civilian_high = text2num(query.item[20])
		job_civilian_med = text2num(query.item[21])
		job_civilian_low = text2num(query.item[22])
		job_medsci_high = text2num(query.item[23])
		job_medsci_med = text2num(query.item[24])
		job_medsci_low = text2num(query.item[25])
		job_engsec_high = text2num(query.item[26])
		job_engsec_med = text2num(query.item[27])
		job_engsec_low = text2num(query.item[28])

		flavor_text = query.item[29]
		if(findtext(flavor_text, "<")) // ... so let's clumsily check for tags!
			flavor_text = html_encode(flavor_text)
		prefered_security_department = query.item[30]
		belly_prefs = query.item[31]
		// Apparently, the preceding vars weren't always encoded properly...
		if(findtext(belly_prefs, "<"))
			belly_prefs = html_encode(belly_prefs)
		devourable = text2num(query.item[32])
		digestable = text2num(query.item[33])
		size_scale = query.item[34]

	//Sanitize

	metadata		= sanitize_text(metadata, initial(metadata))
	real_name		= reject_bad_name(real_name)
	if(!real_name)
		real_name	= random_unique_name(gender)
	be_random_name	= sanitize_integer(be_random_name, 0, 1, initial(be_random_name))
	be_random_body	= sanitize_integer(be_random_body, 0, 1, initial(be_random_body))
	gender			= sanitize_gender(gender)
	age				= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	if(isnull(pref_species)) pref_species = "Human"
	if(!features["mcolor"] || features["mcolor"] == "#000")
		features["mcolor"]	= pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	if(!features["mcolor2"] || features["mcolor"] == "#000")
		features["mcolor2"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	if(!features["mcolor3"] || features["mcolor"] == "#000")
		features["mcolor3"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	if(!real_name)
		real_name = random_unique_name(gender)
	features["mcolor"]		= sanitize_hexcolor(features["mcolor"], 3, 0)
	features["mcolor2"]		= sanitize_hexcolor(features["mcolor2"], 3, 0)
	features["mcolor3"]		= sanitize_hexcolor(features["mcolor3"], 3, 0)
	features["tail_lizard"]	= sanitize_inlist(features["tail_lizard"], tails_list_lizard)
	features["tail_human"] 	= sanitize_inlist(features["tail_human"], tails_list_human, "None")
	features["snout"]		= sanitize_inlist(features["snout"], snouts_list, "Sharp")
	features["horns"]		= sanitize_inlist(features["horns"], horns_list, "None")
	features["ears"]		= sanitize_inlist(features["ears"], ears_list, "None")
	features["frills"]		= sanitize_inlist(features["frills"], frills_list)
	features["spines"]		= sanitize_inlist(features["spines"], spines_list)
	features["body_markings"] 	= sanitize_inlist(features["body_markings"], body_markings_list)
	features["mam_body_markings"] 	= sanitize_inlist(features["mam_body_markings"], mam_body_markings_list, "Fox")
	features["mam_ears"] 	= sanitize_inlist(features["mam_ears"], mam_ears_list, "Fox")
	features["mam_tail"] 	= sanitize_inlist(features["mam_tail"], mam_tails_list, "Fox")
	features["taur"]		= sanitize_inlist(features["taur"], taur_list, "None")
	//Xeno features
	features["xenotail"] 	= sanitize_inlist(features["xenotail"], xeno_tail_list)
	features["xenohead"] 	= sanitize_inlist(features["xenohead"], xeno_head_list)
	features["xenodorsal"] 	= sanitize_inlist(features["xenodorsal"], xeno_dorsal_list)
	features["feature_lizard_legs"]	= sanitize_inlist(features["legs"], legs_list, "Normal Legs")
	if(gender == MALE)
		hair_style			= sanitize_inlist(hair_style, hair_styles_male_list)
		facial_hair_style	= sanitize_inlist(facial_hair_style, facial_hair_styles_male_list)
		underwear			= sanitize_inlist(underwear, underwear_m)
		undershirt 			= sanitize_inlist(undershirt, undershirt_m)
	else
		hair_style			= sanitize_inlist(hair_style, hair_styles_female_list)
		facial_hair_style	= sanitize_inlist(facial_hair_style, facial_hair_styles_female_list)
		underwear			= sanitize_inlist(underwear, underwear_f)
		undershirt			= sanitize_inlist(undershirt, undershirt_f)
	skin_tone			= sanitize_inlist(skin_tone, skin_tones)
	facial_hair_color	= sanitize_hexcolor(facial_hair_color, 3, 0)
	eye_color			= sanitize_hexcolor(eye_color, 3, 0)
	hair_color			= sanitize_hexcolor(hair_color, 3, 0)
	socks				= sanitize_inlist(socks, socks_list)
	backbag				= sanitize_inlist(backbag, backbaglist, initial(backbag))
	joblessrole			= sanitize_integer(joblessrole, 1, 3, initial(joblessrole))
	job_civilian_high	= sanitize_integer(job_civilian_high, 0, 65535, initial(job_civilian_high))
	job_civilian_med	= sanitize_integer(job_civilian_med, 0, 65535, initial(job_civilian_med))
	job_civilian_low	= sanitize_integer(job_civilian_low, 0, 65535, initial(job_civilian_low))
	job_medsci_high		= sanitize_integer(job_medsci_high, 0, 65535, initial(job_medsci_high))
	job_medsci_med		= sanitize_integer(job_medsci_med, 0, 65535, initial(job_medsci_med))
	job_medsci_low		= sanitize_integer(job_medsci_low, 0, 65535, initial(job_medsci_low))
	job_engsec_high		= sanitize_integer(job_engsec_high, 0, 65535, initial(job_engsec_high))
	job_engsec_med		= sanitize_integer(job_engsec_med, 0, 65535, initial(job_engsec_med))
	job_engsec_low		= sanitize_integer(job_engsec_low, 0, 65535, initial(job_engsec_low))
	flavor_text			= sanitize_text(flavor_text, initial(flavor_text))
	uplink_spawn_loc	= sanitize_inlist(uplink_spawn_loc, uplink_spawn_loc_list, initial(uplink_spawn_loc))
	belly_prefs			= sanitize_text(belly_prefs, initial(belly_prefs))
	devourable			= sanitize_integer(devourable, 0, 1, initial(devourable))
	digestable			= sanitize_integer(digestable, 0, 1, initial(digestable))
	size_scale 			= sanitize_text(size_scale, initial(size_scale))
	return 1

/datum/preferences/proc/save_character(client/C)
	var/belly_prefs
	if(!isemptylist(belly_prefs))
		belly_prefs = list2params(belly_prefs)

	var/DBQuery/firstquery = dbcon.NewQuery("SELECT slot FROM [format_table_name("characters")] WHERE ckey='[C.ckey]' ORDER BY slot")
	firstquery.Execute()
	while(firstquery.NextRow())
		if(text2num(firstquery.item[1]) == default_slot)
			var/DBQuery/query = dbcon.NewQuery({"UPDATE [format_table_name("characters")] SET
												metadata='[sanitizeSQL(metadata)]',
												real_name='[sanitizeSQL(real_name)]',
												be_random_name='[be_random_name]',
												be_random_body='[be_random_body]',
												gender='[gender]',
												age='[age]',
												pref_species='[sanitizeSQL(pref_species)]',
												features='[sanitizeSQL(features)]',
												custom_names='[sanitizeSQL(custom_names)]',
												hair_style='[sanitizeSQL(hair_style)]',
												facial_hair_style='[sanitizeSQL(facial_hair_style)]',
												skin_tone='[skin_tone]',
												facial_hair_color='[facial_hair_color]',
												eye_color='[eye_color]',
												hair_color='[hair_color]',
												socks='[socks]',
												underwear='[underwear]',
												undershirt='[undershirt]',
												backbag='[backbag]',
												joblessrole='[joblessrole]',
												job_civilian_high='[job_civilian_high]',
												job_civilian_med='[job_civilian_med]',
												job_civilian_low='[job_civilian_low]',
												job_medsci_high='[job_medsci_high]',
												job_medsci_med='[job_medsci_med]',
												job_medsci_low='[job_medsci_low]',
												job_engsec_high='[job_engsec_high]',
												job_engsec_med='[job_engsec_med]',
												job_engsec_low='[job_engsec_low]',
												flavor_text='[sanitizeSQL(flavor_text)]',
												prefered_security_department='[prefered_security_department]',
												belly_prefs='[sanitizeSQL(belly_prefs)]',
												devourable='[devourable]',
												digestable='[digestable]',
												size_scale='[size_scale]'
												WHERE ckey='[C.ckey]'
												AND slot='[default_slot]'"}
												)

			if(!query.Execute())
				var/err = query.ErrorMsg()
				log_game("SQL ERROR during character slot saving. Error : \[[err]\]\n")
				message_admins("SQL ERROR during character slot saving. Error : \[[err]\]\n")
				return
			return 1

	var/DBQuery/query = dbcon.NewQuery({"
					INSERT INTO [format_table_name("characters")] (ckey, slot, metadata,
					real_name,
					be_random_name,
					be_random_body,
					gender,
					age,
					pref_species,
					features,
					custom_names,
					hair_style,
					facial_hair_style,
					skin_tone,
					facial_hair_color,
					eye_color,
					hair_color,
					socks,
					underwear,
					undershirt,
					backbag,
					joblessrole,
					job_civilian_high,
					job_civilian_med,
					job_civilian_low,
					job_medsci_high,
					job_medsci_med,
					job_medsci_low,
					job_engsec_high,
					job_engsec_med,
					job_engsec_low,
					flavor_text,
					prefered_security_department,
					belly_prefs,
					devourable,
					digestable,
					size_play)

					VALUES
											('[C.ckey]', '[default_slot]', '[sanitizeSQL(metadata)]',
												'[sanitizeSQL(real_name)]',
												'[be_random_name]',
												'[be_random_body]',
												'[gender]',
												'[age]',
												'[sanitizeSQL(pref_species)]',
												'[sanitizeSQL(features)]',
												'[sanitizeSQL(custom_names)]',
												'[sanitizeSQL(hair_style)]',
												'[sanitizeSQL(facial_hair_style)]',
												'[skin_tone]',
												'[facial_hair_color]',
												'[eye_color]',
												'[hair_color]',
												'[socks]',
												'[underwear]',
												'[undershirt]',
												'[backbag]',
												'[joblessrole]',
												'[job_civilian_high]',
												'[job_civilian_med]',
												'[job_civilian_low]',
												'[job_medsci_high]',
												'[job_medsci_med]',
												'[job_medsci_low]',
												'[job_engsec_high]',
												'[job_engsec_med]',
												'[job_engsec_low]',
												'[sanitizeSQL(flavor_text)]',
												'[prefered_security_department]',
												'[sanitizeSQL(belly_prefs)]',
												'[devourable]',
												'[digestable]',
												'[size_scale]')

"}
)

	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("SQL ERROR during character slot saving. Error : \[[err]\]\n")
		message_admins("SQL ERROR during character slot saving. Error : \[[err]\]\n")
		return
	return 1

/datum/preferences/proc/load_random_character_slot(client/C)
	var/DBQuery/query = dbcon.NewQuery("SELECT slot FROM [format_table_name("characters")] WHERE ckey='[C.ckey]' ORDER BY slot")
	var/list/saves = list()

	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("SQL ERROR during random character slot picking. Error : \[[err]\]\n")
		message_admins("SQL ERROR during random character slot picking. Error : \[[err]\]\n")
		return

	while(query.NextRow())
		saves += text2num(query.item[1])

	if(!saves.len)
		load_character(C)
		return 0
	load_character(C,pick(saves))
	return 1

/datum/preferences/proc/SetChangelog(client/C,hash)
	lastchangelog=hash
	winset(C, "rpane.changelog", "background-color=none;font-style=")
	var/DBQuery/query = dbcon.NewQuery("UPDATE [format_table_name("player")] SET lastchangelog='[lastchangelog]' WHERE ckey='[C.ckey]'")
	if(!query.Execute())
		var/err = query.ErrorMsg()
		log_game("SQL ERROR during lastchangelog updating. Error : \[[err]\]\n")
		message_admins("SQL ERROR during lastchangelog updating. Error : \[[err]\]\n")
		C << "Couldn't update your last seen changelog, please try again later."
		return
	return 1
