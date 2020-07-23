/**
  * Checks if we can do another action.
  * Returns TRUE if we can and FALSE if we cannot.
  *
  * @params
  * * cooldown - Time required since last action. Defaults to 0.5
  * * from_next_action - Defaults to FALSE. Should we check from the tail end of next_action instead of last_action?
  * * ignore_mod - Defaults to FALSE. Ignore all adjusts and multipliers. Do not use this unless you know what you are doing and have a good reason.
  * * ignore_next_action - Defaults to FALSE. Ignore next_action and only care about cooldown param and everything else. Generally unused.
  * * immediate - Defaults to FALSE. Checks last action using immediate, used on the head end of an attack. This is to prevent colliding attacks in case of sleep. Not that you should sleep() in an attack but.. y'know.
  *
  * Is this a copypaste?
  * Yes, because status_effects isn't on /mob... :/
  */
/mob/living/CheckActionCooldown(cooldown = 0.5, from_next_action = FALSE, ignore_mod = FALSE, ignore_next_action = FALSE, immediate = FALSE)
	var/mod = action_cooldown_mod
	for(var/datum/status_effect/S in status_effects)
		mod *= S.action_cooldown_mod()
	return (ignore_next_action || (world.time >= (immediate? next_action_immediate : next_action))) && \
	(world.time >= ((from_next_action? (immediate? next_action_immediate : next_action) : (immediate? last_action_immediate : last_action)) + max(0, ignore_mod? cooldown : (cooldown * mod + action_cooldown_adjust))))
