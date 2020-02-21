/datum/job/psych
	title = "Psychologist"
	flag = PSYCH
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer"
	selection_color = "#74b5e0"

	outfit = /datum/outfit/job/psych

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CLONING, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_SURGERY, ACCESS_CLONING, ACCESS_MINERAL_STOREROOM)

	display_order = JOB_DISPLAY_ORDER_PSYCH

/datum/outfit/job/psych
	name = "Psychologist"
	jobtype = /datum/job/psych

	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/suit_jacket/green
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/storage/briefcase/medical
	r_hand = /obj/item/clipboard
	l_pocket = /obj/item/laser_pointer
	r_pocket = /obj/item/pda/medical
	pda_slot = ITEM_SLOT_RPOCKET

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	chameleon_extras = /obj/item/gun/syringe
