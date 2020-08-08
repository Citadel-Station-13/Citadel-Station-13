/mob/living/GetActionCooldownMod()
	. = ..()
	for(var/datum/status_effect/S in status_effects)
		. *= S.action_cooldown_mod()
