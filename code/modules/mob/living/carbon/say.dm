/mob/living/carbon/treat_message(message)
	message = ..(message)
	var/obj/item/organ/tongue/T = getorganslot("tongue")
	if(!T) //hoooooouaah!
		var/regex/tongueless_lower = new("\[gdntke]+", "g")
		var/regex/tongueless_upper = new("\[GDNTKE]+", "g")
		if(copytext(message, 1, 2) != "*")
			message = tongueless_lower.Replace(message, pick("aa","oo","'"))
			message = tongueless_upper.Replace(message, pick("AA","OO","'"))
	else
		message = T.TongueSpeech(message)
	if(wear_mask)
		message = wear_mask.speechModification(message)

	return message

/mob/living/carbon/can_speak_vocal(message)
	if(silent)
		return 0
	return ..()

/mob/living/carbon/get_spans()
	. = ..()
	var/obj/item/organ/tongue/T = getorganslot("tongue")
	if(T)
		. |= T.get_spans()

	var/obj/item/I = get_active_held_item()
	if(I)
		. |= I.get_held_item_speechspans(src)

/mob/living/carbon/can_speak_in_language(datum/language/dt)
	if(HAS_SECONDARY_FLAG(src, OMNITONGUE))
		. = has_language(dt)
	else if(has_language(dt))
		var/obj/item/organ/tongue/T = getorganslot("tongue")
		if(T)
			. = T.can_speak_in_language(dt)
		else
			. = initial(dt.flags) & TONGUELESS_SPEECH
	else
		. = FALSE
