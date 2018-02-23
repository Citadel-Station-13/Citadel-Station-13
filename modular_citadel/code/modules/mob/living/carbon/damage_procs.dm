/mob/living/carbon/adjustStaminaLossBuffered(amount, updating_stamina = 1)
	if(status_flags & GODMODE)
		return 0
	bufferedstam = CLAMP(bufferedstam + amount, 0, stambuffer)
	stambufferregentime = world.time + 5 SECONDS
