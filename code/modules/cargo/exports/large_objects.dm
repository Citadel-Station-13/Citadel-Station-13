/datum/export/large/crate
	cost = 500
	k_elasticity = 0
	unit_name = "crate"
	export_types = list(/obj/structure/closet/crate)
	exclude_types = list(/obj/structure/closet/crate/large, /obj/structure/closet/crate/wooden)

/datum/export/large/crate/total_printout(datum/export_report/ex, notes = TRUE) // That's why a goddamn metal crate costs that much.
	. = ..()
	if(. && notes)
		. += " Thanks for participating in Nanotrasen Crates Recycling Program."

/datum/export/large/crate/wooden
	cost = 100
	unit_name = "large wooden crate"
	export_types = list(/obj/structure/closet/crate/large)
	exclude_types = list()

/datum/export/large/crate/wooden/ore
	unit_name = "ore box"
	export_types = list(/obj/structure/ore_box)

/datum/export/large/crate/wood
	cost = 240
	unit_name = "wooden crate"
	export_types = list(/obj/structure/closet/crate/wooden)
	exclude_types = list()

/datum/export/large/crate/coffin
	cost = 250//50 wooden crates cost 2000 points, and you can make 10 coffins in seconds with those planks. Each coffin selling for 250 means you can make a net gain of 500 points for wasting your time making coffins.
	unit_name = "coffin"
	export_types = list(/obj/structure/closet/crate/coffin)

/datum/export/large/reagent_dispenser
	cost = 100 // +0-400 depending on amount of reagents left
	var/contents_cost = 400

/datum/export/large/reagent_dispenser/get_cost(obj/O)
	var/obj/structure/reagent_dispensers/D = O
	var/ratio = D.reagents.total_volume / D.reagents.maximum_volume

	return ..() + round(contents_cost * ratio)

/datum/export/large/reagent_dispenser/water
	unit_name = "watertank"
	export_types = list(/obj/structure/reagent_dispensers/watertank)
	contents_cost = 200

/datum/export/large/reagent_dispenser/fuel
	unit_name = "fueltank"
	export_types = list(/obj/structure/reagent_dispensers/fueltank)

/datum/export/large/reagent_dispenser/beer
	unit_name = "beer keg"
	contents_cost = 700
	export_types = list(/obj/structure/reagent_dispensers/beerkeg)

/datum/export/large/pipedispenser
	cost = 500
	unit_name = "pipe dispenser"
	export_types = list(/obj/machinery/pipedispenser)

/datum/export/large/emitter
	cost = 550
	unit_name = "emitter"
	export_types = list(/obj/machinery/power/emitter)

/datum/export/large/field_generator
	cost = 550
	unit_name = "field generator"
	export_types = list(/obj/machinery/field/generator)

/datum/export/large/collector
	cost = 400
	unit_name = "radiation collector"
	export_types = list(/obj/machinery/power/rad_collector)

/datum/export/large/tesla_coil
	cost = 450
	unit_name = "tesla coil"
	export_types = list(/obj/machinery/power/tesla_coil)

/datum/export/large/pa
	cost = 350
	unit_name = "particle accelerator part"
	export_types = list(/obj/structure/particle_accelerator)

/datum/export/large/pa/controls
	cost = 500
	unit_name = "particle accelerator control console"
	export_types = list(/obj/machinery/particle_accelerator/control_box)

/datum/export/large/supermatter
	cost = 8000
	unit_name = "supermatter shard"
	export_types = list(/obj/machinery/power/supermatter_crystal/shard)

/datum/export/large/grounding_rod
	cost = 350
	unit_name = "grounding rod"
	export_types = list(/obj/machinery/power/grounding_rod)

/datum/export/large/tesla_gen
	cost = 4000
	unit_name = "energy ball generator"
	export_types = list(/obj/machinery/the_singularitygen/tesla)

/datum/export/large/singulo_gen
	cost = 4000
	unit_name = "gravitational singularity generator"
	export_types = list(/obj/machinery/the_singularitygen)
	include_subtypes = FALSE

/datum/export/large/am_control_unit
	cost = 4000
	unit_name = "antimatter control unit"
	export_types = list(/obj/machinery/power/am_control_unit)

/datum/export/large/am_shielding_container
	cost = 150
	unit_name = "packaged antimatter reactor section"
	export_types = list(/obj/item/am_shielding_container)

/datum/export/large/iv
	cost = 50
	unit_name = "iv drip"
	export_types = list(/obj/machinery/iv_drip)

/datum/export/large/barrier
	cost = 25
	unit_name = "security barrier"
	export_types = list(/obj/item/grenade/barrier, /obj/structure/barricade/security)

/datum/export/large/gas_canister
	cost = 10 //Base cost of canister. You get more for nice gases inside.
	unit_name = "Gas Canister"
	export_types = list(/obj/machinery/portable_atmospherics/canister)
/datum/export/large/gas_canister/get_cost(obj/O)
	var/obj/machinery/portable_atmospherics/canister/C = O
	var/worth = 10
	var/gases = C.air_contents.gases

	worth += gases[/datum/gas/bz]*4	
	worth += gases[/datum/gas/stimulum]*25
	worth += gases[/datum/gas/hypernoblium]*1000
	worth += gases[/datum/gas/miasma]*15
	worth += gases[/datum/gas/tritium]*7
	worth += gases[/datum/gas/pluoxium]*6
	worth += gases[/datum/gas/nitryl]*30
	return worth

/datum/export/large/odysseus
	cost = 5500
	unit_name = "working odysseus"
	export_types = list(/obj/mecha/medical/odysseus)
	include_subtypes = FALSE

/datum/export/large/ripley
	cost = 6500
	unit_name = "working ripley"
	export_types = list(/obj/mecha/working/ripley)
	include_subtypes = FALSE

/datum/export/large/firefighter
	cost = 9000
	unit_name = "working firefighter"
	export_types = list(/obj/mecha/working/ripley/firefighter)
	include_subtypes = FALSE

/datum/export/large/gygax
	cost = 19000
	unit_name = "working gygax"
	export_types = list(/obj/mecha/combat/gygax)
	include_subtypes = FALSE

/datum/export/large/durand
	cost = 10000
	unit_name = "working durand"
	export_types = list(/obj/mecha/combat/durand)
	include_subtypes = FALSE

/datum/export/large/phazon
	cost = 25000 //Little over half do to needing a core
	unit_name = "working phazon"
	export_types = list(/obj/mecha/combat/phazon)
	include_subtypes = FALSE

/datum/export/large/marauder
	cost = 15000 //Still a Combat class mech - CC tech as well! 150% "normal" boundy price.
	unit_name = "working marauder"
	export_types = list(/obj/mecha/combat/marauder)
	include_subtypes = FALSE

/datum/export/large/deathripley
	cost = 8500 //Still a "Combat class" mech - Illegal tech as well! 165% "normal" boundy price.
	unit_name = "working illegally modified"
	export_types = list(/obj/mecha/working/ripley/deathripley)
	include_subtypes = FALSE

/datum/export/large/gygaxdark
	cost = 28500 //Still a Combat class mech - Illegal tech as well! 150% "normal" boundy price.
	unit_name = "working illegally modified gygax"
	export_types = list(/obj/mecha/combat/gygax/dark)
	include_subtypes = FALSE

/datum/export/large/oldripley
	cost = 6250 //old mech - Scrap metal ! 50% "normal" boundy price.
	unit_name = "working miner ripley"
	export_types = list(/obj/mecha/working/ripley/mining)
	include_subtypes = FALSE

/datum/export/large/honk
	cost = 12000 //Still a "Combat class" mech - Comats bordem honk!
	unit_name = "working honker"
	export_types = list(/obj/mecha/combat/honker)
	include_subtypes = FALSE

/datum/export/large/reticence
	cost = 12000 //Still a "Combat class" mech - Has cloking and lethal weaponds.
	unit_name = "working reticence"
	export_types = list(/obj/mecha/combat/reticence)
	include_subtypes = FALSE

/datum/export/large/seraph
	cost = 25500 //Still a Combat class mech - CC tech as well! 150% "normal" boundy price.
	unit_name = "working seraph"
	export_types = list(/obj/mecha/combat/marauder/seraph)
	include_subtypes = FALSE

/datum/export/large/mauler
	cost = 12000 //Still a Combat class mech - CC lethal weaponds.
	unit_name = "working legally modified marauder"
	export_types = list(/obj/mecha/combat/marauder/mauler)
	include_subtypes = FALSE
