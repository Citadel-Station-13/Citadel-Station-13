//datum/design/comp_defib
	name = "compact defibrillator"
	desc = "A belt-equipped defibrillator that can be rapidly deployed"
	id = "comp_defib"
	build_type = PROTOLATHE
	build_path = /obj/item/defibrillator/compact
	materials = list(MAT_METAL=16000, MAT_GLASS = 8000, MAT_GOLD = 6000, MAT_SILVER = 6000, MAT_TITANIUM = 16000)
	construction_time = 100
	category = list("Misc")
	//departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/defib_heal
	name = "Defibrillartor Healing disk"
	desc = "A disk alowing for grater amounts of healing"
	id = "defib_heal"
	build_type = PROTOLATHE
  	build_path = /obj/item/disk/defib_heal
  	materials = list(MAT_METAL=16000, MAT_GLASS = 18000, MAT_GOLD = 6000, MAT_SILVER = 6000)
  	construction_time = 10
  	category = list("Misc")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/defib_shock
	name = "Defibrillartor Anit-Shock Disk"
	desc = "A disk that helps agains shocking anyone, other then the intented target"
	id = "defib_shock"
	build_type = PROTOLATHE
	build_path = /obj/item/disk/defib_shock
	materials = list(MAT_METAL=16000, MAT_GLASS = 18000, MAT_GOLD = 6000, MAT_SILVER = 6000)
	construction_time = 10
	category = list("Misc")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/defib_decay
	name = "Defibrillartor Body-Decay exstender Disk"
	desc = "A disk that helps defibrillators revive the longer decayed dead"
	id = "defib_decay"
	build_type = PROTOLATHE
	build_path = /obj/item/disk/defib_decay
	materials = list(MAT_METAL=16000, MAT_GLASS = 18000, MAT_GOLD = 16000, MAT_SILVER = 6000, MAT_TITANIUM = 2000)
	construction_time = 10
	category = list("Misc")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/defib_speed
	name = "Defibrllartor Pre-Primer Disk"
	desc = "A disk that cuts the time charg time in half for defubrillator use"
	id = "defib_speed"
	build_type = PROTOLATHE
	build_path = /obj/item/disk/defib_speed
	materials = list(MAT_METAL=16000, MAT_GLASS = 8000, MAT_GOLD = 26000, MAT_SILVER = 26000)
	construction_time = 10
	category = list("Misc")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
