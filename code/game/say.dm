/*
 	Miauw's big Say() rewrite.
	This file has the basic atom/movable level speech procs.
	And the base of the send_speech() proc, which is the core of saycode.
*/
GLOBAL_LIST_INIT(freqtospan, list(
	"[FREQ_SCIENCE]" = "sciradio",
	"[FREQ_MEDICAL]" = "medradio",
	"[FREQ_ENGINEERING]" = "engradio",
	"[FREQ_SUPPLY]" = "suppradio",
	"[FREQ_SERVICE]" = "servradio",
	"[FREQ_SECURITY]" = "secradio",
	"[FREQ_COMMAND]" = "comradio",
	"[FREQ_AI_PRIVATE]" = "aiprivradio",
	"[FREQ_SYNDICATE]" = "syndradio",
	"[FREQ_CENTCOM]" = "centcomradio",
	"[FREQ_CTF_RED]" = "redteamradio",
	"[FREQ_CTF_BLUE]" = "blueteamradio"
	))

/atom/movable/proc/say(message, bubble_type, var/list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_selected_language()
	send_speech(message, 7, src, , spans, message_language=language)

/atom/movable/proc/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, atom/movable/source)
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, args)

/atom/movable/proc/bark(list/hearers, distance, volume, pitch, queue_time)
	if(queue_time && vocal_current_bark != queue_time)
		return
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_BARK, hearers, distance, volume, pitch))
		return //bark interception. this probably counts as some flavor of BDSM
	if(!vocal_bark)
		if(!vocal_bark_id || !set_bark(vocal_bark_id)) //just-in-time bark generation
			return
	volume = min(volume, 100)
	var/turf/T = get_turf(src)
	for(var/mob/M in hearers)
		M.playsound_local(T, vol = volume, vary = TRUE, frequency = pitch, max_distance = distance, falloff_distance = 0, falloff_exponent = BARK_SOUND_FALLOFF_EXPONENT(distance), S = vocal_bark, distance_multiplier = 1)

/atom/movable/proc/can_speak()
	return TRUE

/atom/movable/proc/send_speech(message, range = 7, atom/movable/source = src, bubble_type, list/spans, datum/language/message_language = null, message_mode)
	var/rendered = compose_message(src, message_language, message, , spans, message_mode, source)
	var/list/hearers = get_hearers_in_view(range, source)
	for(var/_AM in hearers)
		var/atom/movable/AM = _AM
		AM.Hear(rendered, src, message_language, message, , spans, message_mode, source)
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_QUEUE_BARK, hearers, args) || vocal_bark || vocal_bark_id)
		for(var/mob/M in hearers)
			if(!M.client)
				continue
			if(!(M.client.prefs.toggles & SOUND_BARK))
				hearers -= M
		var/barks = min(round((LAZYLEN(message) / vocal_speed)) + 1, BARK_MAX_BARKS)
		var/total_delay
		vocal_current_bark = world.time //this is juuuuust random enough to reliably be unique every time send_speech() is called, in most scenarios
		for(var/i in 1 to barks)
			if(total_delay > BARK_MAX_TIME)
				break
			addtimer(CALLBACK(src, PROC_REF(bark), hearers, range, vocal_volume, BARK_DO_VARY(vocal_pitch, vocal_pitch_range), vocal_current_bark), total_delay)
			total_delay += rand(DS2TICKS(vocal_speed / BARK_SPEED_BASELINE), DS2TICKS(vocal_speed / BARK_SPEED_BASELINE) + DS2TICKS(vocal_speed / BARK_SPEED_BASELINE)) TICKS

/atom/movable/proc/compose_message(atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode, face_name = FALSE, atom/movable/source)
	if(!source)
		source = speaker
	//This proc uses text() because it is faster than appending strings. Thanks BYOND.
	//Basic span
	var/spanpart1 = "<span class='[radio_freq ? get_radio_span(radio_freq) : "game say"]'>"
	//Start name span.
	var/spanpart2 = "<span class='name'>"
	//Radio freq/name display
	var/freqpart = radio_freq ? "\[[get_radio_name(radio_freq)]\] " : ""
	//Speaker name
	var/namepart = "[speaker.GetVoice()][speaker.get_alt_name()]"
	if(face_name && ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		namepart = "[H.get_face_name()]" //So "fake" speaking like in hallucinations does not give the speaker away if disguised
	//End name span.
	var/endspanpart = "</span>"

	//Message
	var/messagepart = " <span class='message'>[lang_treat(speaker, message_language, raw_message, spans, message_mode)]</span></span>"

	var/languageicon = ""
	var/datum/language/D = GLOB.language_datum_instances[message_language]
	if(istype(D) && D.display_icon(src))
		languageicon = "[D.get_icon()] "

	return "[spanpart1][spanpart2][freqpart][languageicon][compose_track_href(speaker, namepart)][namepart][compose_job(speaker, message_language, raw_message, radio_freq)][endspanpart][messagepart]"

/atom/movable/proc/compose_track_href(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/compose_job(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/say_mod(input, message_mode)
	var/ending = copytext_char(input, -1)
	if(copytext_char(input, -2) == "!!")
		return verb_yell
	else if(ending == "?")
		return verb_ask
	else if(ending == "!")
		return verb_exclaim
	else
		return verb_say

/atom/movable/proc/say_quote(input, list/spans=list(speech_span), message_mode)
	if(!input)
		input = "..."

	if(copytext_char(input, -2) == "!!")
		spans |= SPAN_YELL

	var/spanned = attach_spans(input, spans)
	return "[say_mod(input, message_mode)][spanned ? ", \"[spanned]\"" : ""]"
	// Citadel edit [spanned ? ", \"[spanned]\"" : ""]"

/// Converts specific characters, like +, |, and _ to formatted output.
/atom/movable/proc/say_emphasis(input)
	var/static/regex/italics = regex(@"\|((?=\S)[\w\W]*?(?<=\S))\|", "g")
	input = italics.Replace_char(input, "<i>$1</i>")
	var/static/regex/bold = regex(@"\+((?=\S)[\w\W]*?(?<=\S))\+", "g")
	input = bold.Replace_char(input, "<b>$1</b>")
	var/static/regex/underline = regex(@"_((?=\S)[\w\W]*?(?<=\S))_", "g")
	input = underline.Replace_char(input, "<u>$1</u>")
	return input

/// Quirky citadel proc for our custom sayverbs to strip the verb out. Snowflakey as hell, say rewrite 3.0 when?
/atom/movable/proc/quoteless_say_quote(input, list/spans = list(speech_span), message_mode)
	if((input[1] == "!") && (length_char(input) > 1))
		return ""
	var/pos = findtext(input, "*")
	return pos? copytext(input, pos + 1) : input

/atom/movable/proc/lang_treat(atom/movable/speaker, datum/language/language, raw_message, list/spans, message_mode, no_quote = FALSE)
	if(has_language(language))
		var/atom/movable/AM = speaker.GetSource()
		raw_message = say_emphasis(raw_message)
		if(AM) //Basically means "if the speaker is virtual"
			return no_quote ? AM.quoteless_say_quote(raw_message, spans, message_mode) : AM.say_quote(raw_message, spans, message_mode)
		else
			return no_quote ? speaker.quoteless_say_quote(raw_message, spans, message_mode) : speaker.say_quote(raw_message, spans, message_mode)
	else if(language)
		var/atom/movable/AM = speaker.GetSource()
		var/datum/language/D = GLOB.language_datum_instances[language]
		raw_message = D.scramble(raw_message)
		if(AM)
			return no_quote ? AM.quoteless_say_quote(raw_message, spans, message_mode) : AM.say_quote(raw_message, spans, message_mode)
		else
			return no_quote ? speaker.quoteless_say_quote(raw_message, spans, message_mode) : speaker.say_quote(raw_message, spans, message_mode)
	else
		return "makes a strange sound."

/proc/get_radio_span(freq)
	var/returntext = GLOB.freqtospan["[freq]"]
	if(returntext)
		return returntext
	return "radio"

/proc/get_radio_name(freq)
	var/returntext = GLOB.reverseradiochannels["[freq]"]
	if(returntext)
		return returntext
	return "[copytext_char("[freq]", 1, 4)].[copytext_char("[freq]", 4, 5)]"

/atom/movable/proc/attach_spans(input, list/spans)
	if((input[1] == "!") && (length(input) > 2))
		return
	var/customsayverb = findtext(input, "*")
	if(customsayverb)
		input = capitalize(copytext(input, customsayverb + length(input[customsayverb])))
	if(input)
		return "[message_spans_start(spans)][input]</span>"
	else
		return

/proc/message_spans_start(list/spans)
	var/output = "<span class='"
	for(var/S in spans)
		output = "[output][S] "
	output = "[output]'>"
	return output

/proc/say_test(text)
	var/ending = copytext_char(text, -1)
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

/atom/movable/proc/GetVoice()
	return "[src]"	//Returns the atom's name, prepended with 'The' if it's not a proper noun

/atom/movable/proc/IsVocal()
	return TRUE

/atom/movable/proc/get_alt_name()

//HACKY VIRTUALSPEAKER STUFF BEYOND THIS POINT
//these exist mostly to deal with the AIs hrefs and job stuff.

/atom/movable/proc/GetJob() //Get a job, you lazy butte

/atom/movable/proc/GetSource()

/atom/movable/proc/GetRadio()

//VIRTUALSPEAKERS
/atom/movable/virtualspeaker
	var/job
	var/atom/movable/source
	var/obj/item/radio/radio

INITIALIZE_IMMEDIATE(/atom/movable/virtualspeaker)
/atom/movable/virtualspeaker/Initialize(mapload, atom/movable/M, radio)
	. = ..()
	radio = radio
	source = M
	if (istype(M))
		name = M.GetVoice()
		verb_say = M.verb_say
		verb_ask = M.verb_ask
		verb_exclaim = M.verb_exclaim
		verb_yell = M.verb_yell

	// The mob's job identity
	if(ishuman(M))
		// Humans use their job as seen on the crew manifest. This is so the AI
		// can know their job even if they don't carry an ID.
		var/datum/data/record/findjob = find_record("name", name, GLOB.data_core.general)
		if(findjob)
			job = findjob.fields["rank"]
		else
			job = "Unknown"
	else if(iscarbon(M))  // Carbon nonhuman
		job = "No ID"
	else if(isAI(M))  // AI
		job = "AI"
	else if(iscyborg(M))  // Cyborg
		var/mob/living/silicon/robot/B = M
		job = "[B.designation] Cyborg"
	else if(istype(M, /mob/living/silicon/pai))  // Personal AI (pAI)
		job = "Personal AI"
	else if(isobj(M))  // Cold, emotionless machines
		job = "Machine"
	else  // Unidentifiable mob
		job = "Unknown"

/atom/movable/virtualspeaker/GetJob()
	return job

/atom/movable/virtualspeaker/GetSource()
	return source

/atom/movable/virtualspeaker/GetRadio()
	return radio
