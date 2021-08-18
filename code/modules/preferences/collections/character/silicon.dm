/datum/preferences_collection/character/silicon
	save_key = PREFERENCES_SAVE_KEY_SILICON
	sort_order = 5



	var/preferred_ai_core_display = "Blue"

			dat += "<a href='?_src_=prefs;preference=silicon_flavor_text;task=input'><b>Set Silicon Examine Text</b></a><br>"
			if(length(features["silicon_flavor_text"]) <= 40)
				if(!length(features["silicon_flavor_text"]))
					dat += "\[...\]"
				else
					dat += "[features["silicon_flavor_text"]]"
			else
				dat += "[TextPreview(features["silicon_flavor_text"])]...<BR>"


			dat += "<a href='?_src_=prefs;preference=ai_core_icon;task=input'><b>Preferred AI Core Display:</b> [preferred_ai_core_display]</a><br>"



	S["preferred_ai_core_display"]		>> preferred_ai_core_display


S["silicon_feature_flavor_text"]		>> features["silicon_flavor_text"]

	S["silicon_flavor_text"] >> features["silicon_flavor_text"]
	features["silicon_flavor_text"]			= copytext(features["silicon_flavor_text"], 1, MAX_FLAVOR_LEN)



				if("silicon_flavor_text")
					var/msg = stripped_multiline_input(usr, "Set the silicon flavor text in your 'examine' verb. This can also be used for OOC notes and preferences!", "Silicon Flavor Text", html_decode(features["silicon_flavor_text"]), MAX_FLAVOR_LEN, TRUE)
					if(!isnull(msg))
						features["silicon_flavor_text"] = msg
				if("ai_core_icon")
					var/ai_core_icon = input(user, "Choose your preferred AI core display screen:", "AI Core Display Screen Selection") as null|anything in GLOB.ai_core_display_screens
					if(ai_core_icon)
						preferred_ai_core_display = ai_core_icon
