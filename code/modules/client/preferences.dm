GLOBAL_LIST_EMPTY(preferences_datums)



/datum/preferences
	var/client/parent
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/max_save_slots = 10

	//non-preference stuff
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = null
	var/enable_tips = TRUE
	var/tip_delay = 500 //tip delay in milliseconds

	//Antag preferences
	var/list/be_special = list()		//Special role selection
	var/tmp/old_be_special = 0			//Bitflag version of be_special, used to update old savefiles and nothing more
										//If it's 0, that's good, if it's anything but 0, the owner of this prefs file's antag choices were,
										//autocorrected this round, not that you'd need to check that.


	var/UI_style = "Midnight"
	var/buttons_locked = FALSE
	var/hotkeys = FALSE
	var/tgui_fancy = TRUE
	var/tgui_lock = TRUE
	var/windowflashing = TRUE
	var/toggles = TOGGLES_DEFAULT
	var/db_flags
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	var/ghost_hud = 1
	var/inquisitive_ghost = 1
	var/allow_midround_antag = 1
	var/preferred_map = null
	var/pda_style = MONO

	var/uses_glasses_colour = 0

	var/screenshake = 100
	var/damagescreenshake = 2

	//character preferences
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we'll have a random name every round
	var/be_random_body = 0				//whether we'll have a random body every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/underwear = "Nude"				//underwear type
	var/undershirt = "Nude"				//undershirt type
	var/socks = "Nude"					//socks type
	var/backbag = DBACKPACK				//backpack type
	var/hair_style = "Bald"				//Hair type
	var/hair_color = "000"				//Hair color
	var/facial_hair_style = "Shaved"	//Face hair type
	var/facial_hair_color = "000"		//Facial hair color
	var/skin_tone = "caucasian1"		//Skin color
	var/eye_color = "000"				//Eye color
	var/datum/species/pref_species = new /datum/species/human()	//Mutant race
	var/list/features = list("mcolor" 			= "FFF",
		"mcolor2" 			= "FFF",
		"mcolor3" 			= "FFF",
		"tail_lizard" 		= "Smooth",
		"tail_human" 		= "None",
		"snout" 			= "Round",
		"horns" 			= "None",
		"ears" 				= "None",
		"wings" 			= "None",
		"frills" 			= "None",
		"spines" 			= "None",
		"body_markings" 	= "None",
		"mam_body_markings" = "None",
		"mam_ears" 			= "None",
		"mam_tail" 			= "None",
		"mam_tail_animated" = "None",
		"xenodorsal" 		= "None",
		"xenohead" 			= "None",
		"xenotail" 			= "None",
		"legs" 				= "Normal Legs",
		"taur" 				= "None",
		"exhibitionist" 	= FALSE,
		"genitals_use_skintone"	= FALSE,
		"has_cock"			= FALSE,
		"cock_shape"		= "Human",
		"cock_length"		= 6,
		"cock_girth_ratio"	= COCK_GIRTH_RATIO_DEF,
		"cock_color"		= "fff",
		"has_sheath"		= FALSE,
		"sheath_color"		= "fff",
		"has_balls" 		= FALSE,
		"balls_internal" 	= FALSE,
		"balls_color" 		= "fff",
		"balls_amount"		= 2,
		"balls_sack_size"	= BALLS_SACK_SIZE_DEF,
		"balls_size"		= BALLS_SIZE_DEF,
		"balls_cum_rate"	= CUM_RATE,
		"balls_cum_mult"	= CUM_RATE_MULT,
		"balls_efficiency"	= CUM_EFFICIENCY,
		"balls_fluid" 		= "semen",
		"has_ovi"			= FALSE,
		"ovi_shape"			= "knotted",
		"ovi_length"		= 6,
		"ovi_color"			= "fff",
		"has_eggsack" 		= FALSE,
		"eggsack_internal" 	= TRUE,
		"eggsack_color" 	= "fff",
		"eggsack_size" 		= BALLS_SACK_SIZE_DEF,
		"eggsack_egg_color" = "fff",
		"eggsack_egg_size" 	= EGG_GIRTH_DEF,
		"has_breasts" 		= FALSE,
		"breasts_color" 	= "fff",
		"breasts_size" 		= "C",
		"breasts_shape"		= "Pair",
		"breasts_fluid" 	= "milk",
		"has_vag"			= FALSE,
		"vag_shape"			= "Human",
		"vag_color"			= "fff",
		"vag_clits"			= 1,
		"vag_clit_diam"		= 0.25,
		"vag_clit_len"		= 0.25,
		"has_womb"			= FALSE,
		"womb_cum_rate"		= CUM_RATE,
		"womb_cum_mult"		= CUM_RATE_MULT,
		"womb_efficiency"	= CUM_EFFICIENCY,
		"womb_fluid" 		= "femcum",
		"flavor_text"		= ""
		)//MAKE SURE TO UPDATE THE LIST IN MOBS.DM IF YOU'RE GOING TO ADD TO THIS LIST, OTHERWISE THINGS MIGHT GET FUCKEY

	var/list/custom_names = list("clown", "mime", "ai", "cyborg", "religion", "deity")
	var/prefered_security_department = SEC_DEPT_RANDOM

		//Mob preview
	var/icon/preview_icon = null

		//Jobs, uses bitflags
	var/job_civilian_high = 0
	var/job_civilian_med = 0
	var/job_civilian_low = 0

	var/job_medsci_high = 0
	var/job_medsci_med = 0
	var/job_medsci_low = 0

	var/job_engsec_high = 0
	var/job_engsec_med = 0
	var/job_engsec_low = 0

		// Want randomjob if preferences already filled - Donkie
	var/joblessrole = BERANDOMJOB  //defaults to 1 for fewer assistants

	// 0 = character settings, 1 = game preferences, 2 = character appearance
	var/current_tab = 0

		// OOC Metadata:
	var/metadata = ""

	var/unlock_content = 0

	var/list/ignoring = list()

	var/clientfps = 0

	var/parallax

	var/uplink_spawn_loc = UPLINK_PDA

	var/list/exp
	var/list/menuoptions

	//citadel code
	var/arousable = TRUE //Allows players to disable arousal from the character creation menu

/datum/preferences/New(client/C)
	parent = C
	custom_names["ai"] = pick(GLOB.ai_names)
	custom_names["cyborg"] = pick(GLOB.ai_names)
	custom_names["clown"] = pick(GLOB.clown_names)
	custom_names["mime"] = pick(GLOB.mime_names)
	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			unlock_content = C.IsByondMember()
			if(unlock_content)
				max_save_slots = 16
	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			return
	//we couldn't load character data so just randomize the character appearance + name
	random_character()		//let's create a random character then - rather than a fat, bald and naked man.
	real_name = pref_species.random_name(gender,1)
	if(!loaded_preferences_successfully)
		save_preferences()
	save_character()		//let's save this new random character so it doesn't keep generating new ones.
	menuoptions = list()
	return

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)
		return
	if(current_tab == 2)
		update_preview_icon(nude=TRUE)
	else
		update_preview_icon(nude=FALSE)
	user << browse_rsc(preview_icon, "previewicon.png")
	var/dat = "<center>"

	dat += "<a href='?_src_=prefs;preference=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>Character Settings</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=2' [current_tab == 2 ? "class='linkOn'" : ""]>Character Appearance</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>Game Preferences</a>"

	if(!path)
		dat += "<div class='notice'>Please create an account to save your preferences</div>"

	dat += "</center>"

	dat += "<HR>"

	switch(current_tab)
		if (0) // Character Settings
			if(path)
				var/savefile/S = new /savefile(path)
				if(S)
					dat += "<center>"
					var/name
					for(var/i=1, i<=max_save_slots, i++)
						S.cd = "/character[i]"
						S["real_name"] >> name
						if(!name)
							name = "Character[i]"
						/*if(i!=1)
							dat += " | " */
						dat += "<a style='white-space:nowrap;' href='?_src_=prefs;preference=changeslot;num=[i];' [i == default_slot ? "class='linkOn'" : ""]>[name]</a> "
					dat += "</center>"

			dat += "<center><h2>Occupation Choices</h2>"
			dat += "<a href='?_src_=prefs;preference=job;task=menu'>Set Occupation Preferences</a><br></center>"
			dat += "<h2>Identity</h2>"
			dat += "<table width='100%'><tr><td width='75%' valign='top'>"
			if(jobban_isbanned(user, "appearance"))
				dat += "<b>You are banned from using custom names and appearances. You can continue to adjust your characters, but you will be randomised once you join the game.</b><br>"
			dat += "<a href='?_src_=prefs;preference=name;task=random'>Random Name</A> "
			dat += "<a href='?_src_=prefs;preference=name'>Always Random Name: [be_random_name ? "Yes" : "No"]</a><BR>"

			dat += "<b>Name:</b> "
			dat += "<a href='?_src_=prefs;preference=name;task=input'>[real_name]</a><BR>"

			dat += "<b>Gender:</b> <a href='?_src_=prefs;preference=gender'>[gender == MALE ? "Male" : "Female"]</a><BR>"
			dat += "<b>Age:</b> <a href='?_src_=prefs;preference=age;task=input'>[age]</a><BR>"
			dat += "<b>Arousal:</b><a href='?_src_=prefs;preference=arousable'>[arousable == TRUE ? "Enabled" : "Disabled"]</a><BR>"
			dat += "<b>Exhibitionist:</b><a href='?_src_=prefs;preference=exhibitionist'>[features["exhibitionist"] == TRUE ? "Yes" : "No"]</a><BR>"
			dat += "<b>Special Names:</b><BR>"
			dat += "<a href ='?_src_=prefs;preference=clown_name;task=input'><b>Clown:</b> [custom_names["clown"]]</a> "
			dat += "<a href ='?_src_=prefs;preference=mime_name;task=input'><b>Mime:</b>[custom_names["mime"]]</a><BR>"
			dat += "<a href ='?_src_=prefs;preference=ai_name;task=input'><b>AI:</b> [custom_names["ai"]]</a> "
			dat += "<a href ='?_src_=prefs;preference=cyborg_name;task=input'><b>Cyborg:</b> [custom_names["cyborg"]]</a><BR>"
			dat += "<a href ='?_src_=prefs;preference=religion_name;task=input'><b>Chaplain religion:</b> [custom_names["religion"]] </a>"
			dat += "<a href ='?_src_=prefs;preference=deity_name;task=input'><b>Chaplain deity:</b> [custom_names["deity"]]</a><BR>"

			dat += "<b>Custom job preferences:</b><BR>"
			dat += "<a href='?_src_=prefs;preference=sec_dept;task=input'><b>Prefered security department:</b> [prefered_security_department]</a><BR></td>"

			dat += "<td valign='center'>"

			dat += "<div class='statusDisplay'><center><img src=previewicon.png width=[preview_icon.Width()] height=[preview_icon.Height()]></center></div>"

			dat += "</td></tr></table>"
//			dat += "<b>Size:</b> <a href='?_src_=prefs;preference=character_size;task=input'>[character_size]</a><BR>"
			dat += "<br>"

			dat += "<b>Underwear:</b><BR><a href ='?_src_=prefs;preference=underwear;task=input'>[underwear]</a><BR>"
			dat += "<b>Undershirt:</b><BR><a href ='?_src_=prefs;preference=undershirt;task=input'>[undershirt]</a><BR>"
			dat += "<b>Socks:</b><BR><a href ='?_src_=prefs;preference=socks;task=input'>[socks]</a><BR>"
			dat += "<b>Backpack:</b><BR><a href ='?_src_=prefs;preference=bag;task=input'>[backbag]</a><BR>"
			dat += "<b>Uplink Spawn Location:</b><BR><a href ='?_src_=prefs;preference=uplink_loc;task=input'>[uplink_spawn_loc]</a><BR></td>"

			dat += "</tr></table>"

		if (1) // Game Preferences
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>General Settings</h2>"
			dat += "<b>UI Style:</b> <a href='?_src_=prefs;task=input;preference=ui'>[UI_style]</a><br>"
			dat += "<b>Keybindings:</b> <a href='?_src_=prefs;preference=hotkeys'>[(hotkeys) ? "Hotkeys" : "Default"]</a><br>"
			dat += "<b>Action Buttons:</b> <a href='?_src_=prefs;preference=action_buttons'>[(buttons_locked) ? "Locked In Place" : "Unlocked"]</a><br>"
			dat += "<b>tgui Style:</b> <a href='?_src_=prefs;preference=tgui_fancy'>[(tgui_fancy) ? "Fancy" : "No Frills"]</a><br>"
			dat += "<b>PDA Style:</b> <a href='?_src_=prefs;task=input;preference=PDA'>[pda_style]</a><br>"
			dat += "<b>tgui Monitors:</b> <a href='?_src_=prefs;preference=tgui_lock'>[(tgui_lock) ? "Primary" : "All"]</a><br>"
			dat += "<b>Window Flashing:</b> <a href='?_src_=prefs;preference=winflash'>[(windowflashing) ? "Yes" : "No"]</a><br>"
			dat += "<b>Play admin midis:</b> <a href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "Yes" : "No"]</a><br>"
			dat += "<b>Play lobby music:</b> <a href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "Yes" : "No"]</a><br>"
			dat += "<b>Ghost ears:</b> <a href='?_src_=prefs;preference=ghost_ears'>[(chat_toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost sight:</b> <a href='?_src_=prefs;preference=ghost_sight'>[(chat_toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost whispers:</b> <a href='?_src_=prefs;preference=ghost_whispers'>[(chat_toggles & CHAT_GHOSTWHISPER) ? "All Speech" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost radio:</b> <a href='?_src_=prefs;preference=ghost_radio'>[(chat_toggles & CHAT_GHOSTRADIO) ? "Yes" : "No"]</a><br>"
			dat += "<b>Ghost pda:</b> <a href='?_src_=prefs;preference=ghost_pda'>[(chat_toggles & CHAT_GHOSTPDA) ? "All Messages" : "Nearest Creatures"]</a><br>"
			dat += "<b>Pull requests:</b> <a href='?_src_=prefs;preference=pull_requests'>[(chat_toggles & CHAT_PULLR) ? "Yes" : "No"]</a><br>"
			dat += "<b>Midround Antagonist:</b> <a href='?_src_=prefs;preference=allow_midround_antag'>[(toggles & MIDROUND_ANTAG) ? "Yes" : "No"]</a><br>"
			if(CONFIG_GET(flag/allow_metadata))
				dat += "<b>OOC Notes:</b> <a href='?_src_=prefs;preference=metadata;task=input'>Edit </a><br>"

			if(user.client)
				if(user.client.holder)
					dat += "<b>Adminhelp Sound:</b> <a href='?_src_=prefs;preference=hear_adminhelps'>[(toggles & SOUND_ADMINHELP)?"On":"Off"]</a><br>"
					dat += "<b>Announce Login:</b> <a href='?_src_=prefs;preference=announce_login'>[(toggles & ANNOUNCE_LOGIN)?"On":"Off"]</a><br>"

				if(unlock_content || check_rights_for(user.client, R_ADMIN))
					dat += "<b>OOC:</b> <span style='border: 1px solid #161616; background-color: [ooccolor ? ooccolor : GLOB.normal_ooc_colour];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=ooccolor;task=input'>Change</a><br>"

				if(unlock_content)
					dat += "<b>BYOND Membership Publicity:</b> <a href='?_src_=prefs;preference=publicity'>[(toggles & MEMBER_PUBLIC) ? "Public" : "Hidden"]</a><br>"
					dat += "<b>Ghost Form:</b> <a href='?_src_=prefs;task=input;preference=ghostform'>[ghost_form]</a><br>"
					dat += "<B>Ghost Orbit: </B> <a href='?_src_=prefs;task=input;preference=ghostorbit'>[ghost_orbit]</a><br>"

			var/button_name = "If you see this something went wrong."
			switch(ghost_accs)
				if(GHOST_ACCS_FULL)
					button_name = GHOST_ACCS_FULL_NAME
				if(GHOST_ACCS_DIR)
					button_name = GHOST_ACCS_DIR_NAME
				if(GHOST_ACCS_NONE)
					button_name = GHOST_ACCS_NONE_NAME

			dat += "<b>Ghost Accessories:</b> <a href='?_src_=prefs;task=input;preference=ghostaccs'>[button_name]</a><br>"

			switch(ghost_others)
				if(GHOST_OTHERS_THEIR_SETTING)
					button_name = GHOST_OTHERS_THEIR_SETTING_NAME
				if(GHOST_OTHERS_DEFAULT_SPRITE)
					button_name = GHOST_OTHERS_DEFAULT_SPRITE_NAME
				if(GHOST_OTHERS_SIMPLE)
					button_name = GHOST_OTHERS_SIMPLE_NAME

			dat += "<b>Ghosts of Others:</b> <a href='?_src_=prefs;task=input;preference=ghostothers'>[button_name]</a><br>"

			if (CONFIG_GET(flag/maprotation))
				var/p_map = preferred_map
				if (!p_map)
					p_map = "Default"
					if (config.defaultmap)
						p_map += " ([config.defaultmap.map_name])"
				else
					if (p_map in config.maplist)
						var/datum/map_config/VM = config.maplist[p_map]
						if (!VM)
							p_map += " (No longer exists)"
						else
							p_map = VM.map_name
					else
						p_map += " (No longer exists)"
				if(CONFIG_GET(flag/allow_map_voting))
					dat += "<b>Preferred Map:</b> <a href='?_src_=prefs;preference=preferred_map;task=input'>[p_map]</a><br>"

			dat += "<b>FPS:</b> <a href='?_src_=prefs;preference=clientfps;task=input'>[clientfps]</a><br>"

			dat += "<b>Parallax (Fancy Space):</b> <a href='?_src_=prefs;preference=parallaxdown' oncontextmenu='window.location.href=\"?_src_=prefs;preference=parallaxup\";return false;'>"
			switch (parallax)
				if (PARALLAX_LOW)
					dat += "Low"
				if (PARALLAX_MED)
					dat += "Medium"
				if (PARALLAX_INSANE)
					dat += "Insane"
				if (PARALLAX_DISABLE)
					dat += "Disabled"
				else
					dat += "High"
			dat += "</a><br>"

			dat += "<b>Screen Shake:</b> <a href='?_src_=prefs;preference=screenshake'>[(screenshake==100) ? "Full" : ((screenshake==0) ? "None" : "[screenshake]")]</a><br>"

			if (!user.client.prefs.screenshake==0)
				dat += "<b>Damage Screen Shake:</b> <a href='?_src_=prefs;preference=damagescreenshake'>[(damagescreenshake==1) ? "On" : ((damagescreenshake==0) ? "Off" : "Only when down")]</a><br>"

			dat += "</td><td width='300px' height='300px' valign='top'>"

			dat += "<h2>Special Role Settings</h2>"

			if(jobban_isbanned(user, "Syndicate"))
				dat += "<font color=red><b>You are banned from antagonist roles.</b></font>"
				src.be_special = list()


			for (var/i in GLOB.special_roles)
				if(jobban_isbanned(user, i))
					dat += "<b>Be [capitalize(i)]:</b> <a href='?_src_=prefs;jobbancheck=[i]'>BANNED</a><br>"
				else
					var/days_remaining = null
					if(ispath(GLOB.special_roles[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
						var/mode_path = GLOB.special_roles[i]
						var/datum/game_mode/temp_mode = new mode_path
						days_remaining = temp_mode.get_remaining_days(user.client)

					if(days_remaining)
						dat += "<b>Be [capitalize(i)]:</b> <font color=red> \[IN [days_remaining] DAYS]</font><br>"
					else
						dat += "<b>Be [capitalize(i)]:</b> <a href='?_src_=prefs;preference=be_special;be_special_type=[i]'>[(i in be_special) ? "Yes" : "No"]</a><br>"

			dat += "</td></tr></table>"

		//Character Appearance
		if(2)
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<div class='statusDisplay'><img src=previewicon.png width=[preview_icon.Width()] height=[preview_icon.Height()]></div><br>"
			dat += "<a href='byond://?src=\ref[user];preference=flavor_text;task=input'><b>Set Flavor Text</b></a><br>"
			if(lentext(features["flavor_text"]) <= 40)
				if(!lentext(features["flavor_text"]))
					dat += "\[...\]"
				else
					dat += "[features["flavor_text"]]"
			else
				dat += "[TextPreview(features["flavor_text"])]...<BR>"
			dat += "<h2>Body</h2>"
			dat += "<b>Gender:</b> <a href='?_src_=prefs;preference=gender'>[gender == MALE ? "Male" : "Female"]</a><BR>"
			dat += "<b>Species:</b><a href='?_src_=prefs;preference=species;task=input'>[pref_species.id]</a><BR>"
			dat += "<a href='?_src_=prefs;preference=all;task=random'>Random Body</A><BR>"
			dat += "<a href='?_src_=prefs;preference=all'>Always Random Body: [be_random_body ? "Yes" : "No"]</A><BR>"
			if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))
				dat += "<b>Primary Color: </b><span style='border: 1px solid #161616; background-color: #[features["mcolor"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color;task=input'>Change</a><BR>"
				dat += "<b>Secondary Color: </b><span style='border: 1px solid #161616; background-color: #[features["mcolor2"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color2;task=input'>Change</a><BR>"
				dat += "<b>Tertiary Color: </b><span style='border: 1px solid #161616; background-color: #[features["mcolor3"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color3;task=input'>Change</a><BR>"
			if(pref_species.use_skintones)
				dat += "<b>Skin Tone: </b><a href='?_src_=prefs;preference=s_tone;task=input'>[skin_tone]</a><BR>"
				dat += "<b>Genitals Use Skintone:</b><a href='?_src_=prefs;preference=genital_colour'>[features["genitals_use_skintone"] == TRUE ? "Enabled" : "Disabled"]</a><BR>"

			if(HAIR in pref_species.species_traits)
				dat += "<b>Hair Style: </b><a href='?_src_=prefs;preference=hair_style;task=input'>[hair_style]</a><BR>"
				dat += "<b>Hair Color: </b><span style='border:1px solid #161616; background-color: #[hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=hair;task=input'>Change</a><BR>"
				dat += "<b>Facial Hair Style: </b><a href='?_src_=prefs;preference=facial_hair_style;task=input'>[facial_hair_style]</a><BR>"
				dat += "<b>Facial Hair Color: </b><span style='border: 1px solid #161616; background-color: #[facial_hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=facial;task=input'>Change</a><BR>"
			if(EYECOLOR in pref_species.species_traits)
				dat += "<b>Eye Color: </b><span style='border: 1px solid #161616; background-color: #[eye_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=eyes;task=input'>Change</a><BR>"
			if("tail_lizard" in pref_species.mutant_bodyparts)
				dat += "<b>Tail: </b><a href='?_src_=prefs;preference=tail_lizard;task=input'>[features["tail_lizard"]]</a><BR>"
			else if("mam_tail" in pref_species.mutant_bodyparts)
				dat += "<b>Tail: </b><a href='?_src_=prefs;preference=mam_tail;task=input'>[features["mam_tail"]]</a><BR>"
			else if("tail_human" in pref_species.mutant_bodyparts)
				dat += "<b>Tail: </b><a href='?_src_=prefs;preference=tail_human;task=input'>[features["tail_human"]]</a><BR>"
			if("snout" in pref_species.mutant_bodyparts)
				dat += "<b>Snout: </b><a href='?_src_=prefs;preference=snout;task=input'>[features["snout"]]</a><BR>"
			if("horns" in pref_species.mutant_bodyparts)
				dat += "<b>Snout: </b><a href='?_src_=prefs;preference=horns;task=input'>[features["horns"]]</a><BR>"
			if("frills" in pref_species.mutant_bodyparts)
				dat += "<b>Frills: </b><a href='?_src_=prefs;preference=frills;task=input'>[features["frills"]]</a><BR>"
			if("spines" in pref_species.mutant_bodyparts)
				dat += "<b>Spines: </b><a href='?_src_=prefs;preference=spines;task=input'>[features["spines"]]</a><BR>"
			if("body_markings" in pref_species.mutant_bodyparts)
				dat += "<b>Body Markings: </b><a href='?_src_=prefs;preference=body_markings;task=input'>[features["body_markings"]]</a><BR>"
			else if("mam_body_markings" in pref_species.mutant_bodyparts)
				dat += "<b>Body Markings: </b><a href='?_src_=prefs;preference=mam_body_markings;task=input'>[features["mam_body_markings"]]</a><BR>"
			if("mam_ears" in pref_species.mutant_bodyparts)
				dat += "<b>Ears: </b><a href='?_src_=prefs;preference=mam_ears;task=input'>[features["mam_ears"]]</a><BR>"
			else if("ears" in pref_species.mutant_bodyparts)
				dat += "<b>Ears: </b><a href='?_src_=prefs;preference=ears;task=input'>[features["ears"]]</a><BR>"
			if("legs" in pref_species.mutant_bodyparts)
				dat += "<b>Legs: </b><a href='?_src_=prefs;preference=legs;task=input'>[features["legs"]]</a><BR>"
			if("taur" in pref_species.mutant_bodyparts)
				dat += "<b>Taur: </b><a href='?_src_=prefs;preference=taur;task=input'>[features["taur"]]</a><BR>"
			if("wings" in pref_species.mutant_bodyparts && GLOB.r_wings_list.len >1)
				dat += "<b>Wings: </b><a href='?_src_=prefs;preference=wings;task=input'>[features["wings"]]</a><BR>"
			if("xenohead" in pref_species.mutant_bodyparts)
				dat += "<b>Caste: </b><a href='?_src_=prefs;preference=xenohead;task=input'>[features["xenohead"]]</a><BR>"
			if("xenotail" in pref_species.mutant_bodyparts)
				dat += "<b>Tail: </b><a href='?_src_=prefs;preference=xenotail;task=input'>[features["xenotail"]]</a><BR>"
			if("xenodorsal" in pref_species.mutant_bodyparts)
				dat += "<b>Dorsal Tubes: </b><a href='?_src_=prefs;preference=xenodorsal;task=input'>[features["xenodorsal"]]</a><BR>"

			dat += "</td><td width='300px' height='300px' valign='top'>"


			dat += "<h2>Clothing & Equipment</h2>"
//underwear will be refactored later so it fits in with other wearable equipment and isn't just an overlay
//			dat += "<b>Underwear:</b><a href ='?_src_=prefs;preference=underwear;task=input'>[underwear]</a><br>"
//			dat += "<b>Undershirt:</b><a href ='?_src_=prefs;preference=undershirt;task=input'>[undershirt]</a><br>"
//			dat += "<b>Socks:</b><a href ='?_src_=prefs;preference=socks;task=input'>[socks]</a><br>"
			dat += "<b>Backpack:</b><a href ='?_src_=prefs;preference=bag;task=input'>[backbag]</a><br>"
			dat += "<b>Uplink Location:</b><a href ='?_src_=prefs;preference=uplink_loc;task=input'>[uplink_spawn_loc]</a><br>"

			dat += "<h2>Genitals</h2>"
			if(NOGENITALS in pref_species.species_traits)
				dat += "<b>Your species ([pref_species.name]) does not support genitals!</b><br>"
			else
				dat += "<b>Has Penis:</b><a href='?_src_=prefs;preference=has_cock'>[features["has_cock"] == TRUE ? "Yes" : "No"]</a><BR>"
				if(features["has_cock"] == TRUE)
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Penis Color:</b><span style='border: 1px solid #161616; background-color: #[skintone2hex(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<BR>"
					else
						dat += "<b>Penis Color:</b><span style='border: 1px solid #161616; background-color: #[features["cock_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=cock_color;task=input'>Change</a><BR>"
//					dat += "<br>"
					dat += "<b>Penis Shape:</b> <a href='?_src_=prefs;preference=cock_shape;task=input'>[features["cock_shape"]]</a><BR>"
					dat += "<b>Penis Length:</b> <a href='?_src_=prefs;preference=cock_length;task=input'>[features["cock_length"]] inch(es)</a><BR>"
					dat += "<b>Has Testicles:</b><a href='?_src_=prefs;preference=has_balls'>[features["has_balls"] == TRUE ? "Yes" : "No"]</a><BR>"
					if(features["has_balls"] == TRUE)
						if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
							dat += "<b>Testicles Color:</b><span style='border: 1px solid #161616; background-color: #[skintone2hex(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<BR>"
						else
							dat += "<b>Testicles Color:</b><span style='border: 1px solid #161616; background-color: #[features["balls_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=balls_color;task=input'>Change</a><BR>"
				dat += "<b>Has Vagina:</b><a href='?_src_=prefs;preference=has_vag'>[features["has_vag"] == TRUE ? "Yes" : "No"]</a><BR>"
				if(features["has_vag"])
					dat += "<b>Vagina Type:</b> <a href='?_src_=prefs;preference=vag_shape;task=input'>[features["vag_shape"]]</a><BR>"
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Vagina Color:</b><span style='border: 1px solid #161616; background-color: #[skintone2hex(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<BR>"
					else
						dat += "<b>Vagina Color:</b><span style='border: 1px solid #161616; background-color: #[features["vag_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=vag_color;task=input'>Change</a><BR>"
					dat += "<b>Has Womb:</b><a href='?_src_=prefs;preference=has_womb'>[features["has_womb"] == TRUE ? "Yes" : "No"]</a><BR>"
				dat += "<b>Has Breasts:</b><a href='?_src_=prefs;preference=has_breasts'>[features["has_breasts"] == TRUE ? "Yes" : "No"]</a><BR>"
				if(features["has_breasts"])
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Color:</b><span style='border: 1px solid #161616; background-color: #[skintone2hex(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<BR>"
					else
						dat += "<b>Color:</b><span style='border: 1px solid #161616; background-color: #[features["breasts_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=breasts_color;task=input'>Change</a><BR>"
					dat += "<b>Cup Size:</b><a href='?_src_=prefs;preference=breasts_size;task=input'>[features["breasts_size"]]</a><br>"
					dat += "<b>Breast Shape:</b><a href='?_src_=prefs;preference=breasts_shape;task=input'>[features["breasts_shape"]]</a><br>"
				/*
				dat += "<h3>Ovipositor</h3>"
				dat += "<b>Has Ovipositor:</b><a href='?_src_=prefs;preference=has_ovi'>[features["has_ovi"] == TRUE ? "Yes" : "No"]</a>"
				if(features["has_ovi"])
					dat += "<b>Ovi Color:</b><span style='border: 1px solid #161616; background-color: #[features["ovi_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=ovi_color;task=input'>Change</a>"
					dat += "<h3>Eggsack</h3>"
					dat += "<b>Has Eggsack:</b><a href='?_src_=prefs;preference=has_eggsack'>[features["has_eggsack"] == TRUE ? "Yes" : "No"]</a><BR>"
					if(features["has_eggsack"] == TRUE)
						dat += "<b>Color:</b><span style='border: 1px solid #161616; background-color: #[features["eggsack_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=eggsack_color;task=input'>Change</a>"
						dat += "<b>Egg Color:</b><span style='border: 1px solid #161616; background-color: #[features["eggsack_egg_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=egg_color;task=input'>Change</a>"
						dat += "<b>Egg Size:</b><a href='?_src_=prefs;preference=egg_size;task=input'>[features["eggsack_egg_size"]]\" Diameter</a>"

				dat += "</td>"
				*/


			dat += "</td></tr></table>"
	dat += "<hr><center>"

	if(!IsGuestKey(user.key))
		dat += "<a href='?_src_=prefs;preference=load'>Undo</a> "
		dat += "<a href='?_src_=prefs;preference=save'>Save Setup</a> "

	dat += "<a href='?_src_=prefs;preference=reset_all'>Reset Setup</a>"
	dat += "</center>"

	var/datum/browser/popup = new(user, "preferences", "<div align='center'>Character Setup</div>", 640, 770)
	popup.set_content(dat)
	popup.open(0)

/datum/preferences/proc/SetChoices(mob/user, limit = 17, list/splitJobs = list("Chief Engineer"), widthPerColumn = 295, height = 620)
	if(!SSjob)
		return

	//limit - The amount of jobs allowed per column. Defaults to 17 to make it look nice.
	//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//widthPerColumn - Screen's width for every column.
	//height - Screen's height.

	var/width = widthPerColumn

	var/HTML = "<center>"
	if(SSjob.occupations.len <= 0)
		HTML += "The job ticker is not yet finished creating jobs, please try again later"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.

	else
		HTML += "<b>Choose occupation chances</b><br>"
		HTML += "<div align='center'>Left-click to raise an occupation preference, right-click to lower it.<br></div>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.
		HTML += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='?_src_=prefs;preference=job;task=setJobLevel;level=' + level + ';text=' + encodeURIComponent(rank); return false; }</script>"
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
		var/index = -1

		//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
		var/datum/job/lastJob

		for(var/datum/job/job in SSjob.occupations)

			index += 1
			if((index >= limit) || (job.title in splitJobs))
				width += widthPerColumn
				if((index < limit) && (lastJob != null))
					//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
					//the last job's selection color. Creating a rather nice effect.
					for(var/i = 0, i < (limit - index), i += 1)
						HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"
				HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
				index = 0

			HTML += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
			var/rank = job.title
			lastJob = job
			if(jobban_isbanned(user, rank))
				HTML += "<font color=red>[rank]</font></td><td><a href='?_src_=prefs;jobbancheck=[rank]'> BANNED</a></td></tr>"
				continue
			var/required_playtime_remaining = job.required_playtime_remaining(user.client)
			if(required_playtime_remaining)
				HTML += "<font color=red>[rank]</font></td><td><font color=red> \[ [get_exp_format(required_playtime_remaining)] as [job.get_exp_req_type()] \] </font></td></tr>"
				continue
			if(!job.player_old_enough(user.client))
				var/available_in_days = job.available_in_days(user.client)
				HTML += "<font color=red>[rank]</font></td><td><font color=red> \[IN [(available_in_days)] DAYS\]</font></td></tr>"
				continue
			if((job_civilian_low & ASSISTANT) && (rank != "Assistant") && !jobban_isbanned(user, "Assistant"))
				HTML += "<font color=orange>[rank]</font></td><td></td></tr>"
				continue
			if(CONFIG_GET(flag/enforce_human_authority) && !user.client.prefs.pref_species.qualifies_for_rank(rank, user.client.prefs.features))
				if(user.client.prefs.pref_species.id == "human")
					HTML += "<font color=red>[rank]</font></td><td><font color=red><b> \[MUTANT\]</b></font></td></tr>"
				else
					HTML += "<font color=red>[rank]</font></td><td><font color=red><b> \[NON-HUMAN\]</b></font></td></tr>"
				continue
			if((rank in GLOB.command_positions) || (rank == "AI"))//Bold head jobs
				HTML += "<b><span class='dark'>[rank]</span></b>"
			else
				HTML += "<span class='dark'>[rank]</span>"

			HTML += "</td><td width='40%'>"

			var/prefLevelLabel = "ERROR"
			var/prefLevelColor = "pink"
			var/prefUpperLevel = -1 // level to assign on left click
			var/prefLowerLevel = -1 // level to assign on right click

			if(GetJobDepartment(job, 1) & job.flag)
				prefLevelLabel = "High"
				prefLevelColor = "slateblue"
				prefUpperLevel = 4
				prefLowerLevel = 2
			else if(GetJobDepartment(job, 2) & job.flag)
				prefLevelLabel = "Medium"
				prefLevelColor = "green"
				prefUpperLevel = 1
				prefLowerLevel = 3
			else if(GetJobDepartment(job, 3) & job.flag)
				prefLevelLabel = "Low"
				prefLevelColor = "orange"
				prefUpperLevel = 2
				prefLowerLevel = 4
			else
				prefLevelLabel = "NEVER"
				prefLevelColor = "red"
				prefUpperLevel = 3
				prefLowerLevel = 1


			HTML += "<a class='white' href='?_src_=prefs;preference=job;task=setJobLevel;level=[prefUpperLevel];text=[rank]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"

			if(rank == "Assistant")//Assistant is special
				if(job_civilian_low & ASSISTANT)
					HTML += "<font color=green>Yes</font>"
				else
					HTML += "<font color=red>No</font>"
				HTML += "</a></td></tr>"
				continue

			HTML += "<font color=[prefLevelColor]>[prefLevelLabel]</font>"
			HTML += "</a></td></tr>"

		for(var/i = 1, i < (limit - index), i += 1) // Finish the column so it is even
			HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"

		HTML += "</td'></tr></table>"
		HTML += "</center></table>"

		var/message = "Be an Assistant if preferences unavailable"
		if(joblessrole == BERANDOMJOB)
			message = "Get random job if preferences unavailable"
		else if(joblessrole == RETURNTOLOBBY)
			message = "Return to lobby if preferences unavailable"
		HTML += "<center><br><a href='?_src_=prefs;preference=job;task=random'>[message]</a></center>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>Reset Preferences</a></center>"

	user << browse(null, "window=preferences")
	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Occupation Preferences</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(0)
	return

/datum/preferences/proc/SetJobPreferenceLevel(datum/job/job, level)
	if (!job)
		return 0

	if (level == 1) // to high
		// remove any other job(s) set to high
		job_civilian_med |= job_civilian_high
		job_engsec_med |= job_engsec_high
		job_medsci_med |= job_medsci_high
		job_civilian_high = 0
		job_engsec_high = 0
		job_medsci_high = 0

	if (job.department_flag == CIVILIAN)
		job_civilian_low &= ~job.flag
		job_civilian_med &= ~job.flag
		job_civilian_high &= ~job.flag

		switch(level)
			if (1)
				job_civilian_high |= job.flag
			if (2)
				job_civilian_med |= job.flag
			if (3)
				job_civilian_low |= job.flag

		return 1
	else if (job.department_flag == ENGSEC)
		job_engsec_low &= ~job.flag
		job_engsec_med &= ~job.flag
		job_engsec_high &= ~job.flag

		switch(level)
			if (1)
				job_engsec_high |= job.flag
			if (2)
				job_engsec_med |= job.flag
			if (3)
				job_engsec_low |= job.flag

		return 1
	else if (job.department_flag == MEDSCI)
		job_medsci_low &= ~job.flag
		job_medsci_med &= ~job.flag
		job_medsci_high &= ~job.flag

		switch(level)
			if (1)
				job_medsci_high |= job.flag
			if (2)
				job_medsci_med |= job.flag
			if (3)
				job_medsci_low |= job.flag

		return 1

	return 0

/datum/preferences/proc/UpdateJobPreference(mob/user, role, desiredLvl)
	if(!SSjob || SSjob.occupations.len <= 0)
		return
	var/datum/job/job = SSjob.GetJob(role)

	if(!job)
		user << browse(null, "window=mob_occupation")
		ShowChoices(user)
		return

	if (!isnum(desiredLvl))
		to_chat(user, "<span class='danger'>UpdateJobPreference - desired level was not a number. Please notify coders!</span>")
		ShowChoices(user)
		return

	if(role == "Assistant")
		if(job_civilian_low & job.flag)
			job_civilian_low &= ~job.flag
		else
			job_civilian_low |= job.flag
		SetChoices(user)
		return 1

	SetJobPreferenceLevel(job, desiredLvl)
	SetChoices(user)

	return 1


/datum/preferences/proc/ResetJobs()

	job_civilian_high = 0
	job_civilian_med = 0
	job_civilian_low = 0

	job_medsci_high = 0
	job_medsci_med = 0
	job_medsci_low = 0

	job_engsec_high = 0
	job_engsec_med = 0
	job_engsec_low = 0


/datum/preferences/proc/GetJobDepartment(datum/job/job, level)
	if(!job || !level)
		return 0
	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(1)
					return job_civilian_high
				if(2)
					return job_civilian_med
				if(3)
					return job_civilian_low
		if(MEDSCI)
			switch(level)
				if(1)
					return job_medsci_high
				if(2)
					return job_medsci_med
				if(3)
					return job_medsci_low
		if(ENGSEC)
			switch(level)
				if(1)
					return job_engsec_high
				if(2)
					return job_engsec_med
				if(3)
					return job_engsec_low
	return 0

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(href_list["jobbancheck"])
		var/job = sanitizeSQL(href_list["jobbancheck"])
		var/sql_ckey = sanitizeSQL(user.ckey)
		var/datum/DBQuery/query_get_jobban = SSdbcore.NewQuery("SELECT reason, bantime, duration, expiration_time, a_ckey FROM [format_table_name("ban")] WHERE ckey = '[sql_ckey]' AND (bantype = 'JOB_PERMABAN'  OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned) AND job = '[job]'")
		if(!query_get_jobban.warn_execute())
			return
		if(query_get_jobban.NextRow())
			var/reason = query_get_jobban.item[1]
			var/bantime = query_get_jobban.item[2]
			var/duration = query_get_jobban.item[3]
			var/expiration_time = query_get_jobban.item[4]
			var/a_ckey = query_get_jobban.item[5]
			var/text
			text = "<span class='redtext'>You, or another user of this computer, ([user.ckey]) is banned from playing [job]. The ban reason is:<br>[reason]<br>This ban was applied by [a_ckey] on [bantime]"
			if(text2num(duration) > 0)
				text += ". The ban is for [duration] minutes and expires on [expiration_time] (server time)"
			text += ".</span>"
			to_chat(user, text)
		return

	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("random")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						if(jobban_isbanned(user, "Assistant"))
							joblessrole = BERANDOMJOB
						else
							joblessrole = BEASSISTANT
					if(BEASSISTANT)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = RETURNTOLOBBY
				SetChoices(user)
			if("setJobLevel")
				UpdateJobPreference(user, href_list["text"], text2num(href_list["level"]))
			else
				SetChoices(user)
		return 1

	switch(href_list["task"])
		if("random")
			switch(href_list["preference"])
				if("name")
					real_name = pref_species.random_name(gender,1)
				if("age")
					age = rand(AGE_MIN, AGE_MAX)
				if("hair")
					hair_color = random_short_color()
				if("hair_style")
					hair_style = random_hair_style(gender)
				if("facial")
					facial_hair_color = random_short_color()
				if("facial_hair_style")
					facial_hair_style = random_facial_hair_style(gender)
				if("underwear")
					underwear = random_underwear(gender)
				if("undershirt")
					undershirt = random_undershirt(gender)
				if("socks")
					socks = random_socks()
				if("eyes")
					eye_color = random_eye_color()
				if("s_tone")
					skin_tone = random_skin_tone()
				if("bag")
					backbag = pick(GLOB.backbaglist)
				if("all")
					random_character()

		if("input")
			switch(href_list["preference"])
				if("ghostform")
					if(unlock_content)
						var/new_form = input(user, "Thanks for supporting BYOND - Choose your ghostly form:","Thanks for supporting BYOND",null) as null|anything in GLOB.ghost_forms
						if(new_form)
							ghost_form = new_form
				if("ghostorbit")
					if(unlock_content)
						var/new_orbit = input(user, "Thanks for supporting BYOND - Choose your ghostly orbit:","Thanks for supporting BYOND", null) as null|anything in GLOB.ghost_orbits
						if(new_orbit)
							ghost_orbit = new_orbit

				if("ghostaccs")
					var/new_ghost_accs = alert("Do you want your ghost to show full accessories where possible, hide accessories but still use the directional sprites where possible, or also ignore the directions and stick to the default sprites?",,GHOST_ACCS_FULL_NAME, GHOST_ACCS_DIR_NAME, GHOST_ACCS_NONE_NAME)
					switch(new_ghost_accs)
						if(GHOST_ACCS_FULL_NAME)
							ghost_accs = GHOST_ACCS_FULL
						if(GHOST_ACCS_DIR_NAME)
							ghost_accs = GHOST_ACCS_DIR
						if(GHOST_ACCS_NONE_NAME)
							ghost_accs = GHOST_ACCS_NONE

				if("ghostothers")
					var/new_ghost_others = alert("Do you want the ghosts of others to show up as their own setting, as their default sprites or always as the default white ghost?",,GHOST_OTHERS_THEIR_SETTING_NAME, GHOST_OTHERS_DEFAULT_SPRITE_NAME, GHOST_OTHERS_SIMPLE_NAME)
					switch(new_ghost_others)
						if(GHOST_OTHERS_THEIR_SETTING_NAME)
							ghost_others = GHOST_OTHERS_THEIR_SETTING
						if(GHOST_OTHERS_DEFAULT_SPRITE_NAME)
							ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
						if(GHOST_OTHERS_SIMPLE_NAME)
							ghost_others = GHOST_OTHERS_SIMPLE

				if("name")
					var/new_name = reject_bad_name( input(user, "Choose your character's name:", "Character Preference")  as text|null )
					if(new_name)
						real_name = new_name
					else
						to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")

				if("age")
					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference") as num|null
					if(new_age)
						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("flavor_text")
					var/msg = input(usr,"Set the flavor text in your 'examine' verb. This can also be used for OOC notes and preferences!","Flavor Text",html_decode(features["flavor_text"])) as message
					if(msg != null)
						msg = sanitize(copytext(msg, 1, MAX_MESSAGE_LEN))
						msg = html_encode(msg)
						features["flavor_text"] = msg

				if("metadata")
					var/new_metadata = input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , metadata)  as message|null
					if(new_metadata)
						metadata = sanitize(copytext(new_metadata,1,MAX_MESSAGE_LEN))

				if("hair")
					var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference") as null|color
					if(new_hair)
						hair_color = sanitize_hexcolor(new_hair)


				if("hair_style")
					var/new_hair_style
					if(gender == MALE)
						new_hair_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in GLOB.hair_styles_male_list
					else
						new_hair_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in GLOB.hair_styles_female_list
					if(new_hair_style)
						hair_style = new_hair_style

				if("next_hair_style")
					if (gender == MALE)
						hair_style = next_list_item(hair_style, GLOB.hair_styles_male_list)
					else
						hair_style = next_list_item(hair_style, GLOB.hair_styles_female_list)

				if("previous_hair_style")
					if (gender == MALE)
						hair_style = previous_list_item(hair_style, GLOB.hair_styles_male_list)
					else
						hair_style = previous_list_item(hair_style, GLOB.hair_styles_female_list)

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference") as null|color
					if(new_facial)
						facial_hair_color = sanitize_hexcolor(new_facial)

				if("facial_hair_style")
					var/new_facial_hair_style
					if(gender == MALE)
						new_facial_hair_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in GLOB.facial_hair_styles_male_list
					else
						new_facial_hair_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in GLOB.facial_hair_styles_female_list
					if(new_facial_hair_style)
						facial_hair_style = new_facial_hair_style

				if("next_facehair_style")
					if (gender == MALE)
						facial_hair_style = next_list_item(facial_hair_style, GLOB.facial_hair_styles_male_list)
					else
						facial_hair_style = next_list_item(facial_hair_style, GLOB.facial_hair_styles_female_list)

				if("previous_facehair_style")
					if (gender == MALE)
						facial_hair_style = previous_list_item(facial_hair_style, GLOB.facial_hair_styles_male_list)
					else
						facial_hair_style = previous_list_item(facial_hair_style, GLOB.facial_hair_styles_female_list)

				if("underwear")
					var/new_underwear
					if(gender == MALE)
						new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in GLOB.underwear_m
					else
						new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in GLOB.underwear_f
					if(new_underwear)
						underwear = new_underwear

				if("undershirt")
					var/new_undershirt
					if(gender == MALE)
						new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference") as null|anything in GLOB.undershirt_m
					else
						new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference") as null|anything in GLOB.undershirt_f
					if(new_undershirt)
						undershirt = new_undershirt

				if("socks")
					var/new_socks
					new_socks = input(user, "Choose your character's socks:", "Character Preference") as null|anything in GLOB.socks_list
					if(new_socks)
						socks = new_socks

				if("eyes")
					var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference") as color|null
					if(new_eyes)
						eye_color = sanitize_hexcolor(new_eyes)

				if("species")

					var/result = input(user, "Select a species", "Species Selection") as null|anything in GLOB.roundstart_races

					if(result)
						var/newtype = GLOB.species_list[result]
						pref_species = new newtype()
						//Now that we changed our species, we must verify that the mutant colour is still allowed.
						var/temp_hsv = RGBtoHSV(features["mcolor"])
						if(features["mcolor"] == "#000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor"] = pref_species.default_color
						if(features["mcolor2"] == "#000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor2"] = pref_species.default_color
						if(features["mcolor3"] == "#000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor3"] = pref_species.default_color

				if("mutant_color")
					var/new_mutantcolor = input(user, "Choose your character's primary alien/mutant color:", "Character Preference") as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor"] = sanitize_hexcolor(new_mutantcolor)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mutant_color2")
					var/new_mutantcolor = input(user, "Choose your character's secondary alien/mutant color:", "Character Preference") as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor2"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor2"] = sanitize_hexcolor(new_mutantcolor)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mutant_color3")
					var/new_mutantcolor = input(user, "Choose your character's tertiary alien/mutant color:", "Character Preference") as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor3"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor3"] = sanitize_hexcolor(new_mutantcolor)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("tail_lizard")
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in GLOB.tails_list_lizard
					if(new_tail)
						features["tail_lizard"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"

				if("tail_human")
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in GLOB.tails_list_human
					if(new_tail)
						features["tail_human"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"
				if("mam_tail")
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in GLOB.mam_tails_list
					if(new_tail)
						features["mam_tail"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"

				if("taur")
					var/new_taur
					new_taur = input(user, "Choose your character's tauric body:", "Character Preference") as null|anything in GLOB.taur_list
					if(new_taur)
						features["taur"] = new_taur
						if(new_taur != "None")
							features["mam_tail"] = "None"
							features["xenotail"] = "None"

/*	Doesn't exist yet. will include facial overlays to mimic 5th port species heads.
				if("mam_snout")
					var/new_snout
					new_snout = input(user, "Choose your character's snout:", "Character Preference") as null|anything in GLOB.mam_snouts_list
					if(new_snout)
						features["snout"] = new_snout
*/

				if("snout")
					var/new_snout
					new_snout = input(user, "Choose your character's snout:", "Character Preference") as null|anything in GLOB.snouts_list
					if(new_snout)
						features["snout"] = new_snout

				if("horns")
					var/new_horns
					new_horns = input(user, "Choose your character's horns:", "Character Preference") as null|anything in GLOB.horns_list
					if(new_horns)
						features["horns"] = new_horns

				if("mam_ears")
					var/new_ears
					new_ears = input(user, "Choose your character's ears:", "Character Preference") as null|anything in GLOB.mam_ears_list
					if(new_ears)
						features["mam_ears"] = new_ears

				if("ears")
					var/new_ears
					new_ears = input(user, "Choose your character's ears:", "Character Preference") as null|anything in GLOB.ears_list
					if(new_ears)
						features["ears"] = new_ears

				if("wings")
					var/new_wings
					new_wings = input(user, "Choose your character's wings:", "Character Preference") as null|anything in GLOB.r_wings_list
					if(new_wings)
						features["wings"] = new_wings

				if("frills")
					var/new_frills
					new_frills = input(user, "Choose your character's frills:", "Character Preference") as null|anything in GLOB.frills_list
					if(new_frills)
						features["frills"] = new_frills

				if("spines")
					var/new_spines
					new_spines = input(user, "Choose your character's spines:", "Character Preference") as null|anything in GLOB.spines_list
					if(new_spines)
						features["spines"] = new_spines

				if("body_markings")
					var/new_body_markings
					new_body_markings = input(user, "Choose your character's body markings:", "Character Preference") as null|anything in GLOB.body_markings_list
					if(new_body_markings)
						features["body_markings"] = new_body_markings

				if("mam_body_markings")
					var/new_mam_body_markings
					new_mam_body_markings = input(user, "Choose your character's body markings:", "Character Preference") as null|anything in GLOB.mam_body_markings_list
					if(new_mam_body_markings)
						features["mam_body_markings"] = new_mam_body_markings

				//Xeno Bodyparts
				if("xenohead")//Head or caste type
					var/new_head
					new_head = input(user, "Choose your character's caste:", "Character Preference") as null|anything in GLOB.xeno_head_list
					if(new_head)
						features["xenohead"] = new_head

				if("xenotail")//Currently one one type, more maybe later if someone sprites them. Might include animated variants in the future.
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in GLOB.xeno_tail_list
					if(new_tail)
						features["xenotail"] = new_tail

				if("xenodorsal")
					var/new_dors
					new_dors = input(user, "Choose your character's dorsal tube type:", "Character Preference") as null|anything in GLOB.xeno_dorsal_list
					if(new_dors)
						features["xenodorsal"] = new_dors

				if("legs")
					var/new_legs
					new_legs = input(user, "Choose your character's legs:", "Character Preference") as null|anything in GLOB.legs_list
					if(new_legs)
						features["legs"] = new_legs

				if("s_tone")
					var/new_s_tone = input(user, "Choose your character's skin-tone:", "Character Preference")  as null|anything in GLOB.skin_tones
					if(new_s_tone)
						skin_tone = new_s_tone

				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference") as color|null
					if(new_ooccolor)
						ooccolor = sanitize_ooccolor(new_ooccolor)

				if("bag")
					var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in GLOB.backbaglist
					if(new_backbag)
						backbag = new_backbag

				if("uplink_loc")
					var/new_loc = input(user, "Choose your character's traitor uplink spawn location:", "Character Preference") as null|anything in GLOB.uplink_spawn_loc_list
					if(new_loc)
						uplink_spawn_loc = new_loc

				if("clown_name")
					var/new_clown_name = reject_bad_name( input(user, "Choose your character's clown name:", "Character Preference")  as text|null )
					if(new_clown_name)
						custom_names["clown"] = new_clown_name
					else
						to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")

				if("mime_name")
					var/new_mime_name = reject_bad_name( input(user, "Choose your character's mime name:", "Character Preference")  as text|null )
					if(new_mime_name)
						custom_names["mime"] = new_mime_name
					else
						to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")

				if("ai_name")
					var/new_ai_name = reject_bad_name( input(user, "Choose your character's AI name:", "Character Preference")  as text|null, 1 )
					if(new_ai_name)
						custom_names["ai"] = new_ai_name
					else
						to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, 0-9, -, ' and .</font>")

				if("cyborg_name")
					var/new_cyborg_name = reject_bad_name( input(user, "Choose your character's cyborg name:", "Character Preference")  as text|null, 1 )
					if(new_cyborg_name)
						custom_names["cyborg"] = new_cyborg_name
					else
						to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, 0-9, -, ' and .</font>")

				if("religion_name")
					var/new_religion_name = reject_bad_name( input(user, "Choose your character's religion:", "Character Preference")  as text|null )
					if(new_religion_name)
						custom_names["religion"] = new_religion_name
					else
						to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")

				if("deity_name")
					var/new_deity_name = reject_bad_name( input(user, "Choose your character's deity:", "Character Preference")  as text|null )
					if(new_deity_name)
						custom_names["deity"] = new_deity_name
					else
						to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")

				if("sec_dept")
					var/department = input(user, "Choose your prefered security department:", "Security Departments") as null|anything in GLOB.security_depts_prefs
					if(department)
						prefered_security_department = department

				if ("preferred_map")
					var/maplist = list()
					var/default = "Default"
					if (config.defaultmap)
						default += " ([config.defaultmap.map_name])"
					for (var/M in config.maplist)
						var/datum/map_config/VM = config.maplist[M]
						var/friendlyname = "[VM.map_name] "
						if (VM.voteweight <= 0)
							friendlyname += " (disabled)"
						maplist[friendlyname] = VM.map_name
					maplist[default] = null
					var/pickedmap = input(user, "Choose your preferred map. This will be used to help weight random map selection.", "Character Preference")  as null|anything in maplist
					if (pickedmap)
						preferred_map = maplist[pickedmap]

				if ("clientfps")
					var/version_message
					if (user.client && user.client.byond_version < 511)
						version_message = "\nYou need to be using byond version 511 or later to take advantage of this feature, your version of [user.client.byond_version] is too low"
					if (world.byond_version < 511)
						version_message += "\nThis server does not currently support client side fps. You can set now for when it does."
					var/desiredfps = input(user, "Choose your desired fps.[version_message]\n(0 = synced with server tick rate (currently:[world.fps]))", "Character Preference", clientfps)  as null|num
					if (!isnull(desiredfps))
						clientfps = desiredfps
						if (world.byond_version >= 511 && user.client && user.client.byond_version >= 511)
							user.client.vars["fps"] = clientfps
				if("ui")
					var/pickedui = input(user, "Choose your UI style.", "Character Preference")  as null|anything in list("Midnight", "Plasmafire", "Retro", "Slimecore", "Operative", "Clockwork")
					if(pickedui)
						UI_style = pickedui
				if("PDA")
					var/pickedPDA = input(user, "Choose your PDA style.", "Character Preference")  as null|anything in list(MONO, SHARE, ORBITRON, VT)
					if(pickedPDA)
						pda_style = pickedPDA

				//citadel code
				if("cock_color")
					var/new_cockcolor = input(user, "Penis color:", "Character Preference") as color|null
					if(new_cockcolor)
						var/temp_hsv = RGBtoHSV(new_cockcolor)
						if(new_cockcolor == "#000000")
							features["cock_color"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["cock_color"] = sanitize_hexcolor(new_cockcolor)
						else
							user << "<span class='danger'>Invalid color. Your color is not bright enough.</span>"

				if("cock_length")
					var/new_length = input(user, "Penis length in inches:\n([COCK_SIZE_MIN]-[COCK_SIZE_MAX])", "Character Preference") as num|null
					if(new_length)
						features["cock_length"] = max(min( round(text2num(new_length)), COCK_SIZE_MAX),COCK_SIZE_MIN)

				if("cock_shape")
					var/new_shape
					new_shape = input(user, "Penis shape:", "Character Preference") as null|anything in GLOB.cock_shapes_list
					if(new_shape)
						features["cock_shape"] = new_shape

				if("balls_color")
					var/new_ballscolor = input(user, "Testicle Color:", "Character Preference") as color|null
					if(new_ballscolor)
						var/temp_hsv = RGBtoHSV(new_ballscolor)
						if(new_ballscolor == "#000000")
							features["balls_color"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["balls_color"] = sanitize_hexcolor(new_ballscolor)
						else
							user << "<span class='danger'>Invalid color. Your color is not bright enough.</span>"

				if("egg_size")
					var/new_size
					var/list/egg_sizes = list(1,2,3)
					new_size = input(user, "Egg Diameter(inches):", "Egg Size") as null|anything in egg_sizes
					if(new_size)
						features["eggsack_egg_size"] = new_size

				if("egg_color")
					var/new_egg_color = input(user, "Egg Color:", "Character Preference") as color|null
					if(new_egg_color)
						var/temp_hsv = RGBtoHSV(new_egg_color)
						if(ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["eggsack_egg_color"] = sanitize_hexcolor(new_egg_color)
						else
							user << "<span class='danger'>Invalid color. Your color is not bright enough.</span>"
				if("breasts_size")
					var/new_size
					new_size = input(user, "Breast Size", "Character Preference") as null|anything in GLOB.breasts_size_list
					if(new_size)
						features["breasts_size"] = new_size

				if("breasts_shape")
					var/new_shape
					new_shape = input(user, "Breast Shape", "Character Preference") as null|anything in GLOB.breasts_shapes_list
					if(new_shape)
						features["breasts_shape"] = new_shape

				if("breasts_color")
					var/new_breasts_color = input(user, "Breast Color:", "Character Preference") as color|null
					if(new_breasts_color)
						var/temp_hsv = RGBtoHSV(new_breasts_color)
						if(new_breasts_color == "#000000")
							features["breasts_color"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["breasts_color"] = sanitize_hexcolor(new_breasts_color)
						else
							user << "<span class='danger'>Invalid color. Your color is not bright enough.</span>"
				if("vag_shape")
					var/new_shape
					new_shape = input(user, "Vagina Type", "Character Preference") as null|anything in GLOB.vagina_shapes_list
					if(new_shape)
						features["vag_shape"] = new_shape
				if("vag_color")
					var/new_vagcolor = input(user, "Vagina color:", "Character Preference") as color|null
					if(new_vagcolor)
						var/temp_hsv = RGBtoHSV(new_vagcolor)
						if(new_vagcolor == "#000000")
							features["vag_color"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#202020")[3])
							features["vag_color"] = sanitize_hexcolor(new_vagcolor)
						else
							user << "<span class='danger'>Invalid color. Your color is not bright enough.</span>"

		else
			switch(href_list["preference"])

				//citadel code
				if("genital_colour")
					switch(features["genitals_use_skintone"])
						if(TRUE)
							features["genitals_use_skintone"] = FALSE
						if(FALSE)
							features["genitals_use_skintone"] = TRUE
						else
							features["genitals_use_skintone"] = FALSE
				if("arousable")
					switch(arousable)
						if(TRUE)
							arousable = FALSE
						if(FALSE)
							arousable = TRUE
						else//failsafe
							arousable = FALSE
				if("has_cock")
					switch(features["has_cock"])
						if(TRUE)
							features["has_cock"] = FALSE
						if(FALSE)
							features["has_cock"] = TRUE
							features["has_ovi"] = FALSE
							features["has_eggsack"] = FALSE
						else
							features["has_cock"] = FALSE
							features["has_ovi"] = FALSE
				if("has_balls")
					switch(features["has_balls"])
						if(TRUE)
							features["has_balls"] = FALSE
						if(FALSE)
							features["has_balls"] = TRUE
							features["has_eggsack"] = FALSE
						else
							features["has_balls"] = FALSE
							features["has_eggsack"] = FALSE

				if("has_ovi")
					switch(features["has_ovi"])
						if(TRUE)
							features["has_ovi"] = FALSE
						if(FALSE)
							features["has_ovi"] = TRUE
							features["has_cock"] = FALSE
							features["has_balls"] = FALSE
						else
							features["has_ovi"] = FALSE
							features["has_cock"] = FALSE

				if("has_eggsack")
					switch(features["has_eggsack"])
						if(TRUE)
							features["has_eggsack"] = FALSE
						if(FALSE)
							features["has_eggsack"] = TRUE
							features["has_balls"] = FALSE
						else
							features["has_eggsack"] = FALSE
							features["has_balls"] = FALSE

				if("balls_internal")
					switch(features["balls_internal"])
						if(TRUE)
							features["balls_internal"] = FALSE
						if(FALSE)
							features["balls_internal"] = TRUE
							features["eggsack_internal"] = FALSE
						else
							features["balls_internal"] = FALSE
							features["eggsack_internal"] = FALSE

				if("eggsack_internal")
					switch(features["eggsack_internal"])
						if(TRUE)
							features["eggsack_internal"] = FALSE
						if(FALSE)
							features["eggsack_internal"] = TRUE
							features["balls_internal"] = FALSE
						else
							features["eggsack_internal"] = FALSE
							features["balls_internal"] = FALSE

				if("has_breasts")
					switch(features["has_breasts"])
						if(TRUE)
							features["has_breasts"] = FALSE
						if(FALSE)
							features["has_breasts"] = TRUE
						else
							features["has_breasts"] = FALSE
				if("has_vag")
					switch(features["has_vag"])
						if(TRUE)
							features["has_vag"] = FALSE
						if(FALSE)
							features["has_vag"] = TRUE
						else
							features["has_vag"] = FALSE
				if("has_womb")
					switch(features["has_womb"])
						if(TRUE)
							features["has_womb"] = FALSE
						if(FALSE)
							features["has_womb"] = TRUE
						else
							features["has_womb"] = FALSE
				if("exhibitionist")
					switch(features["exhibitionist"])
						if(TRUE)
							features["exhibitionist"] = FALSE
						if(FALSE)
							features["exhibitionist"] = TRUE
						else
							features["exhibitionist"] = FALSE
				if ("screenshake")
					var/desiredshake = input(user, "Set the amount of screenshake you want. \n(0 = disabled, 100 = full, 200 = maximum.)", "Character Preference", screenshake)  as null|num
					if (!isnull(desiredshake))
						screenshake = desiredshake
				if("damagescreenshake")
					switch(damagescreenshake)
						if(0)
							damagescreenshake = 1
						if(1)
							damagescreenshake = 2
						if(2)
							damagescreenshake = 0
						else
							damagescreenshake = 1

				if("publicity")
					if(unlock_content)
						toggles ^= MEMBER_PUBLIC
				if("gender")
					if(gender == MALE)
						gender = FEMALE
					else
						gender = MALE
					underwear = "Nude"
					undershirt = "Nude"
					socks = "Nude"
					facial_hair_style = "Shaved"
					hair_style = "Bald"

				if("hotkeys")
					hotkeys = !hotkeys
				if("action_buttons")
					buttons_locked = !buttons_locked
				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_lock")
					tgui_lock = !tgui_lock
				if("winflash")
					windowflashing = !windowflashing
				if("hear_adminhelps")
					toggles ^= SOUND_ADMINHELP
				if("announce_login")
					toggles ^= ANNOUNCE_LOGIN

				if("be_special")
					var/be_special_type = href_list["be_special_type"]
					if(be_special_type in be_special)
						be_special -= be_special_type
					else
						be_special += be_special_type

				if("name")
					be_random_name = !be_random_name

				if("all")
					be_random_body = !be_random_body

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if((toggles & SOUND_LOBBY) && user.client)
						user.client.playtitlemusic()
					else
						user.stop_sound_channel(CHANNEL_LOBBYMUSIC)

				if("ghost_ears")
					chat_toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					chat_toggles ^= CHAT_GHOSTSIGHT

				if("ghost_whispers")
					chat_toggles ^= CHAT_GHOSTWHISPER

				if("ghost_radio")
					chat_toggles ^= CHAT_GHOSTRADIO

				if("ghost_pda")
					chat_toggles ^= CHAT_GHOSTPDA

				if("pull_requests")
					chat_toggles ^= CHAT_PULLR

				if("allow_midround_antag")
					toggles ^= MIDROUND_ANTAG

				if("parallaxup")
					parallax = Wrap(parallax + 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("parallaxdown")
					parallax = Wrap(parallax - 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("save")
					save_preferences()
					save_character()

				if("load")
					load_preferences()
					load_character()
					attempt_vr(parent.prefs_vr,"load_vore","")

				if("changeslot")
					attempt_vr(parent.prefs_vr,"load_vore","")
					if(!load_character(text2num(href_list["num"])))
						random_character()
						real_name = random_unique_name(gender)
						save_character()

				if("tab")
					if (href_list["tab"])
						current_tab = text2num(href_list["tab"])

	ShowChoices(user)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1)
	if(be_random_name)
		real_name = pref_species.random_name(gender)

	if(be_random_body)
		random_character(gender)

	if(CONFIG_GET(flag/humans_need_surnames))
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(GLOB.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(GLOB.last_names)]"

	character.real_name = real_name
	character.name = character.real_name

	character.gender = gender
	character.age = age

	character.eye_color = eye_color
	var/obj/item/organ/eyes/organ_eyes = character.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		if(!initial(organ_eyes.eye_color))
			organ_eyes.eye_color = eye_color
		organ_eyes.old_eye_color = eye_color
	character.hair_color = hair_color
	character.facial_hair_color = facial_hair_color

	character.skin_tone = skin_tone
	character.hair_style = hair_style
	character.facial_hair_style = facial_hair_style
	character.underwear = underwear
	character.undershirt = undershirt
	character.socks = socks

	character.backbag = backbag

	character.dna.features = features.Copy() //Flavor text is now a DNA feature
	character.dna.real_name = character.real_name
	var/datum/species/chosen_species
	if(pref_species.id in GLOB.roundstart_races)
		chosen_species = pref_species.type
	else
		chosen_species = /datum/species/human
		pref_species = new /datum/species/human
		save_character()
	character.set_species(chosen_species, icon_update=0)

	//citadel code
	character.give_genitals()
	character.flavor_text = features["flavor_text"] //Let's update their flavor_text at least initially
	character.canbearoused = arousable

	if(icon_updates)
		character.update_body()
		character.update_hair()
		character.update_body_parts()
		character.update_genitals()
