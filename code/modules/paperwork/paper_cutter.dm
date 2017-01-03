/obj/item/weapon/papercutter
	name = "paper cutter"
	desc = "Standard office equipment. Precisely cuts paper using a large blade."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "papercutter"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	var/obj/item/weapon/paper/storedpaper = null
	var/obj/item/weapon/hatchet/cutterblade/storedcutter = null
	var/cuttersecured = TRUE
	pass_flags = PASSTABLE


/obj/item/weapon/papercutter/New()
	..()
	storedcutter = new /obj/item/weapon/hatchet/cutterblade(src)
	update_icon()


/obj/item/weapon/papercutter/suicide_act(mob/user)
	if(storedcutter)
		user.visible_message("<span class='suicide'>[user] is beheading [user.p_them()]self with [src.name]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			var/obj/item/bodypart/BP = C.get_bodypart("head")
			if(BP)
				BP.drop_limb()
				playsound(loc,pick('sound/misc/desceration-01.ogg','sound/misc/desceration-02.ogg','sound/misc/desceration-01.ogg') ,50, 1, -1)
		return (BRUTELOSS)
	else
		user.visible_message("<span class='suicide'>[user] repeatedly bashes [src.name] against [user.p_their()] head! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		playsound(loc, 'sound/items/gavel.ogg', 50, 1, -1)
		return (BRUTELOSS)


/obj/item/weapon/papercutter/update_icon()
	..()
	cut_overlays()
	icon_state = (storedcutter ? "[initial(icon_state)]-cutter" : "[initial(icon_state)]")
	if(storedpaper)
		add_overlay("paper")


/obj/item/weapon/papercutter/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/weapon/paper) && !storedpaper)
		if(!user.drop_item())
			return
		playsound(loc, "pageturn", 60, 1)
		user << "<span class='notice'>You place [P] in [src].</span>"
		P.loc = src
		storedpaper = P
		update_icon()
		return
	if(istype(P, /obj/item/weapon/hatchet/cutterblade) && !storedcutter)
		if(!user.drop_item())
			return
		user << "<span class='notice'>You replace [src]'s [P].</span>"
		P.loc = src
		storedcutter = P
		update_icon()
		return
	if(istype(P, /obj/item/weapon/screwdriver) && storedcutter)
		playsound(src, P.usesound, 50, 1)
		user << "<span class='notice'>[storedcutter] has been [cuttersecured ? "unsecured" : "secured"].</span>"
		cuttersecured = !cuttersecured
		return
	..()


/obj/item/weapon/papercutter/attack_hand(mob/user)
	add_fingerprint(user)
	if(!storedcutter)
		user << "<span class='notice'>The cutting blade is gone! You can't use [src] now.</span>"
		return

	if(!cuttersecured)
		user << "<span class='notice'>You remove [src]'s [storedcutter].</span>"
		user.put_in_hands(storedcutter)
		storedcutter = null
		update_icon()

	if(storedpaper)
		playsound(src.loc, 'sound/weapons/slash.ogg', 50, 1)
		user << "<span class='notice'>You neatly cut [storedpaper].</span>"
		storedpaper = null
		qdel(storedpaper)
		new /obj/item/weapon/paperslip(get_turf(src))
		new /obj/item/weapon/paperslip(get_turf(src))
		update_icon()


/obj/item/weapon/papercutter/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(M.incapacitated() || !Adjacent(M))
		return

	if(over_object == M)
		M.put_in_hands(src)

	else if(istype(over_object, /obj/screen/inventory/hand))
		var/obj/screen/inventory/hand/H = over_object
		if(!remove_item_from_storage(M))
			if(!M.unEquip(src))
				return
		M.put_in_hand(src, H.held_index)
	add_fingerprint(M)


/obj/item/weapon/paperslip
	name = "paper slip"
	desc = "A little slip of paper left over after a larger piece was cut. Whoa."
	icon_state = "paperslip"
	icon = 'icons/obj/bureaucracy.dmi'
	resistance_flags = FLAMMABLE
	obj_integrity = 50
	max_integrity = 50

/obj/item/weapon/paperslip/New()
	..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)


/obj/item/weapon/hatchet/cutterblade
	name = "paper cutter"
	desc = "The blade of a paper cutter. Most likely removed for polishing or sharpening."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "cutterblade"
	item_state = "knife"
