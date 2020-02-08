/obj/item/ammo_box/magazine/internal/cylinder/rev38
	name = "detective revolver cylinder"
	ammo_type = /obj/item/ammo_casing/c38
	caliber = list("38")
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/cylinder/rev38/makeshift
	name = "makeshift cylinder"
	ammo_type = /obj/item/ammo_casing/c38
	caliber = list("38")
	max_ammo = 1
	multiload = 0

/obj/item/ammo_box/magazine/internal/cylinder/rev762
	name = "\improper Nagant revolver cylinder"
	ammo_type = /obj/item/ammo_casing/n762
	caliber = list("n762")
	max_ammo = 7

/obj/item/ammo_box/magazine/internal/cylinder/rus357
	name = "\improper Russian revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = list("357")
	max_ammo = 6
	multiload = 0

/obj/item/ammo_box/magazine/internal/rus357/Initialize()
	stored_ammo += new ammo_type(src)
	. = ..()

//Makeshift Pistol

/obj/item/ammo_box/magazine/internal/cylinder/nine/makeshift
	name = "makeshift cylinder"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = list("9mm")
	max_ammo = 1
	multiload = 0