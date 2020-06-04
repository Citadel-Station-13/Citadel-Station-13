
/////////////////////////engineering tech/////////////////////////
/datum/techweb_node/engineering
	id = "engineering"
	display_name = "Industrial Engineering"
	description = "A refresher course on modern engineering technology."
	prereq_ids = list("base")
	design_ids = list("solarcontrol", "recharger", "powermonitor", "rped", "pacman", "adv_capacitor", "adv_scanning", "emitter", "high_cell", "adv_matter_bin",
	"atmosalerts", "atmos_control", "recycler", "autolathe", "autolathe_secure", "high_micro_laser", "nano_mani", "mesons", "thermomachine", "rad_collector", "tesla_coil", "grounding_rod",
	"apc_control", "power control", "airlock_board", "firelock_board", "airalarm_electronics", "firealarm_electronics", "cell_charger", "stack_console", "stack_machine", "rcd_ammo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 6000)

/datum/techweb_node/adv_engi
	id = "adv_engi"
	display_name = "Advanced Engineering"
	description = "Pushing the boundaries of physics, one chainsaw-fist at a time."
	prereq_ids = list("engineering", "emp_basic")
	design_ids = list("engine_goggles", "magboots", "forcefield_projector", "weldingmask" , "rcd_loaded", "rpd", "tray_goggles_prescription", "engine_goggles_prescription", "mesons_prescription", "rcd_upgrade_frames", "rcd_upgrade_simple_circuits", "rcd_ammo_large")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 4000)

/datum/techweb_node/anomaly
	id = "anomaly_research"
	display_name = "Anomaly Research"
	description = "Unlock the potential of the mysterious anomalies that appear on station."
	prereq_ids = list("adv_engi", "practical_bluespace")
	design_ids = list("reactive_armour", "anomaly_neutralizer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3500)

/datum/techweb_node/high_efficiency
	id = "high_efficiency"
	display_name = "High Efficiency Parts"
	description = "Finely-tooled manufacturing techniques allowing for picometer-perfect precision levels."
	prereq_ids = list("engineering", "datatheory")
	design_ids = list("pico_mani", "super_matter_bin")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/adv_power
	id = "adv_power"
	display_name = "Advanced Power Manipulation"
	description = "How to get more zap."
	prereq_ids = list("engineering")
	design_ids = list("smes", "super_cell", "hyper_cell", "super_capacitor", "superpacman", "mrspacman", "power_turbine", "power_turbine_console", "power_compressor", "circulator", "teg")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/*
/datum/techweb_node/basic_meteor_defense
	id = "basic_meteor_defense"
	display_name = "Meteor Defense Research"
	description = "Unlock the potential of the mysterious of why CC decided to not build these around the station themselves."
	prereq_ids = list("adv_engi", "high_efficiency")
	design_ids = list("meteor_defence", "meteor_console")

/datum/techweb_node/adv_meteor_defense
	id = "adv_meteor_defense"
	display_name = "Meteor Defense Research"
	description = "New and improved coding and lock on tech for meteor defence!"
	prereq_ids = list("basic_meteor_defense", "adv_datatheory", "emp_adv")
	design_ids = list("meteor_disk")
*/
