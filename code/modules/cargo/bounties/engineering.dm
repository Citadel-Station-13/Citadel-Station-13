/datum/bounty/item/engineering/gas
	name = "Full Tank of Pluoxium"
	description = "CentCom RnD is researching extra compact internals. Ship us a tank full of Pluoxium and you'll be compensated."
	reward = 7500
	wanted_types = list(/obj/item/tank)
	var/moles_required = 20 // A full tank is 28 moles, but CentCom ignores that fact.
	var/gas_type = /datum/gas/pluoxium

/datum/bounty/item/engineering/gas/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/tank/T = O
	if(!T.air_contents.gases[gas_type])
		return FALSE
	return T.air_contents.gases[gas_type] >= moles_required

//datum/bounty/item/engineering/gas/nitryl_tank
//	name = "Full Tank of Nitryl"
//	description = "The non-human staff of Station 88 has been volunteered to test performance enhancing drugs. Ship them a tank full of Nitryl so they can get started."
//	gas_type = /datum/gas/nitryl

/datum/bounty/item/engineering/gas/tritium_tank
	name = "Full Tank of Tritium"
	description = "Station 49 is looking to kickstart their research program. Ship them a tank full of Tritium."
	gas_type = /datum/gas/tritium

/datum/bounty/item/engineering/pacman
	name = "P.A.C.M.A.N.-type portable generator"
	description = "A neighboring station had a problem with their SMES, and now need something to power their communications console. Can you send them a P.AC.M.A.N.?"
	reward = 1500 //2500 for the cargo one
	wanted_types = list(/obj/machinery/power/port_gen/pacman)

/datum/bounty/item/engineering/canisters
	name = "Gas Canisters"
	description = "After a recent debacle in a nearby sector, 10 gas canisters are needed for containing an experimental aerosol before it kills all the local fauna."
	reward = 3000
	required_count = 10 //easy to make
	wanted_types = list(/obj/machinery/portable_atmospherics/canister)

/datum/bounty/item/engineering/microwave
	name = "Microwaves"
	description = "Due to a shortage of microwaves, our chefs are incapable of keeping up with our sheer volume of orders. We need at least three microwaves to keep up with our crew's dietary habits."
	reward = 2000
	required_count = 3
	wanted_types = list(/obj/machinery/microwave)

/datum/bounty/item/engineering/hydroponicstrays
	name = "Hydroponics Tray"
	description = "The garden has become a hot spot of late, they need a few more hydroponics tray to grow more flowers."
	reward = 2500
	required_count = 5
	wanted_types = list(/obj/machinery/hydroponics)

/datum/bounty/item/engineering/rcd
	name = "Spare RCD"
	description = "Construction and repairs to are shuttles are going slowly. As it turns out, we're a little short on RCDs, can you send us a few?"
	reward = 1500
	required_count = 3
	wanted_types = list(/obj/item/construction/rcd)

/datum/bounty/item/engineering/rpd
	name = "Spare RPD"
	description = "Our Atmospheric Technicians are still living in the past, relying on stationary pipe dispensers to produce the pipes necessary to accomplish their strenuous tasks. They could use an upgrade. Could you send us some Rapid Pipe Dispensers?"
	reward = 2500
	required_count = 3
	wanted_types = list(/obj/item/pipe_dispenser)

/datum/bounty/item/engineering/heaters
	name = "Space Heaters"
	description = "The kitchen freezer was left open and now the whole place is frozen solid! We need a few space heaters to warm it back up before anyone gets hungry."
	reward = 3000
	required_count = 5
	wanted_types = list(/obj/machinery/space_heater)

/datum/bounty/item/engineering/arcadetrail
	name = "Orion Trail Arcade Games"
	description = "The staff have nothing to do when off-work. Can you send us some Orion Trail games to play?"
	reward = 2500
	required_count = 5
	wanted_types = list(/obj/machinery/computer/arcade/orion_trail)

/datum/bounty/item/engineering/arcadebattle
	name = "Battle Arcade Games"
	description = "The staff have nothing to do when off-work. Can you send us some Battle Arcade games to play?"
	reward = 2500
	required_count = 5
	wanted_types = list(/obj/machinery/computer/arcade/battle)

/datum/bounty/item/engineering/energy_ball
	name = "Contained Tesla Ball"
	description = "Station 24 is being overrun by hordes of angry Mothpeople. They are requesting the ultimate bug zapper."
	reward = 50000 //requires 14k credits of purchases, not to mention cooperation with engineering/heads of staff to set up inside the cramped shuttle
	wanted_types = list(/obj/singularity/energy_ball)
