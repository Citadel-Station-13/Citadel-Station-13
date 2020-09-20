/**
  * Attempts to use an amount of stamina from our stamina buffer.
  * Does not use anything if we don't have enough.
  *
  * Returns TRUE or FALSE based on if we have it.
  */
/mob/living/proc/UseStaminaBuffer(amount, warn = FALSE)
	if(!(combat_flags & COMBAT_FLAG_STAMINA_BUFFER))
		return TRUE
	if(stamina_buffer < amount)
		if(warn)
			to_chat(src, "<span class='warning'>You do not have enough action stamina to do that!</span>")
			return
		return FALSE
	stamina_buffer -= amount
	return TRUE

/**
  * Updates our stamina buffer amount.
  */
/mob/living/proc/UpdateStaminaBuffer(updating_hud = TRUE)
	var/time = world.time - stamina_buffer_regen_last
	var/missing_stamina_percent = getStaminaLoss() / STAMINA_CRIT
	var/stamina_buffer_max = src.stamina_buffer_max * (1 - (missing_stamina_percent * STAMINA_BUFFER_STAMCRIT_CAPACITY_PERCENT_PENALTY))
	if(stamina_buffer > stamina_buffer_max)
		stamina_buffer = stamina_buffer_max
		return
	var/combat_mode = !SEND_SIGNAL(src, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_INACTIVE)
	stamina_buffer += min((stamina_buffer_max - stamina_buffer), (1 - (missing_stamina_percent * STAMINA_BUFFER_STAMCRIT_REGEN_PERCENT_PENALTY)) * (time * 0.1 * ((combat_mode? stamina_buffer_regen_combat : stamina_buffer_regen) * stamina_buffer_regen_mod)))
	hud_used?.staminabuffer?.update_icon()
