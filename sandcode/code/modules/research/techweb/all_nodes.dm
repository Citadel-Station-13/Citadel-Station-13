/datum/techweb_node/janitor/bspspray
	id = "bspspray"
	display_name = "Advanced Janitoring"
	description = "A better sprayer for your job!"
	prereq_ids = list("janitor")
	design_ids = list("bluespacespray")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 750)

/datum/techweb_node/syndicate_basic/cool
	id = "syndicate_cool"
	display_name = "A Single Illegal Weapon"
	description = "Shoot with style! Cannot be supressed!"
	prereq_ids = list("syndicate_basic")
	design_ids = list("luger")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	hidden = FALSE

/datum/techweb_node/adv_bluetravel
	id = "advanced_bluetravel"
	display_name = "Advanced Bluespace Travel"
	description = "Using superior knowledge of bluespace, you can develop more finely-controlled teleportation equipment."
	prereq_ids = list("adv_bluespace", "bluespace_warping")
	design_ids = list("telepad", "telesci_console")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/adv_toolset_implant
	id = "adv_toolset_implant"
	display_name = "Advanced Toolset Implant"
	description = "Allows the creation of alien powerful implants for your arms."
	prereq_ids = list("alien_bio")
	design_ids = list("ci-toolset-adv","ci-surgery-adv")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/adv_surgery/New()
	design_ids += "autodoc"
	. = ..()

/datum/techweb_node/computer_board_gaming/New()
	design_ids += "tetris"
	. = ..()

/datum/techweb_node/nanite_smart/New()
	design_ids += "signaler_nanites"
	. = ..()

/datum/techweb_node/engineering/New()
	design_ids += "upgraded_welder"
	. = ..()
