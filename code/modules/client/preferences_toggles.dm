//toggles
/client/verb/toggle_ghost_ears()
	set name = "Show/Hide GhostEars"
	set category = "Preferences"
	set desc = ".Toggle Between seeing all mob speech, and only speech of nearby mobs"
	prefs.chat_toggles ^= CHAT_GHOSTEARS
	src << "As a ghost, you will now [(prefs.chat_toggles & CHAT_GHOSTEARS) ? "see all speech in the world" : "only see speech from nearby mobs"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_sight()
	set name = "Show/Hide GhostSight"
	set category = "Preferences"
	set desc = ".Toggle Between seeing all mob emotes, and only emotes of nearby mobs"
	prefs.chat_toggles ^= CHAT_GHOSTSIGHT
	src << "As a ghost, you will now [(prefs.chat_toggles & CHAT_GHOSTSIGHT) ? "see all emotes in the world" : "only see emotes from nearby mobs"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_whispers()
	set name = "Show/Hide GhostWhispers"
	set category = "Preferences"
	set desc = ".Toggle between hearing all whispers, and only whispers of nearby mobs"
	prefs.chat_toggles ^= CHAT_GHOSTWHISPER
	src << "As a ghost, you will now [(prefs.chat_toggles & CHAT_GHOSTWHISPER) ? "see all whispers in the world" : "only see whispers from nearby mobs"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGW") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_radio()
	set name = "Show/Hide GhostRadio"
	set category = "Preferences"
	set desc = ".Enable or disable hearing radio chatter as a ghost"
	prefs.chat_toggles ^= CHAT_GHOSTRADIO
	src << "As a ghost, you will now [(prefs.chat_toggles & CHAT_GHOSTRADIO) ? "see radio chatter" : "not see radio chatter"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc! //social experiment, increase the generation whenever you copypaste this shamelessly GENERATION 1

/client/verb/toggle_ghost_pda()
	set name = "Show/Hide GhostPDA"
	set category = "Preferences"
	set desc = ".Toggle Between seeing all mob pda messages, and only pda messages of nearby mobs"
	prefs.chat_toggles ^= CHAT_GHOSTPDA
	src << "As a ghost, you will now [(prefs.chat_toggles & CHAT_GHOSTPDA) ? "see all pda messages in the world" : "only see pda messages from nearby mobs"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_hear_radio()
	set name = "Show/Hide RadioChatter"
	set category = "Preferences"
	set desc = "Toggle seeing radiochatter from nearby radios and speakers"
	if(!holder) return
	prefs.chat_toggles ^= CHAT_RADIO
	prefs.save_preferences()
	usr << "You will [(prefs.chat_toggles & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from nearby radios or speakers"
	feedback_add_details("admin_verb","THR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_deathrattle()
	set name = "Toggle Deathrattle"
	set category = "Preferences"
	set desc = "Toggle recieving a message in deadchat when sentient mobs \
		die."
	prefs.toggles ^= DISABLE_DEATHRATTLE
	prefs.save_preferences()
	usr << "You will \
		[(prefs.toggles & DISABLE_DEATHRATTLE) ? "no longer" : "now"] get \
		messages when a sentient mob dies."
	feedback_add_details("admin_verb", "TDR") // If you are copy-pasting this, maybe you should spend some time reading the comments.

/client/verb/toggle_arrivalrattle()
	set name = "Toggle Arrivalrattle"
	set category = "Preferences"
	set desc = "Toggle recieving a message in deadchat when someone joins \
		the station."
	prefs.toggles ^= DISABLE_ARRIVALRATTLE
	usr << "You will \
		[(prefs.toggles & DISABLE_ARRIVALRATTLE) ? "no longer" : "now"] get \
		messages when someone joins the station."
	prefs.save_preferences()
	feedback_add_details("admin_verb", "TAR") // If you are copy-pasting this, maybe you should rethink where your life went so wrong.

/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Preferences"
	set desc = "Toggle hearing a notification when admin PMs are received"
	if(!holder)
		return
	prefs.toggles ^= SOUND_ADMINHELP
	prefs.save_preferences()
	usr << "You will [(prefs.toggles & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive."
	feedback_add_details("admin_verb","AHS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleannouncelogin()
	set name = "Do/Don't Announce Login"
	set category = "Preferences"
	set desc = "Toggle if you want an announcement to admins when you login during a round"
	if(!holder)
		return
	prefs.toggles ^= ANNOUNCE_LOGIN
	prefs.save_preferences()
	usr << "You will [(prefs.toggles & ANNOUNCE_LOGIN) ? "now" : "no longer"] have an announcement to other admins when you login."
	feedback_add_details("admin_verb","TAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/deadchat()
	set name = "Show/Hide Deadchat"
	set category = "Preferences"
	set desc ="Toggles seeing deadchat"
	prefs.chat_toggles ^= CHAT_DEAD
	prefs.save_preferences()
	src << "You will [(prefs.chat_toggles & CHAT_DEAD) ? "now" : "no longer"] see deadchat."
	feedback_add_details("admin_verb","TDV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Preferences"
	set desc = "Toggles seeing prayers"
	prefs.chat_toggles ^= CHAT_PRAYER
	prefs.save_preferences()
	src << "You will [(prefs.chat_toggles & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat."
	feedback_add_details("admin_verb","TP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggleprayersounds()
	set name = "Hear/Silence Prayer Sounds"
	set category = "Preferences"
	set desc = "Toggles hearing pray sounds."
	prefs.toggles ^= SOUND_PRAYERS
	prefs.save_preferences()
	if(prefs.toggles & SOUND_PRAYERS)
		src << "You will now hear prayer sounds."
	else
		src << "You will no longer prayer sounds."
	feedback_add_details("admin_verb", "PSounds")

/client/verb/togglemidroundantag()
	set name = "Toggle Midround Antagonist"
	set category = "Preferences"
	set desc = "Toggles whether or not you will be considered for antagonist status given during a round."
	prefs.toggles ^= MIDROUND_ANTAG
	prefs.save_preferences()
	src << "You will [(prefs.toggles & MIDROUND_ANTAG) ? "now" : "no longer"] be considered for midround antagonist positions."
	feedback_add_details("admin_verb","TMidroundA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggletitlemusic()
	set name = "Hear/Silence LobbyMusic"
	set category = "Preferences"
	set desc = "Toggles hearing the GameLobby music"
	prefs.toggles ^= SOUND_LOBBY
	prefs.save_preferences()
	if(prefs.toggles & SOUND_LOBBY)
		src << "You will now hear music in the game lobby."
		if(istype(mob, /mob/new_player))
			playtitlemusic()
	else
		src << "You will no longer hear music in the game lobby."
		if(istype(mob, /mob/new_player))
			mob.stopLobbySound()
	feedback_add_details("admin_verb","TLobby") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/togglemidis()
	set name = "Hear/Silence Midis"
	set category = "Preferences"
	set desc = "Toggles hearing sounds uploaded by admins"
	prefs.toggles ^= SOUND_MIDI
	prefs.save_preferences()
	if(prefs.toggles & SOUND_MIDI)
		src << "You will now hear any sounds uploaded by admins."
		if(admin_sound)
			src << admin_sound
	else
		src << "You will no longer hear sounds uploaded by admins; any currently playing midis have been disabled."
		if(admin_sound && !(admin_sound.status & SOUND_PAUSED))
			admin_sound.status |= SOUND_PAUSED
			src << admin_sound
			admin_sound.status ^= SOUND_PAUSED
	feedback_add_details("admin_verb","TMidi") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/stop_client_sounds()
	set name = "Stop Sounds"
	set category = "Preferences"
	set desc = "Kills all currently playing sounds, use if admin taste in midis a shite"
	src << sound(null)
	feedback_add_details("admin_verb","SAPS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/listen_ooc()
	set name = "Show/Hide OOC"
	set category = "Preferences"
	set desc = "Toggles seeing OutOfCharacter chat"
	prefs.chat_toggles ^= CHAT_OOC
	prefs.save_preferences()
	src << "You will [(prefs.chat_toggles & CHAT_OOC) ? "now" : "no longer"] see messages on the OOC channel."
	feedback_add_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/Toggle_Soundscape() //All new ambience should be added here so it works with this verb until someone better at things comes up with a fix that isn't awful
	set name = "Hear/Silence Ambience"
	set category = "Preferences"
	set desc = "Toggles hearing ambient sound effects"
	prefs.toggles ^= SOUND_AMBIENCE
	prefs.save_preferences()
	if(prefs.toggles & SOUND_AMBIENCE)
		src << "You will now hear ambient sounds."
	else
		src << "You will no longer hear ambient sounds."
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
	feedback_add_details("admin_verb","TAmbi") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

// This needs a toggle because you people are awful and spammed terrible music
/client/verb/toggle_instruments()
	set name = "Hear/Silence Instruments"
	set category = "Preferences"
	set desc = "Toggles hearing musical instruments like the violin and piano"
	prefs.toggles ^= SOUND_INSTRUMENTS
	prefs.save_preferences()
	if(prefs.toggles & SOUND_INSTRUMENTS)
		src << "You will now hear people playing musical instruments."
	else
		src << "You will no longer hear musical instruments."
	feedback_add_details("admin_verb","TInstru") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//Lots of people get headaches from the normal ship ambience, this is to prevent that
/client/verb/toggle_ship_ambience()
	set name = "Hear/Silence Ship Ambience"
	set category = "Preferences"
	set desc = "Toggles hearing generalized ship ambience, no matter your area."
	prefs.toggles ^= SOUND_SHIP_AMBIENCE
	prefs.save_preferences()
	if(prefs.toggles & SOUND_SHIP_AMBIENCE)
		src << "You will now hear ship ambience."
	else
		src << "You will no longer hear ship ambience."
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
		src.ambience_playing = 0
	feedback_add_details("admin_verb", "SAmbi") //If you are copy-pasting this, I bet you read this comment expecting to see the same thing :^)

var/global/list/ghost_forms = list("ghost","ghostking","ghostian2","skeleghost","ghost_red","ghost_black", \
							"ghost_blue","ghost_yellow","ghost_green","ghost_pink", \
							"ghost_cyan","ghost_dblue","ghost_dred","ghost_dgreen", \
							"ghost_dcyan","ghost_grey","ghost_dyellow","ghost_dpink", "ghost_purpleswirl","ghost_funkypurp","ghost_pinksherbert","ghost_blazeit",\
							"ghost_mellow","ghost_rainbow","ghost_camo","ghost_fire", "catghost")
/client/proc/pick_form()
	if(!is_content_unlocked())
		alert("This setting is for accounts with BYOND premium only.")
		return
	var/new_form = input(src, "Thanks for supporting BYOND - Choose your ghostly form:","Thanks for supporting BYOND",null) as null|anything in ghost_forms
	if(new_form)
		prefs.ghost_form = new_form
		prefs.save_preferences()
		if(istype(mob,/mob/dead/observer))
			var/mob/dead/observer/O = mob
			O.update_icon(new_form)

var/global/list/ghost_orbits = list(GHOST_ORBIT_CIRCLE,GHOST_ORBIT_TRIANGLE,GHOST_ORBIT_SQUARE,GHOST_ORBIT_HEXAGON,GHOST_ORBIT_PENTAGON)

/client/proc/pick_ghost_orbit()
	if(!is_content_unlocked())
		alert("This setting is for accounts with BYOND premium only.")
		return
	var/new_orbit = input(src, "Thanks for supporting BYOND - Choose your ghostly orbit:","Thanks for supporting BYOND",null) as null|anything in ghost_orbits
	if(new_orbit)
		prefs.ghost_orbit = new_orbit
		prefs.save_preferences()
		if(istype(mob, /mob/dead/observer))
			var/mob/dead/observer/O = mob
			O.ghost_orbit = new_orbit

/client/proc/pick_ghost_accs()
	var/new_ghost_accs = alert("Do you want your ghost to show full accessories where possible, hide accessories but still use the directional sprites where possible, or also ignore the directions and stick to the default sprites?",,"full accessories", "only directional sprites", "default sprites")
	if(new_ghost_accs)
		switch(new_ghost_accs)
			if("full accessories")
				prefs.ghost_accs = GHOST_ACCS_FULL
			if("only directional sprites")
				prefs.ghost_accs = GHOST_ACCS_DIR
			if("default sprites")
				prefs.ghost_accs = GHOST_ACCS_NONE
		prefs.save_preferences()
		if(istype(mob, /mob/dead/observer))
			var/mob/dead/observer/O = mob
			O.update_icon()

/client/verb/pick_ghost_customization()
	set name = "Ghost Customization"
	set category = "Preferences"
	set desc = "Customize your ghastly appearance."
	if(is_content_unlocked())
		switch(alert("Which setting do you want to change?",,"Ghost Form","Ghost Orbit","Ghost Accessories"))
			if("Ghost Form")
				pick_form()
			if("Ghost Orbit")
				pick_ghost_orbit()
			if("Ghost Accessories")
				pick_ghost_accs()
	else
		pick_ghost_accs()

/client/verb/pick_ghost_others()
	set name = "Ghosts of Others"
	set category = "Preferences"
	set desc = "Change display settings for the ghosts of other players."
	var/new_ghost_others = alert("Do you want the ghosts of others to show up as their own setting, as their default sprites or always as the default white ghost?",,"Their Setting", "Default Sprites", "White Ghost")
	if(new_ghost_others)
		switch(new_ghost_others)
			if("Their Setting")
				prefs.ghost_others = GHOST_OTHERS_THEIR_SETTING
			if("Default Sprites")
				prefs.ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
			if("White Ghost")
				prefs.ghost_others = GHOST_OTHERS_SIMPLE
		prefs.save_preferences()
		if(istype(mob, /mob/dead/observer))
			var/mob/dead/observer/O = mob
			O.updateghostsight()

/client/verb/toggle_intent_style()
	set name = "Toggle Intent Selection Style"
	set category = "Preferences"
	set desc = "Toggle between directly clicking the desired intent or clicking to rotate through."
	prefs.toggles ^= INTENT_STYLE
	src << "[(prefs.toggles & INTENT_STYLE) ? "Clicking directly on intents selects them." : "Clicking on intents rotates selection clockwise."]"
	prefs.save_preferences()
	feedback_add_details("admin_verb","ITENTS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/setup_character()
	set name = "Game Preferences"
	set category = "Preferences"
	set desc = "Allows you to access the Setup Character screen. Changes to your character won't take effect until next round, but other changes will."
	prefs.current_tab = 1
	prefs.ShowChoices(usr)

/client/verb/toggle_ghost_hud_pref()
	set name = "Toggle Ghost HUD"
	set category = "Preferences"
	set desc = "Hide/Show Ghost HUD"

	prefs.ghost_hud = !prefs.ghost_hud
	src << "Ghost HUD will now be [prefs.ghost_hud ? "visible" : "hidden"]."
	prefs.save_preferences()
	if(istype(mob,/mob/dead/observer))
		mob.hud_used.show_hud()

/client/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"
	set category = "Preferences"

	prefs.inquisitive_ghost = !prefs.inquisitive_ghost
	prefs.save_preferences()
	if(prefs.inquisitive_ghost)
		src << "<span class='notice'>You will now examine everything you click on.</span>"
	else
		src << "<span class='notice'>You will no longer examine things you click on.</span>"

/client/verb/toggle_announcement_sound()
	set name = "Hear/Silence Announcements"
	set category = "Preferences"
	set desc = ".Toggles hearing Central Command, Captain, VOX, and other announcement sounds"
	prefs.toggles ^= SOUND_ANNOUNCEMENTS
	src << "You will now [(prefs.toggles & SOUND_ANNOUNCEMENTS) ? "hear announcement sounds" : "no longer hear announcements"]."
	prefs.save_preferences()
	feedback_add_details("admin_verb","TAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
