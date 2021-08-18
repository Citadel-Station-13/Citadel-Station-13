/datum/preferences_collection/character/vore
	name = "Vore"
	save_key = PREFERENCES_SAVE_KEY_VORE
	sort_order = 1000


	//bad stuff
	var/vore_flags = 0
	var/list/belly_prefs = list()
	var/vore_taste = "nothing in particular"
	var/vore_smell = null

	S["vore_flags"]						>> vore_flags
	S["vore_taste"]						>> vore_taste
	S["vore_smell"]						>> vore_smell
	var/char_vr_path = "[vr_path]/character_[default_slot]_v2.json"
	if(fexists(char_vr_path))
		var/list/json_from_file = json_decode(file2text(char_vr_path))
		if(json_from_file)
			belly_prefs = json_from_file["belly_prefs"]

	vore_flags						= sanitize_integer(vore_flags, 0, MAX_VORE_FLAG, 0)
	vore_taste						= copytext(vore_taste, 1, MAX_TASTE_LEN)
	vore_smell						= copytext(vore_smell, 1, MAX_TASTE_LEN)
	belly_prefs 					= SANITIZE_LIST(belly_prefs)
