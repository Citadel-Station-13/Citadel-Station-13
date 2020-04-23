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
	icon_state = "c20r45-toy"
	caliber = "foam_force"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	max_ammo = 20

/obj/item/ammo_box/magazine/toy/smgm45/update_icon()
	..()
	icon_state = "c20r45-[round(ammo_count(),2)]"

/obj/item/ammo_box/magazine/toy/smgm45/riot
	icon_state = "c20r45-riot"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot

/obj/item/ammo_box/magazine/toy/m762
	name = "donksoft box magazine"
	icon_state = "a762-toy"
	caliber = "foam_force"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	max_ammo = 50

/obj/item/ammo_box/magazine/toy/m762/update_icon()
	..()
	icon_state = "a762-[round(ammo_count(),10)]"

/obj/item/ammo_box/magazine/toy/m762/riot
	icon_state = "a762-riot"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot

/obj/item/ammo_box/magazine/toy/foamag
	name = "foam force magrifle magazine"
	icon_state = "foamagmag"
	max_ammo = 24
	multiple_sprites = 2
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/mag
	custom_materials = list(/datum/material/iron = 200)

/obj/item/ammo_box/magazine/toy/AM4B
	name = "foam force AM4-B magazine"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "AM4MAG-60"
	max_ammo = 60
	multiple_sprites = 0
	custom_materials = list(/datum/material/iron = 200)

/obj/item/ammo_box/magazine/toy/AM4C
	name = "foam force AM4-C magazine"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "AM4MAG-32"
	max_ammo = 32
	multiple_sprites = 0
	custom_materials = list(/datum/material/iron = 200)

/obj/item/ammo_box/magazine/toy/x9
	name = "foam force X9 magazine"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "toy9magazine"
	max_ammo = 30
	multiple_sprites = 2
	custom_materials = list(/datum/material/iron = 200)

/obj/item/ammo_box/magazine/toy/x9
	name = "foam force X9 magazine"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "toy9magazine"
	max_ammo = 30
	multiple_sprites = 2
	custom_materials = list(/datum/material/iron = 200)