
/mob/living/silicon/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = SHARP_NONE)
	var/hit_percent = (100-blocked)/100
	if(!damage || (!forced && hit_percent <= 0))
		return FALSE
	var/damage_amount = forced ? damage : damage * hit_percent
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage_amount, forced = forced)
		if(BURN)
			adjustFireLoss(damage_amount, forced = forced)
	return TRUE


/mob/living/silicon/apply_effect(effect = 0,effecttype = EFFECT_STUN, blocked = FALSE)
	return FALSE //The only effect that can hit them atm is flashes and they still directly edit so this works for now

/mob/living/silicon/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE, toxins_type = TOX_DEFAULT) //immune to tox damage
	return FALSE

/mob/living/silicon/setToxLoss(amount, updating_health = TRUE, forced = FALSE, toxins_type = TOX_OMNI)
	return FALSE

/mob/living/silicon/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE) //immune to clone damage
	return FALSE

/mob/living/silicon/setCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	return FALSE

/mob/living/silicon/adjustStaminaLoss(amount, updating_health = 1, forced = FALSE) //immune to stamina damage.
	return FALSE

/mob/living/silicon/setStaminaLoss(amount, updating_health = 1)
	return FALSE

/mob/living/silicon/adjustOrganLoss(slot, amount, maximum = 500)
	return FALSE

/mob/living/silicon/setOrganLoss(slot, amount)
	return FALSE

/mob/living/silicon/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE) //immune to oxygen damage
	if(istype(src, /mob/living/silicon/ai)) //ais are snowflakes and use oxyloss for being in AI cards and having no battery
		return ..()

	return FALSE

/mob/living/silicon/setOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(istype(src, /mob/living/silicon/ai)) //ditto
		return ..()

	return FALSE
