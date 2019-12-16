/mob/living/silicon/pai/proc/update_icon()
	if(chassis == "custom")
		custom_holoform_icon = client?.prefs?.get_filtered_holoform(HOLOFORM_FILTER_PAI)
		if(!custom_holoform_icon)
			chassis = pick(possible_chassis - "custom")
	if(chassis != "custom")
		icon = initial(icon)
		icon_state = "[chassis]_[resting]"
	else
		icon = custom_holoform_icon
		icon_state = ""
	update_transform()

//Might be a copypaste from /mob/living/carbon/update_transform(), is it time to pull the combined code to /living yet? didn't want edge cases.
/mob/living/silicon/pai/update_transform()
	var/matrix/ntransform = matrix(transform)
	var/final_pixel_y = pixel_y
	var/final_dir = dir
	if(lying != lying_prev)
		ntransform.TurnTo(lying_prev, lying)
		if(!lying)		//standing
			final_pixel_y = get_standard_pixel_y_offset()
		else
			if(!lying_prev)
				pixel_y = get_standard_pixel_y_offset()
				final_pixel_y = get_standard_pixel_y_offset(lying)
				if(dir & (EAST|WEST))
					final_dir = pick(NORTH, SOUTH)
		animate(src, transform = ntransform, time = 2, pixel_y = final_pixel_y, dir = final_dir, easing = EASE_IN | EASE_OUT)
