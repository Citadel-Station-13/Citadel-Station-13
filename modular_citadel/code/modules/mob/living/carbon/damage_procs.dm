/mob/living/carbon/adjustStaminaLossBuffered(amount, updating_stamina = 1)
	if(status_flags & GODMODE)
		return 0
	if(CONFIG_GET(flag/disable_stambuffer))
		return
	var/directstamloss = (bufferedstam + amount) - stambuffer
	if(directstamloss > 0)
		adjustStaminaLoss(directstamloss)
	bufferedstam = CLAMP(bufferedstam + amount, 0, stambuffer)
	stambufferregentime = world.time + 10
	if(updating_stamina)
		update_health_hud()

/mob/living/carbon/adjustStaminaLoss(amount, updating_health = TRUE, forced = FALSE, affected_zone = BODY_ZONE_CHEST)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	apply_damage(amount > 0 ? amount*incomingstammult : amount, STAMINA, affected_zone)
	if(recoveringstam && amount > 20)
		incomingstammult = max(0.01, incomingstammult/(amount*0.05))
	return amount
