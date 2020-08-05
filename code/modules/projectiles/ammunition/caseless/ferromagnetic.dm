/obj/item/ammo_casing/caseless/magnetic
	desc = "A large ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "mag"
	icon_state = "mag-casing-live"
	click_cooldown_override = 2.5
	delay = 3
	var/energy_cost = 200

/obj/item/ammo_casing/caseless/magnetic
	projectile_type = /obj/item/projectile/bullet/magnetic

/obj/item/ammo_casing/caseless/magnetic/disabler
	desc = "A large, specialized ferromagnetic slug designed with a less-than-lethal payload."
	projectile_type = /obj/item/projectile/bullet/magnetic/disabler

/obj/item/ammo_casing/caseless/magnetic/weak
	desc = "A ferromagnetic slug intended to be launched out of a compatible weapon."
	projectile_type = /obj/item/projectile/bullet/magnetic/weak
	energy_cost = 125

/obj/item/ammo_casing/caseless/magnetic/weak/disabler
	desc = "A specialized ferromagnetic slug designed with a less-than-lethal payload."
	projectile_type = /obj/item/projectile/bullet/magnetic/weak/disabler
	energy_cost = 125

/obj/item/ammo_casing/caseless/magnetic/hyper
	desc = "A large block of speciallized ferromagnetic material designed to be fired out of the experimental Hyper-Burst Rifle."
	caliber = "hypermag"
	icon_state = "hyper-casing-live"
	projectile_type = /obj/item/projectile/bullet/magnetic/hyper
	pellets = 8
	variance = 30
	energy_cost = 1500

/obj/item/ammo_casing/caseless/magnetic/hyper/inferno
	projectile_type = /obj/item/projectile/bullet/incendiary/mag_inferno
	pellets = 1
	variance = 0

