/datum/gear/head
	category = LOADOUT_CATEGORY_HEAD
	subcategory = LOADOUT_SUBCATEGORY_HEAD_GENERAL
	slot = ITEM_SLOT_HEAD

/datum/gear/head/baseball
	name = "Ballcap"
	path = /obj/item/clothing/head/soft/mime

/datum/gear/head/beanie
	name = "Beanie"
	path = /obj/item/clothing/head/beanie

/datum/gear/head/beret
	name = "Black beret"
	path = /obj/item/clothing/head/beret/black

/datum/gear/head/redberet
	name = "Red beret"
	path = /obj/item/clothing/head/beret

/datum/gear/head/purpleberet
	name = "Purple beret"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/head/blueberet
	name = "Blue beret"
	path = /obj/item/clothing/head/beret/blue

/datum/gear/head/flatcap
	name = "Flat cap"
	path = /obj/item/clothing/head/flatcap

/datum/gear/head/pirate
	name = "Pirate hat"
	path = /obj/item/clothing/head/pirate

/datum/gear/head/rice_hat
	name = "Rice hat"
	path = /obj/item/clothing/head/rice_hat

/datum/gear/head/ushanka
	path = /obj/item/clothing/head/ushanka

/datum/gear/head/slime
	name = "Slime hat"
	path = /obj/item/clothing/head/collectable/slime

/datum/gear/head/fedora
	name = "Fedora"
	path = /obj/item/clothing/head/fedora

/datum/gear/head/that
	name = "Top Hat"
	path = /obj/item/clothing/head/that

/datum/gear/head/maidband
	name = "Maid headband"
	path= /obj/item/clothing/head/maid

/datum/gear/head/maidband/poly
	name = "Polychromic maid headband"
	path= /obj/item/clothing/head/maid/polychromic
	loadout_flags = LOADOUT_CAN_NAME | LOADOUT_CAN_DESCRIPTION | LOADOUT_CAN_COLOR_POLYCHROMIC
	loadout_initial_colors = list("#333333", "#FFFFFF")

/datum/gear/head/flakhelm
	name = "Flak Helmet"
	path = /obj/item/clothing/head/flakhelm
	cost = 2

/datum/gear/head/bunnyears
	name = "Bunny Ears"
	path = /obj/item/clothing/head/rabbitears

/datum/gear/head/mailmanhat
	name = "Mailman's Hat"
	path = /obj/item/clothing/head/mailman

//trek fancy Hats!
/datum/gear/head/trekcap
	name = "Federation Officer's Cap (White)"
	path = /obj/item/clothing/head/caphat/formal/fedcover
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_roles = list("Captain","Head of Personnel")

/datum/gear/head/trekcapcap
	name = "Federation Officer's Cap (Black)"
	path = /obj/item/clothing/head/caphat/formal/fedcover/black
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_roles = list("Captain","Head of Personnel")

/datum/gear/head/trekcapmedisci
	name = "Federation Officer's Cap (Blue)"
	path = /obj/item/clothing/head/caphat/formal/fedcover/medsci
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_desc = "Medical and Science"
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/head/trekcapeng
	name = "Federation Officer's Cap (Yellow)"
	path = /obj/item/clothing/head/caphat/formal/fedcover/eng
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_desc = "Engineering, Security, and Cargo"
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/gear/head/trekcapsec
	name = "Federation Officer's Cap (Red)"
	path = /obj/item/clothing/head/caphat/formal/fedcover/sec
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_desc = "Engineering, Security, and Cargo"
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")

// orvilike "original" kepi
/datum/gear/head/orvkepicom
	name = "Federation Kepi, command"
	description = "A visored cap. Intended to be used with ORV uniform."
	path = /obj/item/clothing/head/kepi/orvi/command
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_desc = "Heads of Staff"
	restricted_roles = list("Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer", "Quartermaster")

/datum/gear/head/orvkepieng
	name = "Federation Kepi, eng"
	description = "A visored cap. Intended to be used with ORV uniform."
	path = /obj/item/clothing/head/kepi/orvi/eng
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_desc = "Engineering"
	restricted_roles = list("Chief Engineer", "Atmospheric Technician", "Station Engineer")

/datum/gear/head/orvkepisec
	name = "Federation Kepi, sec"
	description = "A visored cap. Intended to be used with ORV uniform."
	path = /obj/item/clothing/head/kepi/orvi/sec
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_desc = "Security"
	restricted_roles = list("Warden", "Detective", "Security Officer", "Head of Security")

/datum/gear/head/orvkepimedsci
	name = "Federation Kepi, medsci"
	description = "A visored cap. Intended to be used with ORV uniform."
	path = /obj/item/clothing/head/kepi/orvi/medsci
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_desc = "Medical and Science"
	restricted_roles = list("Chief Medical Officer", "Medical Doctor", "Chemist", "Virologist", "Paramedic", "Geneticist", "Research Director", "Scientist", "Roboticist")

/datum/gear/head/orvkepisrv
	name = "Federation Kepi, service"
	description = "A visored cap. Intended to be used with ORV uniform."
	path = /obj/item/clothing/head/kepi/orvi/service
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_desc = "Service, Cargo and Civilian, barring Clown, Mime and Lawyer"
	restricted_roles = list("Bartender", "Botanist", "Cook", "Curator", "Janitor", "Chaplain", "Cargo Technician", "Shaft Miner")

/datum/gear/head/orvkepiass
	name = "Federation Kepi, assistant"
	description = "A visored cap. Intended to be used with ORV uniform."
	path = /obj/item/clothing/head/kepi/orvi
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_roles = list("Assistant")

/*Commenting out Until next Christmas or made automatic
/datum/gear/santahatr
	name = "Red Santa Hat"
	category = ITEM_SLOT_HEAD
	path = /obj/item/clothing/head/christmashat

/datum/gear/santahatg
	name = "Green Santa Hat"
	category = ITEM_SLOT_HEAD
	path = /obj/item/clothing/head/christmashatg
*/

//Cowboy Stuff
/datum/gear/head/cowboyhat
	name = "Cowboy Hat, Brown"
	path = /obj/item/clothing/head/cowboyhat

/datum/gear/head/cowboyhat/black
	name = "Cowboy Hat, Black"
	path = /obj/item/clothing/head/cowboyhat/black

/datum/gear/head/cowboyhat/white
	name = "Cowboy Hat, White"
	path = /obj/item/clothing/head/cowboyhat/white

/datum/gear/head/cowboyhat/pink
	name = "Cowboy Hat, Pink"
	path = /obj/item/clothing/head/cowboyhat/pink

/datum/gear/head/cowboyhat/sec
	name = "Cowboy Hat, Security"
	path = /obj/item/clothing/head/cowboyhat/sec
	subcategory = LOADOUT_SUBCATEGORY_HEAD_JOBS
	restricted_desc = "Security"
	restricted_roles = list("Warden","Detective","Security Officer","Head of Security")

/datum/gear/head/cowboyhat/polychromic
	name = "Cowboy Hat, Polychromic"
	path = /obj/item/clothing/head/cowboyhat/polychromic
	loadout_flags = LOADOUT_CAN_NAME | LOADOUT_CAN_DESCRIPTION | LOADOUT_CAN_COLOR_POLYCHROMIC
	loadout_initial_colors = list("#5F5F5F", "#DDDDDD")

/datum/gear/head/wkepi
	name = "white kepi"
	path = /obj/item/clothing/head/kepi

/datum/gear/head/widered
	name = "Wide red hat"
	path = /obj/item/clothing/head/widered

/datum/gear/head/kabuto
	name = "Kabuto helmet"
	path = /obj/item/clothing/head/kabuto
