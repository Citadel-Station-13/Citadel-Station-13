/datum/techweb_node/mod_basic
	id = "mod"
	starting_node = TRUE
	display_name = "Basic Modular Suits"
	description = "Specialized back mounted power suits with various different modules."
	design_ids = list(
		"mod_shell",
		"mod_helmet",
		"mod_chestplate",
		"mod_gauntlets",
		"mod_boots",
		"mod_plating_standard",
		"mod_paint_kit",
		"mod_storage",
		"mod_welding",
		"mod_mouthhole",
		"mod_flashlight",
	)

/datum/techweb_node/mod_advanced
	id = "mod_advanced"
	display_name = "Advanced Modular Suits"
	description = "More advanced modules, to improve modular suits."
	prereq_ids = list("mod", "robotics")
	design_ids = list(
		"mod_plating_mining",
		"mod_visor_diaghud",
		"mod_gps",
		"mod_reagent_scanner",
		"mod_clamp",
		"mod_drill",
		"mod_orebag",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mod_engineering
	id = "mod_engineering"
	display_name = "Engineering Modular Suits"
	description = "Engineering suits, for powered engineers."
	prereq_ids = list("mod_advanced", "engineering")
	design_ids = list(
		"mod_plating_engineering",
		"mod_visor_meson",
		"mod_t_ray",
		"mod_magboot",
		"mod_tether",
		"mod_constructor",
		"mod_mister_atmos",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mod_advanced_engineering
	id = "mod_advanced_engineering"
	display_name = "Advanced Engineering Modular Suits"
	description = "Advanced Engineering suits, for advanced powered engineers."
	prereq_ids = list("mod_engineering", "adv_engi")
	design_ids = list(
		"mod_plating_atmospheric",
		"mod_jetpack",
		"mod_rad_protection",
		"mod_emp_shield",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3500)

/datum/techweb_node/mod_medical
	id = "mod_medical"
	display_name = "Medical Modular Suits"
	description = "Medical suits for quick rescue purposes."
	prereq_ids = list("mod_advanced", "biotech")
	design_ids = list(
		"mod_plating_medical",
		"mod_visor_medhud",
		"mod_health_analyzer",
		"mod_quick_carry",
		"mod_dna_lock",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mod_advanced_medical
	id = "mod_advanced_medical"
	display_name = "Advanced Medical Modular Suits"
	description = "Advanced medical suits for quicker rescue purposes."
	prereq_ids = list("mod_medical", "adv_biotech")
	design_ids = list(
		"mod_defib",
		"mod_surgicalprocessor",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3500)

/datum/techweb_node/mod_security
	id = "mod_security"
	display_name = "Security Modular Suits"
	description = "Security suits for space crime handling."
	prereq_ids = list("mod_advanced", "sec_basic")
	design_ids = list(
		"mod_plating_security",
		"mod_visor_sechud",
		"mod_stealth",
		"mod_mag_harness",
		"mod_holster",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mod_entertainment
	id = "mod_entertainment"
	display_name = "Entertainment Modular Suits"
	description = "Powered suits for protection against low-humor environments."
	prereq_ids = list("mod_advanced", "clown")
	design_ids = list(
		"mod_plating_cosmohonk",
		"mod_bikehorn",
		"mod_microwave_beam",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/mod_anomaly
	id = "mod_anomaly"
	display_name = "Anomalock Modular Suits"
	description = "Modules for modular suits that require anomaly cores to function."
	prereq_ids = list("mod_advanced", "anomaly_research")
	design_ids = list(
		"mod_antigrav",
		"mod_teleporter",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
