/datum/export/large
	k_elasticity = 0

/datum/export/large/crate
	cost = 500
	k_elasticity = 0
	unit_name = "crate"
	export_types = list(/obj/structure/closet/crate)
	exclude_types = list(/obj/structure/closet/crate/large, /obj/structure/closet/crate/wooden, /obj/structure/closet/crate/bin)

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
	cost = 140
	unit_name = "wooden crate"
	export_types = list(/obj/structure/closet/crate/wooden)
	exclude_types = list()

/datum/export/large/barrel
	cost = 300 //double the wooden cost of a coffin.
	unit_name = "wooden barrel"
	export_types = list(/obj/structure/fermenting_barrel)

/datum/export/large/crate/coffin
	cost = 150
	unit_name = "coffin"
	export_types = list(/obj/structure/closet/crate/coffin)

/datum/export/large/reagent_dispenser
	cost = 100

/datum/export/large/reagent_dispenser/water
	unit_name = "watertank"
	export_types = list(/obj/structure/reagent_dispensers/watertank)

/datum/export/large/reagent_dispenser/fuel
	unit_name = "fueltank"
	export_types = list(/obj/structure/reagent_dispensers/fueltank)

/datum/export/large/reagent_dispenser/beer
	unit_name = "beer keg"
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
	cost = 2000
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

/datum/export/large/frame
	cost = 20
	unit_name = "structure frame"
	export_types = list(/obj/structure/frame, /obj/structure/table_frame)
	include_subtypes = TRUE

/datum/export/large/pacman
	cost = 125
	unit_name = "pacman"
	export_types = list(/obj/machinery/power/port_gen/pacman)

/datum/export/large/pacman
	cost = 150
	unit_name = "super pacman"
	export_types = list(/obj/machinery/power/port_gen/pacman/super)

/datum/export/large/pacman
	cost = 175
	unit_name = "mrs super pacman"
	export_types = list(/obj/machinery/power/port_gen/pacman/mrs)

/datum/export/large/hydroponics
	cost = 120
	unit_name = "hydroponics tray"
	export_types = list(/obj/machinery/hydroponics)

/datum/export/large/nice_chair
	cost = 12
	unit_name = "Padded Chair"
	export_types = list(/obj/structure/chair/comfy)

/datum/export/large/gas_canister
	cost = 10 //Base cost of canister. You get more for nice gases inside.
	unit_name = "Gas Canister"
	export_types = list(/obj/machinery/portable_atmospherics/canister)

/datum/export/large/gas_canister/get_cost(obj/O)
	var/obj/machinery/portable_atmospherics/canister/C = O
	var/worth = 10
	worth += C.air_contents.get_moles(/datum/gas/bz)*3
	worth += C.air_contents.get_moles(/datum/gas/stimulum)*25
	worth += C.air_contents.get_moles(/datum/gas/hypernoblium)*20
	worth += C.air_contents.get_moles(/datum/gas/miasma)*2
	worth += C.air_contents.get_moles(/datum/gas/tritium)*7
	worth += C.air_contents.get_moles(/datum/gas/pluoxium)*6
	worth += C.air_contents.get_moles(/datum/gas/nitryl)*10
	return worth


//////////////
//Matstatues//
//////////////

/datum/export/large/nukestatue
	cost = 175
	unit_name = "Nuke statue"
	export_types = list(/obj/structure/statue/uranium/nuke)

/datum/export/large/engstatue
	cost = 175
	unit_name = "Engine statue"
	export_types = list(/obj/structure/statue/uranium/eng)

/datum/export/large/plasmastatue
	cost = 720
	unit_name = "Scientist statue"
	export_types = list(/obj/structure/statue/plasma/scientist)

/datum/export/large/hosstatue
	cost = 225
	unit_name = "HoS statue"
	export_types = list(/obj/structure/statue/gold/hos)

/datum/export/large/rdstatue
	cost = 225
	unit_name = "RD statue"
	export_types = list(/obj/structure/statue/gold/rd)

/datum/export/large/hopstatue
	cost = 225
	unit_name = "HoP statue"
	export_types = list(/obj/structure/statue/gold/hop)

/datum/export/large/cmostatue
	cost = 225
	unit_name = "CMO statue"
	export_types = list(/obj/structure/statue/gold/cmo)

/datum/export/large/cestatue
	cost = 225
	unit_name = "CE statue"
	export_types = list(/obj/structure/statue/gold/ce)

/datum/export/large/mdstatue
	cost = 200
	unit_name = "MD statue"
	export_types = list(/obj/structure/statue/silver/md)

/datum/export/large/janitorstatue
	cost = 200
	unit_name = "Janitor statue"
	export_types = list(/obj/structure/statue/silver/janitor)

/datum/export/large/secstatue
	cost = 200
	unit_name = "Sec statue"
	export_types = list(/obj/structure/statue/silver/sec)

/datum/export/large/medborgstatue
	cost = 200
	unit_name = "Medborg statue"
	export_types = list(/obj/structure/statue/silver/medborg)

/datum/export/large/secborgstatue
	cost = 200
	unit_name = "Secborg statue"
	export_types = list(/obj/structure/statue/silver/secborg)

/datum/export/large/capstatue
	cost = 1200
	unit_name = "Captain statue"
	export_types = list(/obj/structure/statue/diamond/captain)

/datum/export/large/aistatue
	cost = 1200
	unit_name = "AI statue"
	export_types = list(/obj/structure/statue/diamond/ai1, /obj/structure/statue/diamond/ai2)

/datum/export/large/clownstatue
	cost = 2750
	unit_name = "Clown statue"
	export_types = list(/obj/structure/statue/bananium/clown)

/datum/export/large/sandstatue
	cost = 90 //Big cash
	unit_name = "sandstone statue"
	export_types = list(/obj/structure/statue/sandstone/assistant)

////////////
//MECHS/////
////////////

/datum/export/large/mech
	include_subtypes = FALSE

/datum/export/large/mech/odysseus
	cost = 7500
	unit_name = "working odysseus"
	export_types = list(/obj/mecha/medical/odysseus)

/datum/export/large/mech/ripley
	cost = 12000
	unit_name = "working ripley"
	export_types = list(/obj/mecha/working/ripley)

/datum/export/large/mech/firefighter
	cost = 14000
	unit_name = "working firefighter"
	export_types = list(/obj/mecha/working/ripley/firefighter)

/datum/export/large/mech/gygax
	cost = 19000
	unit_name = "working gygax"
	export_types = list(/obj/mecha/combat/gygax)

/datum/export/large/mech/durand
	cost = 16000
	unit_name = "working durand"
	export_types = list(/obj/mecha/combat/durand)

/datum/export/large/mech/phazon
	cost = 35000 //Little over half due to needing a core
	unit_name = "working phazon"
	export_types = list(/obj/mecha/combat/phazon)

/datum/export/large/mech/marauder
	cost = 15000 //Still a Combat class mech - CC tech as well! 150% "normal" boundy price.
	unit_name = "working marauder"
	export_types = list(/obj/mecha/combat/marauder)

/datum/export/large/mech/deathripley
	cost = 18500 //Still a "Combat class" mech - Illegal tech as well! 165% "normal" boundy price.
	unit_name = "working illegally modified"
	export_types = list(/obj/mecha/working/ripley/deathripley)

/datum/export/large/mech/gygaxdark
	cost = 28500 //Still a Combat class mech - Illegal tech as well! 150% "normal" boundy price.
	unit_name = "working illegally modified gygax"
	export_types = list(/obj/mecha/combat/gygax/dark)

/datum/export/large/mech/oldripley
	cost = 6250 //old mech - Scrap metal ! 50% "normal" boundy price.
	unit_name = "working miner ripley"
	export_types = list(/obj/mecha/working/ripley/mining)

/datum/export/large/mech/honk
	cost = 16000 //Still a "Combat class" mech - Comats bordem honk!
	unit_name = "working honker"
	export_types = list(/obj/mecha/combat/honker)

/datum/export/large/mech/reticence
	cost = 16000 //Still a "Combat class" mech - Has cloking and lethal weaponds.
	unit_name = "working reticence"
	export_types = list(/obj/mecha/combat/reticence)

/datum/export/large/mech/seraph
	cost = 25500 //Still a Combat class mech - CC tech as well! 150% "normal" boundy price.
	unit_name = "working seraph"
	export_types = list(/obj/mecha/combat/marauder/seraph)

/datum/export/large/mech/mauler
	cost = 25000 //Still a Combat class mech - CC lethal weaponds.
	unit_name = "working legally modified marauder"
	export_types = list(/obj/mecha/combat/marauder/mauler)
