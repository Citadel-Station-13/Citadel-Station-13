/obj/item/ammo_box/magazine/mm195x129
	name = "box magazine (1.95x129mm)"
	icon_state = "a762-50"
	ammo_type = /obj/item/ammo_casing/mm195x129
	caliber = "mm195129"
	max_ammo = 50

/obj/item/ammo_box/magazine/mm195x129/hollow
	name = "box magazine (Hollow-Point 1.95x129mm)"
	ammo_type = /obj/item/ammo_casing/mm195x129/hollow

/obj/item/ammo_box/magazine/mm195x129/ap
	name = "box magazine (Armor Penetrating 1.95x129mm)"
	ammo_type = /obj/item/ammo_casing/mm195x129/ap

/obj/item/ammo_box/magazine/mm195x129/incen
	name = "box magazine (Incendiary 1.95x129mm)"
	ammo_type = /obj/item/ammo_casing/mm195x129/incen

/obj/item/ammo_box/magazine/mm195x129/update_icon()
	..()
	icon_state = "a762-[round(ammo_count(),10)]"

/obj/item/ammo_box/magazine/mm556x45
	name = "box magazine (5.56×45mm)"
	icon_state = "a762-50"
	ammo_type = /obj/item/ammo_casing/mm556x45
	caliber = "mm55645"
	max_ammo = 100

/obj/item/ammo_box/magazine/mm556x45/hollow
	name = "box magazine (Hollow-Point 5.56×45mm)"
	ammo_type = /obj/item/ammo_casing/mm556x45/hollow
	max_ammo = 75

/obj/item/ammo_box/magazine/mm556x45/ap
	name = "box magazine (Armor Penetrating 5.56×45mm)"
	ammo_type = /obj/item/ammo_casing/mm556x45/ap

/obj/item/ammo_box/magazine/mm556x45/incen
	name = "box magazine (Incendiary 5.56×45mm)"
	ammo_type = /obj/item/ammo_casing/mm556x45/incen
	max_ammo = 75

/obj/item/ammo_box/magazine/mm556x45/update_icon()
	..()
	icon_state = "a762-[round(ammo_count(),20)]"


