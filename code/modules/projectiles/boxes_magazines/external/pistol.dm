/obj/item/ammo_box/magazine/m10mm
	name = "pistol magazine (10mm)"
	desc = "A gun magazine."
	icon_state = "9x19p"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 8
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m10mm/fire
	name = "pistol magazine (10mm incendiary)"
	icon_state = "9x19pI"
	desc = "A gun magazine. Loaded with rounds which ignite the target."
	ammo_type = /obj/item/ammo_casing/c10mm/fire

/obj/item/ammo_box/magazine/m10mm/hp
	name = "pistol magazine (10mm HP)"
	icon_state = "9x19pH"
	desc= "A gun magazine. Loaded with hollow-point rounds, extremely effective against unarmored targets, but nearly useless against protective clothing."
	ammo_type = /obj/item/ammo_casing/c10mm/hp

/obj/item/ammo_box/magazine/m10mm/ap
	name = "pistol magazine (10mm AP)"
	icon_state = "9x19pA"
	desc= "A gun magazine. Loaded with rounds which penetrate armour, but are less effective against normal targets."
	ammo_type = /obj/item/ammo_casing/c10mm/ap

/obj/item/ammo_box/magazine/m10mm/soporific
	name = "pistol magazine (10mm soporific)"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "9x19pS"
	desc = "A gun magazine. Loaded with rounds which inject the target with a variety of illegal substances to induce sleep in the target."
	ammo_type = /obj/item/ammo_casing/c10mm/soporific

/obj/item/ammo_box/magazine/m45
	name = "handgun magazine (.45)"
	icon_state = "45-8"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 8

/obj/item/ammo_box/magazine/m45/update_icon()
	..()
	icon_state = "45-[ammo_count() ? "8" : "0"]"

/obj/item/ammo_box/magazine/m45/kitchengun
	name = "handgun magazine (.45 cleaning)"
	desc = "BANG! BANG! BANG!"
	ammo_type = /obj/item/ammo_casing/c45/kitchengun

/obj/item/ammo_box/magazine/pistolm9mm
	name = "pistol magazine (9mm)"
	icon_state = "9x19p-8"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 15

/obj/item/ammo_box/magazine/pistolm9mm/update_icon()
	..()
	icon_state = "9x19p-[ammo_count() ? "8" : "0"]"

/obj/item/ammo_box/magazine/m50
	name = "handgun magazine (.50ae)"
	icon_state = "50ae"
	ammo_type = /obj/item/ammo_casing/a50AE
	caliber = ".50"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_box/magazine/m32acp
	name = "pistol magazine (.32)"
	desc = "A crudely construction pistol magazine that holds .32 ACP rounds. It looks like it can only fit eight bullets."
	icon_state = "32acp"
	ammo_type = /obj/item/ammo_casing/c32acp
	caliber = "c32acp"
	max_ammo = 8
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m32acp/empty
	start_empty = 1
