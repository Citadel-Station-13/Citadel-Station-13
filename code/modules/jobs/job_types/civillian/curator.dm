/datum/job/curator
	title = "Curator"
	desc = "The Curator runs the station's library, and occasionally goes on adventures with their trusty whip and hat."
	faction = JOB_FACTION_STATION
	total_positions = 1
	roundstart_positions = 1
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/curator
	plasma_outfit = /datum/outfit/plasmaman/curator

	access = list(ACCESS_LIBRARY)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_CONSTRUCTION, ACCESS_MINING_STATION)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_CIV

	threat = 0.3

/datum/outfit/job/curator
	name = "Curator"
	jobtype = /datum/job/curator

	shoes = /obj/item/clothing/shoes/laceup
	belt = /obj/item/pda/curator
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/curator
	l_hand = /obj/item/storage/bag/books
	r_pocket = /obj/item/key/displaycase
	l_pocket = /obj/item/laser_pointer
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(
		/obj/item/choice_beacon/hero = 1,
		/obj/item/soapstone = 1,
		/obj/item/barcodescanner = 1
	)

/datum/outfit/job/curator/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	..()

	if(visualsOnly)
		return

	H.grant_all_languages(TRUE, TRUE, TRUE, LANGUAGE_CURATOR)
