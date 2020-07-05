/mob/living/carbon/human/get_blocking_items()
	. = ..()
	if(wear_suit)
		. |= wear_suit
	if(w_uniform)
		. |= w_uniform
	if(wear_neck)
		. |= wear_neck
