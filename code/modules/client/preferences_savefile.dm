//This is the lowest supported version, anything below this is completely obsolete and the entire savefile will be wiped.
#define SAVEFILE_VERSION_MIN	18

//This is the current version, anything below this will attempt to update (if it's not obsolete)
//	You do not need to raise this if you are adding new values that have sane defaults.
//	Only raise this value when changing the meaning/format/name/layout of an existing value
//	where you would want the updater procs below to run
#define SAVEFILE_VERSION_MAX	27

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

	if(savefile_version < SAVEFILE_VERSION_MIN)
		S.dir.Cut()
		return -2
	if(savefile_version < SAVEFILE_VERSION_MAX)
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
	if((current_version < 21) && features["meat_type"] && (features["meat_type"] == null))
		features["meat_type"] = "Mammalian"
	if(current_version < 22)

		job_preferences = list() //It loaded null from nonexistant savefile field.

		var/job_civilian_high = 0
		var/job_civilian_med = 0
		var/job_civilian_low = 0

		var/job_medsci_high = 0
		var/job_medsci_med = 0
		var/job_medsci_low = 0

		var/job_engsec_high = 0
		var/job_engsec_med = 0
		var/job_engsec_low = 0

		S["job_civilian_high"]	>> job_civilian_high
		S["job_civilian_med"]	>> job_civilian_med
		S["job_civilian_low"]	>> job_civilian_low
		S["job_medsci_high"]	>> job_medsci_high
		S["job_medsci_med"]		>> job_medsci_med
		S["job_medsci_low"]		>> job_medsci_low
		S["job_engsec_high"]	>> job_engsec_high
		S["job_engsec_med"]		>> job_engsec_med
		S["job_engsec_low"]		>> job_engsec_low

		//Can't use SSjob here since this happens right away on login
		for(var/job in subtypesof(/datum/job))
			var/datum/job/J = job
			var/new_value
			var/fval = initial(J.flag)
			switch(initial(J.department_flag))
				if(CIVILIAN)
					if(job_civilian_high & fval)
						new_value = JP_HIGH
					else if(job_civilian_med & fval)
						new_value = JP_MEDIUM
					else if(job_civilian_low & fval)
						new_value = JP_LOW
				if(MEDSCI)
					if(job_medsci_high & fval)
						new_value = JP_HIGH
					else if(job_medsci_med & fval)
						new_value = JP_MEDIUM
					else if(job_medsci_low & fval)
						new_value = JP_LOW
				if(ENGSEC)
					if(job_engsec_high & fval)
						new_value = JP_HIGH
					else if(job_engsec_med & fval)
						new_value = JP_MEDIUM
					else if(job_engsec_low & fval)
						new_value = JP_LOW
			if(new_value)
				job_preferences["[initial(J.title)]"] = new_value
	else if(current_version < 23) // we are fixing a gamebreaking bug.
		job_preferences = list() //It loaded null from nonexistant savefile field.

	if(current_version < 25)
		var/digi
		S["feature_lizard_legs"] >> digi
		if(digi == "Digitigrade Legs")
			WRITE_FILE(S["feature_lizard_legs"], "Digitigrade")

	if(current_version < 26)
		var/vr_path = "data/player_saves/[parent.ckey[1]]/[parent.ckey]/vore/character[default_slot].json"
		if(fexists(vr_path))
			var/list/json_from_file = json_decode(file2text(vr_path))
			if(json_from_file)
				digestable = json_from_file["digestable"]
				devourable = json_from_file["devourable"]
				feeding = json_from_file["feeding"]
				lickable = json_from_file["lickable"]
				belly_prefs = json_from_file["belly_prefs"]
				vore_taste = json_from_file["vore_taste"]

		for(var/V in all_quirks) // quirk migration
			switch(V)
				if("Acute hepatic pharmacokinesis")
					DISABLE_BITFIELD(cit_toggles, PENIS_ENLARGEMENT)
					DISABLE_BITFIELD(cit_toggles, BREAST_ENLARGEMENT)
					ENABLE_BITFIELD(cit_toggles,FORCED_FEM)
					ENABLE_BITFIELD(cit_toggles,FORCED_MASC)
					all_quirks -= V
				if("Crocin Immunity")
					ENABLE_BITFIELD(cit_toggles,NO_APHRO)
					all_quirks -= V
				if("Buns of Steel")
					ENABLE_BITFIELD(cit_toggles,NO_ASS_SLAP)
					all_quirks -= V

		if(features["meat_type"] == "Inesct")
			features["meat_type"] = "Insect"

	if(current_version < 27)
		var/tennis
		S["feature_balls_shape"] >> tennis
		if(tennis == "Hidden")
			features["balls_visibility"] = GEN_VISIBLE_NEVER

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)
		return
	path = "data/player_saves/[ckey[1]]/[ckey]/[filename]"

/datum/preferences/proc/load_preferences()
	if(!path)
		return 0
	if(world.time < loadprefcooldown)
		if(istype(parent))
			to_chat(parent, "<span class='warning'>You're attempting to load your preferences a little too fast. Wait half a second, then try again.</span>")
		return 0
	loadprefcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	if(!fexists(path))
		return 0

	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"

	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2)		//fatal, can't load any data
		return 0

	//general preferences
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
	S["sprint_spacebar"]	>> sprint_spacebar
	S["sprint_toggle"]		>> sprint_toggle
	S["hud_toggle_flash"]	>> hud_toggle_flash
	S["hud_toggle_color"]	>> hud_toggle_color
	S["menuoptions"]		>> menuoptions
	S["enable_tips"]		>> enable_tips
	S["tip_delay"]			>> tip_delay
	S["pda_style"]			>> pda_style
	S["pda_color"]			>> pda_color
	S["pda_skin"]			>> pda_skin

	//citadel code
	S["arousable"]			>> arousable
	S["screenshake"]		>> screenshake
	S["damagescreenshake"]	>> damagescreenshake
	S["widescreenpref"]		>> widescreenpref
	S["autostand"]			>> autostand
	S["cit_toggles"]		>> cit_toggles
	S["preferred_chaos"]	>> preferred_chaos
	S["auto_ooc"]	>> auto_ooc


	//try to fix any outdated data if necessary
	if(needs_update >= 0)
		update_preferences(needs_update, S)		//needs_update = savefile_version if we need an update (positive integer)

	//Sanitize
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
	sprint_spacebar	= sanitize_integer(sprint_spacebar, 0, 1, initial(sprint_spacebar))
	sprint_toggle	= sanitize_integer(sprint_toggle, 0, 1, initial(sprint_toggle))
	hud_toggle_flash = sanitize_integer(hud_toggle_flash, 0, 1, initial(hud_toggle_flash))
	hud_toggle_color = sanitize_hexcolor(hud_toggle_color, 6, 1, initial(hud_toggle_color))
	ghost_form		= sanitize_inlist(ghost_form, GLOB.ghost_forms, initial(ghost_form))
	ghost_orbit 	= sanitize_inlist(ghost_orbit, GLOB.ghost_orbits, initial(ghost_orbit))
	ghost_accs		= sanitize_inlist(ghost_accs, GLOB.ghost_accs_options, GHOST_ACCS_DEFAULT_OPTION)
	ghost_others	= sanitize_inlist(ghost_others, GLOB.ghost_others_options, GHOST_OTHERS_DEFAULT_OPTION)
	menuoptions		= SANITIZE_LIST(menuoptions)
	be_special		= SANITIZE_LIST(be_special)
	pda_style		= sanitize_inlist(pda_style, GLOB.pda_styles, initial(pda_style))
	pda_color		= sanitize_hexcolor(pda_color, 6, 1, initial(pda_color))
	pda_skin		= sanitize_inlist(pda_skin, GLOB.pda_reskins, PDA_SKIN_ALT)
	screenshake			= sanitize_integer(screenshake, 0, 800, initial(screenshake))
	damagescreenshake	= sanitize_integer(damagescreenshake, 0, 2, initial(damagescreenshake))
	widescreenpref			= sanitize_integer(widescreenpref, 0, 1, initial(widescreenpref))
	autostand			= sanitize_integer(autostand, 0, 1, initial(autostand))
	cit_toggles			= sanitize_integer(cit_toggles, 0, 65535, initial(cit_toggles))
	auto_ooc			= sanitize_integer(auto_ooc, 0, 1, initial(auto_ooc))

	return 1

/datum/preferences/proc/save_preferences()
	if(!path)
		return 0
	if(world.time < saveprefcooldown)
		if(istype(parent))
			to_chat(parent, "<span class='warning'>You're attempting to save your preferences a little too fast. Wait half a second, then try again.</span>")
		return 0
	saveprefcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"

	WRITE_FILE(S["version"] , SAVEFILE_VERSION_MAX)		//updates (or failing that the sanity checks) will ensure data is not invalid at load. Assume up-to-date

	//general preferences
	WRITE_FILE(S["ooccolor"], ooccolor)
	WRITE_FILE(S["lastchangelog"], lastchangelog)
	WRITE_FILE(S["UI_style"], UI_style)
	WRITE_FILE(S["hotkeys"], hotkeys)
	WRITE_FILE(S["tgui_fancy"], tgui_fancy)
	WRITE_FILE(S["tgui_lock"], tgui_lock)
	WRITE_FILE(S["buttons_locked"], buttons_locked)
	WRITE_FILE(S["windowflash"], windowflashing)
	WRITE_FILE(S["be_special"], be_special)
	WRITE_FILE(S["default_slot"], default_slot)
	WRITE_FILE(S["toggles"], toggles)
	WRITE_FILE(S["chat_toggles"], chat_toggles)
	WRITE_FILE(S["ghost_form"], ghost_form)
	WRITE_FILE(S["ghost_orbit"], ghost_orbit)
	WRITE_FILE(S["ghost_accs"], ghost_accs)
	WRITE_FILE(S["ghost_others"], ghost_others)
	WRITE_FILE(S["preferred_map"], preferred_map)
	WRITE_FILE(S["ignoring"], ignoring)
	WRITE_FILE(S["ghost_hud"], ghost_hud)
	WRITE_FILE(S["inquisitive_ghost"], inquisitive_ghost)
	WRITE_FILE(S["uses_glasses_colour"], uses_glasses_colour)
	WRITE_FILE(S["clientfps"], clientfps)
	WRITE_FILE(S["parallax"], parallax)
	WRITE_FILE(S["ambientocclusion"], ambientocclusion)
	WRITE_FILE(S["auto_fit_viewport"], auto_fit_viewport)
	WRITE_FILE(S["sprint_spacebar"], sprint_spacebar)
	WRITE_FILE(S["sprint_toggle"], sprint_toggle)
	WRITE_FILE(S["hud_toggle_flash"], hud_toggle_flash)
	WRITE_FILE(S["hud_toggle_color"], hud_toggle_color)
	WRITE_FILE(S["menuoptions"], menuoptions)
	WRITE_FILE(S["enable_tips"], enable_tips)
	WRITE_FILE(S["tip_delay"], tip_delay)
	WRITE_FILE(S["pda_style"], pda_style)
	WRITE_FILE(S["pda_color"], pda_color)
	WRITE_FILE(S["pda_skin"], pda_skin)

	//citadel code
	WRITE_FILE(S["screenshake"], screenshake)
	WRITE_FILE(S["damagescreenshake"], damagescreenshake)
	WRITE_FILE(S["arousable"], arousable)
	WRITE_FILE(S["widescreenpref"], widescreenpref)
	WRITE_FILE(S["autostand"], autostand)
	WRITE_FILE(S["cit_toggles"], cit_toggles)
	WRITE_FILE(S["preferred_chaos"], preferred_chaos)
	WRITE_FILE(S["auto_ooc"], auto_ooc)

	return 1

/datum/preferences/proc/load_character(slot)
	if(!path)
		return 0
	if(world.time < loadcharcooldown) //This is before the check to see if the filepath exists to ensure that BYOND can't get hung up on read attempts when the hard drive is a little slow
		if(istype(parent))
			to_chat(parent, "<span class='warning'>You're attempting to load your character a little too fast. Wait half a second, then try again.</span>")
		return "SLOW THE FUCK DOWN" //the reason this isn't null is to make sure that people don't have their character slots overridden by random chars if they accidentally double-click a slot
	loadcharcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	if(!fexists(path))
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"
	if(!slot)
		slot = default_slot
	slot = sanitize_integer(slot, 1, max_save_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		WRITE_FILE(S["default_slot"] , slot)

	S.cd = "/character[slot]"
	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2)		//fatal, can't load any data
		return 0

	//Species
	var/species_id
	S["species"]			>> species_id
	if(species_id)
		if(species_id == "avian" || species_id == "aquatic")
			species_id = "mammal"
		else if(species_id == "moth")
			species_id = "insect"

		var/newtype = GLOB.species_list[species_id]
		if(newtype)
			pref_species = new newtype

	if(!S["features["mcolor"]"] || S["features["mcolor"]"] == "#000")
		WRITE_FILE(S["features["mcolor"]"]	, "#FFF")

	if(!S["features["horn_color"]"] || S["features["horn_color"]"] == "#000")
		WRITE_FILE(S["features["horn_color"]"]	, "#85615a")

	if(!S["features["wing_color"]"] || S["features["wing_color"]"] == "#000")
		WRITE_FILE(S["features["wing_color"]"]	, "#FFF")

	//Character
	S["real_name"]				>> real_name
	S["nameless"]				>> nameless
	S["custom_species"]			>> custom_species
	S["name_is_always_random"]	>> be_random_name
	S["body_is_always_random"]	>> be_random_body
	S["gender"]					>> gender
	S["body_model"]				>> features["body_model"]
	S["age"]					>> age
	S["hair_color"]				>> hair_color
	S["facial_hair_color"]		>> facial_hair_color
	S["eye_color"]				>> eye_color
	S["skin_tone"]				>> skin_tone
	S["hair_style_name"]		>> hair_style
	S["facial_style_name"]		>> facial_hair_style
	S["underwear"]				>> underwear
	S["undie_color"]			>> undie_color
	S["undershirt"]				>> undershirt
	S["shirt_color"]			>> shirt_color
	S["socks"]					>> socks
	S["socks_color"]			>> socks_color
	S["horn_color"]				>> horn_color
	S["wing_color"]				>> wing_color
	S["backbag"]				>> backbag
	S["jumpsuit_style"]			>> jumpsuit_style
	S["uplink_loc"]				>> uplink_spawn_loc
	S["feature_mcolor"]					>> features["mcolor"]
	S["feature_lizard_tail"]			>> features["tail_lizard"]
	S["feature_lizard_snout"]			>> features["snout"]
	S["feature_lizard_horns"]			>> features["horns"]
	S["feature_lizard_frills"]			>> features["frills"]
	S["feature_lizard_spines"]			>> features["spines"]
	S["feature_lizard_body_markings"]	>> features["body_markings"]
	S["feature_lizard_legs"]			>> features["legs"]
	S["feature_human_tail"]				>> features["tail_human"]
	S["feature_human_ears"]				>> features["ears"]
	S["feature_deco_wings"]				>> features["deco_wings"]
	S["feature_insect_wings"]			>> features["insect_wings"]
	S["feature_insect_fluff"]			>> features["insect_fluff"]
	S["feature_insect_markings"]		>> features["insect_markings"]

	//Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
		S[savefile_slot_name] >> custom_names[custom_name_id]

	S["preferred_ai_core_display"]		>> preferred_ai_core_display
	S["prefered_security_department"]	>> prefered_security_department

	//Jobs
	S["joblessrole"]		>> joblessrole
	//Load prefs
	S["job_preferences"]	>> job_preferences

	//Quirks
	S["all_quirks"]			>> all_quirks

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
	S["feature_mam_snouts"]				>> features["mam_snouts"]
	S["feature_meat"]					>> features["meat_type"]
	//Xeno features
	S["feature_xeno_tail"]				>> features["xenotail"]
	S["feature_xeno_dors"]				>> features["xenodorsal"]
	S["feature_xeno_head"]				>> features["xenohead"]
	//cock features
	S["feature_has_cock"]				>> features["has_cock"]
	S["feature_cock_shape"]				>> features["cock_shape"]
	S["feature_cock_color"]				>> features["cock_color"]
	S["feature_cock_length"]			>> features["cock_length"]
	S["feature_cock_diameter"]			>> features["cock_diameter"]
	S["feature_cock_visibility"]		>> features["cock_visibility"]
	//balls features
	S["feature_has_balls"]				>> features["has_balls"]
	S["feature_balls_color"]			>> features["balls_color"]
	S["feature_balls_size"]				>> features["balls_size"]
	S["feature_balls_visibility"]		>> features["balls_visibility"]
	//breasts features
	S["feature_has_breasts"]			>> features["has_breasts"]
	S["feature_breasts_size"]			>> features["breasts_size"]
	S["feature_breasts_shape"]			>> features["breasts_shape"]
	S["feature_breasts_color"]			>> features["breasts_color"]
	S["feature_breasts_producing"]		>> features["breasts_producing"]
	S["feature_breasts_visibility"]		>> features["breasts_visibility"]
	//vagina features
	S["feature_has_vag"]				>> features["has_vag"]
	S["feature_vag_shape"]				>> features["vag_shape"]
	S["feature_vag_color"]				>> features["vag_color"]
	S["feature_vag_visibility"]			>> features["vag_visibility"]
	//womb features
	S["feature_has_womb"]				>> features["has_womb"]
	//flavor text
	//Let's make our players NOT cry desperately as we wipe their savefiles of their special snowflake texts:
	if((S["flavor_text"] != "") && (S["flavor_text"] != null) && S["flavor_text"]) //If old text isn't null and isn't "" but still exists.
		S["flavor_text"]				>> features["flavor_text"] //Load old flavortext as current dna-based flavortext

		WRITE_FILE(S["feature_flavor_text"], features["flavor_text"]) //Save it in our new type of flavor-text
		WRITE_FILE(S["flavor_text"]	, "") //Remove old flavortext, completing the cut-and-paste into the new format.

	else //We have no old flavortext, default to new
		S["feature_flavor_text"]		>> features["flavor_text"]

	S["digestable"]						>> digestable
	S["devourable"]						>> devourable
	S["feeding"]						>> feeding
	S["vore_taste"]						>> vore_taste
	S["lickable"]						>> lickable
	S["belly_prefs"]					>> belly_prefs

	//try to fix any outdated data if necessary
	if(needs_update >= 0)
		update_character(needs_update, S)		//needs_update == savefile_version if we need an update (positive integer)

	//Sanitize

	real_name	= reject_bad_name(real_name)
	gender		= sanitize_gender(gender, TRUE, TRUE)
	features["body_model"] = sanitize_gender(features["body_model"], FALSE, FALSE, gender == FEMALE ? FEMALE : MALE)
	if(!real_name)
		real_name	= random_unique_name(gender)
	custom_species	= reject_bad_name(custom_species)
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/namedata = GLOB.preferences_custom_names[custom_name_id]
		custom_names[custom_name_id] = reject_bad_name(custom_names[custom_name_id],namedata["allow_numbers"])
		if(!custom_names[custom_name_id])
			custom_names[custom_name_id] = get_default_name(custom_name_id)

	if(!features["mcolor"] || features["mcolor"] == "#000")
		features["mcolor"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")

	if(!features["horn_color"] || features["horn_color"] == "#000")
		features["horn_color"] = "85615a"

	if(!features["wing_color"] || features["wing_color"] == "#000")
		features["wing_color"] = "FFFFFF"

	nameless		= sanitize_integer(nameless, 0, 1, initial(nameless))
	be_random_name	= sanitize_integer(be_random_name, 0, 1, initial(be_random_name))
	be_random_body	= sanitize_integer(be_random_body, 0, 1, initial(be_random_body))

	hair_style					= sanitize_inlist(hair_style, GLOB.hair_styles_list)
	facial_hair_style			= sanitize_inlist(facial_hair_style, GLOB.facial_hair_styles_list)
	underwear					= sanitize_inlist(underwear, GLOB.underwear_list)
	undershirt 					= sanitize_inlist(undershirt, GLOB.undershirt_list)
	undie_color						= sanitize_hexcolor(undie_color, 3, FALSE, initial(undie_color))
	shirt_color						= sanitize_hexcolor(shirt_color, 3, FALSE, initial(shirt_color))
	socks							= sanitize_inlist(socks, GLOB.socks_list)
	socks_color						= sanitize_hexcolor(socks_color, 3, FALSE, initial(socks_color))
	age								= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	hair_color						= sanitize_hexcolor(hair_color, 3, 0)
	facial_hair_color				= sanitize_hexcolor(facial_hair_color, 3, 0)
	eye_color						= sanitize_hexcolor(eye_color, 3, 0)
	skin_tone						= sanitize_inlist(skin_tone, GLOB.skin_tones)
	horn_color						= sanitize_hexcolor(horn_color, 3, FALSE)
	wing_color						= sanitize_hexcolor(wing_color, 3, FALSE, "#FFFFFF")
	backbag							= sanitize_inlist(backbag, GLOB.backbaglist, initial(backbag))
	jumpsuit_style					= sanitize_inlist(jumpsuit_style, GLOB.jumpsuitlist, initial(jumpsuit_style))
	uplink_spawn_loc				= sanitize_inlist(uplink_spawn_loc, GLOB.uplink_spawn_loc_list, initial(uplink_spawn_loc))
	features["mcolor"]				= sanitize_hexcolor(features["mcolor"], 3, 0)
	features["tail_lizard"]			= sanitize_inlist(features["tail_lizard"], GLOB.tails_list_lizard)
	features["tail_human"]			= sanitize_inlist(features["tail_human"], GLOB.tails_list_human)
	features["snout"]				= sanitize_inlist(features["snout"], GLOB.snouts_list)
	features["horns"]				= sanitize_inlist(features["horns"], GLOB.horns_list)
	features["ears"]				= sanitize_inlist(features["ears"], GLOB.ears_list)
	features["frills"]				= sanitize_inlist(features["frills"], GLOB.frills_list)
	features["spines"]				= sanitize_inlist(features["spines"], GLOB.spines_list)
	features["body_markings"]		= sanitize_inlist(features["body_markings"], GLOB.body_markings_list)
	features["legs"]				= sanitize_inlist(features["legs"], GLOB.legs_list, "Plantigrade")
	features["deco_wings"] 			= sanitize_inlist(features["deco_wings"], GLOB.deco_wings_list, "None")
	features["insect_fluff"]		= sanitize_inlist(features["insect_fluff"], GLOB.insect_fluffs_list)
	features["insect_markings"] 	= sanitize_inlist(features["insect_markings"], GLOB.insect_markings_list, "None")
	features["insect_wings"] 		= sanitize_inlist(features["insect_wings"], GLOB.insect_wings_list)

	var/static/list/B_sizes
	if(!B_sizes)
		var/list/L = CONFIG_GET(keyed_list/breasts_cups_prefs)
		B_sizes = L.Copy()
	var/static/min_D
	if(!min_D)
		min_D = CONFIG_GET(number/penis_min_inches_prefs)
	var/static/max_D
	if(!max_D)
		max_D = CONFIG_GET(number/penis_max_inches_prefs)
	var/static/safe_visibilities
	if(!safe_visibilities)
		var/list/L = CONFIG_GET(keyed_list/safe_visibility_toggles)
		safe_visibilities = L.Copy()

	features["breasts_size"]		= sanitize_inlist(features["breasts_size"], B_sizes, BREASTS_SIZE_DEF)
	features["cock_length"]			= sanitize_integer(features["cock_length"], min_D, max_D, COCK_SIZE_DEF)
	features["breasts_shape"]		= sanitize_inlist(features["breasts_shape"], GLOB.breasts_shapes_list, DEF_BREASTS_SHAPE)
	features["cock_shape"]			= sanitize_inlist(features["cock_shape"], GLOB.cock_shapes_list, DEF_COCK_SHAPE)
	features["balls_shape"]			= sanitize_inlist(features["balls_shape"], GLOB.balls_shapes_list, DEF_BALLS_SHAPE)
	features["vag_shape"]			= sanitize_inlist(features["vag_shape"], GLOB.vagina_shapes_list, DEF_VAGINA_SHAPE)
	features["breasts_color"]		= sanitize_hexcolor(features["breasts_color"], 3, FALSE, "FFF")
	features["cock_color"]			= sanitize_hexcolor(features["cock_color"], 3, FALSE, "FFF")
	features["balls_color"]			= sanitize_hexcolor(features["balls_color"], 3, FALSE, "FFF")
	features["vag_color"]			= sanitize_hexcolor(features["vag_color"], 3, FALSE, "FFF")
	features["breasts_visibility"]	= sanitize_inlist(features["breasts_visibility"], safe_visibilities, GEN_VISIBLE_NO_UNDIES)
	features["cock_visibility"]		= sanitize_inlist(features["cock_visibility"], safe_visibilities, GEN_VISIBLE_NO_UNDIES)
	features["balls_visibility"]	= sanitize_inlist(features["balls_visibility"], safe_visibilities, GEN_VISIBLE_NO_UNDIES)
	features["vag_visibility"]		= sanitize_inlist(features["vag_visibility"], safe_visibilities, GEN_VISIBLE_NO_UNDIES)


	features["flavor_text"]			= copytext(features["flavor_text"], 1, MAX_FLAVOR_LEN)

	joblessrole	= sanitize_integer(joblessrole, 1, 3, initial(joblessrole))
	//Validate job prefs
	for(var/j in job_preferences)
		if(job_preferences["[j]"] != JP_LOW && job_preferences["[j]"] != JP_MEDIUM && job_preferences["[j]"] != JP_HIGH)
			job_preferences -= j

	all_quirks = SANITIZE_LIST(all_quirks)

	lickable						= sanitize_integer(lickable, FALSE, TRUE, initial(lickable))
	devourable						= sanitize_integer(devourable, FALSE, TRUE, initial(devourable))
	digestable						= sanitize_integer(digestable, FALSE, TRUE, initial(digestable))
	feeding							= sanitize_integer(feeding, FALSE, TRUE, initial(feeding))
	vore_taste						= copytext(vore_taste, 1, MAX_TASTE_LEN)
	belly_prefs 					= SANITIZE_LIST(belly_prefs)

	cit_character_pref_load(S)

	return 1

/datum/preferences/proc/save_character()
	if(!path)
		return 0
	if(world.time < savecharcooldown)
		if(istype(parent))
			to_chat(parent, "<span class='warning'>You're attempting to save your character a little too fast. Wait half a second, then try again.</span>")
		return 0
	savecharcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/character[default_slot]"

	WRITE_FILE(S["version"]			, SAVEFILE_VERSION_MAX)	//load_character will sanitize any bad data, so assume up-to-date.)

	//Character
	WRITE_FILE(S["real_name"]				, real_name)
	WRITE_FILE(S["nameless"]				, nameless)
	WRITE_FILE(S["custom_species"]			, custom_species)
	WRITE_FILE(S["name_is_always_random"]	, be_random_name)
	WRITE_FILE(S["body_is_always_random"]	, be_random_body)
	WRITE_FILE(S["gender"]					, gender)
	WRITE_FILE(S["body_model"]				, features["body_model"])
	WRITE_FILE(S["age"]						, age)
	WRITE_FILE(S["hair_color"]				, hair_color)
	WRITE_FILE(S["facial_hair_color"]		, facial_hair_color)
	WRITE_FILE(S["eye_color"]				, eye_color)
	WRITE_FILE(S["skin_tone"]				, skin_tone)
	WRITE_FILE(S["hair_style_name"]			, hair_style)
	WRITE_FILE(S["facial_style_name"]		, facial_hair_style)
	WRITE_FILE(S["underwear"]				, underwear)
	WRITE_FILE(S["undie_color"]				, undie_color)
	WRITE_FILE(S["undershirt"]				, undershirt)
	WRITE_FILE(S["shirt_color"]				, shirt_color)
	WRITE_FILE(S["socks"]					, socks)
	WRITE_FILE(S["socks_color"]				, socks_color)
	WRITE_FILE(S["horn_color"]				, horn_color)
	WRITE_FILE(S["wing_color"]				, wing_color)
	WRITE_FILE(S["backbag"]					, backbag)
	WRITE_FILE(S["jumpsuit_style"]			, jumpsuit_style)
	WRITE_FILE(S["uplink_loc"]				, uplink_spawn_loc)
	WRITE_FILE(S["species"]					, pref_species.id)
	WRITE_FILE(S["feature_mcolor"]					, features["mcolor"])
	WRITE_FILE(S["feature_lizard_tail"]				, features["tail_lizard"])
	WRITE_FILE(S["feature_human_tail"]				, features["tail_human"])
	WRITE_FILE(S["feature_lizard_snout"]			, features["snout"])
	WRITE_FILE(S["feature_lizard_horns"]			, features["horns"])
	WRITE_FILE(S["feature_human_ears"]				, features["ears"])
	WRITE_FILE(S["feature_lizard_frills"]			, features["frills"])
	WRITE_FILE(S["feature_lizard_spines"]			, features["spines"])
	WRITE_FILE(S["feature_lizard_body_markings"]	, features["body_markings"])
	WRITE_FILE(S["feature_lizard_legs"]				, features["legs"])
	WRITE_FILE(S["feature_deco_wings"]				, features["deco_wings"])
	WRITE_FILE(S["feature_insect_wings"]			, features["insect_wings"])
	WRITE_FILE(S["feature_insect_fluff"]			, features["insect_fluff"])
	WRITE_FILE(S["feature_insect_markings"]			, features["insect_markings"])
	WRITE_FILE(S["feature_meat"]					, features["meat_type"])

	WRITE_FILE(S["feature_has_cock"], features["has_cock"])
	WRITE_FILE(S["feature_cock_shape"], features["cock_shape"])
	WRITE_FILE(S["feature_cock_color"], features["cock_color"])
	WRITE_FILE(S["feature_cock_length"], features["cock_length"])
	WRITE_FILE(S["feature_cock_visibility"], features["cock_visibility"])

	WRITE_FILE(S["feature_has_balls"], features["has_balls"])
	WRITE_FILE(S["feature_balls_color"], features["balls_color"])
	WRITE_FILE(S["feature_balls_size"], features["balls_size"])
	WRITE_FILE(S["feature_balls_visibility"], features["balls_visibility"])

	WRITE_FILE(S["feature_has_breasts"], features["has_breasts"])
	WRITE_FILE(S["feature_breasts_size"], features["breasts_size"])
	WRITE_FILE(S["feature_breasts_shape"], features["breasts_shape"])
	WRITE_FILE(S["feature_breasts_color"], features["breasts_color"])
	WRITE_FILE(S["feature_breasts_producing"], features["breasts_producing"])
	WRITE_FILE(S["feature_breasts_visibility"], features["breasts_visibility"])

	WRITE_FILE(S["feature_has_vag"], features["has_vag"])
	WRITE_FILE(S["feature_vag_shape"], features["vag_shape"])
	WRITE_FILE(S["feature_vag_color"], features["vag_color"])
	WRITE_FILE(S["feature_vag_visibility"], features["vag_visibility"])

	WRITE_FILE(S["feature_has_womb"], features["has_womb"])

	//Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
		WRITE_FILE(S[savefile_slot_name],custom_names[custom_name_id])

	WRITE_FILE(S["preferred_ai_core_display"]		,  preferred_ai_core_display)
	WRITE_FILE(S["prefered_security_department"]	, prefered_security_department)

	//Jobs
	WRITE_FILE(S["joblessrole"]		, joblessrole)
	//Write prefs
	WRITE_FILE(S["job_preferences"] , job_preferences)

	//Quirks
	WRITE_FILE(S["all_quirks"]			, all_quirks)

	WRITE_FILE(S["digestable"]			, digestable)
	WRITE_FILE(S["devourable"]			, devourable)
	WRITE_FILE(S["feeding"]				, feeding)
	WRITE_FILE(S["vore_taste"]			, vore_taste)
	WRITE_FILE(S["lickable"]			, lickable)
	WRITE_FILE(S["belly_prefs"]			, belly_prefs)

	cit_character_pref_save(S)

	return 1


#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN

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
