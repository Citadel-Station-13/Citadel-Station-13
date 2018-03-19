/datum/gear/suit/suit
	subtype_path = /datum/gear/suit/suit
	slot = slot_wear_suit
	cost = 2
	sort_category = "External Wear"

/datum/gear/suit/poncho
	name = "Poncho"
	path = /obj/item/clothing/suit/poncho

/datum/gear/suit/ponchogreen
	name = "Green poncho"
	path = /obj/item/clothing/suit/poncho/green

/datum/gear/suit/ponchored
	name = "Red poncho"
	path = /obj/item/clothing/suit/poncho/red

/datum/gear/suit/jacketbomber
	name = "Bomber jacket"
	path = /obj/item/clothing/suit/jacket

/datum/gear/suit/jacketleather
	name = "Leather jacket"
	path = /obj/item/clothing/suit/jacket/leather

/datum/gear/suit/overcoatleather
	name = "Leather overcoat"
	path = /obj/item/clothing/suit/jacket/leather/overcoat

/datum/gear/suit/jacketpuffer
	name = "Puffer jacket"
	path = /obj/item/clothing/suit/jacket/puffer

/datum/gear/suit/vestpuffer
	name = "Puffer vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/gear/suit/jacketlettermanbrown
	name = "Brown letterman jacket"
	path = /obj/item/clothing/suit/jacket/letterman

/datum/gear/suit/jacketlettermanred
	name = "Red letterman jacket"
	path = /obj/item/clothing/suit/jacket/letterman_red

/datum/gear/suit/jacketlettermanNT
	name = "Nanotrasen letterman jacket"
	path = /obj/item/clothing/suit/jacket/letterman_nanotrasen

/datum/gear/suit/coat
	name = "Winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat

/datum/gear/suit/militaryjacket
	name = "Military Jacket"
	path = /obj/item/clothing/suit/jacket/miljacket

/datum/gear/suit/ianshirt
	name = "Ian Shirt"
	path = /obj/item/clothing/suit/ianshirt

//Job Coats
/datum/gear/suit/job
	subtype_path = /datum/gear/suit/job
	subtype_cost_overlap = FALSE
	sort_category = "Job Specific Coats"

/datum/gear/suit/job/sec/navybluejackethos
	name = "head of security's navyblue jacket"
	path = /obj/item/clothing/suit/security/hos
	restricted_roles = list("Head of Security")

/datum/gear/suit/job/sec/navybluejacketofficer
	name = "security officer's navyblue jacket"
	path = /obj/item/clothing/suit/security/officer
	restricted_roles = list("Security Officer")

/datum/gear/suit/job/sec/navybluejacketwarden
	name = "warden navyblue jacket"
	path = /obj/item/clothing/suit/security/warden
	restricted_roles = list("Warden")

//Trek Coats
/datum/gear/suit/trek
	subtype_path = /datum/gear/suit/trek
	subtype_cost_overlap = FALSE
	sort_category = "Trek Coats"

/datum/gear/suit/trek/ds9_coat
	name = "DS9 Overcoat"
	path = /obj/item/clothing/suit/storage/trek/ds9
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster",
							"Medical Doctor","Chemist","Virologist","Geneticist","Scientist", "Roboticist",
							"Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer",
							"Cargo Technician", "Shaft Miner") //everyone who actually deserves a job.
/datum/gear/suit/trek/cap
	name = "fed (movie) uniform, Captain"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/capt
	restricted_roles = list("Captain","Head of Personnel")

/datum/gear/suit/trek/sec
	name = "fed (movie) uniform, sec"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster","Warden","Detective","Security Officer")

/datum/gear/suit/trek/medsci
	name = "fed (movie) uniform, med/sci"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/medsci
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/suit/trek/eng
	name = "fed (movie) uniform, ops/eng"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/eng
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Cargo Technician", "Shaft Miner", "Quartermaster")