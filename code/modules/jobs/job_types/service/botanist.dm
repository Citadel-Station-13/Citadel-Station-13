/datum/job/hydro
	title = "Botanist"
	desc = "The Botanist grows useful crops for the station."
	faction = JOB_FACTION_STATION
	total_positions = 3
	roundstart_positions = 2
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/botanist
	plasma_outfit = /datum/outfit/plasmaman/botany

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_HYDROPONICS, ACCESS_MORGUE, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	threat = 1.5 // lol powergame

/datum/outfit/job/botanist
	name = "Botanist"
	jobtype = /datum/job/hydro

	belt = /obj/item/pda/botanist
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/hydroponics
	suit = /obj/item/clothing/suit/apron
	gloves  =/obj/item/clothing/gloves/botanic_leather
	suit_store = /obj/item/plant_analyzer

	backpack = /obj/item/storage/backpack/botany
	satchel = /obj/item/storage/backpack/satchel/hyd
