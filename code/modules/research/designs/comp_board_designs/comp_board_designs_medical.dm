///////////////////
///MEDICAL Boards//
///////////////////

/datum/design/board/pandemic
	name = "Computer Design (PanD.E.M.I.C. 2200)"
	desc = "Allows for the construction of circuit boards used to build a PanD.E.M.I.C. 2200 console."
	id = "pandemic"
	build_path = /obj/item/circuitboard/computer/pandemic
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/operating
	name = "Computer Design (Operating Computer)"
	desc = "Allows for the construction of circuit boards used to build an operating computer console."
	id = "operating"
	build_path = /obj/item/circuitboard/computer/operating
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/scan_console
	name = "Computer Design (DNA Machine)"
	desc = "Allows for the construction of circuit boards used to build a new DNA scanning console."
	id = "scan_console"
	build_path = /obj/item/circuitboard/computer/scan_consolenew
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/crewconsole
	name = "Computer Design (Crew monitoring computer)"
	desc = "Allows for the construction of circuit boards used to build a Crew monitoring computer."
	id = "crewconsole"
	build_path = /obj/item/circuitboard/computer/crew
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/med_data
	name = "Computer Design (Medical Records)"
	desc = "Allows for the construction of circuit boards used to build a medical records console."
	id = "med_data"
	build_path = /obj/item/circuitboard/computer/med_data
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SECURITY
