/obj/item/assembly/playback
	name = "playback device"
	desc = "A small electronic device able to record a voice sample, and repeat that sample when it receive a signal."
	icon_state = "radio"
	custom_materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	flags_1 = HEAR_1
	attachable = TRUE
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	var/listening = FALSE
	var/recorded = "" //the activation message
	var/languages

/obj/item/assembly/playback/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, atom/movable/source)
	. = ..()
	if(speaker == src)
		return

	if(listening && !radio_freq)
		record_speech(speaker, raw_message, message_language)

/obj/item/assembly/playback/proc/record_speech(atom/movable/speaker, raw_message, datum/language/message_language)
	recorded = raw_message
	listening = FALSE
	languages = message_language
	say("The recorded message is '[recorded]'.", language = message_language)
	activate_cooldown = max(round(length(recorded) * 0.5), 3 SECONDS)

/obj/item/assembly/playback/activate()
	. = ..()
	if(!. || !recorded) // Why say anything when there isn't anything to say
		return FALSE
	say("[recorded]", language = languages) // Repeat the message in the language it was said in

/obj/item/assembly/playback/proc/record()
	if(!secured || holder)
		return FALSE
	listening = !listening
	say("[listening ? "Now" : "No longer"] recording input.")
	return TRUE

/obj/item/assembly/playback/attack_self(mob/user)
	if(!user)
		return FALSE
	record()
	return TRUE

/obj/item/assembly/playback/toggle_secure()
	. = ..()
	listening = FALSE
