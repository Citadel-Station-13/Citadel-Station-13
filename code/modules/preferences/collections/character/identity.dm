/datum/preferences_collection/character/identity
	save_key = PREFERENCES_SAVE_KEY_IDENTITY
	sort_order = 1

/datum/preferences_collection/character/identity/content(datum/preferences/prefs)
	. = ..()


/datum/preferences_collection/character/identity/sanitize_character(datum/preferences/prefs)
	. = ..()

/datum/preferences_collection/character/identity/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	. = ..()


/datum/preferences_collection/character/identity/copy_to_mob(datum/preferences/prefs, mob/M, flags)
	. = ..()


/datum/preferences_collection/character/identity/savefile_full_overhaul_character(datum/preferences/prefs, list/data, savefile/S, list/errors, current_version)
	. = ..()


	var/real_name						//our character's name
	var/nameless = FALSE				//whether or not our character is nameless
	var/be_random_name = 0				//whether we'll have a random name every round

	real_name = pref_species.random_name(gender,1)

	for(var/custom_name_id in GLOB.preferences_custom_names)
		custom_names[custom_name_id] = get_default_name(custom_name_id)

	var/list/custom_names = list()

			dat += "<h2>Identity</h2>"
			dat += "<table width='100%'><tr><td width='75%' valign='top'>"
			if(jobban_isbanned(user, "appearance"))
				dat += "<b>You are banned from using custom names and appearances. You can continue to adjust your characters, but you will be randomised once you join the game.</b><br>"
			dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=name;task=random'>Random Name</A> "
			dat += "<b>Always Random Name:</b><a style='display:block;width:30px' href='?_src_=prefs;preference=name'>[be_random_name ? "Yes" : "No"]</a><BR>"

			dat += "<b>[nameless ? "Default designation" : "Name"]:</b>"
			dat += "<a href='?_src_=prefs;preference=name;task=input'>[real_name]</a><BR>"
			dat += "<a href='?_src_=prefs;preference=nameless'>Be nameless: [nameless ? "Yes" : "No"]</a><BR>"
			dat += "<br><a href='?_src_=prefs;preference=hide_ckey;task=input'><b>Hide ckey: [hide_ckey ? "Enabled" : "Disabled"]</b></a><br>"

			dat += "<b>Special Names:</b><BR>"
			var/old_group
			for(var/custom_name_id in GLOB.preferences_custom_names)
				var/namedata = GLOB.preferences_custom_names[custom_name_id]
				if(!old_group)
					old_group = namedata["group"]
				else if(old_group != namedata["group"])
					old_group = namedata["group"]
					dat += "<br>"
				dat += "<a href ='?_src_=prefs;preference=[custom_name_id];task=input'><b>[namedata["pref_name"]]:</b> [custom_names[custom_name_id]]</a> "
			dat += "<br><br>"

				if("name")
					real_name = pref_species.random_name(gender,1)

			if(href_list["preference"] in GLOB.preferences_custom_names)
				ask_for_custom_name(user,href_list["preference"])


				if("name")
					var/new_name = input(user, "Choose your character's name:", "Character Preference")  as text|null
					if(new_name)
						new_name = reject_bad_name(new_name)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")
				if("hide_ckey")
					hide_ckey = !hide_ckey
					if(user)
						user.mind?.hide_ckey = hide_ckey
				if("nameless")
					nameless = !nameless
				if("name")
					be_random_name = !be_random_name


	var/hide_ckey = FALSE //pref for hiding if your ckey shows round-end or not
	real_name	= reject_bad_name(real_name)
	if(!real_name)
		real_name	= random_unique_name(gender)
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/namedata = GLOB.preferences_custom_names[custom_name_id]
		custom_names[custom_name_id] = reject_bad_name(custom_names[custom_name_id],namedata["allow_numbers"])
		if(!custom_names[custom_name_id])
			custom_names[custom_name_id] = get_default_name(custom_name_id)
	nameless		= sanitize_integer(nameless, 0, 1, initial(nameless))
	be_random_name	= sanitize_integer(be_random_name, 0, 1, initial(be_random_name))


	WRITE_FILE(S["real_name"]				, real_name)
	WRITE_FILE(S["nameless"]				, nameless)
	WRITE_FILE(S["name_is_always_random"]	, be_random_name)
	WRITE_FILE(S["hide_ckey"]		, hide_ckey)

	//Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
		S[savefile_slot_name] >> custom_names[custom_name_id]

/datum/preferences/proc/get_default_name(name_id)
	switch(name_id)
		if("human")
			return random_unique_name()
		if("ai")
			return pick(GLOB.ai_names)
		if("cyborg")
			return DEFAULT_CYBORG_NAME
		if("clown")
			return pick(GLOB.clown_names)
		if("mime")
			return pick(GLOB.mime_names)
	return random_unique_name()

/datum/preferences/proc/ask_for_custom_name(mob/user,name_id)
	var/namedata = GLOB.preferences_custom_names[name_id]
	if(!namedata)
		return

	var/raw_name = input(user, "Choose your character's [namedata["qdesc"]]:","Character Preference") as text|null
	if(!raw_name)
		if(namedata["allow_null"])
			custom_names[name_id] = get_default_name(name_id)
		else
			return
	else
		var/sanitized_name = reject_bad_name(raw_name,namedata["allow_numbers"])
		if(!sanitized_name)
			to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z,[namedata["allow_numbers"] ? ",0-9," : ""] -, ' and .</font>")
			return
		else
			custom_names[name_id] = sanitized_name
