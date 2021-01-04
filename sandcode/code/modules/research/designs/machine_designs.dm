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

/datum/design/mclunky_electronics
	name = "Machine Design (McLunky Circuit Board)"
	desc = "Now just give the parts to the botanist and they could perhaps be making power for you!"
	id = "mclunky_circuit_board"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 2000)
	build_path = /obj/item/circuitboard/machine/pacman/mclunky
	category = list("initial", "Electronics")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/autodoc
	name = "Machine Design (Autodoc)"
	desc = "The circuit board for an Autodoc."
	id = "autodoc"
	build_path = /obj/item/circuitboard/machine/autodoc
	category = list("Medical Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

//Cryptocurrency Miners
/datum/design/board/cryptominer
	name = "Machine Design (Cryptocurrency Miner)"
	desc = "The circuit board for a Cryptocurrency Miner."
	id = "cryptominer"
	build_path = /obj/item/circuitboard/machine/cryptominer
	category = list("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/cryptominer/syndie
	name = "Machine Design (Syndicate Cryptocurrency Miner)"
	desc = "The circuit board for a Syndicate Cryptocurrency Miner."
	id = "cryptominersyndie"
	build_path = /obj/item/circuitboard/machine/cryptominer/syndie
	category = list("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

//BS miner
/datum/design/board/bluespace_miner
	name = "Machine Design (Bluespace Miner)"
	desc = "The circuit board for a Bluespace Miner."
	id = "bluespace_miner"
	build_path = /obj/item/circuitboard/machine/bluespace_miner
	category = list("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_ENGINEERING
