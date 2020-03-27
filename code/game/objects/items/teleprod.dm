/obj/item/melee/baton/cattleprod/teleprod
	name = "teleprod"
	desc = "A prod with a bluespace crystal on the end. The crystal doesn't look too fun to touch."
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "teleprod_nocell"
	item_state = "teleprod"
	slot_flags = null

/obj/item/melee/baton/cattleprod/teleprod/baton_stun(mob/living/L, mob/living/carbon/user)//handles making things teleport when hit
	. = ..()
	if(!. || L.anchored)
		return
	do_teleport(L, get_turf(L), 15, channel = TELEPORT_CHANNEL_BLUESPACE)

/obj/item/melee/baton/cattleprod/teleprod/clowning_around(mob/living/user)
	user.visible_message("<span class='danger'>[user] accidentally hits [user.p_them()]self with [src]!</span>", \
						"<span class='userdanger'>You accidentally hit yourself with [src]!</span>")
	SEND_SIGNAL(user, COMSIG_LIVING_MINOR_SHOCK)
	user.DefaultCombatKnockdown(stamforce * 6)
	playsound(loc, 'sound/weapons/egloves.ogg', 50, 1, -1)
	if(do_teleport(user, get_turf(user), 50, channel = TELEPORT_CHANNEL_BLUESPACE))
		deductcharge(hitcost)
	else
		deductcharge(hitcost * 0.25)

/obj/item/melee/baton/cattleprod/attackby(obj/item/I, mob/user, params)//handles sticking a crystal onto a stunprod to make a teleprod
	if(istype(I, /obj/item/stack/ore/bluespace_crystal))
		if(!cell)
			var/obj/item/stack/ore/bluespace_crystal/BSC = I
			var/obj/item/melee/baton/cattleprod/teleprod/S = new /obj/item/melee/baton/cattleprod/teleprod
			remove_item_from_storage(user)
			qdel(src)
			BSC.use(1)
			user.put_in_hands(S)
			to_chat(user, "<span class='notice'>You place the bluespace crystal firmly into the igniter.</span>")
		else
			user.visible_message("<span class='warning'>You can't put the crystal onto the stunprod while it has a power cell installed!</span>")
	else
		return ..()
