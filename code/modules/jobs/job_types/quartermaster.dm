/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
	department_head = list("Captain")
	department_flag = CIVILIAN
	head_announce = list(RADIO_CHANNEL_SUPPLY)
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#a06121"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SUPPLY
	considered_combat_role = TRUE

	outfit = /datum/outfit/job/quartermaster

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM, ACCESS_MINING,
					ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_KEYCARD_AUTH, ACCESS_RC_ANNOUNCE,
					ACCESS_SEC_DOORS, ACCESS_HEADS)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM, ACCESS_MINING,
					ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_KEYCARD_AUTH, ACCESS_RC_ANNOUNCE,
					ACCESS_SEC_DOORS, ACCESS_HEADS)
	paycheck = PAYCHECK_HARD //They can already buy stuff using cargo budget, don't give em a command-level paycheck.	//alright i'll agree to that -qweq
	paycheck_department = ACCOUNT_CAR
	bounty_types = CIV_JOB_RANDOM

	display_order = JOB_DISPLAY_ORDER_QUARTERMASTER
	blacklisted_quirks = list(/datum/quirk/mute, /datum/quirk/brainproblems, /datum/quirk/insanity)
	threat = 0.5

/datum/outfit/job/quartermaster
	name = "Quartermaster"
	jobtype = /datum/job/qm

	belt = /obj/item/pda/quartermaster
	ears = /obj/item/radio/headset/heads/qm
	uniform = /obj/item/clothing/under/rank/cargo/qm
	shoes = /obj/item/clothing/shoes/sneakers/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/clipboard
	id = /obj/item/card/id/silver
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic = 1, /obj/item/modular_computer/tablet/preset/advanced = 1)

	chameleon_extras = /obj/item/stamp/qm

