/datum/design/10mminc
	name = "pistol magazine (10mm incendiary)"
	desc = "A gun magazine. Loaded with rounds which ignite the target.."
	id = "10mminc"
	build_type = PROTOLATHE
	materials = list(MAT_PLASMA = 2000,MAT_METAL = 18000)
	build_path = /obj/item/ammo_box/magazine/m10mm/fire
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/10mm
	name = "pistol magazine (10mm)"
	desc = "A gun magazine."
	id = "10mm"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 18000)
	build_path = /obj/item/ammo_box/magazine/m10mm
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/10mmhp
	name = "pistol magazine (10mm HP)"
	desc = "A gun magazine. Loaded with hollow-point rounds, extremely effective against unarmored targets, but nearly useless against protective clothing."
	id = "10mmhp"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 18000, MAT_GLASS = 2000)
	build_path = /obj/item/ammo_box/magazine/m10mm/hp
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

datum/design/10mmap
	name = "pistol magazine (10mm AP)"
	desc = "A gun magazine. Loaded with rounds which penetrate armour, but are less effective against normal targets."
	id = "10mmap"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 18000 MAT_TITANIUM = 2000)
	build_path = /obj/item/ammo_box/magazine/m10mm/ap
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/9mm
	name = "pistol magazine (9mm)"
	desc = "A gun magazine for the ASP Stetchkin pistol."
	id = "9mm"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 16000)
	build_path = /obj/item/ammo_box/magazine/pistolm9mm
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/bolt_clip
	name = "Surplus Rifle Clip"
	desc = "A stripper clip used to quickly load bolt action rifles. Contains 5 rounds."
	id = "bolt_clip"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 8000)
	build_path = /obj/item/ammo_box/a762
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/point_45 //Kinda NT in throey
	name = "handgun magazine (.45)"
	desc = "A gun magazine for the M1911 handgun."
	id = "point_45"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 8000)
	build_path = /obj/item/ammo_box/magazine/m45
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
