/mob/living/silicon/robot
	var/dogborg = FALSE

/mob/living/silicon/robot/lay_down()
	if(resting)
		cut_overlays()
		icon_state = "[module.cyborg_base_icon]-rest"
	else
		icon_state = "[module.cyborg_base_icon]"
	update_icons()