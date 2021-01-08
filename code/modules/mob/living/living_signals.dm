/// IN THE FUTURE, WE WILL PROBABLY REFACTOR TO LESSEN THE NEED FOR UPDATE_MOBILITY, BUT FOR NOW.. WE CAN START DOING THIS.
/// FOR BLOCKING MOVEMENT, USE TRAIT_MOBILITY_NOMOVE AS MUCH AS POSSIBLE. IT WILL MAKE REFACTORS IN THE FUTURE EASIER.
/mob/living/ComponentInitialize()
	. = ..()
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_MOBILITY_NOMOVE), .proc/update_mobility)
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_MOBILITY_NOPICKUP), .proc/update_mobility)
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_MOBILITY_NOUSE), .proc/update_mobility)
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_MOBILITY_NOREST), .proc/update_mobility)
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_LIVING_NO_DENSITY), .proc/update_density)
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_PUGILIST), .proc/update_pugilism)

/mob/living/proc/update_pugilism()
	if(HAS_TRAIT(src, TRAIT_PUGILIST))
		combat_flags |= COMBAT_FLAG_UNARMED_PARRY
		block_parry_data = pugilist_block_parry_data
	else
		var/initial_combat_flags = initial(combat_flags)
		if(!(initial_combat_flags & COMBAT_FLAG_UNARMED_PARRY))
			combat_flags &= ~COMBAT_FLAG_UNARMED_PARRY
		block_parry_data = default_block_parry_data
