/mob/living/carbon/human/Life()
		//citadel code
	if(stat != DEAD)
		handle_arousal()
	. = ..()
	
/mob/living/carbon/human/calculate_affecting_pressure(pressure)
	if(ismob(loc))
		return ONE_ATMOSPHERE
	. = ..()
