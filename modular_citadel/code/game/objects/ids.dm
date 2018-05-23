
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
		var/energy_color_input = input(usr,"","Choose Energy Color",id_color) as color|null
		if(energy_color_input)
			id_color = sanitize_hexcolor(energy_color_input, desired_format=6, include_crunch=1)
		update_icon()

/obj/item/card/id/knight/Initialize()
	. = ..()
	update_icon()

/obj/item/card/id/knight/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>Alt-click to recolor it.</span>")

//=================================================

/obj/item/card/emag_broken
	desc = "It's a card with a melted magnetic strip, useless!"
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	flags_1 = NOBLUDGEON_1
	item_flags = NO_MAT_REDEMPTION
	color = rgb(35, 20, 11)

/obj/item/card/emag
	var/uses = 10

/obj/item/card/emag/afterattack(atom/target, mob/user, proximity)
	. = ..()
	uses--

	if(uses<1)
		user.visible_message("[src] fizzles and sparks. It's burned out!")
		user.dropItemToGround(src)
		var/obj/item/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)
		return
