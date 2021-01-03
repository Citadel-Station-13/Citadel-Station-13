/obj/machinery/rnd/production/protolathe/department/autobottler //We want to link with Rnd
	name = "auto bottler"
	desc = "Takes glass, metal and booze to make exports."
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/autobottler
	categories = list(
								"Wines",
								"Beers",
								"Brands",
								"Storage",
								)
	production_animation = "protolathe_n"
	allowed_buildtypes = AUTOBOTTLER

//Brands - This is just export verson of the booze bottles
//Storge - Just the bottles not booze inside
//Wines - Holds wines later made by Sci nodes
//Beers - Holds beers later made by Sci nodes
