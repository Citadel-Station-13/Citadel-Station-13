/mob/living/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language=null, message_mode)
	var/static/list/eavesdropping_modes = list(MODE_WHISPER = TRUE, MODE_WHISPER_CRIT = TRUE)
	var/eavesdrop_range = 0
	if(eavesdropping_modes[message_mode])
		eavesdrop_range = EAVESDROP_EXTRA_RANGE
	var/list/listening = get_hearers_in_view(message_range+eavesdrop_range, source)
	var/list/the_dead = list()
	var/list/dead_away = list()
	var/list/yellareas	//CIT CHANGE - adds the ability for yelling to penetrate walls and echo throughout areas
	if(!eavesdrop_range && say_test(message) == "2")	//CIT CHANGE - ditto
		yellareas = get_areas_in_range(message_range*0.5, source)	//CIT CHANGE - ditto
	for(var/_M in GLOB.player_list)
		var/mob/M = _M
		if(M.stat != DEAD) //not dead, not important
			if(yellareas)	//CIT CHANGE - see above. makes yelling penetrate walls
				var/area/A = get_area(M)	//CIT CHANGE - ditto
				if(istype(A) && A.ambientsounds != SPACE && (A in yellareas))	//CIT CHANGE - ditto
					listening |= M	//CIT CHANGE - ditto
			continue
		if(!M.client || !client) //client is so that ghosts don't have to listen to mice
			continue
		if(get_dist(M, source) > 7 || M.z != z) //they're out of range of normal hearing
			if(eavesdropping_modes[message_mode] && !(M.client.prefs.chat_toggles & CHAT_GHOSTWHISPER)) //they're whispering and we have hearing whispers at any range off
				continue
			if(!(M.client.prefs.chat_toggles & CHAT_GHOSTEARS)) //they're talking normally and we have hearing at any range off
				continue
			dead_away[M] = TRUE
		listening |= M
		the_dead[M] = TRUE

	var/eavesdropping
	var/eavesrendered
	if(eavesdrop_range)
		eavesdropping = stars(message)
		eavesrendered = compose_message(src, message_language, eavesdropping, null, spans, message_mode, FALSE, source)

	var/rendered = compose_message(src, message_language, message, null, spans, message_mode, FALSE, source)
	for(var/_AM in listening)
		var/atom/movable/AM = _AM
		if(!(the_dead[AM]))
			if(eavesdrop_range && get_dist(source, AM) > message_range)
				AM.Hear(eavesrendered, src, message_language, eavesdropping, null, spans, message_mode, source)
			else
				AM.Hear(rendered, src, message_language, message, null, spans, message_mode, source)
		else if (dead_away[AM] && istype(AM, /mob/dead/observer))
			var/mob/dead/observer/O = AM
			O.HearNoPopup(rendered, src, message_language, message, null, spans, message_mode, source)
		else
			AM.Hear(rendered, src, message_language, message, null, spans, message_mode, source)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LIVING_SAY_SPECIAL, src, message)

	//speech bubble
	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client && !M.client.prefs.chat_on_map) //Skyrat change
			speech_bubble_recipients.Add(M.client)
	var/image/I = image('icons/mob/talk.dmi', src, "[bubble_type][say_test(message)]", FLY_LAYER)
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, /.proc/animate_speechbubble, I, speech_bubble_recipients, 30) //skyrat-edit 
