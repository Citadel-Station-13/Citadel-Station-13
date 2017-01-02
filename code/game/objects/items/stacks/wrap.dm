

/*
 * Wrapping Paper
 */

/obj/item/stack/wrapping_paper
	name = "wrapping paper"
	desc = "Wrap packages with this festive paper to make gifts."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrap_paper"
	flags = NOBLUDGEON
	amount = 25
	max_amount = 25
	burn_state = FLAMMABLE

/obj/item/stack/wrapping_paper/Destroy()
	if(!amount)
		new /obj/item/weapon/c_tube(get_turf(src))
	return ..()


/*
 * Package Wrap
 */

/obj/item/stack/packageWrap
	name = "package wrapper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/items.dmi'
	icon_state = "deliveryPaper"
	flags = NOBLUDGEON
	amount = 25
	max_amount = 25
	burn_state = FLAMMABLE

/obj/item/proc/can_be_package_wrapped() //can the item be wrapped with package wrapper into a delivery package
	return 1

/obj/item/weapon/storage/can_be_package_wrapped()
	return 0

/obj/item/weapon/storage/box/can_be_package_wrapped()
	return 1

/obj/item/smallDelivery/can_be_package_wrapped()
	return 0

/obj/item/stack/packageWrap/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(!istype(target))
		return
	if(target.anchored)
		return

	if(istype(target, /obj/item))
		var/obj/item/I = target
		if(!I.can_be_package_wrapped())
			return
		if(user.r_hand == I || user.l_hand == I)
			if(!user.unEquip(I))
				return
		else if(!isturf(I.loc))
			return
		if(use(1))
			var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(get_turf(I.loc))
			if(user.Adjacent(I))
				P.add_fingerprint(user)
				I.add_fingerprint(user)
				user.put_in_hands(P)
			I.forceMove(P)
			var/size = round(I.w_class)
			P.w_class = size
			size = min(size, 5)
			P.icon_state = "deliverypackage[size]"

	else if(istype (target, /obj/structure/closet))
		var/obj/structure/closet/O = target
		if(O.opened)
			return
		if(!O.density) //can't wrap non dense closets (e.g. body bags)
			user << "<span class='warning'>You can't wrap this!</span>"
			return
		if(use(3))
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
			if(O.horizontal)
				P.icon_state = "deliverycrate"
			O.loc = P
			P.add_fingerprint(user)
			O.add_fingerprint(user)
		else
			user << "<span class='warning'>You need more paper!</span>"
			return
	else
		user << "<span class='warning'>The object you are trying to wrap is unsuitable for the sorting machinery!</span>"
		return

	user.visible_message("<span class='notice'>[user] wraps [target].</span>")
	user.attack_log += text("\[[time_stamp()]\] <font color='blue'>Has used [name] on [target]</font>")

/obj/item/stack/packageWrap/Destroy()
	if(!amount)
		new /obj/item/weapon/c_tube(get_turf(src))
	return ..()

/obj/item/weapon/c_tube
	name = "cardboard tube"
	desc = "A tube... of cardboard."
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	throwforce = 0
	w_class = 1
	throw_speed = 3
	throw_range = 5