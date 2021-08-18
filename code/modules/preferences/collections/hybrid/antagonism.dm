/datum/preferences_collection/hybrid/antagonism
	name = "Antagonism"
	sort_order = 1
	save_key = PREFERENCES_SAVE_KEY_ANTAGONISM

/datum/preferences_collection/hybrid/antagonism/content(datum/preferences/prefs)
	. = ..()
	if(jobban_isbanned(prefs.parent?.mob))
		. += "<center><h1><font color='red'>You are banned from antagonist roles.</font></h1><br>You can still change these settings, but you will not be an antagonist until this is lifted.</center><br>"
	var/be_special = LoadKey(prefs, "be_special")
	for(var/i in GLOB.special_roles)
		if(i == ROLE_NO_ANTAGONISM)
			. += "<b>DISABLE ALL ANTAGONISM</b> "
			if(i in be_special)
				. += "<span class='linkOn'>YES</span> "
				. += generate_topic_key_value(prefs, "NO", "be_special_toggle", i)
			else
				. += generate_topic_key_value(prefs, "YES", "be_special_toggle", i)
				. += " <span class='linkOn'>NO</span>"
			. += "<br>"
			return
		. += "<b>Be [capitalize(i)]:</b> "
		if(jobban_isbanned(prefs.parent?.mob, i))
			. += generate_topic_key_value(prefs, "<font color='red'>BANNED</font>", "jobbancheck", i)
		else
			var/days_remaining = null
			if(ispath(GLOB.special_roles[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
				var/mode_path = GLOB.special_roles[i]
				var/datum/game_mode/temp_mode = new mode_path
				days_remaining = temp_mode.get_remaining_days(prefs.parent)
			if(days_remaining)
				. += "<font color='red'> \[IN [days_remaining] DAYS]</font><br>"
			else
				if(i in be_special)
					. += "<span class='linkOn'>Enabled</span> "
					. += generate_topic_key_value(prefs, "Disabled", "be_special_toggle", i)
				else
					. += generate_topic_key_value(prefs, "Enabled", "be_special_toggle", i)
					. += " <span class='linkOn'>Disabled</span>"

	. += "<b>Midround Antagonist:</b> "
	if(LoadKey(prefs, "midround_antagonist"))
		. += "<span class='linkOn'>Enabled</span> "
		. += generate_topic(prefs, "Disabled", "midround_toggle")
	else
		. += generate_topic(prefs, "Enabled", "midround_toggle")
		. += " <span class='linkOn'>Disabled</span>"

/datum/preferences_collection/hybrid/antagonism/sanitize_any(datum/preferences/prefs)
	. = ..()
	auto_sanitize_list(prefs, "be_special")
	auto_sanitize_boolean(prefs, "midround_antagonist")

/datum/preferences_collection/hybrid/antagonism/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	. = ..()
	if(href_list["midround_toggle"])
		SaveKey(prefs, "midround_antagonist", !LoadKey(prefs, "midround_antagonist"))
		return PREFERENCES_ONTOPIC_REFRESH
	if(href_list["be_special_toggle"])
		var/list/current = LoadKey(prefs, "be_special")
		var/type = href_list["be_special_toggle"]
		if(type in current)
			current -= type
		else
			current += type
		SaveKey(prefs, "be_special")
	if(href_list["jobbancheck"])
		prefs.jobbancheck(href_list["jobbancheck"])

/datum/preferences_collection/hybrid/antagonism/savefile_full_overhaul_character(datum/preferences/prefs, list/data, savefile/S, list/errors, current_version)
	. = ..()
	var/list/be_special
	S["be_special"] >> be_special
	var/midround_antag
	S["toggles"] >> midround_antag
	midround_antag &= MIDROUND_ANTAG
	midround_antag = FORCE_BOOLEAN(midround_antag)

	data["be_special"] = be_special
	data["midround_antagonist"] = midround_antag



#warn put these in
	S["uplink_loc"]				>> uplink_spawn_loc
	var/uplink_spawn_loc = UPLINK_PDA


	uplink_spawn_loc				= sanitize_inlist(uplink_spawn_loc, GLOB.uplink_spawn_loc_list, initial(uplink_spawn_loc))


				if("uplink_loc")
					var/new_loc = input(user, "Choose your character's traitor uplink spawn location:", "Character Preference") as null|anything in GLOB.uplink_spawn_loc_list
					if(new_loc)
						uplink_spawn_loc = new_loc

