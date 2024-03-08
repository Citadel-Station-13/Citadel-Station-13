#define INCLUSIVE_MODE 1
#define EXCLUSIVE_MODE 2
#define RECOGNIZER_MODE 3
#define VOICE_SENSOR_MODE 4

/obj/item/assembly/voice
	name = "voice analyzer"
	desc = "A small electronic device able to record a voice sample, and send a signal when that sample is repeated."
	icon_state = "voice"
	custom_materials = list(/datum/material/iron=500, /datum/material/glass=50)
	flags_1 = HEAR_1
	attachable = TRUE
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	var/listening = FALSE
	var/recorded = "" //the activation message
	var/languages // The Message's language
	var/mode = 1
	var/static/list/modes = list("inclusive",
								 "exclusive",
								 "recognizer",
								 "voice sensor")

/obj/item/assembly/voice/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Use a multitool to swap between \"inclusive\", \"exclusive\", \"recognizer\", and \"voice sensor\" mode.</span>"

/obj/item/assembly/voice/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, atom/movable/source)
	. = ..()
	if(speaker == src)
		return

	if(listening && !radio_freq)
		record_speech(speaker, raw_message, message_language)
	else
		if(!istype(speaker, /obj/item/assembly/playback)) // Check if it isn't a playback device to prevent spam and lag
			if(message_language == languages) // If it isn't in the same language as the message, don't try to find the message
				if(check_activation(speaker, raw_message)) // Is it the message?
					addtimer(CALLBACK(src, PROC_REF(pulse), 0), 10)

/obj/item/assembly/voice/proc/record_speech(atom/movable/speaker, raw_message, datum/language/message_language)
	languages = message_language // Assign the message's language to a variable to use it elsewhere
	switch(mode)
		if(INCLUSIVE_MODE)
			recorded = raw_message
			listening = FALSE
			say("Activation message is '[recorded]'.", language = languages) // Say the message in the language it was said in
		if(EXCLUSIVE_MODE)
			recorded = raw_message
			listening = FALSE
			say("Activation message is '[recorded]'.", language = languages)
		if(RECOGNIZER_MODE)
			recorded = speaker.GetVoice()
			listening = FALSE
			say("Your voice pattern is saved.", language = languages)
		if(VOICE_SENSOR_MODE)
			if(length(raw_message))
				addtimer(CALLBACK(src, PROC_REF(pulse), 0), 10)

/obj/item/assembly/voice/proc/check_activation(atom/movable/speaker, raw_message)
	. = FALSE
	switch(mode)
		if(INCLUSIVE_MODE)
			if(findtext(raw_message, recorded))
				. = TRUE
		if(EXCLUSIVE_MODE)
			if(raw_message == recorded)
				. = TRUE
		if(RECOGNIZER_MODE)
			if(speaker.GetVoice() == recorded)
				. = TRUE
		if(VOICE_SENSOR_MODE)
			if(length(raw_message))
				. = TRUE

/obj/item/assembly/voice/multitool_act(mob/living/user, obj/item/I)
	mode %= modes.len
	mode++
	to_chat(user, "<span class='notice'>You set [src] into [modes[mode]] mode.</span>")
	listening = FALSE
	recorded = ""
	return TRUE

/obj/item/assembly/voice/activate()
	if(!secured || holder)
		return FALSE
	listening = !listening
	say("[listening ? "Now" : "No longer"] recording input.")
	return TRUE

/obj/item/assembly/voice/attack_self(mob/user)
	if(!user)
		return FALSE
	activate()
	return TRUE

/obj/item/assembly/voice/toggle_secure()
	. = ..()
	listening = FALSE

#undef INCLUSIVE_MODE
#undef EXCLUSIVE_MODE
#undef RECOGNIZER_MODE
#undef VOICE_SENSOR_MODE
