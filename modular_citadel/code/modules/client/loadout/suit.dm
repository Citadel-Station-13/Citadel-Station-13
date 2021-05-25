/datum/gear/suit
	category = LOADOUT_CATEGORY_SUIT
	subcategory = LOADOUT_SUBCATEGORY_SUIT_GENERAL
	slot = SLOT_WEAR_SUIT

/datum/gear/suit/poncho
	name = "Poncho"
	path = /obj/item/clothing/suit/poncho

/datum/gear/suit/ponchogreen
	name = "Green poncho"
	path = /obj/item/clothing/suit/poncho/green

/datum/gear/suit/ponchored
	name = "Red poncho"
	path = /obj/item/clothing/suit/poncho/red

/datum/gear/suit/redhood
	name = "Red cloak"
	path = /obj/item/clothing/suit/hooded/cloak/david
	cost = 3

/datum/gear/suit/jacketbomber
	name = "Bomber jacket"
	path = /obj/item/clothing/suit/jacket
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/jacketflannelblack // all of these are reskins of bomber jackets but with the vibe to make you look like a true lumberjack
	name = "Black flannel jacket"
	path = /obj/item/clothing/suit/jacket/flannel
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/jacketflannelred
	name = "Red flannel jacket"
	path = /obj/item/clothing/suit/jacket/flannel/red
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/jacketflannelaqua
	name = "Aqua flannel jacket"
	path = /obj/item/clothing/suit/jacket/flannel/aqua
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/jacketflannelbrown
	name = "Brown flannel jacket"
	path = /obj/item/clothing/suit/jacket/flannel/brown
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/jacketleather
	name = "Leather jacket"
	path = /obj/item/clothing/suit/jacket/leather
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/overcoatleather
	name = "Leather overcoat"
	path = /obj/item/clothing/suit/jacket/leather/overcoat
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/jacketpuffer
	name = "Puffer jacket"
	path = /obj/item/clothing/suit/jacket/puffer
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/vestpuffer
	name = "Puffer vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/jacketlettermanbrown
	name = "Brown letterman jacket"
	path = /obj/item/clothing/suit/jacket/letterman
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/jacketlettermanred
	name = "Red letterman jacket"
	path = /obj/item/clothing/suit/jacket/letterman_red
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/jacketlettermanNT
	name = "Nanotrasen letterman jacket"
	path = /obj/item/clothing/suit/jacket/letterman_nanotrasen
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/coat
	name = "Winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat
	subcategory = LOADOUT_SUBCATEGORY_SUIT_COATS

/datum/gear/suit/coat/aformal
	name = "Assistant's formal winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/aformal

/datum/gear/suit/coat/runed
	name = "Runed winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/narsie/fake

/datum/gear/suit/coat/brass
	name = "Brass winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/ratvar/fake

/datum/gear/suit/coat/polycoat
	name = "Polychromic winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/polychromic
	cost = 4 //too many people with neon green coats is hard on the eyes
	loadout_flags = LOADOUT_CAN_NAME | LOADOUT_CAN_DESCRIPTION | LOADOUT_CAN_COLOR_POLYCHROMIC
	loadout_initial_colors = list("#6A6964", "#C4B8A6", "#0000FF")

/datum/gear/suit/coat/wbreakpoly
	name = "Polychromic windbreaker"
	path = /obj/item/clothing/suit/toggle/wbreakpoly/polychromic
	cost = 4
	loadout_flags = LOADOUT_CAN_NAME | LOADOUT_CAN_DESCRIPTION | LOADOUT_CAN_COLOR_POLYCHROMIC
	loadout_initial_colors = list("#464F65", "#916035", "#474747")

/datum/gear/suit/coat/med
	name = "Medical winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/medical
	restricted_roles = list("Chief Medical Officer", "Medical Doctor") // Reserve it to Medical Doctors and their boss, the Chief Medical Officer

/datum/gear/suit/coat/paramedic
	name = "Paramedic winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/paramedic
	restricted_roles = list("Chief Medical Officer", "Paramedic") // Reserve it to Paramedics and their boss, the Chief Medical Officer

/datum/gear/suit/coat/robotics
	name = "Robotics winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/robotics
	restricted_roles = list("Research Director", "Roboticist")

/datum/gear/suit/coat/sci
	name = "Science winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/science
	restricted_roles = list("Research Director", "Scientist", "Roboticist") // Reserve it to the Science Departement

/datum/gear/suit/coat/eng
	name = "Engineering winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/engineering
	restricted_roles = list("Chief Engineer", "Station Engineer") // Reserve it to Station Engineers and their boss, the Chief Engineer

/datum/gear/suit/coat/eng/atmos
	name = "Atmospherics winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/engineering/atmos
	restricted_roles = list("Chief Engineer", "Atmospheric Technician") // Reserve it to Atmos Techs and their boss, the Chief Engineer

/datum/gear/suit/coat/hydro
	name = "Hydroponics winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/hydro
	restricted_roles = list("Head of Personnel", "Botanist") // Reserve it to Botanists and their boss, the Head of Personnel

/datum/gear/suit/coat/bar
	name = "Bar winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/bar
	restricted_roles = list("Bartender") // Reserve it to Bartenders and not the Head of Personnel because he doesnt deserve to look as fancy as them

/datum/gear/suit/coat/cargo
	name = "Cargo winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/cargo
	restricted_roles = list("Quartermaster", "Cargo Technician") // Reserve it to Cargo Techs and their boss, the Quartermaster

/datum/gear/suit/coat/miner
	name = "Mining winter coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/miner
	restricted_roles = list("Quartermaster", "Shaft Miner") // Reserve it to Miners and their boss, the Quartermaster

/datum/gear/suit/militaryjacket
	name = "Military Jacket"
	path = /obj/item/clothing/suit/jacket/miljacket
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/gear/suit/urbanjacket
	name = "Urban Jacket"
	path = /obj/item/clothing/suit/jacket/urbanjacket/polychromic
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS
	loadout_flags = LOADOUT_CAN_NAME | LOADOUT_CAN_DESCRIPTION | LOADOUT_CAN_COLOR_POLYCHROMIC
	loadout_initial_colors = list("#3B4B2E", "#CBBDAF", "#444444")

/datum/gear/suit/ianshirt
	name = "Ian Shirt"
	path = /obj/item/clothing/suit/ianshirt

/datum/gear/suit/flakjack
	name = "Flak Jacket"
	path = /obj/item/clothing/suit/flakjack
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS
	cost = 2

/datum/gear/suit/trekds9_coat
	name = "DS9 Overcoat (use uniform)"
	path = /obj/item/clothing/suit/storage/trek/ds9
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JOBS
	restricted_desc = "All, barring Service and Civilian"
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster",
							"Medical Doctor","Chemist","Virologist","Paramedic","Geneticist","Scientist", "Roboticist",
							"Atmospheric Technician","Station Engineer","Warden","Detective","Security Officer",
							"Cargo Technician", "Shaft Miner") //everyone who actually deserves a job.
//Federation jackets from movies
/datum/gear/suit/trekcmdcap
	name = "Fed (movie) uniform, Black"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/capt
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JOBS
	restricted_roles = list("Captain","Head of Personnel")

/datum/gear/suit/trekcmdmov
	name = "Fed (movie) uniform, Red"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JOBS
	restricted_desc = "Heads of Staff and Security"
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster","Warden","Detective","Security Officer")

/datum/gear/suit/trekmedscimov
	name = "Fed (movie) uniform, Blue"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/medsci
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JOBS
	restricted_desc = "Medical and Science"
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/suit/trekengmov
	name = "Fed (movie) uniform, Yellow"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/eng
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JOBS
	restricted_desc = "Engineering and Cargo"
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/gear/suit/trekcmdcapmod
	name = "Fed (Modern) uniform, White"
	path = /obj/item/clothing/suit/storage/fluff/modernfedcoat
	restricted_roles = list("Captain","Head of Personnel")

/datum/gear/suit/trekcmdmod
	name = "Fed (Modern) uniform, Red"
	path = /obj/item/clothing/suit/storage/fluff/modernfedcoat/sec
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JOBS
	restricted_desc = "Heads of Staff and Security"
	restricted_roles = list("Head of Security","Captain","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer","Quartermaster","Warden","Detective","Security Officer")

/datum/gear/suit/trekmedscimod
	name = "Fed (Modern) uniform, Blue"
	path = /obj/item/clothing/suit/storage/fluff/modernfedcoat/medsci
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JOBS
	restricted_desc = "Medical and Science"
	restricted_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Virologist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist")

/datum/gear/suit/trekengmod
	name = "Fed (Modern) uniform, Yellow"
	path = /obj/item/clothing/suit/storage/fluff/modernfedcoat/eng
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JOBS
	restricted_desc = "Engineering and Cargo"
	restricted_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer","Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/gear/suit/christmascoatr
	name = "Red Christmas Coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/christmascoatr
	subcategory = LOADOUT_SUBCATEGORY_SUIT_COATS

/datum/gear/suit/christmascoatg
	name = "Green Christmas Coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/christmascoatg
	subcategory = LOADOUT_SUBCATEGORY_SUIT_COATS

/datum/gear/suit/christmascoatrg
	name = "Red and Green Christmas Coat"
	path = /obj/item/clothing/suit/hooded/wintercoat/christmascoatrg
	subcategory = LOADOUT_SUBCATEGORY_SUIT_COATS

/datum/gear/suit/samurai
	name = "Samurai outfit"
	path = /obj/item/clothing/suit/samurai
