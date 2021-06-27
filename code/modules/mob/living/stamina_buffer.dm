/**
  * Attempts to use an amount of stamina from our stamina buffer.
  * Does not use anything if we don't have enough.
  *
  * Returns TRUE or FALSE based on if we have it.
  */
/mob/living/proc/UseStaminaBuffer(amount, warn = FALSE, considered_action = TRUE)
	if(!(combat_flags & COMBAT_FLAG_STAMINA_BUFFER))
		return TRUE
	if(stamina_buffer < amount)
		var/stamina_health = getStaminaLoss()
		if(stamina_health > STAMINA_NO_OVERDRAW_THRESHOLD)
			if(warn)
				to_chat(src, "<span class='warning'>You do not have enough action stamina to do that!</span>")
			return FALSE
		adjustStaminaLoss(amount * CONFIG_GET(number/stamina_combat/overdraw_penalty_factor))
	else
		stamina_buffer -= amount
	if(considered_action)
		stamina_buffer_last_use = world.time
	UpdateStaminaBuffer()
	return TRUE

/**
  * Updates our stamina buffer amount.
  */
/mob/living/proc/UpdateStaminaBuffer(updating_hud = TRUE)
	var/time = world.time - stamina_buffer_regen_last
	CONFIG_CACHE_ENTRY_AND_FETCH_VALUE(number/stamina_combat/buffer_max, buffer_max)
	stamina_buffer_regen_last = world.time
	if((stamina_buffer >= buffer_max) || !(combat_flags & COMBAT_FLAG_STAMINA_BUFFER))
		stamina_buffer = buffer_max
		return
	else if(!time || HAS_TRAIT(src, TRAIT_NO_STAMINA_BUFFER_REGENERATION))
		return
	CONFIG_CACHE_ENTRY_AND_FETCH_VALUE(number/stamina_combat/out_of_combat_timer, out_of_combat_timer)
	CONFIG_CACHE_ENTRY_AND_FETCH_VALUE(number/stamina_combat/base_regeneration, base_regeneration)
	CONFIG_CACHE_ENTRY_AND_FETCH_VALUE(number/stamina_combat/percent_regeneration_out_of_combat, percent_regeneration_out_of_combat)
	CONFIG_CACHE_ENTRY_AND_FETCH_VALUE(number/stamina_combat/post_action_penalty_delay, post_action_penalty_delay)
	CONFIG_CACHE_ENTRY_AND_FETCH_VALUE(number/stamina_combat/post_action_penalty_factor, post_action_penalty_factor)
	var/base_regen = base_regeneration
	var/time_since_last_action = world.time - stamina_buffer_last_use
	var/action_penalty = ((time_since_last_action) < (post_action_penalty_delay * 10))? post_action_penalty_factor : 1
	var/out_of_combat_bonus = (time_since_last_action < (out_of_combat_timer * 10))? 0 : ((buffer_max * percent_regeneration_out_of_combat * 0.01))
	var/regen = ((base_regen * action_penalty) + out_of_combat_bonus) * time * 0.1 * stamina_buffer_regen_mod
	stamina_buffer += min((buffer_max - stamina_buffer), regen)
	if(updating_hud)
		hud_used?.staminabuffer?.mark_dirty()

/**
  * Boosts our stamina buffer by this much.
  */
/mob/living/proc/RechargeStaminaBuffer(amount)
	stamina_buffer += abs(amount)
	UpdateStaminaBuffer()
