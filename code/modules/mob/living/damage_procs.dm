
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = 0)
	var/hit_percent = (100-blocked)/100
	if(!damage || (hit_percent <= 0))
		return 0
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage * hit_percent)
		if(BURN)
			adjustFireLoss(damage * hit_percent)
		if(TOX)
			adjustToxLoss(damage * hit_percent)
		if(OXY)
			adjustOxyLoss(damage * hit_percent)
		if(CLONE)
			adjustCloneLoss(damage * hit_percent)
		if(STAMINA)
			adjustStaminaLoss(damage * hit_percent)
	return 1


/mob/living/proc/apply_damages(brute = 0, burn = 0, tox = 0, oxy = 0, clone = 0, def_zone = null, blocked = 0, stamina = 0)
	if(blocked >= 100)
		return 0
	if(brute)
		apply_damage(brute, BRUTE, def_zone, blocked)
	if(burn)
		apply_damage(burn, BURN, def_zone, blocked)
	if(tox)
		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)
		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)
		apply_damage(clone, CLONE, def_zone, blocked)
	if(stamina)
		apply_damage(stamina, STAMINA, def_zone, blocked)
	return 1



/mob/living/proc/apply_effect(effect = 0,effecttype = STUN, blocked = 0)
	var/hit_percent = (100-blocked)/100
	if(!effect || (hit_percent <= 0))
		return 0
	switch(effecttype)
		if(STUN)
			Stun(effect * hit_percent)
		if(WEAKEN)
			Weaken(effect * hit_percent)
		if(PARALYZE)
			Paralyse(effect * hit_percent)
		if(IRRADIATE)
			radiation += max(effect * hit_percent, 0)
		if(SLUR)
			slurring = max(slurring,(effect * hit_percent))
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = max(stuttering,(effect * hit_percent))
		if(EYE_BLUR)
			blur_eyes(effect * hit_percent)
		if(DROWSY)
			drowsyness = max(drowsyness,(effect * hit_percent))
		if(JITTER)
			if(status_flags & CANSTUN)
				jitteriness = max(jitteriness,(effect * hit_percent))
	return 1


/mob/living/proc/apply_effects(stun = 0, weaken = 0, paralyze = 0, irradiate = 0, slur = 0, stutter = 0, eyeblur = 0, drowsy = 0, blocked = 0, stamina = 0, jitter = 0)
	if(blocked >= 100)
		return 0
	if(stun)
		apply_effect(stun, STUN, blocked)
	if(weaken)
		apply_effect(weaken, WEAKEN, blocked)
	if(paralyze)
		apply_effect(paralyze, PARALYZE, blocked)
	if(irradiate)
		apply_effect(irradiate, IRRADIATE, blocked)
	if(slur)
		apply_effect(slur, SLUR, blocked)
	if(stutter)
		apply_effect(stutter, STUTTER, blocked)
	if(eyeblur)
		apply_effect(eyeblur, EYE_BLUR, blocked)
	if(drowsy)
		apply_effect(drowsy, DROWSY, blocked)
	if(stamina)
		apply_damage(stamina, STAMINA, null, blocked)
	if(jitter)
		apply_effect(jitter, JITTER, blocked)
	return 1


/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(amount, updating_health=1)
	if(status_flags & GODMODE)
		return 0
	bruteloss = Clamp((bruteloss + (amount * config.damage_multiplier)), 0, maxHealth*2)
	if(updating_health)
		updatehealth()

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(amount, updating_health=1)
	if(status_flags & GODMODE)
		return 0
	oxyloss = Clamp((oxyloss + (amount * config.damage_multiplier)), 0, maxHealth*2)
	if(updating_health)
		updatehealth()

/mob/living/proc/setOxyLoss(amount, updating_health=1)
	if(status_flags & GODMODE)
		return 0
	oxyloss = amount
	if(updating_health)
		updatehealth()

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(amount, updating_health=1)
	if(status_flags & GODMODE)
		return 0
	toxloss = Clamp((toxloss + (amount * config.damage_multiplier)), 0, maxHealth*2)
	if(updating_health)
		updatehealth()
	return amount

/mob/living/proc/setToxLoss(amount, updating_health=1)
	if(status_flags & GODMODE)
		return 0
	toxloss = amount
	if(updating_health)
		updatehealth()

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(amount, updating_health=1)
	if(status_flags & GODMODE)
		return 0
	fireloss = Clamp((fireloss + (amount * config.damage_multiplier)), 0, maxHealth*2)
	if(updating_health)
		updatehealth()

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(amount, updating_health=1)
	if(status_flags & GODMODE)
		return 0
	cloneloss = Clamp((cloneloss + (amount * config.damage_multiplier)), 0, maxHealth*2)
	if(updating_health)
		updatehealth()

/mob/living/proc/setCloneLoss(amount, updating_health=1)
	if(status_flags & GODMODE)
		return 0
	cloneloss = amount
	if(updating_health)
		updatehealth()

/mob/living/proc/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(amount)
	if(status_flags & GODMODE)
		return 0
	brainloss = Clamp((brainloss + (amount * config.damage_multiplier)), 0, maxHealth*2)

/mob/living/proc/setBrainLoss(amount)
	if(status_flags & GODMODE)
		return 0
	brainloss = amount

/mob/living/proc/getStaminaLoss()
	return staminaloss

/mob/living/proc/adjustStaminaLoss(amount, updating_stamina = 1)
	return

/mob/living/proc/setStaminaLoss(amount, updating_stamina = 1)
	return


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_bodypart_damage(brute, burn, updating_health = 1)
	adjustBruteLoss(-brute, 0) //zero as argument for no instant health update
	adjustFireLoss(-burn, 0)
	if(updating_health)
		updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_bodypart_damage(brute, burn, updating_health = 1)
	adjustBruteLoss(brute, 0) //zero as argument for no instant health update
	adjustFireLoss(burn, 0)
	if(updating_health)
		updatehealth()

// heal MANY bodyparts, in random order
/mob/living/proc/heal_overall_damage(brute, burn, only_robotic = 0, only_organic = 1, updating_health = 1)
	adjustBruteLoss(-brute, 0) //zero as argument for no instant health update
	adjustFireLoss(-burn, 0)
	if(updating_health)
		updatehealth()

// damage MANY bodyparts, in random order
/mob/living/proc/take_overall_damage(brute, burn, updating_health = 1)
	adjustBruteLoss(brute, 0) //zero as argument for no instant health update
	adjustFireLoss(burn, 0)
	if(updating_health)
		updatehealth()