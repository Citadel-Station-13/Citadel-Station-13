//we vlambeer now

/obj/item/gun/energy
	..()
	recoil = 0.1

/obj/item/gun/energy/kinetic_accelerator
	..()
	recoil = 0.8

/obj/item/gun/ballistic
	..()
	recoil = 0.25

/obj/item/gun/ballistic/shotgun
	..()
	recoil = 1

/obj/item/gun/ballistic/revolver
	..()
	recoil = 0.5

/obj/item/gun/ballistic/revolver/doublebarrel
	..()
	recoil = 1

/obj/item/gun/syringe
	..()
	recoil = 0.1

/obj/item/pneumatic_cannon/fire_items(turf/target, mob/user)
	. = ..()
	shake_camera(user, (pressureSetting * 0.75 + 1), (pressureSetting * 0.75))

/obj/item/attack(mob/living/M, mob/living/user)
	. = ..()
	if(force && force >=11)
		shake_camera(user, ((force - 10) * 0.01 + 1), ((force - 10) * 0.01))
		shake_camera(M, ((force - 10) * 0.02 + 1), ((force - 10) * 0.02))

/obj/item/attack_obj(obj/O, mob/living/user)
	. = ..()
	if(force && force >= 20)
		shake_camera(user, ((force - 15) * 0.02 + 1), ((force - 15) * 0.02))
