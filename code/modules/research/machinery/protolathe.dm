/obj/machinery/rnd/production/protolathe
	name = "protolathe"
	desc = "Converts raw materials into useful objects."
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/protolathe
	categories = list(
								"Power Designs",
								"Medical Designs",
								"Bluespace Designs",
								"Stock Parts",
								"Equipment",
								"Tool Designs",
								"Mining Designs",
								"Electronics",
								"Weapons",
								"Ammo",
								"Firing Pins",
								"Computer Parts"
								)
	production_animation = "protolathe_n"
	allowed_buildtypes = PROTOLATHE

/obj/machinery/rnd/production/protolathe/disconnect_console()
	linked_console.linked_lathe = null
	..()

/obj/machinery/rnd/production/protolathe/calculate_efficiency()
	. = ..()
	var/obj/item/circuitboard/machine/protolathe/C = circuit
	offstation_security_levels = C.offstation_security_levels

/obj/machinery/rnd/production/protolathe/offstation
	offstation_security_levels = FALSE
	circuit = /obj/item/circuitboard/machine/protolathe/offstation

/obj/machinery/rnd/production/protolathe/offstation/ghost_cafe
	categories = list(
								"Power Designs",
								"Medical Designs",
								"Bluespace Designs",
								"Stock Parts",
								"Equipment",
								"Tool Designs",
								"Mining Designs",
								"Electronics",
								"Weapons",
								"Ammo",
								"Firing Pins",
								"Computer Parts",
								"Exosuit Modules",
								"Hydroponics Machinery",
								"Misc. Machinery",
								"Computer Parts"
								)
	console_link = FALSE
	requires_console = FALSE
	allowed_buildtypes = PROTOLATHE | IMPRINTER
/obj/machinery/rnd/production/protolathe/offstation/ghost_cafe/Initialize(mapload)
	. = ..()
	host_research = SSresearch.admin_tech

/obj/effect/landmark/ghost_protolathe
	name = "Ghost Cafe Protolathe"
	icon = 'icons/obj/machines/research.dmi'

/obj/effect/landmark/ghost_protolathe/Initialize()
	. = ..()
	new /obj/machinery/rnd/production/protolathe/offstation/ghost_cafe(get_turf(src))
	return INITIALIZE_HINT_QDEL