/datum/design/bsrpd
	name = "Bluespace Rapid Pipe Dispenser"
	desc = "A tool that can construct and deconstruct pipes on the fly."
	id = "bsrpd"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 75000, /datum/material/glass = 37500, /datum/material/bluespace = 1000)
	build_path = /obj/item/pipe_dispenser/bluespace // Skyrat edit
	category = list("Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/computermath
	name = "Problem Computer"
	desc = "Solve math problems. Get them correct, get credits."
	id = "computermath"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 250, /datum/material/glass = 250, /datum/material/plastic = 250)
	build_path = /obj/item/computermath/default
	category = list("Tool Designs")
	departmental_flags =  DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/upgraded_welder
	name = "Upgraded Industrial Welding Tool"
	desc = "An upgraded welder based of the industrial welder."
	id = "upgraded_welder"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron=70, /datum/material/glass=120)
	build_path = /obj/item/weldingtool/hugetank
	category = list("Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING
