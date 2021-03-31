/datum/job/janitor
	title = "Custodian"
	flag = JANITOR
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the head worksman"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/janitor
	plasma_outfit = /datum/outfit/plasmaman/janitor

	access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	display_order = JOB_DISPLAY_ORDER_JANITOR
	threat = 0.2

/datum/outfit/job/janitor
	name = "Janitor"
	jobtype = /datum/job/janitor

	belt = /obj/item/pda/janitor
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/janitor
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced=1,/obj/item/claymore/april_fools=1,)

	head = /obj/item/clothing/head/helmet/knight
	suit = /obj/item/clothing/suit/armor/riot/knight
