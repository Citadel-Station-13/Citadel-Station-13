///////////////////Computer Boards///////////////////////////////////
/datum/design/board
	name = "Computer Design ( NULL ENTRY )"
	desc = "A blank compurter board!"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 1000)

/datum/design/board/arcade_battle
	name = "Computer Design (Battle Arcade Machine)"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "arcade_battle"
	build_path = /obj/item/circuitboard/computer/arcade/battle
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/orion_trail
	name = "Computer Design (Orion Trail Arcade Machine)"
	desc = "Allows for the construction of circuit boards used to build a new Orion Trail machine."
	id = "arcade_orion"
	build_path = /obj/item/circuitboard/computer/arcade/orion_trail
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/minesweeper
	name = "Computer Design (Minesweeper Arcade Machine)"
	desc = "Allows for the construction of circuit boards used to build a new Minesweeper machine."
	id = "arcade_minesweeper"
	build_path = /obj/item/circuitboard/computer/arcade/minesweeper
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/slot_machine
	name = "Computer Design (Slot Machine)"
	desc = "Allows for the construction of circuit boards used to build a new slot machine."
	id = "slotmachine"
	build_path = /obj/item/circuitboard/computer/slot_machine
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/board/libraryconsole
	name = "Computer Design (Library Console)"
	desc = "Allows for the construction of circuit boards used to build a new library console."
	id = "libraryconsole"
	build_path = /obj/item/circuitboard/computer/libraryconsole
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_ALL