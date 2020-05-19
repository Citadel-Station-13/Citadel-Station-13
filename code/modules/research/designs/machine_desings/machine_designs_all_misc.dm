////////////////////////////////////////
//////////////MISC Boards///////////////
////////////////////////////////////////

/datum/design/board/recycler
	name = "Machine Design (Recycler Board)"
	desc = "The circuit board for a recycler."
	id = "recycler"
	build_path = /obj/item/circuitboard/machine/recycler
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/holopad
	name = "Machine Design (AI Holopad Board)"
	desc = "The circuit board for a holopad."
	id = "holopad"
	build_path = /obj/item/circuitboard/machine/holopad
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/autolathe
	name = "Machine Design (Autolathe Board)"
	desc = "The circuit board for an autolathe."
	id = "autolathe"
	build_path = /obj/item/circuitboard/machine/autolathe
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/autolathe_secure
	name = "Machine Design (Secure Autolathe Board)"
	desc = "The circuit board for an autolathe. This one is programmed to not allow hacking."
	id = "autolathe_secure"
	build_path = /obj/item/circuitboard/machine/autolathe/secure
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/recharger
	name = "Machine Design (Weapon Recharger Board)"
	desc = "The circuit board for a Weapon Recharger."
	id = "recharger"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000)
	build_path = /obj/item/circuitboard/machine/recharger
	category = list("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/vendor
	name = "Machine Design (Vendor Board)"
	desc = "The circuit board for a Vendor. Use a screwdriver to turn the \"brand selection\" dial."
	id = "vendor"
	build_path = /obj/item/circuitboard/machine/vendor
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/donksofttoyvendor
	name = "Machine Design (Donksoft Toy Vendor Board)"
	desc = "The circuit board for a Donksoft Toy Vendor."
	id = "donksofttoyvendor"
	build_path = /obj/item/circuitboard/machine/vending/donksofttoyvendor
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/space_heater
	name = "Machine Design (Space Heater Board)"
	desc = "The circuit board for a space heater."
	id = "space_heater"
	build_path = /obj/item/circuitboard/machine/space_heater
	category = list ("Engineering Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/reagentgrinder
	name = "Machine Design (All-In-One Grinder)"
	desc = "The circuit board for an All-In-One Grinder."
	id = "reagentgrinder"
	build_path = /obj/item/circuitboard/machine/reagentgrinder
	category = list ("Medical Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/microwave
	name = "Machine Design (Microwave Board)"
	desc = "The circuit board for a microwave."
	id = "microwave"
	build_path = /obj/item/circuitboard/machine/microwave
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/smartfridge
	name = "Machine Design (Smartfridge Board)"
	desc = "The circuit board for a smartfridge."
	id = "smartfridge"
	build_path = /obj/item/circuitboard/machine/smartfridge
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/cell_charger
	name = "Machine Design (Cell Charger Board)"
	desc = "The circuit board for a cell charger."
	id = "cell_charger"
	build_path = /obj/item/circuitboard/machine/cell_charger
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/vr_sleeper
	name = "Machine Design (VR Sleeper Board)"
	desc = "The circuit board for a VR sleeper."
	id = "vr_sleeper"
	build_path = /obj/item/circuitboard/machine/vr_sleeper
	departmental_flags = DEPARTMENTAL_FLAG_ALL
	category = list ("Medical Machinery")

/datum/design/board/paystand
	name = "Machine Design (Pay Stand)"
	desc = "The circuit board for a paystand."
	id = "paystand"
	build_path = /obj/item/circuitboard/machine/paystand
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/autoylathe
	name = "Machine Design (Autoylathe)"
	desc = "The circuit board for an autoylathe."
	id = "autoylathe"
	build_path = /obj/item/circuitboard/machine/autolathe/toy
	departmental_flags = DEPARTMENTAL_FLAG_ALL
	category = list("Misc. Machinery")
