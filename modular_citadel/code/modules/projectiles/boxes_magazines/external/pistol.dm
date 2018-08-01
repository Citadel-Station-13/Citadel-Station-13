/datum/design/m10mm/fire
	name = "pistol magazine (10mm incendiary)"
	desc = "A gun magazine. Loaded with rounds which ignite the target.."
	id = "10mminc"
	build_type = PROTOLATHE
	materials = list(MAT_PLASMA = 50000, MAT_METAL = 18000)
	reagents_list = list("plasma" = 120, "napalm" = 240)
	build_path = /obj/item/ammo_box/magazine/m10mm/fire
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10mm
	name = "pistol magazine (10mm)"
	desc = "A gun magazine."
	id = "10mm"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 18000)
	build_path = /obj/item/ammo_box/magazine/m10mm
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10mm/hp
	name = "pistol magazine (10mm HP)"
	desc = "A gun magazine. Loaded with hollow-point rounds, extremely effective against unarmored targets, but nearly useless against protective clothing."
	id = "10mmhp"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 18000, MAT_GLASS = 25000)
	reagents_list = list("sonic_powder" = 280)
	build_path = /obj/item/ammo_box/magazine/m10mm/hp
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
