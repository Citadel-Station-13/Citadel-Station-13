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
	UpdateStaminaBuffer()
	return TRUE

/**
  * Updates our stamina buffer amount.
  */
/mob/living/proc/UpdateStaminaBuffer(updating_hud = TRUE)
	var/time = world.time - stamina_buffer_regen_last
	var/missing_stamina_percent = getStaminaLoss() / STAMINA_CRIT
	var/stamina_buffer_max = src.stamina_buffer_max * (1 - (missing_stamina_percent * STAMINA_BUFFER_STAMCRIT_CAPACITY_PERCENT_PENALTY))
	stamina_buffer_regen_last = world.time
	if(stamina_buffer > stamina_buffer_max)
		stamina_buffer = stamina_buffer_max
		return
	var/combat_mode = !SEND_SIGNAL(src, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_INACTIVE)
	var/action_penalty = (((world.time - last_action) >= STAMINA_BUFFER_REGEN_ACTION_PENALTY_TIME) && STAMINA_BUFFER_REGEN_ACTION_PENALTY_FACTOR) || 1
	var/stamina_penalty = 1 - (missing_stamina_percent * STAMINA_BUFFER_STAMCRIT_REGEN_PERCENT_PENALTY)
	var/regen = time * 0.1 * ((combat_mode? stamina_buffer_regen_combat : stamina_buffer_regen) * stamina_buffer_regen_mod)
	stamina_buffer += min((stamina_buffer_max - stamina_buffer), action_penalty * stamina_penalty * regen)
	hud_used?.staminabuffer?.mark_dirty()

/**
  * Boosts our stamina buffer by this much.
  */
/mob/living/proc/RechargeStaminaBuffer(amount)
	var/missing_stamina_percent = getStaminaLoss() / STAMINA_CRIT
	var/stamina_buffer_max = src.stamina_buffer_max * (1 - (missing_stamina_percent * STAMINA_BUFFER_STAMCRIT_CAPACITY_PERCENT_PENALTY))
	stamina_buffer += min(amount, stamina_buffer_max - stamina_buffer)
	hud_used?.staminabuffer?.mark_dirty()
