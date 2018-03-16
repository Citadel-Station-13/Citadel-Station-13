/datum/status_effect/incapacitating/knockdown/on_creation(mob/living/new_owner, set_duration, updating_canmove)
	if(iscarbon(new_owner) && isnum(set_duration))
		new_owner.resting = TRUE
		new_owner.adjustStaminaLoss(set_duration*0.25)
		if(set_duration > 80)
			set_duration = set_duration*0.15
			. = ..()
			return
		else if(updating_canmove)
			new_owner.update_canmove()
		qdel(src)
	else
		. = ..()
