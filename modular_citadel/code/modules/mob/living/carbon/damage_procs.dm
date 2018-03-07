/mob/living/carbon/adjustStaminaLossBuffered(amount, updating_stamina = 1)
	if(status_flags & GODMODE)
		return 0
	var/directstamloss = (bufferedstam + amount) - stambuffer
	if(directstamloss > 0)
		adjustStaminaLoss(directstamloss)
	bufferedstam = CLAMP(bufferedstam + amount, 0, stambuffer)
	stambufferregentime = world.time + 5 SECONDS
	if(updating_stamina)
		update_health_hud()
