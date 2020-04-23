/obj/item/ammo_box/magazine/m10mm/rifle
	name = "rifle magazine (10mm)"
	desc = "A well-worn magazine fitted for the surplus rifle."
	icon_state = "75-8"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 10

/obj/item/ammo_box/magazine/m10mm/rifle/update_icon()
	if(ammo_count())
		icon_state = "75-8"
	else
		icon_state = "75-0"

/obj/item/ammo_box/magazine/m556
	name = "toploader magazine (5.56mm)"
	icon_state = "5.56m"
	ammo_type = /obj/item/ammo_casing/a556
	caliber = "a556"
	max_ammo = 30
	multiple_sprites = 2

//flechette

/obj/item/ammo_box/magazine/flechette
	name = "flechette magazine (armor piercing)"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "flechettemag"
	ammo_type = /obj/item/ammo_casing/caseless/flechetteap
	caliber = "flechette"
	max_ammo = 40
	multiple_sprites = 2

/obj/item/ammo_box/magazine/flechette/s
	name = "flechette magazine (serrated)"
	ammo_type = /obj/item/ammo_casing/caseless/flechettes

/obj/item/ammo_box/magazine/flechette/shredder
	name = "flechette magazine (shredder)"
	icon_state = "shreddermag"
	ammo_type = /obj/item/ammo_casing/caseless/flechetteshredder

/obj/item/ammo_box/magazine/wt550m9/wtrubber
	name = "wt550 magazine (Rubber bullets 4.6x30mm)"
	icon_state = "46x30mmtA-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm/rubber