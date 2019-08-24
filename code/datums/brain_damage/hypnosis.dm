/datum/brain_trauma/hypnosis
	name = "Hypnosis"
	desc = "Patient's unconscious is completely enthralled by a word or sentence, focusing their thoughts and actions on it."
	scan_desc = "looping thought pattern"
	gain_text = ""
	lose_text = ""
	resilience = TRAUMA_RESILIENCE_SURGERY
	var/hypnotic_phrase = ""
	var/regex/target_phrase

/datum/brain_trauma/hypnosis/New(phrase, quirk = FALSE)
	if(!phrase)
		qdel(src)
	if(quirk == TRUE)
		hypnotic_phrase = phrase
	else
		friendliify(phrase)
	if(IsAdminAdvancedProcCall())
		to_chat(usr, "<span class='danger'>Hypnosis New() skipped due to try/catch incompatibility with admin proccalling.</span>")
		qdel(src)
	try
		target_phrase = new("(\\b[hypnotic_phrase]\\b)","ig")
	catch(var/exception/e)
		stack_trace("[e] on [e.file]:[e.line]")
		qdel(src)
	..()

/datum/brain_trauma/hypnosis/proc/friendliify(phrase)
	phrase = replacetext(lowertext(phrase), "kill", "hug")
	phrase = replacetext(lowertext(phrase), "murder", "cuddle")
	phrase = replacetext(lowertext(phrase), "harm", "snuggle")
	phrase = replacetext(lowertext(phrase), "decapitate", "headpat")
	phrase = replacetext(lowertext(phrase), "strangle", "meow at")
	phrase = replacetext(lowertext(phrase), "suicide", "self-love")
	phrase = replacetext(lowertext(phrase), "lynch", "kiss")
	hypnotic_phrase = phrase

/datum/brain_trauma/hypnosis/on_gain()
	message_admins("[ADMIN_LOOKUPFLW(owner)] was hypnotized with the phrase '[hypnotic_phrase]'.")
	log_game("[key_name(owner)] was hypnotized with the phrase '[hypnotic_phrase]'.")
	to_chat(owner, "<span class='reallybig hypnophrase'>[hypnotic_phrase]</span>")
	to_chat(owner, "<span class='notice'>[pick("You feel your thoughts focusing on this phrase... you can't seem to get it out of your head.",\
												"Your head hurts, but this is all you can think of. It must be vitally important.",\
												"You feel a part of your mind repeating this over and over. You need to follow these words.",\
												"Something about this sounds... right, for some reason. You feel like you should follow these words.",\
												"These words keep echoing in your mind. You find yourself completely fascinated by them.")]</span>")
	if(!HAS_TRAIT(owner, "hypnotherapy"))
		to_chat(owner, "<span class='boldwarning'>You've been hypnotized by this sentence. You must follow these words. If it isn't a clear order, you can freely interpret how to do so,\
										as long as you act like the words are your highest priority.</span>")
	else
		to_chat(owner, "<span class='boldwarning'>You've been hypnotized by this sentence. You feel an incredible desire to follow these words, but are able to resist it somewhat. If it isn't a clear order, you can freely interpret how to do so,\
									however this does not take precedence over your other objectives.</span>")
	..()

/datum/brain_trauma/hypnosis/on_lose()
	message_admins("[ADMIN_LOOKUPFLW(owner)] is no longer hypnotized with the phrase '[hypnotic_phrase]'.")
	log_game("[key_name(owner)] is no longer hypnotized with the phrase '[hypnotic_phrase]'.")
	to_chat(owner, "<span class='userdanger'>You suddenly snap out of your fixation. The phrase '[hypnotic_phrase]' no longer feels important to you.</span>")
	..()

/datum/brain_trauma/hypnosis/on_life()
	..()
	if(prob(2))
		switch(rand(1,2))
			if(1)
				to_chat(owner, "<i>...[lowertext(hypnotic_phrase)]...</i>")
			if(2)
				new /datum/hallucination/chat(owner, TRUE, FALSE, "<span class='hypnophrase'>[hypnotic_phrase]</span>")

/datum/brain_trauma/hypnosis/on_hear(message, speaker, message_language, raw_message, radio_freq)
	message = target_phrase.Replace(message, "<span class='hypnophrase'>$1</span>")
	return message
