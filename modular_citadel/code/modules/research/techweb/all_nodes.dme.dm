/datum/techweb_node/bluespace_basic/New()
	. = ..()
	design_ids += "xenobio_monkeys"

/datum/techweb_node/practical_bluespace/New()
	. = ..()
	design_ids += "xenobio_slimebasic"

/datum/techweb_node/adv_bluespace/New()
	. = ..()
	design_ids += "xenobio_slimeadv"

/datum/techweb_node/ballistic_weapons/New()
	. = ..()
	design_ids += "mag_oldsmg_rubber"

/datum/techweb_node/computer_board_gaming
	id = "computer_board_gaming"
	display_name = "Games and Toys"
	description = "For the slackers on the station."
	prereq_ids = list("comptech")
	design_ids = list("arcade_battle", "arcade_orion", "slotmachine", "autoylathe")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)
	export_price = 5000

/datum/techweb_node/advanced_illegl_ballistics
	id = "advanced_illegal_ballistics"
	display_name = "Advanced Illegal Ballistics
	description = "Advanced Ballistic for Illegal weaponds."
	design_ids = list("10mm","10mmap","10mminc","10mmhp","9mm","point_45","bolt_clip")
	prereq_ids = list("ballistic_weapons","syndicate_basic","explosive_weapons")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 25000) //This gives sec lethal mags/clips for guns form traitors or space.
	export_price = 7000
