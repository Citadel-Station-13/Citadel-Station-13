GLOBAL_LIST_INIT(department_radio_prefixes, list(":", "."))

GLOBAL_LIST_INIT(department_radio_keys, list(
	// Location
	MODE_KEY_R_HAND = MODE_R_HAND,
	MODE_KEY_L_HAND = MODE_L_HAND,
	MODE_KEY_INTERCOM = MODE_INTERCOM,

	// Department
	MODE_KEY_DEPARTMENT = MODE_DEPARTMENT,
	RADIO_KEY_COMMAND = RADIO_CHANNEL_COMMAND,
	RADIO_KEY_SCIENCE = RADIO_CHANNEL_SCIENCE,
	RADIO_KEY_MEDICAL = RADIO_CHANNEL_MEDICAL,
	RADIO_KEY_ENGINEERING = RADIO_CHANNEL_ENGINEERING,
	RADIO_KEY_SECURITY = RADIO_CHANNEL_SECURITY,
	RADIO_KEY_SUPPLY = RADIO_CHANNEL_SUPPLY,
	RADIO_KEY_SERVICE = RADIO_CHANNEL_SERVICE,

	// Faction
	RADIO_KEY_SYNDICATE = RADIO_CHANNEL_SYNDICATE,
	RADIO_KEY_CENTCOM = RADIO_CHANNEL_CENTCOM,

	// Admin
	MODE_KEY_ADMIN = MODE_ADMIN,
	MODE_KEY_DEADMIN = MODE_DEADMIN,

	// Misc
	RADIO_KEY_AI_PRIVATE = RADIO_CHANNEL_AI_PRIVATE, // AI Upload channel
	MODE_KEY_VOCALCORDS = MODE_VOCALCORDS,		// vocal cords, used by Voice of God


	//kinda localization -- rastaf0
	//same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	// Location
	"ê" = MODE_R_HAND,
	"ä" = MODE_L_HAND,
	"ø" = MODE_INTERCOM,

	// Department
	"ð" = MODE_DEPARTMENT,
	"ñ" = RADIO_CHANNEL_COMMAND,
	"ò" = RADIO_CHANNEL_SCIENCE,
	"ü" = RADIO_CHANNEL_MEDICAL,
	"ó" = RADIO_CHANNEL_ENGINEERING,
	"û" = RADIO_CHANNEL_SECURITY,
	"ã" = RADIO_CHANNEL_SUPPLY,
	"ì" = RADIO_CHANNEL_SERVICE,

	// Faction
	"å" = RADIO_CHANNEL_SYNDICATE,
	"í" = RADIO_CHANNEL_CENTCOM,

	// Admin
	"ç" = MODE_ADMIN,
	"â" = MODE_ADMIN,

	// Misc
	"ù" = RADIO_CHANNEL_AI_PRIVATE,
	"÷" = MODE_VOCALCORDS
))

/mob/living/proc/Ellipsis(original_msg, chance = 50, keep_words)
	if(chance <= 0)
		return "..."
	if(chance >= 100)
		return original_msg

	var/list/words = splittext(original_msg," ")
	var/list/new_words = list()

	var/new_msg = ""

	for(var/w in words)
		if(prob(chance))
			new_words += "..."
			if(!keep_words)
				continue
		new_words += w

	new_msg = jointext(new_words," ")

	return new_msg

/mob/living/say(message, bubble_type,var/list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	var/static/list/crit_allowed_modes = list(MODE_WHISPER = TRUE, MODE_CHANGELING = TRUE, MODE_ALIEN = TRUE)
	var/static/list/unconscious_allowed_modes = list(MODE_CHANGELING = TRUE, MODE_ALIEN = TRUE)
	var/talk_key = get_key(message)

	var/static/list/one_character_prefix = list(MODE_HEADSET = TRUE, MODE_ROBOT = TRUE, MODE_WHISPER = TRUE)

	if(sanitize)
		message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))
	if(!message || message == "")
		return

	var/datum/saymode/saymode = SSradio.saymodes[talk_key]
	var/message_mode = get_message_mode(message)
	var/original_message = message
	var/in_critical = InCritical()

	if(one_character_prefix[message_mode])
		message = copytext_char(message, 2)
	else if(message_mode || saymode)
		message = copytext_char(message, 3)
	message = trim_left(message)
	if(!message)
		return
	if(message_mode == MODE_ADMIN)
		if(client)
			client.cmd_admin_say(message)
		return

	if(message_mode == MODE_DEADMIN)
		if(client)
			client.dsay(message)
		return

	if(stat == DEAD)
		say_dead(original_message)
		return

	if(check_emote(original_message) || !can_speak_basic(original_message, ignore_spam))
		return

	if(in_critical)
		if(!(crit_allowed_modes[message_mode]))
			return
	else if(stat == UNCONSCIOUS)
		if(!(unconscious_allowed_modes[message_mode]))
			return

	// language comma detection.
	var/datum/language/message_language = get_message_language(message)
	if(message_language)
		// No, you cannot speak in xenocommon just because you know the key
		if(can_speak_language(message_language))
			language = message_language
		message = copytext_char(message, 3)

		// Trim the space if they said ",0 I LOVE LANGUAGES"
		message = trim_left(message)

	if(!language)
		language = get_selected_language()

	// Detection of language needs to be before inherent channels, because
	// AIs use inherent channels for the holopad. Most inherent channels
	// ignore the language argument however.

	if(saymode && !saymode.handle_message(src, message, language))
		return

	if(!can_speak_vocal(message))
		to_chat(src, "<span class='warning'>You find yourself unable to speak!</span>")
		return

	var/message_range = 7

	var/succumbed = FALSE

	var/fullcrit = InFullCritical()
	if((InCritical() && !fullcrit) || message_mode == MODE_WHISPER)
		message_range = 1
		message_mode = MODE_WHISPER
		src.log_talk(message, LOG_WHISPER)
		if(fullcrit)
			var/health_diff = round(-HEALTH_THRESHOLD_DEAD + health)
			// If we cut our message short, abruptly end it with a-..
			var/message_len = length_char(message)
			message = copytext_char(message, 1, health_diff) + "[message_len > health_diff ? "-.." : "..."]"
			message = Ellipsis(message, 10, 1)
			message_mode = MODE_WHISPER_CRIT
			succumbed = TRUE
	else
		src.log_talk(message, LOG_SAY, forced_by=forced)

	message = treat_message(message) // unfortunately we still need this
	var/sigreturn = SEND_SIGNAL(src, COMSIG_MOB_SAY, args)
	if (sigreturn & COMPONENT_UPPERCASE_SPEECH)
		message = uppertext(message)
	if(!message)
		return

	last_words = message

	spans |= speech_span

	if(language)
		var/datum/language/L = GLOB.language_datum_instances[language]
		spans |= L.spans

	var/radio_return = radio(message, message_mode, spans, language)
	if(radio_return & ITALICS)
		spans |= SPAN_ITALICS
	if(radio_return & REDUCE_RANGE)
		message_range = 1
	if(radio_return & NOPASS)
		return 1

	//No screams in space, unless you're next to someone.
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	var/pressure = (environment)? environment.return_pressure() : 0
	if(pressure < SOUND_MINIMUM_PRESSURE)
		message_range = 1

	if(pressure < ONE_ATMOSPHERE*0.4) //Thin air, let's italicise the message
		spans |= SPAN_ITALICS

	send_speech(message, message_range, src, bubble_type, spans, language, message_mode)

	if(succumbed)
		succumb()
		to_chat(src, compose_message(src, language, message, null, spans, message_mode))

	return 1

/mob/living/compose_message(atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode, face_name = FALSE, atom/movable/source)
	. = ..()
	if(isliving(speaker))
		var/turf/sourceturf = get_turf(source)
		var/turf/T = get_turf(src)
		if(sourceturf && T && !(sourceturf in get_hear(5, T)))
			. = "<span class='small'>[.]</span>"

/mob/living/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode, atom/movable/source)
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, args) //parent calls can't overwrite the current proc args.
	if(!client)
		return
	var/deaf_message
	var/deaf_type
	if(speaker != src)
		if(!radio_freq) //These checks have to be seperate, else people talking on the radio will make "You can't hear yourself!" appear when hearing people over the radio while deaf.
			deaf_message = "<span class='name'>[speaker]</span> [speaker.verb_say] something but you cannot hear [speaker.p_them()]."
			deaf_type = 1
	else
		deaf_message = "<span class='notice'>You can't hear yourself!</span>"
		deaf_type = 2 // Since you should be able to hear yourself without looking

	// Create map text prior to modifying message for goonchat
	if (client?.prefs.chat_on_map && stat != UNCONSCIOUS && (client.prefs.see_chat_non_mob || ismob(speaker)) && can_hear())
		create_chat_message(speaker, message_language, raw_message, spans, message_mode)

	// Recompose message for AI hrefs, language incomprehension.
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mode, FALSE, source)

	show_message(message, MSG_AUDIBLE, deaf_message, deaf_type)
	return message

/mob/living/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language=null, message_mode)
	var/static/list/eavesdropping_modes = list(MODE_WHISPER = TRUE, MODE_WHISPER_CRIT = TRUE)
	var/eavesdrop_range = 0
	if(eavesdropping_modes[message_mode])
		eavesdrop_range = EAVESDROP_EXTRA_RANGE
	var/list/listening = get_hearers_in_view(message_range+eavesdrop_range, source)
	var/list/the_dead = list()
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
		if(eavesdrop_range && get_dist(source, AM) > message_range && !(the_dead[AM]))
			AM.Hear(eavesrendered, src, message_language, eavesdropping, null, spans, message_mode, source)
		else
			AM.Hear(rendered, src, message_language, message, null, spans, message_mode, source)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LIVING_SAY_SPECIAL, src, message)

	//speech bubble
	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client && !M.client.prefs.chat_on_map)
			speech_bubble_recipients.Add(M.client)
	var/image/I = image('icons/mob/talk.dmi', src, "[bubble_type][say_test(message)]", FLY_LAYER)
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, /.proc/flick_overlay, I, speech_bubble_recipients, 30)

/mob/proc/binarycheck()
	return FALSE

/mob/living/can_speak(message) //For use outside of Say()
	if(can_speak_basic(message) && can_speak_vocal(message))
		return 1

/mob/living/proc/can_speak_basic(message, ignore_spam = FALSE) //Check BEFORE handling of xeno and ling channels
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='danger'>You cannot speak in IC (muted).</span>")
			return 0
		if(!ignore_spam && client.handle_spam_prevention(message,MUTE_IC))
			return 0

	return 1

/mob/living/proc/can_speak_vocal(message) //Check AFTER handling of xeno and ling channels
	if(HAS_TRAIT(src, TRAIT_MUTE))
		return 0

	if(is_muzzled())
		return 0

	if(!IsVocal())
		return 0

	return 1

/mob/living/proc/get_key(message)
	var/key = message[1]
	if(key in GLOB.department_radio_prefixes)
		return lowertext(message[1 + length(key)])

/mob/living/proc/get_message_language(message)
	if(message[1] == ",")
		var/key = message[1 + length(message[1])]
		for(var/ld in GLOB.all_languages)
			var/datum/language/LD = ld
			if(initial(LD.key) == key)
				return LD
	return null

/mob/living/proc/treat_message(message)

	if(HAS_TRAIT(src, TRAIT_UNINTELLIGIBLE_SPEECH))
		message = unintelligize(message)

	if(derpspeech)
		message = derpspeech(message, stuttering)

	if(stuttering)
		message = stutter(message)

	if(slurring)
		message = slur(message,slurring)

	if(cultslurring)
		message = cultslur(message)

	if(clockcultslurring)
		message = CLOCK_CULT_SLUR(message)

	message = capitalize(message)

	return message

/mob/living/proc/radio(message, message_mode, list/spans, language)
	var/obj/item/implant/radio/imp = locate() in implants
	if(imp?.radio.on)
		if(message_mode == MODE_HEADSET)
			imp.radio.talk_into(src, message, , spans, language)
			return ITALICS | REDUCE_RANGE
		if(message_mode == MODE_DEPARTMENT || (message_mode in GLOB.radiochannels))
			imp.radio.talk_into(src, message, message_mode, spans, language)
			return ITALICS | REDUCE_RANGE

	switch(message_mode)
		if(MODE_WHISPER)
			return ITALICS
		if(MODE_R_HAND)
			for(var/obj/item/r_hand in get_held_items_for_side("r", all = TRUE))
				if (r_hand)
					return r_hand.talk_into(src, message, , spans, language)
				return ITALICS | REDUCE_RANGE
		if(MODE_L_HAND)
			for(var/obj/item/l_hand in get_held_items_for_side("l", all = TRUE))
				if (l_hand)
					return l_hand.talk_into(src, message, , spans, language)
				return ITALICS | REDUCE_RANGE

		if(MODE_INTERCOM)
			for (var/obj/item/radio/intercom/I in view(1, null))
				I.talk_into(src, message, , spans, language)
			return ITALICS | REDUCE_RANGE

		if(MODE_BINARY)
			return ITALICS | REDUCE_RANGE //Does not return 0 since this is only reached by humans, not borgs or AIs.

	return 0

/mob/living/say_mod(input, message_mode)
	. = ..()
	if(message_mode == MODE_WHISPER_CRIT)
		. = "[verb_whisper] in [p_their()] last breath"
	else if(message_mode != MODE_CUSTOM_SAY)
		if(message_mode == MODE_WHISPER)
			. = verb_whisper
		else if(stuttering)
			. = "stammers"
		else if(derpspeech)
			. = "gibbers"

/mob/living/whisper(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	say("#[message]", bubble_type, spans, sanitize, language, ignore_spam, forced)

/mob/living/get_language_holder(get_minds = TRUE)
	if(get_minds && mind)
		return mind.get_language_holder()
	. = ..()
