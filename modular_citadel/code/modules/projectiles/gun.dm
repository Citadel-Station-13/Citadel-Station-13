/obj/item/gun/pre_altattackby(atom/A, mob/living/user, params)
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/gun/altafterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	if(istype(user))
		if(!user.aimingdownsights)
			user.visible_message("<span class='warning'>[user] brings [src]'s sights up to [user.p_their()] eyes, aiming directly at [target].</span>", "<span class='warning'>You bring [src]'s sights up to your eyes, aiming directly at [target].</span>")
			user.adjustStaminaLoss(1)
		else
			user.visible_message("<span class='notice'>[user] lowers [src].</span>", "<span class='notice'>You lower [src].</span>")
		user.aimingdownsights = !user.aimingdownsights
	return TRUE

/obj/item/gun/dropped(mob/living/user)
	. = ..()
	if(istype(user))
		user.aimingdownsights = FALSE
