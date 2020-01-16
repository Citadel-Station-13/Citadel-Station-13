/mob/living/simple_animal/slime/update_mobility()
	. = ..()
	if(Tempstun && !buckled)
		DISABLE_BITFIELD(., MOBILITY_MOVE)
		mobility_flags = .
