/mob/living/carbon/get_blocking_items()
	. = ..()
	if(wear_suit)
		. += wear_suit
