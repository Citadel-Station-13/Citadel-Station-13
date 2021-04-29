/datum/design/m10mm/fire
	name = "pistol magazine (10mm incendiary)"
	desc = "A gun magazine. Loaded with rounds which ignite the target.."
	id = "10mminc"
	build_type = PROTOLATHE
	materials = list(/datum/material/plasma = 5000, /datum/material/iron = 7500)
	build_path = /obj/item/ammo_box/magazine/m10mm/fire
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10mm
	name = "pistol magazine (10mm)"
	desc = "A gun magazine."
	id = "10mm"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 6000)
	build_path = /obj/item/ammo_box/magazine/m10mm
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10mm/hp
	name = "pistol magazine (10mm HP)"
	desc = "A gun magazine. Loaded with hollow-point rounds, extremely effective against unarmored targets, but nearly useless against protective clothing."
	id = "10mmhp"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 7500, /datum/material/glass = 5000)
	build_path = /obj/item/ammo_box/magazine/m10mm/hp
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10mm/ap
	name = "pistol magazine (10mm AP)"
	desc = "A gun magazine. Loaded with rounds which penetrate armour, but are less effective against normal targets."
	id = "10mmap"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 7500, /datum/material/titanium = 6500)
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
	materials = list(/datum/material/iron = 8000)
	build_path = /obj/item/ammo_box/magazine/m45
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/pistolm9mm
	name = "pistol magazine (9mm)"
	desc = "A gun magazine."
	id = "pistolm9mm"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 7500)
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
	materials = list(/datum/material/iron = 30000, /datum/material/titanium = 5000)
	build_path = /obj/item/ammo_box/a357/ap
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10apbox
	name = "ammo box (10mm Armour Piercing)"
	desc = "A box of ammo containing 20 rounds designed to penetrate armor, at the cost of raw damage."
	id = "m10apbox"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 30000, /datum/material/titanium = 6000)
	build_path = /obj/item/ammo_box/c10mm/ap
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10firebox
	name = "ammo box (10mm Incendiary)"
	desc = "A box of ammo containing 20 rounds designed to set people ablaze, at the cost of raw damage."
	id = "m10firebox"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 30000, /datum/material/plasma = 6000)
	build_path = /obj/item/ammo_box/c10mm/fire
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/m10hpbox
	name = "ammo box (10mm Hollowpoint)"
	desc = "A box of ammo containing 20 rounds designed to tear through unarmored opponents, while being completely ineffective against armor."
	id = "m10hpbox"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 30000, /datum/material/glass = 6000)
	build_path = /obj/item/ammo_box/c10mm/hp
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
