///////////////////
///CARGO Boards////
///////////////////

/datum/design/board/cargo
	name = "Computer Design (Supply Console)"
	desc = "Allows for the construction of circuit boards used to build a Supply Console."
	id = "cargo"
	build_path = /obj/item/circuitboard/computer/cargo
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/cargorequest
	name = "Computer Design (Supply Request Console)"
	desc = "Allows for the construction of circuit boards used to build a Supply Request Console."
	id = "cargorequest"
	build_path = /obj/item/circuitboard/computer/cargo/request
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO
	
/datum/design/board/mining
	name = "Computer Design (Outpost Status Display)"
	desc = "Allows for the construction of circuit boards used to build an outpost status display console."
	id = "mining"
	build_path = /obj/item/circuitboard/computer/mining
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/miningshuttle
	name = "Computer Design (Mining Shuttle Console)"
	desc = "Allows for the construction of circuit boards used to build a Mining Shuttle Console."
	id = "miningshuttle"
	build_path = /obj/item/circuitboard/computer/mining_shuttle
	category = list("Computer Boards")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/bountypad_control
	name = "Computer Design (Civilian Bounty Pad Control)"
	desc = "Allows for the construction of circuit boards used to build a new civilian bounty pad console."
	id = "bounty_pad_control"
	build_path = /obj/item/circuitboard/computer/bountypad
	category = list("Computer Boards")
