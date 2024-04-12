/mob/living/simple_animal/slime/update_mobility()
	. = ..()
	if(Tempstun && !buckled)
		. &= ~(MOBILITY_MOVE)
		mobility_flags = .
