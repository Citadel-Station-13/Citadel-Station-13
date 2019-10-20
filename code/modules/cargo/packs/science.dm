
//Reminders-
// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal
// cost = 700- Minimum cost, or infinite points are possible.
//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Science /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/science
	group = "Science"
	crate_type = /obj/structure/closet/crate/science

/datum/supply_pack/science/robotics/mecha_odysseus
	name = "Circuit Crate (Odysseus)"
	desc = "Ever wanted to build your own giant medical robot? Well, now you can! Contains the Odysseus main control board and Odysseus peripherals board. Requires Robotics access to open."
	cost = 2500
	access = ACCESS_ROBOTICS
	contains = list(/obj/item/circuitboard/mecha/odysseus/peripherals,
					/obj/item/circuitboard/mecha/odysseus/main)
	crate_name = "\improper Odysseus circuit crate"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/robotics/mecha_ripley
	name = "Circuit Crate (Ripley APLU)"
	desc = "Rip apart rocks and xenomorphs alike with the Ripley APLU. Contains the Main Ripley control board, as well as the Ripley Peripherals board. Requires Robotics access to open."
	cost = 3000
	access = ACCESS_ROBOTICS
	contains = list(/obj/item/book/manual/ripley_build_and_repair,
					/obj/item/circuitboard/mecha/ripley/main,
					/obj/item/circuitboard/mecha/ripley/peripherals)
	crate_name = "\improper APLU Ripley circuit crate"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/circuitry
	name = "Circuitry Starter Pack Crate"
	desc = "Journey into the mysterious world of Circuitry with this starter pack. Contains a circuit printer, analyzer, debugger and wirer. Power cells not included."
	cost = 1000
	contains = list(/obj/item/integrated_electronics/analyzer,
					/obj/item/integrated_circuit_printer,
					/obj/item/integrated_electronics/debugger,
					/obj/item/integrated_electronics/wirer)
	crate_name = "circuitry starter pack crate"

/datum/supply_pack/science/plasma
	name = "Plasma Assembly Crate"
	desc = "Everything you need to burn something to the ground, this contains three plasma assembly sets. Each set contains a plasma tank, igniter, proximity sensor, and timer! Warranty void if exposed to high temperatures. Requires Toxins access to open."
	cost = 1800
	access = ACCESS_TOX_STORAGE
	contains = list(/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/assembly/igniter,
					/obj/item/assembly/igniter,
					/obj/item/assembly/igniter,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/timer,
					/obj/item/assembly/timer,
					/obj/item/assembly/timer)
	crate_name = "plasma assembly crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/science/robotics
	name = "Robotics Assembly Crate"
	desc = "The tools you need to replace those finicky humans with a loyal robot army! Contains three proximity sensors, two high-powered cells, six flashes, and an electrical toolbox. Requires Robotics access to open."
	cost = 1500
	access = ACCESS_ROBOTICS
	contains = list(/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/storage/toolbox/electrical,
					/obj/item/storage/box/flashes,
					/obj/item/stock_parts/cell/high,
					/obj/item/stock_parts/cell/high)
	crate_name = "robotics assembly crate"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/shieldwalls
	name = "Shield Generator Crate"
	desc = "These high powered Shield Wall Generators are guaranteed to keep any unwanted lifeforms on the outside, where they belong! Contains four shield wall generators. Requires Teleporter access to open."
	cost = 2000
	access = ACCESS_TELEPORTER
	contains = list(/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen)
	crate_name = "shield generators crate"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/tablets
	name = "Tablet Crate"
	desc = "What's a computer? Contains five cargo tablets."
	cost = 5000
	contains = list(/obj/item/modular_computer/tablet/preset/cargo,
					/obj/item/modular_computer/tablet/preset/cargo,
					/obj/item/modular_computer/tablet/preset/cargo,
					/obj/item/modular_computer/tablet/preset/cargo,
					/obj/item/modular_computer/tablet/preset/cargo)
	crate_name = "tablet crate"

/datum/supply_pack/science/transfer_valves
	name = "Tank Transfer Valves Crate"
	desc = "The key ingredient for making a lot of people very angry very fast. Contains two tank transfer valves. Requires RD access to open."
	cost = 6000
	access = ACCESS_RD
	contains = list(/obj/item/transfer_valve,
					/obj/item/transfer_valve)
	crate_name = "tank transfer valves crate"
	crate_type = /obj/structure/closet/crate/secure/science
	dangerous = TRUE

/datum/supply_pack/science/tech_slugs
	name = "Tech Slug Ammo Shells"
	desc = "A new type of shell that is able to be made into a few different dangerous types. Contains two boxes of tech slugs, 14 shells in all."
	cost = 1700
	contains = list(/obj/item/storage/box/techsslug,
					/obj/item/storage/box/techsslug)
	crate_name = "tech slug crate"
