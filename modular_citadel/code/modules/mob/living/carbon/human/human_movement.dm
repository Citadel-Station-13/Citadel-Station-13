/mob/living/carbon/human
	var/sprinting = FALSE

/mob/living/carbon/human/Move(NewLoc, direct)
	. = ..()
	if(. && sprinting && !resting && m_intent == MOVE_INTENT_RUN)
		adjustStaminaLoss(0.3)

/mob/living/carbon/human/movement_delay()
	. = 0
	if(!resting && m_intent == MOVE_INTENT_RUN && !sprinting)
		. += 1
	. += ..()

/mob/living/carbon/human/proc/togglesprint() // If you call this proc outside of hotkeys or clicking the HUD button, I'll be disappointed in you.
	sprinting = !sprinting
	if(!resting && m_intent == MOVE_INTENT_RUN && canmove)
		if(sprinting)
			playsound_local(src, 'modular_citadel/sound/misc/sprintactivate.ogg', 50, FALSE, pressure_affected = FALSE)
		else
			playsound_local(src, 'modular_citadel/sound/misc/sprintdeactivate.ogg', 50, FALSE, pressure_affected = FALSE)
	return TRUE
