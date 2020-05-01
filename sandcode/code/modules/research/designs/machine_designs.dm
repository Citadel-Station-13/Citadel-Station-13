/datum/design/board/telepad
	name = "Machine Design (Telepad Board)"
	desc = "The circuit board for a telescience telepad."
	id = "telepad"
	build_path = /obj/item/circuitboard/machine/telesci_pad
	category = list ("Teleportation Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/telesci_console
	name = "Computer Design (Telepad Control Console Board)"
	desc = "Allows for the construction of circuit boards used to build a telescience console."
	id = "telesci_console"
	build_path = /obj/item/circuitboard/computer/telesci_console
	category = list("Teleportation Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/mecha_part_fabricator_adv
	name= "Machine Design (Advanced exosuit fabricator)"
	desc = "An advanced version of the exosuit fabricator that can link to oresilos!"
	id = "mech_fab_adv"
	build_path = /obj/item/circuitboard/machine/mechfab_adv
	category = list("Research Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/mclunky_electronics
	name = "Machine Design (McLunky Circuit Board)"
	desc = "Now just give the parts to the botanist and they could perhaps be making power for you!"
	id = "mclunky_circuit_board"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 2000)
	build_path = /obj/item/circuitboard/machine/pacman/mclunky
	category = list("initial", "Electronics")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_ENGINEERING
