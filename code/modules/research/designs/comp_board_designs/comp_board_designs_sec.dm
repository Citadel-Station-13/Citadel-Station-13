///////////////////
///SECURITY Boards/
///////////////////

/datum/design/board/seccamera
	name = "Computer Design (Security Camera)"
	desc = "Allows for the construction of circuit boards used to build security camera computers."
	id = "seccamera"
	build_path = /obj/item/circuitboard/computer/security
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/shuttleseccamera
	name = "Computer Design (Shuttle-Linked Security Camera)"
	desc = "Same as a regular security camera console, but when linked to a shuttle, will specifically access cameras on that shuttle."
	id = "shuttleseccamera"
	build_path = /obj/item/circuitboard/computer/security/shuttle
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/secdata
	name = "Computer Design (Security Records Console)"
	desc = "Allows for the construction of circuit boards used to build a security records console."
	id = "secdata"
	build_path = /obj/item/circuitboard/computer/secure_data
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/prisonmanage
	name = "Computer Design (Prisoner Management Console)"
	desc = "Allows for the construction of circuit boards used to build a prisoner management console."
	id = "prisonmanage"
	build_path = /obj/item/circuitboard/computer/prisoner
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/comconsole
	name = "Computer Design (Communications)"
	desc = "Allows for the construction of circuit boards used to build a communications console."
	id = "comconsole"
	build_path = /obj/item/circuitboard/computer/communications
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY	| DEPARTMENTAL_FLAG_ENGINEERING 	//Honestly should have a bridge techfab for this sometime.

/datum/design/board/idcardconsole
	name = "Computer Design (ID Console)"
	desc = "Allows for the construction of circuit boards used to build an ID computer."
	id = "idcardconsole"
	build_path = /obj/item/circuitboard/computer/card
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY	| DEPARTMENTAL_FLAG_ENGINEERING 	//Honestly should have a bridge techfab for this sometime.
