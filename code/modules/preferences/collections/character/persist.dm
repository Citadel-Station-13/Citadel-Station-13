/datum/preferences_collection/character/persist
	name = "Persist"
	save_key = PREFERENCES_SAVE_KEY_PERSIST
	sort_order = 900

/datum/preferences_collection/character/persist/is_visible(client/C)
	return FALSE



	var/list/tcg_cards = list()
	var/list/tcg_decks = list()

	/// We have 5 slots for persistent scars, if enabled we pick a random one to load (empty by default) and scars at the end of the shift if we survived as our original person
	var/list/scars_list = list("1" = "", "2" = "", "3" = "", "4" = "", "5" = "")

	/// Which of the 5 persistent scar slots we randomly roll to load for this round, if enabled. Actually rolled in [/datum/preferences/proc/load_character(slot)]
	var/scars_index = 1

	scars_list["1"] = sanitize_text(scars_list["1"])
	scars_list["2"] = sanitize_text(scars_list["2"])
	scars_list["3"] = sanitize_text(scars_list["3"])
	scars_list["4"] = sanitize_text(scars_list["4"])
	scars_list["5"] = sanitize_text(scars_list["5"])

	scars_index = rand(1,5) // WHY





	S["scars1"]							>> scars_list["1"]
	S["scars2"]							>> scars_list["2"]
	S["scars3"]							>> scars_list["3"]
	S["scars4"]							>> scars_list["4"]
	S["scars5"]							>> scars_list["5"]






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


