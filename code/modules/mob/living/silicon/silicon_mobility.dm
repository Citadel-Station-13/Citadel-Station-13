/mob/living/silicon/resist_a_rest()
	if(!resting)
		return FALSE
	return set_resting(FALSE)
