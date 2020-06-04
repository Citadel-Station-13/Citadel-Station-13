/datum/design/m10mm/fire
	name = "pistol magazine (10mm incendiary)"
	desc = "A gun magazine. Loaded with rounds which ignite the target.."
	id = "10mminc"
	build_type = PROTOLATHE
	materials = list(/datum/material/plasma = 50000, /datum/material/iron = 18000)
	reagents_list = list(/datum/reagent/toxin/plasma = 120, /datum/reagent/napalm = 240)
	build_path = /obj/item/ammo_box/magazine/m10mm/fire
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10mm
	name = "pistol magazine (10mm)"
	desc = "A gun magazine."
	id = "10mm"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 55000)
	build_path = /obj/item/ammo_box/magazine/m10mm
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10mm/hp
	name = "pistol magazine (10mm HP)"
	desc = "A gun magazine. Loaded with hollow-point rounds, extremely effective against unarmored targets, but nearly useless against protective clothing."
	id = "10mmhp"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 40000, /datum/material/glass = 50000)
	reagents_list = list(/datum/reagent/sonic_powder = 280)
	build_path = /obj/item/ammo_box/magazine/m10mm/hp
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10mm/ap
	name = "pistol magazine (10mm AP)"
	desc = "A gun magazine. Loaded with rounds which penetrate armour, but are less effective against normal targets."
	id = "10mmap"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 40000, /datum/material/titanium = 60000)
	build_path = /obj/item/ammo_box/magazine/m10mm/ap
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/bolt_clip
	name = "Surplus Rifle Clip"
	desc = "A stripper clip used to quickly load bolt action rifles. Contains 5 rounds."
	id = "bolt_clip"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 8000)
	build_path = /obj/item/ammo_box/a762
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m45 //Kinda NT in theory
	name = "handgun magazine (.45)"
	id = "m45"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 80000)
	build_path = /obj/item/ammo_box/magazine/m45
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/pistolm9mm
	name = "pistol magazine (9mm)"
	desc = "A gun magazine."
	id = "pistolm9mm"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 80000)
	build_path = /obj/item/ammo_box/magazine/pistolm9mm
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/sl357
	name = "revolver speedloader (.357)"
	desc = "A revolver speedloader."
	id = "sl357"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 30000)
	build_path = /obj/item/ammo_box/a357
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/sl357ap
	name = "revolver speedloader (.357 AP)"
	desc = "A revolver speedloader. Cuts through like a hot knife through butter."
	id = "sl357ap"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 30000, /datum/material/titanium = 45000)
	build_path = /obj/item/ammo_box/a357/ap
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
