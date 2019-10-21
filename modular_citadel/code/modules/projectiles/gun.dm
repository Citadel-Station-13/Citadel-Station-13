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
