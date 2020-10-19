/obj/machinery/rnd/production/circuit_imprinter
	name = "circuit imprinter"
	desc = "Manufactures circuit boards for the construction of machines."
	icon_state = "circuit_imprinter"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter
	categories = list(
								"AI Modules",
								"Computer Boards",
								"Teleportation Machinery",
								"Medical Machinery",
								"Engineering Machinery",
								"Exosuit Modules",
								"Hydroponics Machinery",
								"Subspace Telecomms",
								"Research Machinery",
								"Misc. Machinery",
								"Computer Parts"
								)
	production_animation = "circuit_imprinter_ani"
	allowed_buildtypes = IMPRINTER

/obj/machinery/rnd/production/circuit_imprinter/disconnect_console()
	linked_console.linked_imprinter = null
	..()

/obj/machinery/rnd/production/circuit_imprinter/calculate_efficiency()
	. = ..()
	var/obj/item/circuitboard/machine/circuit_imprinter/C = circuit
	offstation_security_levels = C.offstation_security_levels

/obj/machinery/rnd/production/circuit_imprinter/offstation
	offstation_security_levels = FALSE
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/offstation
