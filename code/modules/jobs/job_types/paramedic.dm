/datum/job/paramedic
	title = "Paramedic"
	flag = PARAMEDIC
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#74b5e0"

	outfit = /datum/outfit/job/paramedic

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_MINERAL_STOREROOM, ACCESS_MAINT_TUNNELS)

	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_CLONING, ACCESS_MINERAL_STOREROOM, ACCESS_MAINT_TUNNELS)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED
	bounty_types = CIV_JOB_MED

	display_order = JOB_DISPLAY_ORDER_PARAMEDIC

	threat = 0.5

	starting_modifiers = list(/datum/skill_modifier/job/surgery, /datum/skill_modifier/job/affinity/surgery)

/datum/outfit/job/paramedic
	name = "Paramedic"
	jobtype = /datum/job/paramedic

	ears = /obj/item/radio/headset/headset_med
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	mask = /obj/item/clothing/mask/cigarette
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/soft/emt
	suit =  /obj/item/clothing/suit/toggle/labcoat/paramedic
	belt = /obj/item/storage/belt/medical
	l_hand = /obj/item/storage/firstaid/regular
	suit_store = /obj/item/flashlight/pen/paramedic
	id = /obj/item/card/id
	r_pocket = /obj/item/pinpointer/crew
	l_pocket = /obj/item/pda/medical
	backpack_contents = list(/obj/item/roller=1)
	pda_slot = ITEM_SLOT_LPOCKET

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	chameleon_extras = /obj/item/gun/syringe
