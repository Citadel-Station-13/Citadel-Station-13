
////////////////////////Tools////////////////////////
/datum/techweb_node/basic_tools
	id = "basic_tools"
	display_name = "Basic Tools"
	description = "Basic mechanical, electronic, surgical and botanical tools."
	prereq_ids = list("base")
	design_ids = list("screwdriver", "wrench", "wirecutters", "crowbar", "multitool", "welding_tool", "tscanner", "analyzer", "cable_coil", "pipe_painter", "airlock_painter", "scalpel", "circular_saw", "surgicaldrill", "retractor", "cautery", "hemostat", "cultivator", "plant_analyzer", "shovel", "spade", "hatchet", "mop", "broom", "normtrash")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 500)

/datum/techweb_node/basic_mining
	id = "basic_mining"
	display_name = "Mining Technology"
	description = "Better than Efficiency V."
	prereq_ids = list("engineering", "basic_plasma")
	design_ids = list("drill", "superresonator", "triggermod", "damagemod", "cooldownmod", "rangemod", "ore_redemption", "mining_equipment_vendor", "cargoexpress", "plasmacutter")//e a r l y    g a  m e)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_mining
	id = "adv_mining"
	display_name = "Advanced Mining Technology"
	description = "Efficiency Level 127"	//dumb mc references
	prereq_ids = list("basic_mining", "adv_engi", "adv_power", "adv_plasma")
	design_ids = list("drill_diamond", "jackhammer", "hypermod", "plasmacutter_adv", "ore_silo", "plasteel_pick", "titanium_pick")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/janitor
	id = "janitor"
	display_name = "Advanced Sanitation Technology"
	description = "Clean things better, faster, stronger, and harder!"
	prereq_ids = list("adv_engi")
	design_ids = list("advmop", "buffer", "light_replacer", "spraybottle", "beartrap", "ci-janitor", "paint_remover")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1750) // No longer has its bag

/datum/techweb_node/botany
	id = "botany"
	display_name = "Botanical Engineering"
	description = "Botanical tools."
	prereq_ids = list("adv_engi", "biotech")
	design_ids = list("diskplantgene", "portaseeder", "plantgenes", "flora_gun", "hydro_tray", "biogenerator", "seed_extractor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2750)

/datum/techweb_node/exp_tools
	id = "exp_tools"
	display_name = "Experimental Tools"
	description = "Highly advanced construction tools."
	design_ids = list("exwelder", "jawsoflife", "handdrill", "holosigncombifan")
	prereq_ids = list("adv_engi")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2750)

/datum/techweb_node/sec_basic
	id = "sec_basic"
	display_name = "Basic Security Equipment"
	description = "Standard equipment used by security."
	design_ids = list("seclite", "pepperspray", "bola_energy", "zipties", "evidencebag")
	prereq_ids = list("base")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 750)
