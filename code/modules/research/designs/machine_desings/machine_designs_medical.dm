///////////////////
///MEDICAL Boards//
///////////////////

/datum/design/board/limbgrower
	name = "Machine Design (Limb Grower Board)"
	desc = "The circuit board for a limb grower."
	id = "limbgrower"
	build_path = /obj/item/circuitboard/machine/limbgrower
	category = list("Medical Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/harvester
	name = "Machine Design (Organ Harvester Board)"
	desc = "The circuit board for an organ harvester."
	id = "harvester"
	build_path = /obj/item/circuitboard/machine/harvester
	category = list("Medical Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/sleeper
	name = "Machine Design (Sleeper Board)"
	desc = "The circuit board for a sleeper."
	id = "sleeper"
	build_path = /obj/item/circuitboard/machine/sleeper
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING
	category = list("Medical Machinery")

/datum/design/board/syndiesleeper
	name = "Machine Design (Syndicate Sleeper Board)"
	desc = "The circuit board for a Syndicate sleeper, with controls inside."
	id = "syndiesleeper"
	build_path = /obj/item/circuitboard/machine/sleeper/syndie
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING
	category = list("Medical Machinery")

/datum/design/board/cryotube
	name = "Machine Design (Cryotube Board)"
	desc = "The circuit board for a cryotube."
	id = "cryotube"
	build_path = /obj/item/circuitboard/machine/cryo_tube
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING
	category = list ("Medical Machinery")

/datum/design/board/chem_dispenser
	name = "Machine Design (Portable Chem Dispenser Board)"
	desc = "The circuit board for a portable chem dispenser."
	id = "chem_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING
	category = list ("Medical Machinery")

/datum/design/board/chem_master
	name = "Machine Design (Chem Master Board)"
	desc = "The circuit board for a Chem Master 3000."
	id = "chem_master"
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING
	build_path = /obj/item/circuitboard/machine/chem_master
	category = list ("Medical Machinery")

/datum/design/board/chem_heater
	name = "Machine Design (Chemical Heater Board)"
	desc = "The circuit board for a chemical heater."
	id = "chem_heater"
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING
	build_path = /obj/item/circuitboard/machine/chem_heater
	category = list ("Medical Machinery")

/datum/design/board/smoke_machine
	name = "Machine Design (Smoke Machine)"
	desc = "The circuit board for a smoke machine."
	id = "smoke_machine"
	build_path = /obj/item/circuitboard/machine/smoke_machine
	category = list ("Medical Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/clonecontrol
	name = "Computer Design (Cloning Machine Console)"
	desc = "Allows for the construction of circuit boards used to build a new Cloning Machine console."
	id = "clonecontrol"
	build_path = /obj/item/circuitboard/computer/cloning
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING
	category = list("Medical Machinery")

/datum/design/board/clonepod
	name = "Machine Design (Clone Pod)"
	desc = "Allows for the construction of circuit boards used to build a Cloning Pod."
	id = "clonepod"
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING
	build_path = /obj/item/circuitboard/machine/clonepod
	category = list("Medical Machinery")

/datum/design/board/clonescanner
	name = "Machine Design (Cloning Scanner)"
	desc = "Allows for the construction of circuit boards used to build a Cloning Scanner."
	id = "clonescanner"
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_ENGINEERING
	build_path = /obj/item/circuitboard/machine/clonescanner
	category = list("Medical Machinery")

/datum/design/board/bloodbankgen
	name = "Machine Design (Blood Bank Generator Board)"
	desc = "The circuit board for a blood bank generator."
	id = "bloodbankgen"
	build_path = /obj/item/circuitboard/machine/bloodbankgen
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Medical Machinery")

/datum/design/board/medipen_refiller
	name = "Machine Design (Medipen Refiller)"
	desc = "The circuit board for a Medipen Refiller."
	id = "medipen_refiller"
	build_path = /obj/item/circuitboard/machine/medipen_refiller
	category = list ("Medical Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
