/////////////spinfusor stuff////////////////

/obj/item/projectile/bullet/spinfusor
	name ="spinfusor disk"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state= "spinner"
	damage = 30

/obj/item/projectile/bullet/spinfusor/on_hit(atom/target, blocked = FALSE) //explosion to emulate the spinfusor's AOE
	..()
	explosion(target, -1, -1, 2, 0, -1)
	return BULLET_ACT_HIT

/obj/item/ammo_casing/caseless/spinfusor
	name = "spinfusor disk"
	desc = "A magnetic disk designed specifically for the Stormhammer magnetic cannon. Packs a punch."
	projectile_type = /obj/item/projectile/bullet/spinfusor
	caliber = "spinfusor"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "disk"
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 15 //still deadly when thrown
	force = 5
	throw_speed = 3

/obj/item/ammo_box/magazine/internal/spinfusor
	name = "spinfusor internal magazine"
	ammo_type = /obj/item/ammo_casing/caseless/spinfusor
	caliber = "spinfusor"
	max_ammo = 1

/obj/item/gun/ballistic/automatic/spinfusor
	name = "Stormhammer Magnetic Cannon"
	desc = "An innovative weapon utilizing mag-lev technology to spin up a magnetic fusor and launch it at extreme velocities."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "spinfusor"
	item_state = "spinfusor"
	mag_type = /obj/item/ammo_box/magazine/internal/spinfusor
	fire_sound = 'sound/weapons/rocketlaunch.ogg'
	w_class = WEIGHT_CLASS_BULKY
	can_suppress = 0
	burst_size = 1
	fire_delay = 40
	select = 0
	actions_types = list()
	casing_ejector = 0

/obj/item/gun/ballistic/automatic/spinfusor/attackby(obj/item/A, mob/user, params)
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		to_chat(user, "<span class='notice'>You load [num_loaded] disk\s into \the [src].</span>")
		update_icon()
		chamber_round()

/obj/item/gun/ballistic/automatic/spinfusor/attack_self(mob/living/user)
	return //caseless rounds are too glitchy to unload properly. Best to make it so that you cannot remove disks from the spinfusor

/obj/item/gun/ballistic/automatic/spinfusor/update_icon_state()
	icon_state = "spinfusor[magazine ? "-[get_ammo(1)]" : ""]"

/obj/item/ammo_box/aspinfusor
	name = "ammo box (spinfusor disks)"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "spinfusorbox"
	ammo_type = /obj/item/ammo_casing/caseless/spinfusor
	w_class = WEIGHT_CLASS_NORMAL
	max_ammo = 4