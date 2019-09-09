////////////////////////////////////////
//////////////////Power/////////////////
////////////////////////////////////////

/datum/design/basic_cell
	name = "Basic Power Cell"
	desc = "A basic power cell that holds 1 MJ of energy."
	id = "basic_cell"
	build_type = PROTOLATHE | AUTOLATHE |MECHFAB
	materials = list(MAT_METAL = 700, MAT_GLASS = 50)
	construction_time=100
	build_path = /obj/item/stock_parts/cell/empty
	category = list("Misc","Power Designs","Machinery","initial")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/high_cell
	name = "High-Capacity Power Cell"
	desc = "A power cell that holds 10 MJ of energy."
	id = "high_cell"
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	materials = list(MAT_METAL = 700, MAT_GLASS = 60)
	construction_time=100
	build_path = /obj/item/stock_parts/cell/high/empty
	category = list("Misc","Power Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/super_cell
	name = "Super-Capacity Power Cell"
	desc = "A power cell that holds 20 MJ of energy."
	id = "super_cell"
	build_type = PROTOLATHE | MECHFAB
	materials = list(MAT_METAL = 700, MAT_GLASS = 70)
	construction_time=100
	build_path = /obj/item/stock_parts/cell/super/empty
	category = list("Misc","Power Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/hyper_cell
	name = "Hyper-Capacity Power Cell"
	desc = "A power cell that holds 30 MJ of energy."
	id = "hyper_cell"
	build_type = PROTOLATHE | MECHFAB
	materials = list(MAT_METAL = 700, MAT_GOLD = 150, MAT_SILVER = 150, MAT_GLASS = 80)
	construction_time=100
	build_path = /obj/item/stock_parts/cell/hyper/empty
	category = list("Misc","Power Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/bluespace_cell
	name = "Bluespace Power Cell"
	desc = "A power cell that holds 40 MJ of energy."
	id = "bluespace_cell"
	build_type = PROTOLATHE | MECHFAB
	materials = list(MAT_METAL = 800, MAT_GOLD = 120, MAT_GLASS = 160, MAT_DIAMOND = 160, MAT_TITANIUM = 300, MAT_BLUESPACE = 100)
	construction_time=100
	build_path = /obj/item/stock_parts/cell/bluespace/empty
	category = list("Misc","Power Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/inducer
	name = "Inducer"
	desc = "The NT-75 Electromagnetic Power Inducer can wirelessly induce electric charge in an object, allowing you to recharge power cells without having to remove them."
	id = "inducer"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 3000, MAT_GLASS = 1000)
	build_path = /obj/item/inducer/sci
	category = list("Power Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/inducercombat
	name = "Combat Ready Inducer"
	desc = "The improved NT-8475 Electromagnetic Power Inducer can this one has been SCIENCED to allow for combat. It still comes printed with SCIENCED colors!"
	id = "combatinducer"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 13000, MAT_GLASS = 10000,  MAT_SILVER = 1500,  MAT_GOLD = 1250, MAT_DIAMOND = 500, MAT_TITANIUM = 1200)
	build_path = /obj/item/inducer/sci/combat/dry
	category = list("Power Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/pacman
	name = "Machine Design (PACMAN-type Generator Board)"
	desc = "The circuit board that for a PACMAN-type portable generator."
	id = "pacman"
	build_path = /obj/item/circuitboard/machine/pacman
	category = list("Engineering Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/pacman/super
	name = "Machine Design (SUPERPACMAN-type Generator Board)"
	desc = "The circuit board that for a SUPERPACMAN-type portable generator."
	id = "superpacman"
	build_path = /obj/item/circuitboard/machine/pacman/super
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/pacman/mrs
	name = "Machine Design (MRSPACMAN-type Generator Board)"
	desc = "The circuit board that for a MRSPACMAN-type portable generator."
	id = "mrspacman"
	build_path = /obj/item/circuitboard/machine/pacman/mrs
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING
