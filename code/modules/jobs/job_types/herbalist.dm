/datum/job/herbalist
	title = "Herbalist"
	flag = HERBALIST
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#74b5e0"
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/herbalist

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CLONING, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_HERBALIST, ACCESS_CHEMISTRY, ACCESS_MINERAL_STOREROOM)

	display_order = JOB_DISPLAY_ORDER_HERBALIST
	threat = 1.9 //Oh no

	starting_skills = list(/datum/skill/numerical/surgery = STARTING_SKILL_SURGERY_MEDICAL)
	skill_affinities = list(/datum/skill/numerical/surgery = STARTING_SKILL_AFFINITY_SURGERY_MEDICAL)

/datum/outfit/job/herbalist
	name = "Herbalist"
	jobtype = /datum/job/herbalist

	belt = /obj/item/pda/botanist//To Do: change these into their own sprites
	ears = /obj/item/radio/headset/headset_medsrv
	uniform = /obj/item/clothing/under/rank/medical/doctor//To Do: change these into their own sprites
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/regular
	r_hand = /obj/item/plant_analyzer
	gloves  =/obj/item/clothing/gloves/botanic_leather

	backpack = /obj/item/storage/backpack/medic//To Do: change these into their own sprites
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med


