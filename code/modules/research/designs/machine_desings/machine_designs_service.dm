///////////////////
///CIV Boards///
///////////////////
/datum/design/board/gibber
	name = "Machine Design (Gibber Board)"
	desc = "The circuit board for a gibber."
	id = "gibber"
	build_path = /obj/item/circuitboard/machine/gibber
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/seed_extractor
	name = "Machine Design (Seed Extractor Board)"
	desc = "The circuit board for a seed extractor."
	id = "seed_extractor"
	build_path = /obj/item/circuitboard/machine/seed_extractor
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/soda_dispenser
	name = "Machine Design (Portable Soda Dispenser Board)"
	desc = "The circuit board for a portable soda dispenser."
	id = "soda_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser/drinks
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE
	category = list ("Misc. Machinery")

/datum/design/board/beer_dispenser
	name = "Machine Design (Portable Booze Dispenser Board)"
	desc = "The circuit board for a portable booze dispenser."
	id = "beer_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser/drinks/beer
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE
	category = list ("Misc. Machinery")

/datum/design/board/plantgenes
	name = "Machine Design (Plant DNA Manipulator Board)"
	desc = "The circuit board for a plant DNA manipulator."
	id = "plantgenes"
	build_path = /obj/item/circuitboard/machine/plantgenes
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/ayyplantgenes
	name = "Machine Design (Alien Plant DNA Manipulator Board)"
	desc = "The circuit board for an advanced plant DNA manipulator, utilizing alien technologies."
	id = "ayyplantgenes"
	build_path = /obj/item/circuitboard/machine/plantgenes/vault
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/deepfryer
	name = "Machine Design (Deep Fryer)"
	desc = "The circuit board for a Deep Fryer."
	id = "deepfryer"
	build_path = /obj/item/circuitboard/machine/deep_fryer
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/dish_drive
	name = "Machine Design (Dish Drive)"
	desc = "The circuit board for a dish drive."
	id = "dish_drive"
	build_path = /obj/item/circuitboard/machine/dish_drive
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/biogenerator
	name = "Machine Design (Biogenerator Board)"
	desc = "The circuit board for a biogenerator."
	id = "biogenerator"
	build_path = /obj/item/circuitboard/machine/biogenerator
	category = list ("Hydroponics Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/hydroponics
	name = "Machine Design (Hydroponics Tray Board)"
	desc = "The circuit board for a hydroponics tray."
	id = "hydro_tray"
	build_path = /obj/item/circuitboard/machine/hydroponics
	category = list ("Hydroponics Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/board/hydroponics/auto
	name = "Machine Design (Automatic Hydroponics Tray Board)"
	desc = "The circuit board for an automatic hydroponics tray. GIVE ME THE PLANT, CAPTAIN."
	id = "autohydrotray"
	build_path = /obj/item/circuitboard/machine/hydroponics/automagic
	category = list ("Hydroponics Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/monkey_recycler
	name = "Machine Design (Monkey Recycler Board)"
	desc = "The circuit board for a monkey recycler."
	id = "monkey_recycler"
	build_path = /obj/item/circuitboard/machine/monkey_recycler
	category = list ("Misc. Machinery")
	departmental_flags =  DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/processor
	name = "Machine Design (Food/Slime Processor Board)"
	desc = "The circuit board for a processing unit. Screwdriver the circuit to switch between food (default) or slime processing."
	id = "processor"
	build_path = /obj/item/circuitboard/machine/processor
	category = list ("Misc. Machinery")
	departmental_flags =  DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_SCIENCE
