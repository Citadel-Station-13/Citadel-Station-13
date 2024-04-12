
/mob/living/carbon/alien/getToxLoss(toxins_type = TOX_OMNI)
	return FALSE

/mob/living/carbon/alien/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE, toxins_type = TOX_DEFAULT) //alien immune to tox damage
	return FALSE

//aliens are immune to stamina damage.
/mob/living/carbon/alien/adjustStaminaLoss(amount, updating_health = TRUE, forced = FALSE)
	return

/mob/living/carbon/alien/setStaminaLoss(amount, updating_health = TRUE, forced = FALSE)
	return
