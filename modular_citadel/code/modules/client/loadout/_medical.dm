/datum/gear/hands/medicbriefcase
	name = "Medical Briefcase"
	path = /obj/item/storage/briefcase/medical
	restricted_roles = list("Medical Doctor", "Chief Medical Officer")
	restricted_desc = "MD, CMO"

/datum/gear/neck/stethoscope
	name = "Stethoscope"
	path = /obj/item/clothing/neck/stethoscope
	restricted_roles = list("Medical Doctor", "Chief Medical Officer")

/datum/gear/uniform/bluescrubs
	name = "Blue Scrubs"
	subcategory = LOADOUT_SUBCATEGORY_UNIFORM_JOBS
	path = /obj/item/clothing/under/rank/medical/doctor/blue
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist")
	restricted_desc = "Medical"

/datum/gear/uniform/greenscrubs
	name = "Green Scrubs"
	subcategory = LOADOUT_SUBCATEGORY_UNIFORM_JOBS
	path = /obj/item/clothing/under/rank/medical/doctor/green
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist")
	restricted_desc = "Medical"

/datum/gear/uniform/purplescrubs
	name = "Purple Scrubs"
	subcategory = LOADOUT_SUBCATEGORY_UNIFORM_JOBS
	path = /obj/item/clothing/under/rank/medical/doctor/purple
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist")
	restricted_desc = "Medical"

/datum/gear/head/nursehat
	name = "Nurse Hat"
	path = /obj/item/clothing/head/nursehat
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist")
	restricted_desc = "Medical"

/datum/gear/uniform/nursesuit
	name = "Nurse Suit"
	path = /obj/item/clothing/under/rank/medical/doctor/nurse
	subcategory = LOADOUT_SUBCATEGORY_UNIFORM_JOBS
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist")
	restricted_desc = "Medical"
