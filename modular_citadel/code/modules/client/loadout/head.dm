/datum/gear/baseball
	name = "Ballcap"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/soft/mime

/datum/gear/beanie
	name = "Beanie"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/beanie

/datum/gear/beret
	name = "Black beret"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/beret/black

/datum/gear/flatcap
	name = "Flat cap"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/flatcap

/datum/gear/pirate
	name = "Pirate hat"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/pirate

/datum/gear/rice_hat
	name = "Rice hat"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/rice_hat

/datum/gear/ushanka
	name = "Ushanka"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/ushanka

/datum/gear/slime
	name = "Slime hat"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/collectable/slime

/datum/gear/fedora
	name = "Fedora"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/fedora

/datum/gear/that
	name = "Top Hat"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/that

/datum/gear/flakhelm
	name = "Flak Helmet"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/flakhelm
	cost = 2

/datum/gear/bunnyears
	name = "Bunny Ears"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/rabbitears

/datum/gear/mailmanhat
	name = "Mailman's Hat"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/mailman

//trek fancy Hats!
/datum/gear/trekcap
	name = "Federation Officer's Cap (White)"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/caphat/formal/fedcover
	restricted_roles = list("Captain","Head of Personnel")

/datum/gear/trekcapcap
	name = "Federation Officer's Cap (Black)"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/caphat/formal/fedcover/black
	restricted_roles = list("Captain","Head of Personnel")

/datum/gear/trekcapmedisci
	name = "Federation Officer's Cap (Blue)"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/caphat/formal/fedcover/medsci
	restricted_desc = "Medical and Science"
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/trekcapeng
	name = "Federation Officer's Cap (Yellow)"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/caphat/formal/fedcover/eng
	restricted_desc = "Engineering, Security, and Cargo"
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/gear/trekcapsec
	name = "Federation Officer's Cap (Red)"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/caphat/formal/fedcover/sec
	restricted_desc = "Engineering, Security, and Cargo"
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer","Head of Security","Cargo Technician", "Shaft Miner", "Quartermaster")

// orvilike "original" kepi
/datum/gear/orvkepicom
	name = "Federation Kepi, command"
	description = "A visored cap. Intended to be used with ORV uniform."
	category = SLOT_HEAD
	path = /obj/item/clothing/head/kepi/orvi/command
	restricted_desc = "Heads of Staff"
	restricted_roles = list("Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer", "Quartermaster")

/datum/gear/orvkepiops
	name = "Federation Kepi, ops/sec"
	description = "A visored cap. Intended to be used with ORV uniform."
	category = SLOT_HEAD
	path = /obj/item/clothing/head/kepi/orvi/engsec
	restricted_desc = "Engineering, Security and Cargo"
	restricted_roles = list("Chief Engineer", "Atmospheric Technician", "Station Engineer", "Warden", "Detective", "Security Officer", "Head of Security", "Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/gear/orvkepimedsci
	name = "Federation Kepi, medsci"
	description = "A visored cap. Intended to be used with ORV uniform."
	category = SLOT_HEAD
	path = /obj/item/clothing/head/kepi/orvi/medsci
	restricted_desc = "Medical and Science"
	restricted_roles = list("Chief Medical Officer", "Medical Doctor", "Chemist", "Virologist", "Paramedic", "Geneticist", "Research Director", "Scientist", "Roboticist")

/datum/gear/orvkepisrv
	name = "Federation Kepi, service"
	description = "A visored cap. Intended to be used with ORV uniform."
	category = SLOT_HEAD
	path = /obj/item/clothing/head/kepi/orvi/service
	restricted_desc = "Service and Civilian, barring Clown, Mime and Lawyer"
	restricted_roles = list("Assistant", "Bartender", "Botanist", "Cook", "Curator", "Janitor", "Chaplain")

/datum/gear/orvkepiass
	name = "Federation Kepi, assistant"
	description = "A visored cap. Intended to be used with ORV uniform."
	category = SLOT_HEAD
	path = /obj/item/clothing/head/kepi/orvi
	restricted_roles = list("Assistant")

/*Commenting out Until next Christmas or made automatic
/datum/gear/santahatr
	name = "Red Santa Hat"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/christmashat

/datum/gear/santahatg
	name = "Green Santa Hat"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/christmashatg
*/

//Cowboy Stuff
/datum/gear/cowboyhat
	name = "Cowboy Hat, Brown"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/cowboyhat

/datum/gear/cowboyhat/black
	name = "Cowboy Hat, Black"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/cowboyhat/black

/datum/gear/cowboyhat/white
	name = "Cowboy Hat, White"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/cowboyhat/white

/datum/gear/cowboyhat/pink
	name = "Cowboy Hat, Pink"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/cowboyhat/pink

/datum/gear/cowboyhat/sec
	name = "Cowboy Hat, Security"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/cowboyhat/sec
	restricted_desc = "Security"
	restricted_roles = list("Warden","Detective","Security Officer","Head of Security")

// Misc
/datum/gear/wkepi
	name = "white kepi"
	category = SLOT_HEAD
	path = /obj/item/clothing/head/kepi
