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
	research_cost = 1000
	export_price = 5000

/datum/techweb_node/beam_weapons
	design_ids = list("beamrifle", "ioncarbine", "triphasic", "triphasicammo")
