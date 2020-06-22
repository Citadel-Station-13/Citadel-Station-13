/mob/living/carbon/human/get_blocking_items()
	. = ..()
	if(wear_suit)
		if(!.[wear_suit])
			.[wear_suit] = wear_suit.block_priority
	if(w_uniform)
		if(!.[w_uniform])
			.[w_uniform] = w_uniform.block_priority
	if(wear_neck)
		if(!.[wear_neck])
			.[wear_neck] = wear_neck.block_priority
