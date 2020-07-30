/datum/design/bluespacespray
	name = "Bluespace Spray"
	desc = "A bluespace sprayer, may be illegal in some places due to honkers."
	id = "bluespacespray"
	build_type = PROTOLATHE
	materials = list(/datum/material/glass = 2250, /datum/material/plasma = 2250, /datum/material/diamond = 185, /datum/material/bluespace = 185)
	build_path = /obj/item/reagent_containers/spray/bluespace
	category = list("Misc", "Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_SERVICE

/datum/design/cyberimp_toolset_advanced
	name = "Advanced Toolset Arm Implant"
	desc = "A very advanced version of the regular toolset implant, has alien stuff!"
	id = "ci-toolset-adv"
	build_type = PROTOLATHE | MECHFAB
	materials = list (/datum/material/iron = 7500, /datum/material/glass = 4500, /datum/material/silver = 4500)
	construction_time = 200
	build_path = /obj/item/organ/cyberimp/arm/toolset/advanced
	category = list("Misc", "Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cyberimp_surgical_advanced
	name = "Advanced Surgical Arm Implant"
	desc = "A very advanced version of the regular surgical implant, has alien stuff!"
	id = "ci-surgery-adv"
	build_type = PROTOLATHE | MECHFAB
	materials = list (/datum/material/iron = 7500, /datum/material/glass = 4500, /datum/material/silver = 4500)
	construction_time = 200
	build_path = /obj/item/organ/cyberimp/arm/surgery/advanced
	category = list("Misc", "Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
