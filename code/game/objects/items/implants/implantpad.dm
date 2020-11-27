/obj/item/implantpad
	name = "implantpad"
	desc = "Used to modify implants."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "implantpad-0"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/obj/item/implantcase/case = null
	var/broadcasting = null
	var/listening = 1

/obj/item/implantpad/examine(mob/user)
	. = ..()
	if(case)
		. += "<span class='notice'>Alt-click [src] to remove the inserted implant case.</span>"

/obj/item/implantpad/update_icon_state()
	icon_state = "implantpad-[case ? TRUE : FALSE]"

/obj/item/implantpad/AltClick(mob/user)
	. = ..()
	if(case && user.can_hold_items() && user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		user.put_in_hands(case)

		case.add_fingerprint(user)
		case = null

		add_fingerprint(user)
		update_icon()
		return TRUE

/obj/item/implantpad/attackby(obj/item/implantcase/C, mob/user, params)
	if(istype(C))
		if(!case && user.transferItemToLoc(C, src))
			case = C
			update_icon()
	else
		return ..()

/obj/item/implantpad/attack_self(mob/user)
	user.set_machine(src)
	var/dat = "<B>Implant Mini-Computer:</B><HR>"
	if(case)
		if(case.imp)
			if(istype(case.imp, /obj/item/implant))
				dat += case.imp.get_data()
		else
			dat += "The implant casing is empty."
	else
		dat += "Please insert an implant casing!"
	user << browse(dat, "window=implantpad")
	onclose(user, "implantpad")


/obj/item/implantpad/Topic(href, href_list)
	..()
	if(usr.stat)
		return
	if(usr.contents.Find(src) || (in_range(src, usr) && isturf(loc)))
		usr.set_machine(src)

		if(ismob(loc))
			attack_self(loc)
		else
			for(var/mob/M in fov_viewers(1, src))
				if(M.client)
					attack_self(M)
		add_fingerprint(usr)
	else
		usr << browse(null, "window=implantpad")
