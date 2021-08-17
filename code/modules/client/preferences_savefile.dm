

/datum/preferences/proc/load_character(slot, bypass_cooldown = FALSE)
	if(!path)
		return FALSE
	if(!bypass_cooldown)
		if(world.time < loadcharcooldown) //This is before the check to see if the filepath exists to ensure that BYOND can't get hung up on read attempts when the hard drive is a little slow
			if(istype(parent))
				to_chat(parent, "<span class='warning'>You're attempting to load your character a little too fast. Wait half a second, then try again.</span>")
			return "SLOW THE FUCK DOWN" //the reason this isn't null is to make sure that people don't have their character slots overridden by random chars if they accidentally double-click a slot
		loadcharcooldown = world.time + PREF_SAVELOAD_COOLDOWN
	if(!fexists(path))
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	features = list("mcolor" = "FFFFFF", "mcolor2" = "FFFFFF", "mcolor3" = "FFFFFF", "tail_lizard" = "Smooth", "tail_human" = "None", "snout" = "Round", "horns" = "None", "horns_color" = "85615a", "ears" = "None", "wings" = "None", "wings_color" = "FFF", "frills" = "None", "deco_wings" = "None", "spines" = "None", "legs" = "Plantigrade", "insect_wings" = "Plain", "insect_fluff" = "None", "insect_markings" = "None", "arachnid_legs" = "Plain", "arachnid_spinneret" = "Plain", "arachnid_mandibles" = "Plain", "mam_body_markings" = "Plain", "mam_ears" = "None", "mam_snouts" = "None", "mam_tail" = "None", "mam_tail_animated" = "None", "xenodorsal" = "Standard", "xenohead" = "Standard", "xenotail" = "Xenomorph Tail", "taur" = "None", "ipc_screen" = "Sunburst", "ipc_antenna" = "None", "flavor_text" = "", "silicon_flavor_text" = "", "ooc_notes" = "", "meat_type" = "Mammalian", "body_model" = MALE, "body_size" = RESIZE_DEFAULT_SIZE, "color_scheme" = OLD_CHARACTER_COLORING)

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
		return FALSE

	. = TRUE

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


	scars_index = rand(1,5) // WHY

	//Character
	S["custom_species"]			>> custom_species
	S["body_is_always_random"]	>> be_random_body
	S["gender"]					>> gender
	S["body_model"]				>> features["body_model"]
	S["body_size"]				>> features["body_size"]
	S["age"]					>> age
	S["hair_color"]				>> hair_color
	S["facial_hair_color"]		>> facial_hair_color
	S["eye_type"]				>> eye_type
	S["left_eye_color"]			>> left_eye_color
	S["right_eye_color"]		>> right_eye_color
	S["use_custom_skin_tone"]	>> use_custom_skin_tone
	S["skin_tone"]				>> skin_tone
	S["hair_style_name"]		>> hair_style
	S["facial_style_name"]		>> facial_hair_style
	S["underwear"]				>> underwear
	S["undie_color"]			>> undie_color
	S["undershirt"]				>> undershirt
	S["shirt_color"]			>> shirt_color
	S["socks"]					>> socks
	S["socks_color"]			>> socks_color
	S["backbag"]				>> backbag
	S["jumpsuit_style"]			>> jumpsuit_style
	S["uplink_loc"]				>> uplink_spawn_loc
	S["feature_mcolor"]					>> features["mcolor"]
	S["feature_lizard_tail"]			>> features["tail_lizard"]
	S["feature_lizard_snout"]			>> features["snout"]
	S["feature_lizard_horns"]			>> features["horns"]
	S["feature_lizard_frills"]			>> features["frills"]
	S["feature_lizard_spines"]			>> features["spines"]
	S["feature_lizard_legs"]			>> features["legs"]
	S["feature_human_tail"]				>> features["tail_human"]
	S["feature_human_ears"]				>> features["ears"]
	S["feature_deco_wings"]				>> features["deco_wings"]
	S["feature_insect_wings"]			>> features["insect_wings"]
	S["feature_insect_fluff"]			>> features["insect_fluff"]
	S["feature_insect_markings"]		>> features["insect_markings"]
	S["feature_arachnid_legs"]			>> features["arachnid_legs"]
	S["feature_arachnid_spinneret"]		>> features["arachnid_spinneret"]
	S["feature_arachnid_mandibles"]		>> features["arachnid_mandibles"]
	S["feature_horns_color"]			>> features["horns_color"]
	S["feature_wings_color"]			>> features["wings_color"]
	S["feature_color_scheme"]			>> features["color_scheme"]
	S["persistent_scars"] 				>> persistent_scars
	S["scars1"]							>> scars_list["1"]
	S["scars2"]							>> scars_list["2"]
	S["scars3"]							>> scars_list["3"]
	S["scars4"]							>> scars_list["4"]
	S["scars5"]							>> scars_list["5"]
	var/limbmodstr
	S["modified_limbs"] >> limbmodstr
	if(length(limbmodstr))
		modified_limbs = safe_json_decode(limbmodstr)
	else
		modified_limbs = list()

	var/tcgcardstr
	S["tcg_cards"] >> tcgcardstr
	if(length(tcgcardstr))
		tcg_cards = safe_json_decode(tcgcardstr)
	else
		tcg_cards = list()

	var/tcgdeckstr
	S["tcg_decks"] >> tcgdeckstr
	if(length(tcgdeckstr))
		tcg_decks = safe_json_decode(tcgdeckstr)
	else
		tcg_decks = list()

	S["chosen_limb_id"]					>> chosen_limb_id

	S["preferred_ai_core_display"]		>> preferred_ai_core_display



	//Records
	S["security_records"]			>>			security_records
	S["medical_records"]			>>			medical_records

	//Citadel code
	S["feature_mcolor2"]				>> features["mcolor2"]
	S["feature_mcolor3"]				>> features["mcolor3"]
	// note safe json decode will runtime the first time it migrates but this is fine and it solves itself don't worry about it if you see it error
	features["mam_body_markings"] = safe_json_decode(S["feature_mam_body_markings"])
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

	//flavor text
	//Let's make our players NOT cry desperately as we wipe their savefiles of their special snowflake texts:
	if((S["flavor_text"] != "") && (S["flavor_text"] != null) && S["flavor_text"]) //If old text isn't null and isn't "" but still exists.
		S["flavor_text"]				>> features["flavor_text"] //Load old flavortext as current dna-based flavortext

		WRITE_FILE(S["feature_flavor_text"], features["flavor_text"]) //Save it in our new type of flavor-text
		WRITE_FILE(S["flavor_text"]	, "") //Remove old flavortext, completing the cut-and-paste into the new format.

	else //We have no old flavortext, default to new
		S["feature_flavor_text"]		>> features["flavor_text"]


	S["silicon_feature_flavor_text"]		>> features["silicon_flavor_text"]

	S["feature_ooc_notes"]				>> features["ooc_notes"]
	S["silicon_flavor_text"] >> features["silicon_flavor_text"]

	S["vore_flags"]						>> vore_flags
	S["vore_taste"]						>> vore_taste
	S["vore_smell"]						>> vore_smell
	var/char_vr_path = "[vr_path]/character_[default_slot]_v2.json"
	if(fexists(char_vr_path))
		var/list/json_from_file = json_decode(file2text(char_vr_path))
		if(json_from_file)
			belly_prefs = json_from_file["belly_prefs"]


	//try to fix any outdated data if necessary
	//preference updating will handle saving the updated data for us.
	if(needs_update >= 0)
		update_character(needs_update, S)		//needs_update == savefile_version if we need an update (positive integer)

	//Sanitize

	gender		= sanitize_gender(gender, TRUE, TRUE)
	features["body_model"] = sanitize_gender(features["body_model"], FALSE, FALSE, gender == FEMALE ? FEMALE : MALE)
	custom_species	= reject_bad_name(custom_species)

	be_random_body	= sanitize_integer(be_random_body, 0, 1, initial(be_random_body))

	hair_style					= sanitize_inlist(hair_style, GLOB.hair_styles_list)
	facial_hair_style			= sanitize_inlist(facial_hair_style, GLOB.facial_hair_styles_list)
	underwear					= sanitize_inlist(underwear, GLOB.underwear_list)
	undershirt 					= sanitize_inlist(undershirt, GLOB.undershirt_list)
	undie_color						= sanitize_hexcolor(undie_color, 6, FALSE, initial(undie_color))
	shirt_color						= sanitize_hexcolor(shirt_color, 6, FALSE, initial(shirt_color))
	socks							= sanitize_inlist(socks, GLOB.socks_list)
	socks_color						= sanitize_hexcolor(socks_color, 6, FALSE, initial(socks_color))
	age								= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	hair_color						= sanitize_hexcolor(hair_color, 6, FALSE)
	facial_hair_color				= sanitize_hexcolor(facial_hair_color, 6, FALSE)
	eye_type						= sanitize_inlist(eye_type, GLOB.eye_types, DEFAULT_EYES_TYPE)
	left_eye_color					= sanitize_hexcolor(left_eye_color, 6, FALSE)
	right_eye_color					= sanitize_hexcolor(right_eye_color, 6, FALSE)

	var/static/allow_custom_skintones
	if(isnull(allow_custom_skintones))
		allow_custom_skintones = CONFIG_GET(flag/allow_custom_skintones)
	use_custom_skin_tone			= allow_custom_skintones ? sanitize_integer(use_custom_skin_tone, FALSE, TRUE, initial(use_custom_skin_tone)) : FALSE
	if(use_custom_skin_tone)
		skin_tone					= sanitize_hexcolor(skin_tone, 6, TRUE, "#FFFFFF")
	else
		skin_tone					= sanitize_inlist(skin_tone, GLOB.skin_tones - GLOB.nonstandard_skin_tones, initial(skin_tone))

	features["horns_color"]			= sanitize_hexcolor(features["horns_color"], 6, FALSE, "85615a")
	features["wings_color"]			= sanitize_hexcolor(features["wings_color"], 6, FALSE, "FFFFFF")
	backbag							= sanitize_inlist(backbag, GLOB.backbaglist, initial(backbag))
	jumpsuit_style					= sanitize_inlist(jumpsuit_style, GLOB.jumpsuitlist, initial(jumpsuit_style))
	uplink_spawn_loc				= sanitize_inlist(uplink_spawn_loc, GLOB.uplink_spawn_loc_list, initial(uplink_spawn_loc))
	features["mcolor"]				= sanitize_hexcolor(features["mcolor"], 6, FALSE)
	features["tail_lizard"]			= sanitize_inlist(features["tail_lizard"], GLOB.tails_list_lizard)
	features["tail_human"]			= sanitize_inlist(features["tail_human"], GLOB.tails_list_human)
	features["snout"]				= sanitize_inlist(features["snout"], GLOB.snouts_list)
	features["horns"]				= sanitize_inlist(features["horns"], GLOB.horns_list)
	features["ears"]				= sanitize_inlist(features["ears"], GLOB.ears_list)
	features["frills"]				= sanitize_inlist(features["frills"], GLOB.frills_list)
	features["spines"]				= sanitize_inlist(features["spines"], GLOB.spines_list)
	features["legs"]				= sanitize_inlist(features["legs"], GLOB.legs_list, "Plantigrade")
	features["deco_wings"] 			= sanitize_inlist(features["deco_wings"], GLOB.deco_wings_list, "None")
	features["insect_fluff"]		= sanitize_inlist(features["insect_fluff"], GLOB.insect_fluffs_list)
	features["insect_markings"] 	= sanitize_inlist(features["insect_markings"], GLOB.insect_markings_list, "None")
	features["insect_wings"] 		= sanitize_inlist(features["insect_wings"], GLOB.insect_wings_list)
	features["arachnid_legs"] 		= sanitize_inlist(features["arachnid_legs"], GLOB.arachnid_legs_list, "Plain")
	features["arachnid_spinneret"] 	= sanitize_inlist(features["arachnid_spinneret"], GLOB.arachnid_spinneret_list, "Plain")
	features["arachnid_mandibles"]	= sanitize_inlist(features["arachnid_mandibles"], GLOB.arachnid_mandibles_list, "Plain")

	var/static/size_min
	if(!size_min)
		size_min = CONFIG_GET(number/body_size_min)
	var/static/size_max
	if(!size_max)
		size_max = CONFIG_GET(number/body_size_max)
	features["body_size"]			= sanitize_num_clamp(features["body_size"], size_min, size_max, RESIZE_DEFAULT_SIZE, 0.01)

	security_records				= copytext(security_records, 1, MAX_FLAVOR_LEN)
	medical_records					= copytext(medical_records, 1, MAX_FLAVOR_LEN)

	features["flavor_text"]			= copytext(features["flavor_text"], 1, MAX_FLAVOR_LEN)
	features["silicon_flavor_text"]			= copytext(features["silicon_flavor_text"], 1, MAX_FLAVOR_LEN)
	features["ooc_notes"]			= copytext(features["ooc_notes"], 1, MAX_FLAVOR_LEN)

	//load every advanced coloring mode thing in one go
	//THIS MUST BE DONE AFTER ALL FEATURE SAVES OR IT WILL NOT WORK
	for(var/feature in features)
		var/feature_value = features[feature]
		if(feature_value)
			var/ref_list = GLOB.mutant_reference_list[feature]
			if(ref_list)
				var/datum/sprite_accessory/accessory = ref_list[feature_value]
				if(accessory)
					var/mutant_string = accessory.mutant_part_string
					if(!mutant_string)
						if(istype(accessory, /datum/sprite_accessory/mam_body_markings))
							mutant_string = "mam_body_markings"
					var/primary_string = "[mutant_string]_primary"
					var/secondary_string = "[mutant_string]_secondary"
					var/tertiary_string = "[mutant_string]_tertiary"
					if(accessory.color_src == MATRIXED && !accessory.matrixed_sections && feature_value != "None")
						message_admins("Sprite Accessory Failure (loading data): Accessory [accessory.type] is a matrixed item without any matrixed sections set!")
						continue
					if(S["feature_[primary_string]"])
						S["feature_[primary_string]"]		>> features[primary_string]
					if(S["feature_[secondary_string]"])
						S["feature_[secondary_string]"]		>> features[secondary_string]
					if(S["feature_[tertiary_string]"])
						S["feature_[tertiary_string]"]		>> features[tertiary_string]

	persistent_scars = sanitize_integer(persistent_scars)
	scars_list["1"] = sanitize_text(scars_list["1"])
	scars_list["2"] = sanitize_text(scars_list["2"])
	scars_list["3"] = sanitize_text(scars_list["3"])
	scars_list["4"] = sanitize_text(scars_list["4"])
	scars_list["5"] = sanitize_text(scars_list["5"])



	vore_flags						= sanitize_integer(vore_flags, 0, MAX_VORE_FLAG, 0)
	vore_taste						= copytext(vore_taste, 1, MAX_TASTE_LEN)
	vore_smell						= copytext(vore_smell, 1, MAX_TASTE_LEN)
	belly_prefs 					= SANITIZE_LIST(belly_prefs)

	cit_character_pref_load(S)

	return 1

/datum/preferences/proc/save_character(bypass_cooldown = FALSE)
	if(!path)
		return 0
	if(!bypass_cooldown)
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
	WRITE_FILE(S["custom_species"]			, custom_species)
	WRITE_FILE(S["body_is_always_random"]	, be_random_body)
	WRITE_FILE(S["gender"]					, gender)
	WRITE_FILE(S["body_model"]				, features["body_model"])
	WRITE_FILE(S["body_size"]				, features["body_size"])
	WRITE_FILE(S["age"]						, age)
	WRITE_FILE(S["hair_color"]				, hair_color)
	WRITE_FILE(S["facial_hair_color"]		, facial_hair_color)
	WRITE_FILE(S["eye_type"]				, eye_type)
	WRITE_FILE(S["left_eye_color"]			, left_eye_color)
	WRITE_FILE(S["right_eye_color"]			, right_eye_color)
	WRITE_FILE(S["use_custom_skin_tone"]	, use_custom_skin_tone)
	WRITE_FILE(S["skin_tone"]				, skin_tone)
	WRITE_FILE(S["hair_style_name"]			, hair_style)
	WRITE_FILE(S["facial_style_name"]		, facial_hair_style)
	WRITE_FILE(S["underwear"]				, underwear)
	WRITE_FILE(S["undie_color"]				, undie_color)
	WRITE_FILE(S["undershirt"]				, undershirt)
	WRITE_FILE(S["shirt_color"]				, shirt_color)
	WRITE_FILE(S["socks"]					, socks)
	WRITE_FILE(S["socks_color"]				, socks_color)
	WRITE_FILE(S["backbag"]					, backbag)
	WRITE_FILE(S["jumpsuit_style"]			, jumpsuit_style)
	WRITE_FILE(S["uplink_loc"]				, uplink_spawn_loc)
	WRITE_FILE(S["species"]					, pref_species.id)

	// records
	WRITE_FILE(S["security_records"]		, security_records)
	WRITE_FILE(S["medical_records"]			, medical_records)

	WRITE_FILE(S["feature_mcolor"]					, features["mcolor"])
	WRITE_FILE(S["feature_lizard_tail"]				, features["tail_lizard"])
	WRITE_FILE(S["feature_human_tail"]				, features["tail_human"])
	WRITE_FILE(S["feature_lizard_snout"]			, features["snout"])
	WRITE_FILE(S["feature_lizard_horns"]			, features["horns"])
	WRITE_FILE(S["feature_human_ears"]				, features["ears"])
	WRITE_FILE(S["feature_lizard_frills"]			, features["frills"])
	WRITE_FILE(S["feature_lizard_spines"]			, features["spines"])
	WRITE_FILE(S["feature_lizard_legs"]				, features["legs"])
	WRITE_FILE(S["feature_deco_wings"]				, features["deco_wings"])
	WRITE_FILE(S["feature_horns_color"]				, features["horns_color"])
	WRITE_FILE(S["feature_wings_color"]				, features["wings_color"])
	WRITE_FILE(S["feature_insect_wings"]			, features["insect_wings"])
	WRITE_FILE(S["feature_insect_fluff"]			, features["insect_fluff"])
	WRITE_FILE(S["feature_insect_markings"]			, features["insect_markings"])
	WRITE_FILE(S["feature_arachnid_legs"]			, features["arachnid_legs"])
	WRITE_FILE(S["feature_arachnid_spinneret"]		, features["arachnid_spinneret"])
	WRITE_FILE(S["feature_arachnid_mandibles"]		, features["arachnid_mandibles"])
	WRITE_FILE(S["feature_meat"]					, features["meat_type"])

	WRITE_FILE(S["feature_ooc_notes"], features["ooc_notes"])

	WRITE_FILE(S["feature_color_scheme"], features["color_scheme"])

	//save every advanced coloring mode thing in one go
	for(var/feature in features)
		var/feature_value = features[feature]
		if(feature_value)
			var/ref_list = GLOB.mutant_reference_list[feature]
			if(ref_list)
				var/datum/sprite_accessory/accessory = ref_list[feature_value]
				if(accessory)
					var/mutant_string = accessory.mutant_part_string
					if(!mutant_string)
						if(istype(accessory, /datum/sprite_accessory/mam_body_markings))
							mutant_string = "mam_body_markings"
					var/primary_string = "[mutant_string]_primary"
					var/secondary_string = "[mutant_string]_secondary"
					var/tertiary_string = "[mutant_string]_tertiary"
					if(accessory.color_src == MATRIXED && !accessory.matrixed_sections && feature_value != "None")
						message_admins("Sprite Accessory Failure (saving data): Accessory [accessory.type] is a matrixed item without any matrixed sections set!")
						continue
					if(features[primary_string])
						WRITE_FILE(S["feature_[primary_string]"], features[primary_string])
					if(features[secondary_string])
						WRITE_FILE(S["feature_[secondary_string]"], features[secondary_string])
					if(features[tertiary_string])
						WRITE_FILE(S["feature_[tertiary_string]"], features[tertiary_string])

	WRITE_FILE(S["preferred_ai_core_display"]		,  preferred_ai_core_display)



	WRITE_FILE(S["vore_flags"]			, vore_flags)
	WRITE_FILE(S["vore_taste"]			, vore_taste)
	WRITE_FILE(S["vore_smell"]			, vore_smell)
	var/char_vr_path = "[vr_path]/character_[default_slot]_v2.json"
	var/belly_prefs_json = safe_json_encode(list("belly_prefs" = belly_prefs))
	if(fexists(char_vr_path))
		fdel(char_vr_path)
	text2file(belly_prefs_json,char_vr_path)

	WRITE_FILE(S["persistent_scars"]			, persistent_scars)
	WRITE_FILE(S["scars1"]						, scars_list["1"])
	WRITE_FILE(S["scars2"]						, scars_list["2"])
	WRITE_FILE(S["scars3"]						, scars_list["3"])
	WRITE_FILE(S["scars4"]						, scars_list["4"])
	WRITE_FILE(S["scars5"]						, scars_list["5"])
	if(islist(modified_limbs))
		WRITE_FILE(S["modified_limbs"]				, safe_json_encode(modified_limbs))
	WRITE_FILE(S["chosen_limb_id"],   chosen_limb_id)



	if(length(tcg_cards))
		S["tcg_cards"] << safe_json_encode(tcg_cards)
	else
		S["tcg_cards"] << safe_json_encode(list())

	if(length(tcg_decks))
		S["tcg_decks"] << safe_json_encode(tcg_decks)
	else
		S["tcg_decks"] << safe_json_encode(list())

	cit_character_pref_save(S)

	return 1

