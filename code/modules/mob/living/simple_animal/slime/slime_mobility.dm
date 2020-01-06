/mob/living/simple_animal/slime/proc/update_mobility()
	. = ..()
	if(Tempstun && !buckled)
		DISABLE_BITFIELD(., MOBILITY_MOVE)
		mobility_flags = .
