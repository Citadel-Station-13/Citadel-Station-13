//MODsuit construction

/datum/design/mod_shell
	name = "MOD Shell"
	desc = "A 'Nakamura Engineering' designed shell for a Modular Suit."
	id = "mod_shell"
	build_type = MECHFAB
	materials = list(/datum/material/iron = 10000, /datum/material/plasma = 5000)
	construction_time = 25 SECONDS
	build_path = /obj/item/mod/construction/shell
	category = list("MODsuit Chassis")

/datum/design/mod_helmet
	name = "MOD Helmet"
	desc = "A 'Nakamura Engineering' designed helmet for a Modular Suit."
	id = "mod_helmet"
	build_type = MECHFAB
	materials = list(/datum/material/iron = 5000)
	construction_time = 10 SECONDS
	build_path = /obj/item/mod/construction/helmet
	category = list("MODsuit Chassis")

/datum/design/mod_chestplate
	name = "MOD Chestplate"
	desc = "A 'Nakamura Engineering' designed chestplate for a Modular Suit."
	id = "mod_chestplate"
	build_type = MECHFAB
	materials = list(/datum/material/iron = 5000)
	construction_time = 10 SECONDS
	build_path = /obj/item/mod/construction/chestplate
	category = list("MODsuit Chassis")

/datum/design/mod_gauntlets
	name = "MOD Gauntlets"
	desc = "'Nakamura Engineering' designed gauntlets for a Modular Suit."
	id = "mod_gauntlets"
	build_type = MECHFAB
	materials = list(/datum/material/iron = 5000)
	construction_time = 10 SECONDS
	build_path = /obj/item/mod/construction/gauntlets
	category = list("MODsuit Chassis")

/datum/design/mod_boots
	name = "MOD Boots"
	desc = "'Nakamura Engineering' designed boots for a Modular Suit."
	id = "mod_boots"
	build_type = MECHFAB
	materials = list(/datum/material/iron = 5000)
	construction_time = 10 SECONDS
	build_path = /obj/item/mod/construction/boots
	category = list("MODsuit Chassis")

/datum/design/mod_plating
	name = "MOD External Plating"
	desc = "External plating for a MODsuit."
	id = "mod_plating_standard"
	build_type = PROTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 3000, /datum/material/plasma = 1000)
	construction_time = 15 SECONDS
	build_path = /obj/item/mod/construction/armor
	category = list("MODsuit Chassis", "MODsuit Designs")
	departmental_flags = DEPARTMENTAL_FLAG_ALL
	research_icon = 'icons/obj/clothing/modsuit/mod_construction.dmi'
	research_icon_state = "standard-plating"

/datum/design/mod_plating/New()
	. = ..()
	var/obj/item/mod/construction/armor/armor_type = build_path
	var/datum/mod_theme/theme = GLOB.mod_themes[initial(armor_type.theme)]
	desc = "External plating for a MODsuit. [theme.desc]"

/datum/design/mod_plating/engineering
	name = "MOD Engineering Plating"
	id = "mod_plating_engineering"
	build_path = /obj/item/mod/construction/armor/engineering
	materials = list(/datum/material/iron = 6000, /datum/material/gold = 2000, /datum/material/glass = 1000, /datum/material/plasma = 1000)
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING
	research_icon_state = "engineering-plating"

/datum/design/mod_plating/atmospheric
	name = "MOD Atmospheric Plating"
	id = "mod_plating_atmospheric"
	build_path = /obj/item/mod/construction/armor/atmospheric
	materials = list(/datum/material/iron = 6000, /datum/material/titanium = 2000, /datum/material/glass = 1000, /datum/material/plasma = 1000)
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING
	research_icon_state = "atmospheric-plating"

/datum/design/mod_plating/mining
	name = "MOD Mining Plating"
	id = "mod_plating_mining"
	build_path = /obj/item/mod/construction/armor/mining
	materials = list(/datum/material/iron = 6000, /datum/material/titanium = 2000, /datum/material/glass = 1000, /datum/material/plasma = 1000)
	departmental_flags = DEPARTMENTAL_FLAG_CARGO
	research_icon_state = "mining-plating"

/datum/design/mod_plating/medical
	name = "MOD Medical Plating"
	id = "mod_plating_medical"
	build_path = /obj/item/mod/construction/armor/medical
	materials = list(/datum/material/iron = 6000, /datum/material/silver = 2000, /datum/material/glass = 1000, /datum/material/plasma = 1000)
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	research_icon_state = "medical-plating"

/datum/design/mod_plating/security
	name = "MOD Security Plating"
	id = "mod_plating_security"
	build_path = /obj/item/mod/construction/armor/security
	materials = list(/datum/material/iron = 6000, /datum/material/uranium = 2000, /datum/material/glass = 1000, /datum/material/plasma = 1000)
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
	research_icon_state = "security-plating"

/datum/design/mod_plating/cosmohonk
	name = "MOD Cosmohonk Plating"
	id = "mod_plating_cosmohonk"
	build_path = /obj/item/mod/construction/armor/cosmohonk
	materials = list(/datum/material/iron = 6000, /datum/material/bananium = 2000, /datum/material/glass = 1000, /datum/material/plasma = 1000)
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE
	research_icon_state = "cosmohonk-plating"

/datum/design/mod_paint_kit
	name = "MOD Paint Kit"
	desc = "A paint kit for Modular Suits."
	id = "mod_paint_kit"
	build_type = MECHFAB
	materials = list(/datum/material/iron = 1000, /datum/material/plastic = 500)
	construction_time = 5 SECONDS
	build_path = /obj/item/mod/paint
	category = list("MODsuit Modules", "MODsuit Designs")

//MODsuit modules

/datum/design/module
	name = "MOD Module"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 1 SECONDS
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 1000)
	build_path = /obj/item/mod/module
	category = list("MODsuit Modules", "MODsuit Designs")
	departmental_flags = DEPARTMENTAL_FLAG_ALL

/datum/design/module/New()
	. = ..()
	var/obj/item/mod/module/module = build_path
	desc = "[initial(module.desc)] It uses [initial(module.complexity)] complexity."

/datum/design/module/mod_storage
	name = "Storage Module"
	id = "mod_storage"
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 500)
	build_path = /obj/item/mod/module/storage

/datum/design/module/mod_visor_medhud
	name = "Medical Visor Module"
	id = "mod_visor_medhud"
	materials = list(/datum/material/silver = 500, /datum/material/glass = 1000)
	build_path = /obj/item/mod/module/visor/medhud
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/module/mod_visor_diaghud
	name = "Diagnostic Visor Module"
	id = "mod_visor_diaghud"
	materials = list(/datum/material/gold = 500, /datum/material/glass = 1000)
	build_path = /obj/item/mod/module/visor/diaghud
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/module/mod_visor_sechud
	name = "Security Visor Module"
	id = "mod_visor_sechud"
	materials = list(/datum/material/titanium = 500, /datum/material/glass = 1000)
	build_path = /obj/item/mod/module/visor/sechud
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/module/mod_visor_meson
	name = "Meson Visor Module"
	id = "mod_visor_meson"
	materials = list(/datum/material/uranium = 500, /datum/material/glass = 1000)
	build_path = /obj/item/mod/module/visor/meson
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/module/mod_visor_welding
	name = "Welding Protection Module"
	id = "mod_welding"
	materials = list(/datum/material/iron = 500, /datum/material/glass = 1000)
	build_path = /obj/item/mod/module/welding
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/module/mod_t_ray
	name = "T-Ray Scanner Module"
	id = "mod_t_ray"
	materials = list(/datum/material/iron = 500, /datum/material/glass = 1000)
	build_path = /obj/item/mod/module/t_ray
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/module/mod_health_analyzer
	name = "Health Analyzer Module"
	id = "mod_health_analyzer"
	materials = list(/datum/material/iron = 500, /datum/material/glass = 1000)
	build_path = /obj/item/mod/module/health_analyzer
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/module/mod_stealth
	name = "Cloak Module"
	id = "mod_stealth"
	materials = list(/datum/material/iron = 1000, /datum/material/bluespace = 500)
	build_path = /obj/item/mod/module/stealth
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/module/mod_jetpack
	name = "Ion Jetpack Module"
	id = "mod_jetpack"
	materials = list(/datum/material/iron = 1500, /datum/material/plasma = 1000)
	build_path = /obj/item/mod/module/jetpack
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/module/mod_magboot
	name = "Magnetic Stabilizator Module"
	id = "mod_magboot"
	materials = list(/datum/material/iron = 1000, /datum/material/gold = 500)
	build_path = /obj/item/mod/module/magboot
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/module/mod_mag_harness
	name = "Magnetic Harness Module"
	id = "mod_mag_harness"
	materials = list(/datum/material/iron = 1500, /datum/material/silver = 500)
	build_path = /obj/item/mod/module/magnetic_harness
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/module/mod_tether
	name = "Emergency Tether Module"
	id = "mod_tether"
	materials = list(/datum/material/iron = 1000, /datum/material/silver = 500)
	build_path = /obj/item/mod/module/tether
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/module/mod_mouthhole
	name = "Eating Apparatus Module"
	id = "mod_mouthhole"
	materials = list(/datum/material/iron = 1500)
	build_path = /obj/item/mod/module/mouthhole

/datum/design/module/mod_rad_protection
	name = "Radiation Protection Module"
	id = "mod_rad_protection"
	materials = list(/datum/material/iron = 1000, /datum/material/uranium = 1000)
	build_path = /obj/item/mod/module/rad_protection
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/module/mod_emp_shield
	name = "EMP Shield Module"
	id = "mod_emp_shield"
	materials = list(/datum/material/iron = 1000, /datum/material/plasma = 1000)
	build_path = /obj/item/mod/module/emp_shield
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/module/mod_flashlight
	name = "Flashlight Module"
	id = "mod_flashlight"
	materials = list(/datum/material/iron = 500, /datum/material/glass = 1000)
	build_path = /obj/item/mod/module/flashlight

/datum/design/module/mod_reagent_scanner
	name = "Reagent Scanner Module"
	id = "mod_reagent_scanner"
	materials = list(/datum/material/glass = 1000)
	build_path = /obj/item/mod/module/reagent_scanner
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/module/mod_gps
	name = "Internal GPS Module"
	id = "mod_gps"
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/mod/module/gps
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO

/datum/design/module/mod_constructor
	name = "Constructor Module"
	id = "mod_constructor"
	materials = list(/datum/material/iron = 1000, /datum/material/titanium = 500)
	build_path = /obj/item/mod/module/constructor
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/module/mod_quick_carry
	name = "Quick Carry Module"
	id = "mod_quick_carry"
	materials = list(/datum/material/iron = 1000, /datum/material/titanium = 500)
	build_path = /obj/item/mod/module/quick_carry
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/module/mod_bikehorn
	name = "Bike Horn Module"
	id = "mod_bikehorn"
	materials = list(/datum/material/plastic = 500, /datum/material/iron = 500)
	build_path = /obj/item/mod/module/bikehorn
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/module/mod_microwave_beam
	name = "Microwave Beam Module"
	id = "mod_microwave_beam"
	materials = list(/datum/material/iron = 1000, /datum/material/uranium = 500)
	build_path = /obj/item/mod/module/microwave_beam
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/module/mod_clamp
	name = "Crate Clamp Module"
	id = "mod_clamp"
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/mod/module/clamp
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/module/mod_drill
	name = "Drill Module"
	id = "mod_drill"
	materials = list(/datum/material/silver = 1000, /datum/material/iron = 2000)
	build_path = /obj/item/mod/module/drill
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/module/mod_orebag
	name = "Ore Bag Module"
	id = "mod_orebag"
	materials = list(/datum/material/iron = 1500)
	build_path = /obj/item/mod/module/orebag
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/module/mod_dna_lock
	name = "DNA Lock Module"
	id = "mod_dna_lock"
	materials = list(/datum/material/diamond = 500, /datum/material/glass = 1000)
	build_path = /obj/item/mod/module/dna_lock

/datum/design/module/mister_atmos
	name = "Resin Mister Module"
	id = "mod_mister_atmos"
	materials = list(/datum/material/glass = 1000, /datum/material/titanium = 1500)
	build_path = /obj/item/mod/module/mister/atmos
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/module/mod_holster
	name = "Holster Module"
	id = "mod_holster"
	materials = list(/datum/material/iron = 1500, /datum/material/glass = 500)
	build_path = /obj/item/mod/module/holster
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/module/surgicalprocessor
	name = "Surgical Processor Module"
	id = "mod_surgicalprocessor"
	materials = list(/datum/material/titanium = 250, /datum/material/glass = 1000, /datum/material/silver = 1500)
	build_path = /obj/item/mod/module/surgical_processor
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/module/defibrillator
	name = "Defibrillator Module"
	id = "mod_defib"
	materials = list(/datum/material/titanium = 250, /datum/material/diamond = 1000, /datum/material/silver = 1500)
	build_path = /obj/item/mod/module/defibrillator
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

//MODsuit anomalock modules
/datum/design/module/mod_antigrav
	name = "Anti-Gravity Module"
	id = "mod_antigrav"
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 2000, /datum/material/uranium = 2000)
	build_path = /obj/item/mod/module/anomaly_locked/antigrav
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/module/mod_teleporter
	name = "Teleporter Module"
	id = "mod_teleporter"
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 2000, /datum/material/bluespace = 2000)
	build_path = /obj/item/mod/module/anomaly_locked/teleporter
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE
