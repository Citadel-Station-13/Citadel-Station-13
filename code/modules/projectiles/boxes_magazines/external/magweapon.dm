/obj/item/ammo_box/magazine/mmag
	icon_state = "mediummagmag"
	ammo_type = /obj/item/ammo_casing/caseless/magnetic/disabler
	caliber = "mag"
	max_ammo = 24
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag/lethal
	name = "magrifle magazine (lethal)"
	ammo_type = /obj/item/ammo_casing/caseless/magnetic

/obj/item/ammo_box/magazine/mmag/small
	name = "magpistol magazine (non-lethal disabler)"
	icon_state = "smallmagmag"
	ammo_type = /obj/item/ammo_casing/caseless/magnetic/weak/disabler
	max_ammo = 16

/obj/item/ammo_box/magazine/mmag/small/lethal
	name = "magpistol magazine (lethal)"
	ammo_type = /obj/item/ammo_casing/caseless/magnetic/weak

/obj/item/ammo_box/magazine/mhyper
	name = "hyper-burst rifle magazine"
	icon_state = "hypermag"
	ammo_type = /obj/item/ammo_casing/caseless/magnetic/hyper
	caliber = "hypermag"
	desc = "A magazine for the Hyper-Burst Rifle. Loaded with a special slug that fragments into 6 smaller shards which can absolutely puncture anything, but has rather short effective range."
	max_ammo = 4
	multiple_sprites = 4

/obj/item/ammo_box/magazine/mhyper/inferno
	name = "hyper-burst rifle magazine (inferno)"
	ammo_type = /obj/item/ammo_casing/caseless/magnetic/hyper/inferno
	desc = "A magazine for the Hyper-Burst Rifle. Loaded with a special slug that violently reacts with whatever surface it strikes, generating massive amount of heat and light."
