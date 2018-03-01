/datum/design/triphasic
	name = "Triphase Laser Rifle"
	desc = "Designed as a new type of experimental hybrid energy weapon, the triphase laser rifle utilises energy magazines to charge an internal high-efficiency capacitor, which in turn powers a focusing crystal to create a beam of high-powered light."
	id = "triphasic"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 6000, MAT_GLASS = 1500, MAT_DIAMOND = 1000, MAT_URANIUM = 1000, MAT_SILVER = 2500, MAT_GOLD = 2500)
	build_path = /obj/item/gun/ballistic/automatic/triphase
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/triphasicammo
	name = "Triphase power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for the triphase laser rifle. It can store enough power for five shots."
	id = "triphasicammo"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 2000, MAT_GLASS = 800, MAT_DIAMOND = 300, MAT_URANIUM = 300, MAT_SILVER = 1000, MAT_GOLD = 1000)
	build_path = /obj/item/ammo_box/magazine/recharge/triphase
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY