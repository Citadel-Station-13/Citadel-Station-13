/mob/living/silicon/robot/update_mobility()
	var/newflags = NONE
	if(!stat)
		if(!resting)
			newflags |= MOBILITY_STAND
			if(!locked_down)
				newflags |= MOBILITY_MOVE
				newflags |= MOBILITY_PULL
		if(!locked_down)
			newflags |= (MOBILITY_UI | MOBILITY_STORAGE)
	mobility_flags = newflags
	update_transform()
	update_action_buttons_icon()
	return canmove
