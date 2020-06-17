
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
	design_ids = list("bs_rped","biobag_holding","minerbag_holding", "bluespacebeaker", "bluespacesyringe", "phasic_scanning", "bluespacesmartdart", "xenobio_slimebasic")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/adv_bluespace
	id = "adv_bluespace"
	display_name = "Advanced Bluespace Research"
	description = "Deeper understanding of how the Bluespace dimension works"
	prereq_ids = list("practical_bluespace", "high_efficiency")
	design_ids = list("bluespace_matter_bin", "femto_mani", "triphasic_scanning", "bluespace_crystal", "xenobio_slimeadv")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)

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
	design_ids = list( "bluespacebodybag","bag_holding", "bluespace_pod", "borg_upgrade_trashofholding", "blutrash", "satchel_holding", "bsblood_bag", "duffelbag_holding")
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
	design_ids = list("tele_station", "tele_hub", "quantumpad", "quantum_keycard", "launchpad", "launchpad_console", "teleconsole", "roastingstick")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/unregulated_bluespace
	id = "unregulated_bluespace"
	display_name = "Unregulated Bluespace Research"
	description = "Bluespace technology using unstable or unbalanced procedures, prone to damaging the fabric of bluespace. Outlawed by galactic conventions."
	prereq_ids = list("bluespace_warping", "syndicate_basic")
	design_ids = list("desynchronizer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
