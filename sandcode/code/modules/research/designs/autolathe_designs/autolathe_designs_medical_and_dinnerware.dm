/datum/design/oxygen_tank
	name = "Oxygen Tank"
	id = "oxygen_tank"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/tank/internals/oxygen/empty
	category = list("initial", "Medical","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/plasma_tank
	name = "Plasma Tank"
	id = "plasma_tank"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/tank/internals/plasma/empty
	category = list("initial", "Medical","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/emergency_oxygen
	name = "Emergency Oxygen Tank"
	id = "emergency_oxygen"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/tank/internals/emergency_oxygen/empty
	category = list("initial", "Medical","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/generic_tank
	name = "Gas Tank"
	id = "gas_tank"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/tank/internals/generic
	category = list("initial", "Medical","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING
