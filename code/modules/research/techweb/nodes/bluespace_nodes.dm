
/////////////////////////Bluespace tech/////////////////////////
/datum/techweb_node/bluespace_basic //Bluespace-memery
	id = "bluespace_basic"
	display_name = "Basic Bluespace Theory"
	description = "Basic studies into the mysterious alternate dimension known as bluespace."
	prereq_ids = list("base", "datatheory")
	design_ids = list("beacon", "xenobioconsole", "telesci_gps", "xenobio_monkeys")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/practical_bluespace
	id = "practical_bluespace"
	display_name = "Applied Bluespace Research"
	description = "Using bluespace to make things faster and better."
	prereq_ids = list("bluespace_basic", "engineering")
	design_ids = list("bs_rped","biobag_holding","minerbag_holding", "bluespacebeaker", "bluespacesyringe", "phasic_scanning", "bluespacesmartdart", "xenobio_slimebasic", "bluespace_tray")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/adv_bluespace
	id = "adv_bluespace"
	display_name = "Advanced Bluespace Research"
	description = "Deeper understanding of how the Bluespace dimension works"
	prereq_ids = list("practical_bluespace", "high_efficiency")
	design_ids = list("bluespace_matter_bin", "femto_mani", "triphasic_scanning", "bluespace_crystal", "xenobio_slimeadv")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

/datum/techweb_node/emp_super
	id = "emp_super"
	display_name = "Quantum Electromagnetic Technology"
	description = "Even better electromagnetic technology."
	prereq_ids = list("emp_adv", "adv_bluespace") // why should the rest of T4 be locked but not this node? grmblgrmbl
	design_ids = list("quadultra_micro_laser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/datum/techweb_node/bluespace_power
	id = "bluespace_power"
	display_name = "Bluespace Power Technology"
	description = "Even more powerful.. power!"
	prereq_ids = list("adv_power", "adv_bluespace")
	design_ids = list("bluespace_cell", "quadratic_capacitor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/bluespace_holding
	id = "bluespace_holding"
	display_name = "Bluespace Pockets"
	description = "Studies into the mysterious alternate dimension known as bluespace and how to place items in the threads of reality."
	prereq_ids = list("adv_power", "adv_bluespace", "adv_biotech", "adv_plasma")
	design_ids = list("bluespacebodybag","bag_holding", "bluespace_pod", "borg_upgrade_trashofholding", "blutrash", "satchel_holding", "bsblood_bag", "duffelbag_holding")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5500)

/datum/techweb_node/bluespace_portal
	id = "bluespace_portal"
	display_name = "Bluespace Portals"
	description = "Allows for Bluespace Tech to be used tandem with Wormhole tech."
	prereq_ids = list("adv_weaponry", "adv_bluespace")
	design_ids = list("wormholeprojector")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/bluespace_warping
	id = "bluespace_warping"
	display_name = "Bluespace Travel"
	description = "Application of Bluespace for static teleportation technology."
	prereq_ids = list("adv_power", "adv_bluespace")
	design_ids = list("tele_station", "tele_hub", "quantumpad", "quantum_keycard", "launchpad", "launchpad_console", "teleconsole", "roastingstick", "bluespace_pipe")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/unregulated_bluespace
	id = "unregulated_bluespace"
	display_name = "Unregulated Bluespace Research"
	description = "Bluespace technology using unstable or unbalanced procedures, prone to damaging the fabric of bluespace. Outlawed by galactic conventions."
	prereq_ids = list("bluespace_warping", "syndicate_basic")
	design_ids = list("desynchronizer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/////////////////////////shuttle tech/////////////////////////
/datum/techweb_node/basic_shuttle_tech
	id = "basic_shuttle"
	display_name = "Basic Shuttle Research"
	description = "Research the technology required to create and use basic shuttles."
	prereq_ids = list("practical_bluespace", "adv_engi")
	design_ids = list("shuttle_creator", "engine_plasma", "engine_heater", "shuttle_control", "shuttle_docker","spaceship_navigation_beacon")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/shuttle_route_upgrade
	id = "shuttle_route_upgrade"
	display_name = "Route Optimisation Upgrade"
	description = "Research into bluespace tunnelling, allowing us to reduce flight times by up to 20%!"
	prereq_ids = list("basic_shuttle")
	design_ids = list("disk_shuttle_route")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/shuttle_route_upgrade_hyper
	id = "shuttle_route_upgrade_hyper"
	display_name = "Hyperlane Optimisation Upgrade"
	description = "Research into bluespace hyperlane, allowing us to reduce flight times by up to 40%!"
	prereq_ids = list("shuttle_route_upgrade", "bluespace_warping")
	design_ids = list("disk_shuttle_route_hyper")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/shuttle_route_upgrade_void
	id = "shuttle_route_upgrade_void"
	display_name = "Nullspace Breaching Upgrade"
	description = "Research into voidspace tunnelling, allowing us to significantly reduce flight times."
	prereq_ids = list("shuttle_route_upgrade_hyper", "alientech")
	design_ids = list("disk_shuttle_route_void", "engine_void")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 12500)
