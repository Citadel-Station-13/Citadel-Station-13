/*
Chief Engineer
*/
/datum/job/chief_engineer
	title = "Chief Engineer"
	flag = CHIEF
	department_head = list("Captain")
	department_flag = ENGSEC
	head_announce = list("Engineering")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffeeaa"
	req_admin_notify = 1
	minimal_player_age = 7

	outfit = /datum/outfit/job/ce

	access = list(GLOB.access_engine, GLOB.access_engine_equip, GLOB.access_tech_storage, GLOB.access_maint_tunnels,
			            GLOB.access_external_airlocks, GLOB.access_atmospherics, GLOB.access_emergency_storage, GLOB.access_eva,
			            GLOB.access_heads, GLOB.access_construction, GLOB.access_sec_doors, GLOB.access_minisat,
			            GLOB.access_ce, GLOB.access_RC_announce, GLOB.access_keycard_auth, GLOB.access_tcomsat, GLOB.access_mineral_storeroom)
	minimal_access = list(GLOB.access_engine, GLOB.access_engine_equip, GLOB.access_tech_storage, GLOB.access_maint_tunnels,
			            GLOB.access_external_airlocks, GLOB.access_atmospherics, GLOB.access_emergency_storage, GLOB.access_eva,
			            GLOB.access_heads, GLOB.access_construction, GLOB.access_sec_doors, GLOB.access_minisat,
			            GLOB.access_ce, GLOB.access_RC_announce, GLOB.access_keycard_auth, GLOB.access_tcomsat, GLOB.access_mineral_storeroom)

/datum/outfit/job/ce
	name = "Chief Engineer"
	jobtype = /datum/job/chief_engineer

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/weapon/storage/belt/utility/chief/full
	l_pocket = /obj/item/device/pda/heads/ce
	ears = /obj/item/device/radio/headset/heads/ce
	uniform = /obj/item/clothing/under/rank/chief_engineer
	shoes = /obj/item/clothing/shoes/sneakers/brown
	head = /obj/item/clothing/head/hardhat/white
	gloves = /obj/item/clothing/gloves/color/black/ce
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1,/obj/item/device/modular_computer/tablet/preset/advanced=1)

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel/eng
	duffelbag = /obj/item/weapon/storage/backpack/duffelbag/engineering
	box = /obj/item/weapon/storage/box/engineer
	pda_slot = slot_l_store

/datum/outfit/job/ce/rig
	name = "Chief Engineer (Hardsuit)"

	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/engine/elite
	shoes = /obj/item/clothing/shoes/magboots/advance
	suit_store = /obj/item/weapon/tank/internals/oxygen
	gloves = /obj/item/clothing/gloves/color/yellow
	head = null
	internals_slot = slot_s_store


/*
Station Engineer
*/
/datum/job/engineer
	title = "Station Engineer"
	flag = ENGINEER
	department_head = list("Chief Engineer")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the chief engineer"
	selection_color = "#fff5cc"

	outfit = /datum/outfit/job/engineer

	access = list(GLOB.access_engine, GLOB.access_engine_equip, GLOB.access_tech_storage, GLOB.access_maint_tunnels,
									GLOB.access_external_airlocks, GLOB.access_construction, GLOB.access_atmospherics, GLOB.access_tcomsat)
	minimal_access = list(GLOB.access_engine, GLOB.access_engine_equip, GLOB.access_tech_storage, GLOB.access_maint_tunnels,
									GLOB.access_external_airlocks, GLOB.access_construction, GLOB.access_tcomsat)

/datum/outfit/job/engineer
	name = "Station Engineer"
	jobtype = /datum/job/engineer

	belt = /obj/item/weapon/storage/belt/utility/full/engi
	l_pocket = /obj/item/device/pda/engineering
	ears = /obj/item/device/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/hardhat
	r_pocket = /obj/item/device/t_scanner
	accessory = /obj/item/clothing/accessory/pocketprotector/full

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel/eng
	duffelbag = /obj/item/weapon/storage/backpack/duffelbag/engineering
	box = /obj/item/weapon/storage/box/engineer
	pda_slot = slot_l_store
	backpack_contents = list(/obj/item/device/modular_computer/tablet/preset/advanced=1)

/datum/outfit/job/engineer/gloved
	name = "Station Engineer (Gloves)"
	gloves = /obj/item/clothing/gloves/color/yellow

/datum/outfit/job/engineer/gloved/rig
	name = "Station Engineer (Hardsuit)"

	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/engine
	suit_store = /obj/item/weapon/tank/internals/oxygen
	head = null
	internals_slot = slot_s_store


/*
Atmospheric Technician
*/
/datum/job/atmos
	title = "Atmospheric Technician"
	flag = ATMOSTECH
	department_head = list("Chief Engineer")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the chief engineer"
	selection_color = "#fff5cc"

	outfit = /datum/outfit/job/atmos

	access = list(GLOB.access_engine, GLOB.access_engine_equip, GLOB.access_tech_storage, GLOB.access_maint_tunnels,
									GLOB.access_external_airlocks, GLOB.access_construction, GLOB.access_atmospherics)
	minimal_access = list(GLOB.access_atmospherics, GLOB.access_maint_tunnels, GLOB.access_emergency_storage, GLOB.access_construction)

/datum/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/atmos

	belt = /obj/item/weapon/storage/belt/utility/atmostech
	l_pocket = /obj/item/device/pda/atmos
	ears = /obj/item/device/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	r_pocket = /obj/item/device/analyzer
	accessory = /obj/item/clothing/accessory/pocketprotector/full

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel/eng
	duffelbag = /obj/item/weapon/storage/backpack/duffelbag/engineering
	box = /obj/item/weapon/storage/box/engineer
	pda_slot = slot_l_store
	backpack_contents = list(/obj/item/device/modular_computer/tablet/preset/advanced=1)

/datum/outfit/job/atmos/rig
	name = "Atmospheric Technician (Hardsuit)"

	mask = /obj/item/clothing/mask/gas
	suit = /obj/item/clothing/suit/space/hardsuit/engine/atmos
	suit_store = /obj/item/weapon/tank/internals/oxygen
	internals_slot = slot_s_store
