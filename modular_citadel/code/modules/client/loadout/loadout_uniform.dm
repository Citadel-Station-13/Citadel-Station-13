// Uniform slot
/datum/gear/uniform
	subtype_path = /datum/gear/uniform
	slot = slot_w_uniform
	cost = 2
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/turtleneck
	name = "Tactitool Turtleneck"
	path = /obj/item/clothing/under/syndicate/cosmetic

/datum/gear/uniform/suitblack
	name = "Black suit"
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/uniform/suitgreen
	name = "Green suit"
	path = /obj/item/clothing/under/suit_jacket/green

/datum/gear/uniform/suitred
	name = "Red suit"
	path = /obj/item/clothing/under/suit_jacket/red

/datum/gear/uniform/suitcharcoal
	name = "Charcoal suit"
	path = /obj/item/clothing/under/suit_jacket/charcoal

/datum/gear/uniform/suitnavy
	name = "Navy suit"
	path = /obj/item/clothing/under/suit_jacket/navy

/datum/gear/uniform/suitburgundy
	name = "Burgundy suit"
	path = /obj/item/clothing/under/suit_jacket/burgundy

/datum/gear/uniform/suittan
	name = "Tan suit"
	path = /obj/item/clothing/under/suit_jacket/tan

/datum/gear/uniform/suitwhite
	name = "White suit"
	path = /obj/item/clothing/under/suit_jacket/white

/datum/gear/uniform/assistantformal
	name = "Assistant's formal uniform"
	path = /obj/item/clothing/under/assistantformal

/datum/gear/uniform/maidcostume
	name = "Maid costume"
	path = /obj/item/clothing/under/maid

/datum/gear/uniform/mailmanuniform
	name = "Mailman's jumpsuit"
	path = /obj/item/clothing/under/rank/mailman

/datum/gear/uniform/skirt
	subtype_path = /datum/gear/uniform/skirt
	subtype_cost_overlap = FALSE

/datum/gear/uniform/skirt/black
	name = "Black skirt"
	path = /obj/item/clothing/under/skirt/black

/datum/gear/uniform/skirt/blue
	name = "Blue skirt"
	path = /obj/item/clothing/under/skirt/blue

/datum/gear/uniform/skirt/red
	name = "Red skirt"
	path = /obj/item/clothing/under/skirt/red

/datum/gear/uniform/skirt/purple
	name = "Purple skirt"
	path = /obj/item/clothing/under/skirt/purple

/datum/gear/uniform/skirt/kilt
	name = "Kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/pants
	subtype_path = /datum/gear/uniform/pants
	sort_category = "Pants"

/datum/gear/uniform/pants/camoshorts
	name = "Camo Pants"
	path = /obj/item/clothing/under/pants/camo

/datum/gear/uniform/pants/bjeans
	name = "Black Jeans"
	path = /obj/item/clothing/under/pants/blackjeans

/datum/gear/uniform/pants/cjeans
	name = "Classic Jeans"
	path = /obj/item/clothing/under/pants/classicjeans

/datum/gear/uniform/pants/khaki
	name = "Khaki Pants"
	path = /obj/item/clothing/under/pants/khaki

/datum/gear/uniform/pants/wpants
	name = "White Pants"
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/rpants
	name = "Red Pants"
	path = /obj/item/clothing/under/pants/red

/datum/gear/uniform/pants/tpants
	name = "Tan Pants"
	path = /obj/item/clothing/under/pants/tan

/datum/gear/uniform/pants/trpants
	name = "Track Pants"
	path = /obj/item/clothing/under/pants/track

/datum/gear/uniform/job
	subtype_path = /datum/gear/uniform/job
	subtype_cost_overlap = FALSE
	sort_category = "Job Specific Uniformss"

/datum/gear/uniform/job/sec
	subtype_path = /datum/gear/uniform/job/sec

/datum/gear/uniform/job/sec/navyblueuniformhos
 	name = "Head of Security navyblue uniform"
 	path = /obj/item/clothing/under/rank/head_of_security/navyblue
 	restricted_roles = list("Head of Security")

/datum/gear/uniform/job/sec/navyblueuniformofficer
 	name = "security officer navyblue uniform"
 	path = /obj/item/clothing/under/rank/security/navyblue
 	restricted_roles = list("Security officer")

/datum/gear/uniform/job/sec/navyblueuniformwarden
 	name = "Warden navyblue uniform"
 	path = /obj/item/clothing/under/rank/warden/navyblue
 	restricted_roles = list("Warden")

/datum/gear/uniform/job/sec/secskirt
	name = "Security skirt"
	path = /obj/item/clothing/under/rank/security/skirt
	restricted_roles = list("Security Officer", "Warden", "Head of Security")

/datum/gear/uniform/job/sec/hosskirt
	name = "Head of security's skirt"
	path = /obj/item/clothing/under/rank/head_of_security/skirt
	restricted_roles = list("Head of Security")
	
// Trekie things
/datum/gear/uniform/trek
	sort_category = "Trek Uniforms"
	subtype_path = /datum/gear/uniform/trek
	subtype_cost_overlap = FALSE

/datum/gear/uniform/trek/cmd
	subtype_path = /datum/gear/uniform/trek/cmd
/datum/gear/uniform/trek/medsci
	subtype_path = /datum/gear/uniform/trek/medsci
/datum/gear/uniform/trek/eng
	subtype_path = /datum/gear/uniform/trek/eng

//TOS
/datum/gear/uniform/trek/cmd/tos
	name = "TOS uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster")

/datum/gear/uniform/trek/medsci/tos
	name = "TOS uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/uniform/trek/eng/tos
	name = "TOS uniform, ops/sec"
	path = /obj/item/clothing/under/rank/trek/engsec
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")

//TNG
/datum/gear/uniform/trek/cmd/tng
	name = "TNG uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/next
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster")

/datum/gear/uniform/trek/medsci/tng
	name = "TNG uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/next
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/uniform/trek/eng/tng
	name = "TNG uniform, ops/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/next
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")

//VOY
/datum/gear/uniform/trek/cmd/voy
	name = "VOY uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/voy
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster")

/datum/gear/uniform/trek/medsci/voy
	name = "VOY uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/voy
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/uniform/trek/eng/voy
	name = "VOY uniform, ops/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/voy
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")

//DS9
/datum/gear/uniform/trek/cmd/ds9
	name = "DS9 uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/ds9
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster")

/datum/gear/uniform/trek/medsci/ds9
	name = "DS9 uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/ds9
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/uniform/trek/eng/ds9
	name = "DS9 uniform, ops/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/ds9
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")

//ENT
/datum/gear/uniform/trek/cmd/ent
	name = "ENT uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/ent
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster")

/datum/gear/uniform/trek/medsci/ent
	name = "ENT uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/ent
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/uniform/trek/eng/ent
	name = "ENT uniform, ops/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/ent
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")
