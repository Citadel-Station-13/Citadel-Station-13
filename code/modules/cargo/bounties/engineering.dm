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

/datum/bounty/item/engineering/gas/nitryl_tank
	name = "Full Tank of Nitryl"
	description = "The non-human staff of Station 88 has been volunteered to test performance enhancing drugs. Ship them a tank full of Nitryl so they can get started."
	gas_type = /datum/gas/nitryl

/datum/bounty/item/engineering/gas/tritium_tank
	name = "Full Tank of Tritium"
	description = "Station 49 is looking to kickstart their research program. Ship them a tank full of Tritium."
	gas_type = /datum/gas/tritium

/datum/bounty/item/engineering/pacman
	name = "P.A.C.M.A.N.-type portable generator"
	description = "A neighboring station had a problem with their SMES, and now need something to power their communications console. Can you send them a P.AC.M.A.N.?"
	reward = 3500 //2500 for the cargo one
	wanted_types = list(/obj/machinery/power/port_gen/pacman)

/datum/bounty/item/engineering/canisters
	name = "Gas Canisters"
	description = "After a recent debacle in a nearby sector, 10 gas canisters are needed for containing an experimental aerosol before it kills all the local fauna."
	reward = 5000
	required_count = 10 //easy to make
	wanted_types = list(/obj/machinery/portable_atmospherics/canister)

/datum/bounty/item/engineering/energy_ball
	name = "Contained Tesla Ball"
	description = "Station 24 is being overrun by hordes of angry Mothpeople. They are requesting the ultimate bug zapper."
	reward = 75000 //requires 14k credits of purchases, not to mention cooperation with engineering/heads of staff to set up inside the cramped shuttle
	wanted_types = list(/obj/singularity/energy_ball)
