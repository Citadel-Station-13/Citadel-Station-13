/datum/job/cargo_tech
	title = "Cargo Technician"
	desc = "Cargo Technicians assist in the day-to-day of the supply division, keeping the station's crew supplied with whatever they require for their duties."
	faction = JOB_FACTION_STATION
	total_positions = 3
	roundstart_positions = 2
	selection_color = "#ca8f55"

	outfit = /datum/outfit/job/cargo_tech
	plasma_outfit = /datum/outfit/plasmaman/cargo

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_MINING,
				ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_CAR

	threat = 0.2

/datum/outfit/job/cargo_tech
	name = "Cargo Technician"
	jobtype = /datum/job/cargo_tech

	belt = /obj/item/pda/cargo
	ears = /obj/item/radio/headset/headset_cargo
	uniform = /obj/item/clothing/under/rank/cargo/tech
	l_hand = /obj/item/export_scanner

