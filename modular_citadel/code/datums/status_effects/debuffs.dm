/datum/status_effect/incapacitating/knockdown/on_creation(mob/living/new_owner, set_duration, updating_canmove)
	if(istype(new_owner) && isnum(set_duration))
		new_owner.resting = TRUE
		new_owner.adjustStaminaLoss(set_duration*0.4)
		to_chat(world, "adjuststaminaloss of [set_duration*0.4]")
		if(set_duration > 80)
			set_duration = set_duration*0.15
			to_chat(world, "applying knockdown with duration of [set_duration]")
			. = ..()
			return
		else if(updating_canmove)
			new_owner.update_canmove()
		to_chat(world, "applying knockdown, original duration [set_duration]")
		qdel(src)
