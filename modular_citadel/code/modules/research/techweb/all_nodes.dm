/datum/techweb_node/bluespace_basic/New()
	. = ..()
	design_ids += "xenobio_monkeys"

/datum/techweb_node/practical_bluespace/New()
	. = ..()
	design_ids += "xenobio_slimebasic"

/datum/techweb_node/adv_bluespace/New()
	. = ..()
	design_ids += "xenobio_slimeadv"

/datum/techweb_node/computer_board_gaming
	id = "computer_board_gaming"
	display_name = "Games and Toys"
	description = "For the slackers on the station."
	prereq_ids = list("comptech")
	design_ids = list("arcade_battle", "arcade_orion", "slotmachine", "autoylathe")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)
	export_price = 5000

/datum/techweb_node/ballistic_weapons
	design_ids = list("mag_oldsmg", "mag_oldsmg_ap", "mag_oldsmg_ic", "mag_oldsmg_tx")

/datum/techweb_node/adv_defibrillator_tec
	id = adv_defibrillator_tec"
	display_name = "Adv Defibrillartor tec"
	description = "More ways to bring back the freshly dead."
	prereq_ids = list("adv_biotech", "exp_surgery", "adv_engi", "adv_power")
	design_ids = list("defib_speed", "defib_decay", "defib_shock", "defib_heal", "comp_defib)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	export_price = 5000
