/obj/item/ammo_box/magazine/mm556x45
	name = "box magazine (5.56×45mm)"
	icon_state = "mm55645-100"
	ammo_type = /obj/item/ammo_casing/mm556x45
	caliber = "mm55645"
	max_ammo = 100

/obj/item/ammo_box/magazine/mm556x45/update_icon()
	..()
	icon_state = "mm55645-[round(ammo_count(),20)]"

/obj/item/ammo_box/magazine/mm556x45/ap
	name = "box magazine (Armor Penetrating 5.56×45mm)"
	ammo_type = /obj/item/ammo_casing/mm556x45/ap

/obj/item/ammo_box/magazine/mm556x45/hollow
	name = "box magazine (Hollow-Point 5.56×45mm)"
	ammo_type = /obj/item/ammo_casing/mm556x45/hollow
	max_ammo = 75

/obj/item/ammo_box/magazine/mm556x45/incen
	name = "box magazine (Incendiary 5.56×45mm)"
	ammo_type = /obj/item/ammo_casing/mm556x45/incen
	max_ammo = 75