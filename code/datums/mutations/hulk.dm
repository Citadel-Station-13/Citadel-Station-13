//Hulk turns your skin green, and allows you to punch through walls.
/datum/mutation/human/hulk
	name = "Hulk"
	desc = "A poorly understood genome that causes the holder's muscles to expand, inhibit speech and gives the person a bad skin condition."
	quality = POSITIVE
	locked = TRUE
	difficulty = 16
	text_gain_indication = "<span class='notice'>Your muscles hurt!</span>"
	health_req = 25
	instability = 40

/datum/mutation/human/hulk/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, TRAIT_HULK)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, TRAIT_HULK)
	ADD_TRAIT(owner, TRAIT_CHUNKYFINGERS, TRAIT_HULK)
	owner.update_body_parts()
	SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "hulk", /datum/mood_event/hulk)
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/hulk/on_attack_hand(atom/target, proximity, act_intent, unarmed_attack_flags)
	if(proximity && (act_intent == INTENT_HARM)) //no telekinetic hulk attack
		if(!owner.CheckActionCooldown(CLICK_CD_MELEE))
			return INTERRUPT_UNARMED_ATTACK | NO_AUTO_CLICKDELAY_HANDLING
		owner.DelayNextAction()
		target.attack_hulk(owner)
		return INTERRUPT_UNARMED_ATTACK | NO_AUTO_CLICKDELAY_HANDLING

/**
  *Checks damage of a hulk's arm and applies bone wounds as necessary.
  *
  *Called by specific atoms being attacked, such as walls. If an atom
  *does not call this proc, than punching that atom will not cause
  *arm breaking (even if the atom deals recoil damage to hulks).
  *Arguments:
  *arg1 is the arm to evaluate damage of and possibly break.
  */
/datum/mutation/human/hulk/proc/break_an_arm(obj/item/bodypart/arm)
	switch(arm.brute_dam)
		if(45 to 50)
			arm.force_wound_upwards(/datum/wound/blunt/critical)
		if(41 to 45)
			arm.force_wound_upwards(/datum/wound/blunt/severe)
		if(35 to 41)
			arm.force_wound_upwards(/datum/wound/blunt/moderate)

/datum/mutation/human/hulk/on_life()
	if(owner.health < 0)
		on_losing(owner)
		to_chat(owner, "<span class='danger'>You suddenly feel very weak.</span>")

/datum/mutation/human/hulk/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, TRAIT_HULK)
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, TRAIT_HULK)
	REMOVE_TRAIT(owner, TRAIT_CHUNKYFINGERS, TRAIT_HULK)
	owner.update_body_parts()
	SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "hulk")
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/hulk/proc/handle_speech(original_message, wrapped_message)
	var/message = wrapped_message[1]
	if(message)
		message = "[replacetext(message, ".", "!")]!!"
	wrapped_message[1] = message
	return COMPONENT_UPPERCASE_SPEECH
