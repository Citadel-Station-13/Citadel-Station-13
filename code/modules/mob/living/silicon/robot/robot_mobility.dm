/mob/living/silicon/robot/update_mobility()
	var/newflags = NONE
	if(!stat)
		if(!resting)
			newflags |= (MOBILITY_STAND | MOBILITY_RESIST)
			if(!locked_down)
				newflags |= MOBILITY_MOVE
				newflags |= MOBILITY_PULL
		if(!locked_down)
			newflags |= MOBILITY_FLAGS_ANY_INTERACTION
	mobility_flags = newflags
	update_transform()
	update_action_buttons_icon()
	update_icons()
	return mobility_flags
