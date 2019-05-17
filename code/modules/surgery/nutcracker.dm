/obj/item/nutcracker
	name = "nutcracker"
	desc = "It seems oversized... quite much... you could fit a head in it."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "nutcracker"
	force = 10
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("smashed", "beaten", "crushed")

/obj/item/nutcracker/attack(mob/living/carbon/M, mob/user)
	if(!istype(M))
		return
	if(user && imp)
		if(M != user)
			M.visible_message("<span class='warning'>[user] is attempting to implant [M].</span>")

		var/turf/T = get_turf(M)
		if(T && (M == user || do_mob(user, M, 50)))
			if(src && imp)
				if(imp.implant(M, user))
					if (M == user)
						to_chat(user, "<span class='notice'>You implant yourself.</span>")
					else
						M.visible_message("[user] has implanted [M].", "<span class='notice'>[user] implants you.</span>")
					imp = null
					update_icon()
				else
					to_chat(user, "<span class='warning'>[src] fails to implant [M].</span>")
