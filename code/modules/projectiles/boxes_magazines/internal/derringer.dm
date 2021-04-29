/obj/item/ammo_box/magazine/internal/derringer
	name = "derringer muzzle"
	ammo_type = /obj/item/ammo_casing/c38
	caliber = "38"
	max_ammo = 2
	multiload = FALSE

/obj/item/ammo_box/magazine/internal/derringer/ammo_count(countempties = 1)
	if (!countempties)
		var/boolets = 0
		for(var/obj/item/ammo_casing/bullet in stored_ammo)
			if(bullet.BB)
				boolets++
		return boolets
	else
		return ..()

/obj/item/ammo_box/magazine/internal/derringer/a357
	name = "\improper derringer muzzle"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = "357"
	max_ammo = 2
	multiload = FALSE

/obj/item/ammo_box/magazine/internal/derringer/g4570
	name = "\improper derringer muzzle"
	ammo_type = /obj/item/ammo_casing/g4570
	caliber = "45-70g"
	max_ammo = 2
	multiload = FALSE
