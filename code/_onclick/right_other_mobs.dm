/mob/living/carbon/human/AltUnarmedAttack(atom/A, proximity)
	if(!has_active_hand())
		to_chat(src, "<span class='notice'>You look at the state of the universe and sigh.</span>") //lets face it, people rarely ever see this message in its intended condition.
		return TRUE

	return A.alt_attack_hand(src)

/mob/living/carbon/human/AltRangedAttack(atom/A, params)
	if(isturf(A) || incapacitated()) // pretty annoying to wave your fist at floors and walls. And useless.
		return 
	if(!CheckActionCooldown(CLICK_CD_RANGE))
		return
	DelayNextAction()
	var/list/target_viewers = fov_viewers(11, A) //doesn't check for blindness.
	if(!(src in target_viewers)) //click catcher issuing calls for out of view objects.
		return TRUE
	if(!has_active_hand())
		to_chat(src, "<span class='notice'>You ponder your life choices and sigh.</span>")
		return TRUE
	var/list/src_viewers = viewers(DEFAULT_MESSAGE_RANGE, src) - src // src has a different message.
	var/the_action = "waves to [A]"
	var/what_action = "waves to something you can't see"
	var/self_action = "wave to [A]"

	switch(a_intent)
		if(INTENT_DISARM)
			the_action = "shoos away [A]"
			what_action = "shoo away something out of your vision"
			self_action = "shoo away [A]"
		if(INTENT_GRAB)
			the_action = "beckons [A] to come"
			what_action = "beckons something out of your vision to come"
			self_action = "beckon [A] to come"
		if(INTENT_HARM)
			var/pronoun = "[p_their()]"
			the_action = "shakes [pronoun] fist at [A]"
			what_action = "shakes [pronoun] fist at something out of your vision"
			self_action = "shake your fist at [A]"

	if(!eye_blind)
		to_chat(src, "You [self_action].")
	for(var/B in src_viewers)
		var/mob/M = B
		if(!M.eye_blind)
			var/message = (M in target_viewers) ? the_action : what_action
			to_chat(M, "[src] [message].")
	return TRUE

/atom/proc/alt_attack_hand(mob/user)
	return FALSE
