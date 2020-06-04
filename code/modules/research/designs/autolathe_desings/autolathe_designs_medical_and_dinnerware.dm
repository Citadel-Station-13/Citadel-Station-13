///////////////////////////////////
//////////Autolathe Designs ///////
///////////////////////////////////
////////////////
////Dinnerware//
////////////////

/datum/design/kitchen_knife
	name = "Kitchen Knife"
	id = "kitchen_knife"
	build_type = AUTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 12000)
	build_path = /obj/item/kitchen/knife
	category = list("initial","Dinnerware")

/datum/design/fork
	name = "Fork"
	id = "fork"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 80)
	build_path = /obj/item/kitchen/fork
	category = list("initial","Dinnerware")

/datum/design/tray
	name = "Tray"
	id = "tray"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/storage/bag/tray
	category = list("initial","Dinnerware")

/datum/design/bowl
	name = "Bowl"
	id = "bowl"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/glass/bowl
	category = list("initial","Dinnerware")

/datum/design/drinking_glass
	name = "Drinking Glass"
	id = "drinking_glass"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/food/drinks/drinkingglass
	category = list("initial","Dinnerware")

/datum/design/shot_glass
	name = "Shot Glass"
	id = "shot_glass"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 100)
	build_path = /obj/item/reagent_containers/food/drinks/drinkingglass/shotglass
	category = list("initial","Dinnerware")

/datum/design/shaker
	name = "Shaker"
	id = "shaker"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1500)
	build_path = /obj/item/reagent_containers/food/drinks/shaker
	category = list("initial","Dinnerware")

////////////
///Medical//
////////////

/datum/design/scalpel
	name = "Scalpel"
	id = "scalpel"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1000)
	build_path = /obj/item/scalpel
	category = list("initial", "Medical","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/circular_saw
	name = "Circular Saw"
	id = "circular_saw"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000)
	build_path = /obj/item/circular_saw
	category = list("initial", "Medical","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/surgicaldrill
	name = "Surgical Drill"
	id = "surgicaldrill"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000)
	build_path = /obj/item/surgicaldrill
	category = list("initial", "Medical","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/retractor
	name = "Retractor"
	id = "retractor"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 3000)
	build_path = /obj/item/retractor
	category = list("initial", "Medical","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/cautery
	name = "Cautery"
	id = "cautery"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 750)
	build_path = /obj/item/cautery
	category = list("initial", "Medical","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/hemostat
	name = "Hemostat"
	id = "hemostat"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500)
	build_path = /obj/item/hemostat
	category = list("initial", "Medical","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/beaker
	name = "Beaker"
	id = "beaker"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/glass/beaker
	category = list("initial", "Medical","Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/large_beaker
	name = "Large Beaker"
	id = "large_beaker"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/glass = 2500)
	build_path = /obj/item/reagent_containers/glass/beaker/large
	category = list("initial", "Medical","Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/healthanalyzer
	name = "Health Analyzer"
	id = "healthanalyzer"
	build_type = AUTOLATHE | PROTOLATHE | NO_PUBLIC_LATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/healthanalyzer
	category = list("initial", "Medical")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/pillbottle
	name = "Pill Bottle"
	id = "pillbottle"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 20, /datum/material/glass = 100)
	build_path = /obj/item/storage/pill_bottle
	category = list("initial", "Medical","Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/syringe
	name = "Syringe"
	id = "syringe"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 10, /datum/material/glass = 20)
	build_path = /obj/item/reagent_containers/syringe
	category = list("initial", "Medical")

/datum/design/health_sensor
	name = "Health Sensor"
	id = "health_sensor"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 800, /datum/material/glass = 200)
	build_path = /obj/item/assembly/health
	category = list("initial", "Medical")

/datum/design/hypovialsmall
	name = "Hypovial"
	id = "hypovial"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/reagent_containers/glass/bottle/vial/small
	category = list("initial","Medical","Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/hypoviallarge
	name = "Large Hypovial"
	id = "large_hypovial"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 2500)
	build_path = /obj/item/reagent_containers/glass/bottle/vial/large
	category = list("initial","Medical","Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
