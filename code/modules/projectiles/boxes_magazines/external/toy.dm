/obj/item/ammo_box/magazine/toy
	name = "foam force META magazine"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	caliber = "foam_force"

/obj/item/ammo_box/magazine/toy/smg
	name = "foam force SMG magazine"
	icon_state = "smg9mm-42"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	max_ammo = 20

/obj/item/ammo_box/magazine/toy/smg/update_icon()
	..()
	if(ammo_count())
		icon_state = "smg9mm-42"
	else
		icon_state = "smg9mm-0"

/obj/item/ammo_box/magazine/toy/smg/riot
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot

/obj/item/ammo_box/magazine/toy/pistol
	name = "foam force pistol magazine"
	icon_state = "9x19p"
	max_ammo = 8
	multiple_sprites = 2

/obj/item/ammo_box/magazine/toy/pistol/riot
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot

/obj/item/ammo_box/magazine/toy/smgm45
	name = "donksoft SMG magazine"
	icon_state = "smgm10mm-toy"
	caliber = "foam_force"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	max_ammo = 28

/obj/item/ammo_box/magazine/toy/smgm45/update_icon()
	..()
	icon_state = "smgm10mm-[round(ammo_count(),2)]"

/obj/item/ammo_box/magazine/toy/smgm45/riot
	icon_state = "smgm10mm-riot"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot

/obj/item/ammo_box/magazine/toy/m762
	name = "donksoft box magazine"
	icon_state = "mm55645-toy"
	caliber = "foam_force"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	max_ammo = 75

/obj/item/ammo_box/magazine/toy/m762/update_icon()
	..()
	icon_state = "mm55645-[round(ammo_count(),20)]"

/obj/item/ammo_box/magazine/toy/m762/riot
	icon_state = "mm55645-riot"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot
