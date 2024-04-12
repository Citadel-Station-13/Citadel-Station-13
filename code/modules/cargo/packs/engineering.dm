
//Reminders-
// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal
// cost = 700- Minimum cost, or infinite points are possible.
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// Engineering ////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/engineering
	group = "Engineering"
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/engineering/shieldgen
	name = "Anti-breach Shield Projector Crate"
	desc = "Hull breaches again? Say no more with the Nanotrasen Anti-Breach Shield Projector! Uses forcefield technology to keep the air in, and the space out. Contains two shield projectors."
	cost = 2500
	contains = list(/obj/machinery/shieldgen,
					/obj/machinery/shieldgen)
	crate_name = "anti-breach shield projector crate"

/datum/supply_pack/engineering/conveyor
	name = "Conveyor Assembly Crate"
	desc = "Keep production moving along with fifteen conveyor belts. Conveyor switch included. If you have any questions, check out the enclosed instruction book."
	cost = 750
	contains = list(/obj/item/stack/conveyor/fifteen,
					/obj/item/paper/guides/conveyor)
	crate_name = "conveyor assembly crate"

/datum/supply_pack/engineering/engiequipment
	name = "Engineering Gear Crate"
	desc = "Gear up with three toolbelts, high-visibility vests, welding helmets, hardhats, and two pairs of meson goggles!"
	cost = 1500
	contains = list(/obj/item/storage/belt/utility,
					/obj/item/storage/belt/utility,
					/obj/item/storage/belt/utility,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/glasses/meson/engine,
					/obj/item/clothing/glasses/meson/engine)
	crate_name = "engineering gear crate"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engineering/engihardsuit
	name = "Engineering Hardsuit"
	desc = "Polly 'Who stole all the hardsuits!' Well now you can get more hardsuits if needed! NOTE ONE HARDSUIT IS IN THIS CRATE, as well as one air tank and mask!"
	cost = 2250
	access = ACCESS_ENGINE
	contains = list(/obj/item/tank/internals/air,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/suit/space/hardsuit/engine)
	crate_name = "engineering hardsuit"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engineering/atmoshardsuit
	name = "Atmospherics Hardsuit"
	desc = "Too many techs and not enough hardsuits? Time to buy some more! Comes with gas mask and air tank. Ask the CE to open."
	cost = 5000
	access = ACCESS_CE //100% Fire and Bio resistance
	contains = list(/obj/item/tank/internals/air,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/suit/space/hardsuit/engine/atmos)
	crate_name = "atmospherics hardsuit"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engineering/radvoidsuit
	name = "Radiation Voidsuit"
	desc = "The Singulo is loose? Do you need to do a few changes to its containment and don't want to spent the rest of the shift under the shower? Get this Radiation Hardsuit! It protect from radiations and space only."
	cost = 3500
	access = ACCESS_ENGINE
	contains = list(/obj/item/tank/internals/air,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/suit/space/rad,
					/obj/item/clothing/head/helmet/space/rad)
	crate_name = "radiation hardsuit"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engineering/industrialrcd
	name = "Industrial RCD"
	desc = "An industrial RCD in case the station has gone through more then one meteor storm and the CE needs to bring out the somthing a bit more reliable. Does not contain spare ammo for the industrial RCD or any other RCD models."
	cost = 4500
	access = ACCESS_CE
	contains = list(/obj/item/construction/rcd/industrial)
	crate_name = "industrial rcd"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engineering/inducers
	name = "NT-75 Electromagnetic Power Inducers Crate"
	desc = "No rechargers? No problem, with the NT-75 EPI, you can recharge any standard cell-based equipment anytime, anywhere. Contains two Inducers."
	cost = 2300
	contains = list(/obj/item/inducer/sci/supply, /obj/item/inducer/sci/supply)
	crate_name = "inducer crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/pacman
	name = "P.A.C.M.A.N Generator Crate"
	desc = "Engineers can't set up the engine? Not an issue for you, once you get your hands on this P.A.C.M.A.N. Generator! Takes in plasma and spits out sweet sweet energy."
	cost = 2250
	contains = list(/obj/machinery/power/port_gen/pacman)
	crate_name = "PACMAN generator crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/airpump
	name = "Portable Air Pump Crate"
	desc = "We all know you work in a high pressure workplace. Keep it that way with two additional air pumps!"
	cost = 3000
	contains = list(/obj/machinery/portable_atmospherics/pump,
					/obj/machinery/portable_atmospherics/pump)
	crate_name = "portable air pump crate"

/datum/supply_pack/engineering/airscrubber
	name = "Portable Scrubber Crate"
	desc = "Miasma got you down? Plasma in the vents? Freshen up with these two brand-new air scrubbers!"
	cost = 3000
	contains = list(/obj/machinery/portable_atmospherics/scrubber,
					/obj/machinery/portable_atmospherics/scrubber)
	crate_name = "portable scrubber crate"

/datum/supply_pack/engineering/power
	name = "Power Cell Crate"
	desc = "Looking for power overwhelming? Look no further. Contains three high-voltage power cells."
	cost = 1000
	contains = list(/obj/item/stock_parts/cell/high,
					/obj/item/stock_parts/cell/high,
					/obj/item/stock_parts/cell/high)
	crate_name = "power cell crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/shuttle_engine
	name = "Shuttle Engine Crate"
	desc = "Through advanced bluespace-shenanigans, our engineers have managed to fit an entire shuttle engine into one tiny little crate. Requires CE access to open."
	cost = 5000
	access = ACCESS_CE
	contains = list(/obj/structure/shuttle/engine/propulsion/burst/cargo)
	crate_name = "shuttle engine crate"
	crate_type = /obj/structure/closet/crate/secure/engineering

/datum/supply_pack/engineering/tools
	name = "Toolbox Crate"
	desc = "Any robust spaceman is never far from their trusty toolbox. Contains three electrical toolboxes and three mechanical toolboxes."
	contains = list(/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/storage/toolbox/mechanical)
	cost = 1200
	crate_name = "toolbox crate"
	special = TRUE //Department resupply shuttle loan event.

/datum/supply_pack/engineering/bsa
	name = "Bluespace Artillery Parts"
	desc = "The pride of Nanotrasen Naval Command. The legendary Bluespace Artillery Cannon is a devastating feat of human engineering and testament to wartime determination. Highly advanced research is required for proper construction. "
	cost = 15000
	special = TRUE
	contains = list(/obj/item/circuitboard/machine/bsa/front,
					/obj/item/circuitboard/machine/bsa/middle,
					/obj/item/circuitboard/machine/bsa/back,
					/obj/item/circuitboard/computer/bsa_control
					)
	crate_name= "bluespace artillery parts crate"

/datum/supply_pack/engineering/dna_vault
	name = "DNA Vault Parts"
	desc = "Secure the longevity of the current state of civilization within this massive library of scientific knowledge, capable of granting superhuman powers and abilities. Highly advanced research is required for proper construction. Also contains five DNA probes." //C'mon now, it's nae just humans on the station these days
	cost = 12000
	special = TRUE
	contains = list(
					/obj/item/circuitboard/machine/dna_vault,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe
					)
	crate_name= "dna vault parts crate"

/datum/supply_pack/engineering/dna_probes
	name = "DNA Vault Samplers"
	desc = "Contains five DNA probes for use in the DNA vault."
	cost = 3000
	special = TRUE
	contains = list(/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe
					)
	crate_name= "dna samplers crate"

/datum/supply_pack/engineering/shield_sat
	name = "Shield Generator Satellite"
	desc = "Protect the very existence of this station with these Anti-Meteor defenses. Contains three Shield Generator Satellites."
	cost = 4000
	contains = list(
					/obj/machinery/satellite/meteor_shield,
					/obj/machinery/satellite/meteor_shield,
					/obj/machinery/satellite/meteor_shield
					)
	crate_name= "shield sat crate"

/datum/supply_pack/engineering/shield_sat_control
	name = "Shield System Control Board"
	desc = "A control system for the Shield Generator Satellite system."
	cost = 4000
	contains = list(/obj/item/circuitboard/computer/sat_control)
	crate_name= "shield control board crate"
