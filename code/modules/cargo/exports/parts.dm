// Circuit boards, spare parts, etc.

/datum/export/solar/assembly
	cost = 50
	unit_name = "solar panel assembly"
	export_types = list(/obj/item/solar_assembly)

/datum/export/solar/tracker_board
	cost = 30
	unit_name = "solar tracker board"
	export_types = list(/obj/item/electronics/tracker)

/datum/export/solar/control_board
	cost = 75
	unit_name = "solar panel control board"
	export_types = list(/obj/item/circuitboard/computer/solar_control)

/datum/export/swarmer
	cost = 500
	unit_name = "deactivated alien deconstruction drone"
	export_types = list(/obj/item/deactivated_swarmer)

//Board

/datum/export/board
	cost = 5
	unit_name = "circuit board"
	export_types = list(/obj/item/circuitboard)
	include_subtypes = TRUE

/datum/export/board/SMES
	cost = 20
	k_elasticity = 1/2 //Only a few
	unit_name = "smes board"
	export_types = list(/obj/item/circuitboard/machine/smes)

//Stock Parts

/datum/export/subspace
	cost = 3
	unit_name = "subspace part"
	export_types = list(/obj/item/stock_parts/subspace)
	include_subtypes = TRUE

/datum/export/t1
	cost = 1
	unit_name = "basic stock part"
	export_types = list(/obj/item/stock_parts/capacitor, /obj/item/stock_parts/scanning_module, /obj/item/stock_parts/manipulator, /obj/item/stock_parts/micro_laser, /obj/item/stock_parts/matter_bin)

/datum/export/t2
	cost = 2
	unit_name = "upgraded stock part"
	export_types = list(/obj/item/stock_parts/capacitor/adv, /obj/item/stock_parts/scanning_module/adv, /obj/item/stock_parts/manipulator/nano, /obj/item/stock_parts/micro_laser/high, /obj/item/stock_parts/matter_bin/adv)

/datum/export/t3
	cost = 3
	unit_name = "advanced stock part"
	export_types = list(/obj/item/stock_parts/capacitor/super, /obj/item/stock_parts/scanning_module/phasic, /obj/item/stock_parts/manipulator/pico, /obj/item/stock_parts/micro_laser/ultra, /obj/item/stock_parts/matter_bin/super)

/datum/export/t4
	cost = 4
	unit_name = "blue space stock part"
	export_types = list(/obj/item/stock_parts/capacitor/quadratic, /obj/item/stock_parts/scanning_module/triphasic, /obj/item/stock_parts/manipulator/femto, /obj/item/stock_parts/micro_laser/quadultra, /obj/item/stock_parts/matter_bin/bluespace)

//Cells

/datum/export/cell
	cost = 5
	unit_name = "power cell"
	export_types = list(/obj/item/stock_parts/cell)
	include_subtypes = TRUE

/datum/export/cell
	cost = 10
	unit_name = "upgraded power cell"
	export_types = list(/obj/item/stock_parts/cell/upgraded, /obj/item/stock_parts/cell/upgraded/plus)

/datum/export/cellhigh
	cost = 15
	unit_name = "high power cell"
	export_types = list(/obj/item/stock_parts/cell/high, /obj/item/stock_parts/cell/high/plus)

/datum/export/cellhyper
	cost = 20
	unit_name = "super-capacity power cell"
	export_types = list(/obj/item/stock_parts/cell/super, /obj/item/stock_parts/cell/hyper)

/datum/export/cellbs
	cost = 25
	unit_name = "bluespace power cell"
	export_types = list(/obj/item/stock_parts/cell/bluespace)

/datum/export/cellyellow
	cost = 40
	unit_name = "slime power cell"
	export_types = list(/obj/item/stock_parts/cell/high/slime)

/datum/export/cellyellowhyper
	cost = 120 //Takes a lot to make and is really good
	unit_name = "hyper slime power cell"
	export_types = list(/obj/item/stock_parts/cell/high/slime/hypercharged)