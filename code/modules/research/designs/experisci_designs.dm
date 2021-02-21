/datum/design/experi_scanner
	name = "Experimental Scanner"
	desc = "Experimental scanning unit used for performing scanning experiments."
	id = "experi_scanner"
	build_type = PROTOLATHE
	materials = list(/datum/material/glass = 500, /datum/material/iron = 500)
	build_path = /obj/item/experi_scanner
	category = list("Equipment")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/destructive_scanner
	name = "Machine Design (Destructive Scanner Board)"
	desc = "The circuit board for an experimental destructive scanner."
	id = "destructive_scanner"
	build_path = /obj/item/circuitboard/machine/destructive_scanner
	category = list("Research Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/doppler_array
	name = "Machine Design (Tachyon-Doppler Research Array Board)"
	desc = "The circuit board for a tachyon-doppler research array"
	id = "doppler_array"
	build_path = /obj/item/circuitboard/machine/doppler_array
	category = list("Research Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE
