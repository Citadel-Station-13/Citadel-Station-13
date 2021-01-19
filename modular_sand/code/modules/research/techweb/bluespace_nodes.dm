/datum/techweb_node/bluespace_portal/New()
	design_ids += "borg_upgrade_bsrpd"
	design_ids += "bsrpd"
	. = ..()

/datum/techweb_node/cryptominer
	id = "cryptominer"
	display_name = "Cryptocurrency Mining"
	description = "Harness the power of cryptocurrency to make credits for Cargo-- slowly."
	prereq_ids = list("bluespace_mining")
	design_ids = list("cryptominer")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/cryptominersyndie
	id = "cryptominersyndie"
	display_name = "Illegal Cryptocurrency Mining"
	description = "Harness the power of bluespace to make credits for Cargo-- slowly."
	prereq_ids = list("cryptominer","syndicate_basic")
	design_ids = list("cryptominersyndie")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/computermath
	id = "computermath"
	display_name = "Problem Computer"
	description = "Solve problems for either cargo credits or research points."
	prereq_ids = list("base")
	design_ids = list("computermath")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/encryption
	id = "encryption_key"
	display_name = "Communication Encryption"
	description = "Study into usage of frequencies within headsets and their repoduction."
	prereq_ids = list("telecomms")
	design_ids = list("eng_key", "sci_key", "med_key", "supply_key", "serv_key")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 3000)

/datum/techweb_node/bs_mining
	id = "bluespace_mining"
	display_name = "Bluespace Mining Technology"
	description = "Harness the power of bluespace to make materials out of nothing. Slowly."
	prereq_ids = list("practical_bluespace", "adv_mining")
	design_ids = list("bluespace_miner")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)
