
/mob/living/silicon/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE)
	var/hit_percent = (100-blocked)/100
	if(!damage || (!forced && hit_percent <= 0))
		return 0
	if(istype(src, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = src
		if(R.shielded)
			var/absorb_dmg = 10 //less than 11 dmg is ignored
			R.cell.charge -= 500
			if(R.cell.charge <= 0)
				R.cell.charge = 0
				to_chat(src, "<span class='notice'>Your shield has overloaded!</span>")
			else
				damage -= absorb_dmg
				to_chat(R,"<span class='notice'>Your shield absorbs some of the impact!</span>")
			if(damage <= 0)
				return FALSE

	var/damage_amount = forced ? damage : damage * hit_percent
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage_amount, forced = forced)
		if(BURN)
			adjustFireLoss(damage_amount, forced = forced)
		if(OXY)
			if(damage < 0 || forced) //we shouldn't be taking oxygen damage through this proc, but we'll let it heal.
				adjustOxyLoss(damage_amount, forced = forced)
	return 1


/mob/living/silicon/apply_effect(effect = 0,effecttype = EFFECT_STUN, blocked = FALSE)
	return FALSE //The only effect that can hit them atm is flashes and they still directly edit so this works for now

/mob/living/silicon/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE) //immune to tox damage
	return FALSE

/mob/living/silicon/setToxLoss(amount, updating_health = TRUE, forced = FALSE)
	return FALSE

/mob/livi	ng/silicon/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE) //immune to clone damage
	return FALSE

/mob/living/silicon/setCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	return FALSE

/mob/living/silicon/adjustStaminaLoss(amount, updating_stamina = 1, forced = FALSE)//immune to stamina damage.
	return FALSE

/mob/living/silicon/setStaminaLoss(amount, updating_stamina = 1)
	return FALSE

/mob/living/silicon/adjustOrganLoss(slot, amount, maximum = 500)
	return FALSE

/mob/living/silicon/setOrganLoss(slot, amount)
	return FALSE
