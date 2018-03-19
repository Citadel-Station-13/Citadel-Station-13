/datum/gear/hat
	subtype_path = /datum/gear/hat
	slot = slot_head
	sort_category = "Headwear"

/datum/gear/hat/balaclava
	name = "Balaclava"
	slot = slot_in_backpack
	cost = 3
	path = /obj/item/clothing/mask/balaclava

/datum/gear/hat/baseball
	name = "Ballcap"
	path = /obj/item/clothing/head/soft/mime

/datum/gear/hat/beanie
	name = "Beanie"
	path = /obj/item/clothing/head/beanie

/datum/gear/hat/beret
	name = "Black beret"
	path = /obj/item/clothing/head/beret/black

/datum/gear/hat/flatcap
	name = "Flat cap"
	path = /obj/item/clothing/head/flatcap

/datum/gear/hat/pirate
	name = "Pirate hat"
	path = /obj/item/clothing/head/pirate

/datum/gear/hat/rice_hat
	name = "Rice hat"
	path = /obj/item/clothing/head/rice_hat

/datum/gear/hat/ushanka
	name = "Ushanka"
	path = /obj/item/clothing/head/ushanka

/datum/gear/hat/slime
	name = "Slime hat"
	path = /obj/item/clothing/head/collectable/slime

/datum/gear/hat/fedora
	name = "Fedora"
	path = /obj/item/clothing/head/fedora

/datum/gear/hat/that
	name = "Top Hat"
	path = /obj/item/clothing/head/that

/datum/gear/hat/navy
	subtype_path = datum/gear/hat/navy
	subtype_cost_overlap = FALSE
	sort_category = "Job Specific Headwear"

/datum/gear/hat/navy/bluehosberet
	name = "Head of security's Navy beret"
	path = /obj/item/clothing/head/beret/sec/navyhos
	restricted_roles = list("Head of Security")

/datum/gear/hat/navy/blueofficerberet
	name = "Security officer's Navyblue beret"
	path = /obj/item/clothing/head/beret/sec/navyofficer
	restricted_roles = list("Security Officer")

/datum/gear/hat/navy/bluewardenberet
	name = "Warden's navyblue beret"
	path = /obj/item/clothing/head/beret/sec/navywarden
	restricted_roles = list("Warden")

//trek fancy Hats!
/datum/gear/hat/navy/trekcap
	name = "Federation Officer's Cap"
	path = /obj/item/clothing/head/caphat/formal/fedcover
	restricted_roles = list("Captain","Head of Personnel")

/datum/gear/hat/navy/trekcap/medisci
	name = "Federation Officer's Cap"
	path = /obj/item/clothing/head/caphat/formal/fedcover/medsci
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/hat/navy/trekcap/eng
	name = "Federation Officer's Cap"
	path = /obj/item/clothing/head/caphat/formal/fedcover/eng
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/gear/hat/navy/trekcap/sec
	name = "Federation Officer's Cap"
	path = /obj/item/clothing/head/caphat/formal/fedcover/sec
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")
