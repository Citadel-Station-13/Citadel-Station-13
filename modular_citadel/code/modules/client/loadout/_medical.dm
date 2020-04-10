/datum/gear/medicbriefcase
	name = "Medical Briefcase"
	category = SLOT_HANDS
	path = /obj/item/storage/briefcase/medical
	restricted_roles = list("Medical Doctor", "Chief Medical Officer")
	restricted_desc = "MD, CMO"

/datum/gear/stethoscope
	name = "Stethoscope"
	category = SLOT_NECK
	path = /obj/item/clothing/neck/stethoscope
	restricted_roles = list("Medical Doctor", "Chief Medical Officer")

/datum/gear/bluescrubs
	name = "Blue Scrubs"
	category = SLOT_W_UNIFORM
	path = /obj/item/clothing/under/rank/medical/doctor/blue
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist")
	restricted_desc = "Medical"
	
/datum/gear/greenscrubs
	name = "Green Scrubs"
	category = SLOT_W_UNIFORM
	path = /obj/item/clothing/under/rank/medical/doctor/green
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist")
	restricted_desc = "Medical"

/datum/gear/purplescrubs
	name = "Purple Scrubs"
	category = SLOT_W_UNIFORM
	path = /obj/item/clothing/under/rank/medical/doctor/purple
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist")
	restricted_desc = "Medical"

/datum/gear/nursehat
	name = "Nurse Hat"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/nursehat
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist")
	restricted_desc = "Medical"

/datum/gear/nursesuit
	name = "Nurse Suit"
	category = SLOT_W_UNIFORM
	path = /obj/item/clothing/under/rank/medical/doctor/nurse
	restricted_roles = list("Medical Doctor", "Chief Medical Officer", "Geneticist", "Chemist", "Virologist")
	restricted_desc = "Medical"