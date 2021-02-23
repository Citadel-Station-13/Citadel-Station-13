/obj/item/airlock_painter/decal/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/airlock_painter/decal/proc/choose_decal(user)
	var/decal_list_img = list(
		"Warning Line" = image(icon = 'icons/turf/decals.dmi', icon_state = "warningline", dir = stored_dir),
		"Warning Line Corner" = image(icon = 'icons/turf/decals.dmi', icon_state = "warninglinecorner", dir = stored_dir),
		"Caution Label" = image(icon = 'icons/turf/decals.dmi', icon_state = "caution", dir = stored_dir),
		"Directional Arrows" = image(icon = 'icons/turf/decals.dmi', icon_state = "arrows", dir = stored_dir),
		"Stand Clear Label" = image(icon = 'icons/turf/decals.dmi', icon_state = "stand_clear", dir = stored_dir),
		"Box" = image(icon = 'icons/turf/decals.dmi', icon_state = "box", dir = stored_dir),
		"Box Corner" = image(icon = 'icons/turf/decals.dmi', icon_state = "box_corners", dir = stored_dir),
		"Delivery Marker" = image(icon = 'icons/turf/decals.dmi', icon_state = "delivery", dir = stored_dir),
		"Warning Box" = image(icon = 'icons/turf/decals.dmi', icon_state = "warn_full", dir = stored_dir)
	)
	var/choice = show_radial_menu(user, src, decal_list_img, radius = 45, custom_check = CALLBACK(src,.proc/check_menu,user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(choice)
		if("Warning Line")
			var/picked_decal = decal_list[1]
			stored_decal = picked_decal[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] decal to '[choice]'.</span>")
			update_decal_path()
		if("Warning Line Corner")
			var/picked_decal = decal_list[2]
			stored_decal = picked_decal[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] decal to '[choice]'.</span>")
			update_decal_path()
		if("Caution Label")
			var/picked_decal = decal_list[3]
			stored_decal = picked_decal[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] decal to '[choice]'.</span>")
			update_decal_path()
		if("Directional Arrows")
			var/picked_decal = decal_list[4]
			stored_decal = picked_decal[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] decal to '[choice]'.</span>")
			update_decal_path()
		if("Stand Clear Label")
			var/picked_decal = decal_list[5]
			stored_decal = picked_decal[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] decal to '[choice]'.</span>")
			update_decal_path()
		if("Box")
			var/picked_decal = decal_list[6]
			stored_decal = picked_decal[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] decal to '[choice]'.</span>")
			update_decal_path()
		if("Box Corner")
			var/picked_decal = decal_list[7]
			stored_decal = picked_decal[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] decal to '[choice]'.</span>")
			update_decal_path()
		if("Delivery Marker")
			var/picked_decal = decal_list[8]
			stored_decal = picked_decal[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] decal to '[choice]'.</span>")
			update_decal_path()
		if("Warning Box")
			var/picked_decal = decal_list[9]
			stored_decal = picked_decal[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] decal to '[choice]'.</span>")
			update_decal_path()
		else
			to_chat(user, "<span class='notice'>You decided not to change the decal.")

/obj/item/airlock_painter/decal/proc/choose_color(user)
	var/choose_color = list(
		"Disable" = image(icon = 'icons/turf/decals.dmi', icon_state = "[stored_decal]", dir = stored_dir),
		"Red" = image(icon = 'icons/obj/crayons.dmi', icon_state = "crayonred"),
		"White" = image(icon = 'icons/obj/crayons.dmi', icon_state = "crayonwhite")
	)
	var/choice = show_radial_menu(user, src, choose_color, custom_check = CALLBACK(src,.proc/check_menu,user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(choice)
		if("Disable")
			stored_color = color_list[1]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You disable [src]'s painter.</span>")
			update_decal_path()
		if("Red")
			stored_color = color_list[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] color to '[choice]'.</span>")
			update_decal_path()
		if("White")
			stored_color = color_list[3]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] color to '[choice]'.</span>")
			update_decal_path()
		else
			to_chat(user, "<span class='notice'>You decided not to change the color.</span>")

/obj/item/airlock_painter/decal/proc/choose_dir(user)
	var/choose_dir = list(
		"North" = image(icon = 'icons/turf/decals.dmi', icon_state = "[stored_decal]", dir = 2),
		"East" = image(icon = 'icons/turf/decals.dmi', icon_state = "[stored_decal]", dir = 8),
		"South" = image(icon = 'icons/turf/decals.dmi', icon_state = "[stored_decal]", dir = 1),
		"West"  = image(icon = 'icons/turf/decals.dmi', icon_state = "[stored_decal]", dir = 4)
	)
	var/choice =  show_radial_menu(user,src,choose_dir, custom_check = CALLBACK(src,.proc/check_menu,user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(choice)
		if("South")
			stored_dir = dir_list[1]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] direction to '[choice]'.</span>")
			update_decal_path()
		if("North")
			stored_dir = dir_list[2]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] direction to '[choice]'.</span>")
			update_decal_path()
		if("West")
			stored_dir = dir_list[3]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] direction to '[choice]'.</span>")
			update_decal_path()
		if("East")
			stored_dir = dir_list[4]
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='notice'>You change [src] direction to '[choice]'.</span>")
			update_decal_path()
		else
			to_chat(user, "<span class='notice'>You decided not to change the direction.</span>")
