/datum/techweb_node/powerarmor
	id = "powerarmor"
	display_name = "Full Body Exoskeleton"
	description = "Utilizing fluctuations in bluespace crystals, we can draw small amounts of energy to create self-powered body enhancing suits."
	prereq_ids = list("adv_biotech", "adv_bluespace", "adv_robotics")
	design_ids = list("powerarmor_skeleton","powerarmor_torso","powerarmor_helmet","powerarmor_armR","powerarmor_armL","powerarmor_legR","powerarmor_legL")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)

/datum/techweb_node/adv_robotics/New()
	design_ids += "borg_upgrade_premiumka"
	. = ..()

/datum/techweb_node/cyborg_upg_util/New()
	design_ids += "borg_upgrade_xwelding"
	design_ids += "borg_upgrade_shrink"
	//design_ids += "borg_upgrade_plasma"
	. = ..()
