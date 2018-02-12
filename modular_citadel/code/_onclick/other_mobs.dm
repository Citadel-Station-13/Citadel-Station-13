/mob/living/carbon/human/AltUnarmedAttack(atom/A, proximity)
	if(!has_active_hand())
		to_chat(src, "<span class='notice'>You look at the state of the universe and sigh.</span>") //lets face it, people rarely ever see this message in its intended condition.
		return TRUE

	if(!A.alt_attack_hand(src))
		A.attack_hand(src)
		return TRUE
	return TRUE

/atom/proc/alt_attack_hand(mob/user)
	return FALSE
