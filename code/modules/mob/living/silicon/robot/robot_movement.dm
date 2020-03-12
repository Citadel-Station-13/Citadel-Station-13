/mob/living/silicon/robot/Process_Spacemove(movement_dir = 0)
	if(ionpulse())
		return 1
	return ..()

/mob/living/silicon/robot/mob_negates_gravity()
	return magpulse

/mob/living/silicon/robot/mob_has_gravity()
	return ..() || mob_negates_gravity()

/mob/living/silicon/robot/experience_pressure_difference(pressure_difference, direction)
	if(!magpulse)
		return ..()

/mob/living/silicon/robot/Move(NewLoc, direct)
	. = ..()
	if(. && IS_SPRINTING(src) && !(movement_type & FLYING) && CHECK_ALL_MOBILITY(src, MOBILITY_STAND | MOBILITY_MOVE))
		if(!(cell?.use(25)))
			default_toggle_sprint(TRUE)

/mob/living/silicon/robot/movement_delay()
	. = ..()
	if(!resting && !IS_SPRINTING(src))
		. += 1
	. += speed
