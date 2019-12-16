/mob/living/silicon/pai/say(message, bubble_type, var/list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(silent)
		to_chat(src, "<span class='warning'>Communication circuits remain unitialized.</span>")
	else
		..(message)

/mob/living/silicon/pai/binarycheck()
	return FALSE

/mob/living/silicon/pai/radio()
	if(radio_short)
		to_chat(src, "<span class='warning'>Your radio is shorted out!</span>")
		return ITALICS | REDUCE_RANGE
	return ..()
