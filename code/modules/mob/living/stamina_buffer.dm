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
	if(time <= 0)
		return
	stamina_buffer_regen_last = time
	var/penalized 
