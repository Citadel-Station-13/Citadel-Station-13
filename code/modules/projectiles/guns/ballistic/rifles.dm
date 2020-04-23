/obj/item/gun/ballistic/automatic/x9	//will be adminspawn only so ERT or something can use them
	name = "\improper X9 Assault Rifle"
	desc = "A rather old design of a cheap, reliable assault rifle made for combat against unknown enemies. Uses 5.56mm ammo."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "x9"
	item_state = "arg"
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/m556	//Uses the m90gl's magazine, just like the NT-ARG
	fire_sound = 'sound/weapons/gunshot_smg.ogg'
	can_suppress = 0
	burst_size = 6	//in line with XCOMEU stats. This can fire 5 bursts from a full magazine.
	fire_delay = 1
	spread = 30	//should be 40 for XCOM memes, but since its adminspawn only, might as well make it useable
	recoil = 1

/obj/item/gun/ballistic/automatic/x9/toy
	name = "\improper Foam Force X9"
	desc = "An old but reliable assault rifle made for combat against unknown enemies. Appears to be hastily converted. Ages 8 and up."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "toy9"
	can_suppress = 0
	obj_flags = 0
	mag_type = /obj/item/ammo_box/magazine/toy/x9
	casing_ejector = 0
	spread = 90		//MAXIMUM XCOM MEMES (actually that'd be 180 spread)
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY

/obj/item/gun/ballistic/automatic/x9/toy
	name = "\improper Foam Force X9"
	desc = "An old but reliable assault rifle made for combat against unknown enemies. Appears to be hastily converted. Ages 8 and up."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "toy9"
	can_suppress = 0
	obj_flags = 0
	mag_type = /obj/item/ammo_box/magazine/toy/x9
	casing_ejector = 0
	spread = 90		//MAXIMUM XCOM MEMES (actually that'd be 180 spread)
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY

/obj/item/gun/ballistic/automatic/flechette
	name = "\improper CX Flechette Launcher"
	desc = "A flechette launching machine pistol with an unconventional bullpup frame."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "flechettegun"
	item_state = "gun"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = 0
	pin = /obj/item/firing_pin/implant/pindicate
	mag_type = /obj/item/ammo_box/magazine/flechette
	fire_sound = 'sound/weapons/gunshot_smg.ogg'
	can_suppress = 0
	burst_size = 5
	fire_delay = 1
	casing_ejector = 0
	spread = 10
	recoil = 0.05

/obj/item/gun/ballistic/automatic/flechette/update_icon()
	cut_overlays()
	if(magazine)
		add_overlay("flechettegun-magazine")
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/gun/ballistic/automatic/flechette/shredder
	name = "\improper CX Shredder"
	desc = "A flechette launching machine pistol made of ultra-light CFRP optimized for firing serrated monofillament flechettes."
	w_class = WEIGHT_CLASS_SMALL
	spread = 15
	recoil = 0.1

/obj/item/gun/ballistic/automatic/flechette/shredder/update_icon()
	cut_overlays()
	if(magazine)
		add_overlay("shreddergun-magazine")
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/gun/ballistic/automatic/AM4B
	name = "AM4-B"
	desc = "A Relic from a bygone age. Nobody quite knows why it's here. Has a polychromic coating."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "AM4"
	item_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/toy/AM4B
	can_suppress = 0
	item_flags = NEEDS_PERMIT
	casing_ejector = 0
	spread = 30		//Assault Rifleeeeeee
	w_class = WEIGHT_CLASS_NORMAL
	burst_size = 4	//Shh.
	fire_delay = 1
	var/body_color = "#3333aa"

/obj/item/gun/ballistic/automatic/AM4B/update_icon()
	..()
	var/mutable_appearance/body_overlay = mutable_appearance('icons/obj/guns/cit_guns.dmi', "AM4-Body")
	if(body_color)
		body_overlay.color = body_color
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	add_overlay(body_overlay)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/gun/ballistic/automatic/AM4B/AltClick(mob/living/user)
	. = ..()
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	. = TRUE
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return
	if(alert("Are you sure you want to recolor your gun?", "Confirm Repaint", "Yes", "No") == "Yes")
		var/body_color_input = input(usr,"","Choose Shroud Color",body_color) as color|null
		if(body_color_input)
			body_color = sanitize_hexcolor(body_color_input, desired_format=6, include_crunch=1)
		update_icon()

/obj/item/gun/ballistic/automatic/AM4B/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to recolor it.</span>"

/obj/item/gun/ballistic/automatic/AM4C
	name = "AM4-C"
	desc = "A Relic from a bygone age. This one seems newer, yet less effective."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "AM4C"
	item_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/toy/AM4C
	can_suppress = 0
	item_flags = NEEDS_PERMIT
	casing_ejector = 0
	spread = 45		//Assault Rifleeeeeee
	w_class = WEIGHT_CLASS_NORMAL
	burst_size = 4	//Shh.
	fire_delay = 1
