// Circuit boards, spare parts, etc.

/datum/export/solar/assembly
	cost = 50
	unit_name = "solar panel assembly"
	export_types = list(/obj/item/solar_assembly)

/datum/export/solar/tracker_board
	cost = 10
	unit_name = "solar tracker board"
	export_types = list(/obj/item/electronics/tracker)

/datum/export/solar/control_board
	cost = 15
	unit_name = "solar panel control board"
	export_types = list(/obj/item/circuitboard/computer/solar_control)
	include_subtypes = FALSE

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
	unit_name = "smes board"
	export_types = list(/obj/item/circuitboard/machine/smes)
	include_subtypes = FALSE

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

/datum/export/cellupgraded
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
	cost = 200
	unit_name = "slime power cell"
	export_types = list(/obj/item/stock_parts/cell/high/slime)

/datum/export/cellyellowhyper
	cost = 1200 //Takes a lot to make and is really good
	unit_name = "hyper slime power cell"
	export_types = list(/obj/item/stock_parts/cell/high/slime/hypercharged)

//Glass working stuff

/datum/export/glasswork_dish
	cost = 300
	unit_name = "small glass dish"
	export_types = list(/obj/item/reagent_containers/glass/beaker/glass_dish)
	include_subtypes = FALSE

/datum/export/glasswork_lens
	cost = 1800
	unit_name = "small glass lens"
	export_types = list(/obj/item/lens)

/datum/export/glasswork_spouty
	cost = 1200
	unit_name = "flask with spout"
	export_types = list(/obj/item/reagent_containers/glass/beaker/flask/spouty)
	include_subtypes = FALSE

/datum/export/glasswork_smallflask
	cost = 600
	unit_name = "small flask"
	export_types = list(/obj/item/reagent_containers/glass/beaker/flask)
	include_subtypes = FALSE

/datum/export/glasswork_largeflask
	cost = 1000
	unit_name = "large flask"
	export_types = list(/obj/item/reagent_containers/glass/beaker/flask/large)
	include_subtypes = FALSE
