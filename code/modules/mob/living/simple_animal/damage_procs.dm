
/mob/living/simple_animal/proc/adjustHealth(amount, updating_health = TRUE, forced = FALSE, damage_type = BRUTE)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	bruteloss = round(clamp(bruteloss + amount, 0, maxHealth),DAMAGE_PRECISION)
	if(updating_health)
		updatehealth()
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, throw_damage_indicator), amount, damage_type)
	return amount

/mob/living/simple_animal/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, only_robotic = FALSE, only_organic = TRUE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced, BRUTE)
	else if(damage_coeff[BRUTE])
		. = adjustHealth(amount * damage_coeff[BRUTE] * CONFIG_GET(number/damage_multiplier), updating_health, forced, BRUTE)

/mob/living/simple_animal/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE, only_robotic = FALSE, only_organic = TRUE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced, BURN)
	else if(damage_coeff[BURN])
		. = adjustHealth(amount * damage_coeff[BURN] * CONFIG_GET(number/damage_multiplier), updating_health, forced, BURN)

/mob/living/simple_animal/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced, OXY)
	else if(damage_coeff[OXY])
		. = adjustHealth(amount * damage_coeff[OXY] * CONFIG_GET(number/damage_multiplier), updating_health, forced, OXY)

/mob/living/simple_animal/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE, toxins_type = TOX_DEFAULT)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced, TOX)
	else if(damage_coeff[TOX])
		. = adjustHealth(amount * damage_coeff[TOX] * CONFIG_GET(number/damage_multiplier), updating_health, forced, TOX)

/mob/living/simple_animal/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced, CLONE)
	else if(damage_coeff[CLONE])
		. = adjustHealth(amount * damage_coeff[CLONE] * CONFIG_GET(number/damage_multiplier), updating_health, forced, CLONE)

/mob/living/simple_animal/adjustStaminaLoss(amount, forced = FALSE)
	return
