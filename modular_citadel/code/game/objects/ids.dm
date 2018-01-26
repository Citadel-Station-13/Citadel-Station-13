
//Polychromatic Knight Badge

/obj/item/card/id/knight
	var/id_color = "#00FF00" //defaults to green
	name = "knight badge"
	icon = 'modular_citadel/icons/obj/id.dmi'
	icon_state = "knight"
	desc = "A badge denoting the owner as a knight! It has a strip for swiping like an ID"

/obj/item/card/id/knight/update_label(newname, newjob)
	. = ..()
	if(newname || newjob)
		name = "[(!newname)	? "identification card"	: "[newname]'s Knight Badge"][(!newjob) ? "" : " ([newjob])"]"
		return

	name = "[(!registered_name)	? "identification card"	: "[registered_name]'s Knight Badge"][(!assignment) ? "" : " ([assignment])"]"

/obj/item/card/id/knight/update_icon()
	var/mutable_appearance/id_overlay = mutable_appearance('modular_citadel/icons/obj/id.dmi', "knight_overlay")

	if(id_color)
		id_overlay.color = id_color
	cut_overlays()

	add_overlay(id_overlay)

/obj/item/card/id/knight/AltClick(mob/living/user)
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return
	if(alert("Are you sure you want to recolor your id?", "Confirm Repaint", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"Choose Energy Color") as color|null
		if(energy_color_input)
			id_color = sanitize_hexcolor(energy_color_input, desired_format=6, include_crunch=1)
		update_icon()

/obj/item/card/id/knight/Initialize()
	. = ..()
	update_icon()

/obj/item/card/id/knight/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>Alt-click to recolor it.</span>")