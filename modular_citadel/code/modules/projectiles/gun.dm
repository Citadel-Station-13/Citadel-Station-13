/obj/item/gun/pre_altattackby(atom/A, mob/living/user, params)
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/gun/altafterattack(atom/target, mob/living/carbon/user, proximity_flag, click_parameters)
	if(istype(user))
		if(!user.aimingdownsights)
			user.visible_message("<span class='warning'>[user] brings [src]'s sights up to [user.p_their()] eyes, aiming directly at [target].</span>", "<span class='warning'>You bring [src]'s sights up to your eyes, aiming directly at [target].</span>")
			user.adjustStaminaLossBuffered(1)
		else
			user.visible_message("<span class='notice'>[user] lowers [src].</span>", "<span class='notice'>You lower [src].</span>")
		user.aimingdownsights = !user.aimingdownsights
	return TRUE

/obj/item/gun/dropped(mob/living/user)
	. = ..()
	if(istype(user))
		user.aimingdownsights = FALSE

/obj/item/gun/proc/getstamcost(mob/living/carbon/user)
	if(user && user.has_gravity())
		return recoil
	else
		return recoil*5

/obj/item/gun/energy/kinetic_accelerator/getstamcost(mob/living/carbon/user)
	if(user && !lavaland_equipment_pressure_check(get_turf(user)))
		return 0
	else
		return ..()

/obj/item/gun/proc/getinaccuracy(mob/living/user)
	if(!iscarbon(user) || user.aimingdownsights)
		return 0
	else
		return weapon_weight * 25
