/datum/job/atmos
	title = "Atmospheric Technician"
	flag = ATMOSTECH
	department_head = list("Chief Engineer")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief engineer"
	selection_color = "#ff9b3d"
	exp_requirements = 60
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/atmos

	access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
									ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_ATMOSPHERICS, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ENGINE,
									ACCESS_ENGINE_EQUIP, ACCESS_EMERGENCY_STORAGE, ACCESS_CONSTRUCTION, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_ENG

	starting_modifiers = list(/datum/skill_modifier/job/level/wiring/basic, /datum/skill_modifier/job/affinity/wiring)

	display_order = JOB_DISPLAY_ORDER_ATMOSPHERIC_TECHNICIAN
	threat = 0.5

/datum/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/atmos

	belt = /obj/item/storage/belt/utility/atmostech
	l_pocket = /obj/item/pda/atmos
	ears = /obj/item/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/engineering/atmospheric_technician
	r_pocket = /obj/item/analyzer

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/engineer
	pda_slot = SLOT_L_STORE
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced=1)

/datum/outfit/job/atmos/rig
	name = "Atmospheric Technician (Hardsuit)"

	mask = /obj/item/clothing/mask/gas
	suit = /obj/item/clothing/suit/space/hardsuit/engine/atmos
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = SLOT_S_STORE
