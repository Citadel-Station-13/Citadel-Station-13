/mob/living/carbon/human/get_blocking_items()
	. = ..()
	if(wear_suit)
		if(!.[wear_suit])
			.[wear_suit] = wear_suit.block_priority
	if(w_uniform)
		if(!.[w_uniform])
			.[w_uniform] = w_uniform.block_priority
	//skyrat edit
	if(w_underwear)
		if(!.[w_underwear])
			.[w_underwear] = w_underwear.block_priority
	if(w_socks)
		if(!.[w_socks])
			.[w_socks] = w_socks.block_priority
	if(w_shirt)
		if(!.[w_shirt])
			.[w_shirt] = w_shirt.block_priority
	if(wrists)
		if(!.[wrists])
			.[wrists] = wrists.block_priority
	//
	if(wear_neck)
		if(!.[wear_neck])
			.[wear_neck] = wear_neck.block_priority
