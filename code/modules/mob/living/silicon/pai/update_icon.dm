/mob/living/silicon/pai/update_icon()
	if(chassis == "custom")			//Make sure custom exists if it's set to custom
		custom_holoform_icon = client?.prefs?.get_filtered_holoform(HOLOFORM_FILTER_PAI)
		if(!custom_holoform_icon)
			chassis = pick(possible_chassis - "custom")
	if(chassis == "dynamic")		//handle dynamic generated icons
		icon = dynamic_chassis_icons[dynamic_chassis]
		var/list/states = icon_states(icon)
		icon_state = ""
		if(resting)		//The next line is some bullshit but I can make it worse if you want and make it a single line instead of four.. :)
			if(dynamic_chassis_sit && ("sit" in states))
				icon_state = "sit"
			else if(dynamic_chassis_bellyup && ("bellyup" in states))
				icon_state = "bellyup"
			else if("rest" in states)
				icon_state = "rest"
		rotate_on_lying = FALSE
	else if(chassis == "custom")
		icon = custom_holoform_icon
		icon_state = ""
		rotate_on_lying = TRUE
	else
		icon = initial(icon)
		icon_state = "[chassis][resting? "_rest" : (stat == DEAD? "_dead" : "")]"
		rotate_on_lying = FALSE
	pixel_x = ((chassis == "dynamic") && chassis_pixel_offsets_x[dynamic_chassis]) || 0
	update_transform()
