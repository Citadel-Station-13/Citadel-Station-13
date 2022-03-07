/datum/job/bartender
	title = "Bartender"
	desc = "The bartender is part of the station's service staff. Serve drinks to your patrons and maintain an orderly bar."
	faction = JOB_FACTION_STATION
	total_positions = 1
	roundstart_positions = 1
	selection_color = "#bbe291"
	exp_type_department = EXP_TYPE_SERVICE // This is so the jobs menu can work properly

	outfit = /datum/outfit/job/bartender
	plasma_outfit = /datum/outfit/plasmaman/bar

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	threat = 0.5

/datum/outfit/job/bartender
	name = "Bartender"
	jobtype = /datum/job/bartender

	glasses = /obj/item/clothing/glasses/sunglasses/reagent
	belt = /obj/item/pda/bar
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/bartender
	suit = /obj/item/clothing/suit/armor/vest
	backpack_contents = list(/obj/item/storage/box/beanbag=1,/obj/item/book/granter/action/drink_fling=1)
	shoes = /obj/item/clothing/shoes/laceup

/datum/job/bartender/after_spawn(mob/M, latejoin, client/C)
	. = ..()
	var/datum/action/innate/drink_fling/D = new
	D.Grant(M)
