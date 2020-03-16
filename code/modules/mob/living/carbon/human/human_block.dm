/mob/living/carbon/human/get_blocking_items()
	. = ..()
	if(w_uniform)
		. += w_uniform
	if(wear_neck)
		. += wear_neck
