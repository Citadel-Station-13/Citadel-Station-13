//Moved Maint Loot and other assorted bounties to silly.dm

/datum/bounty/item/assistant/scooter
	name = "Scooter"
	description = "Nanotrasen has determined walking to be wasteful. Ship a scooter to CentCom to speed operations up."
	reward = 900 // the mat hoffman
	wanted_types = list(/obj/vehicle/ridden/scooter)
	include_subtypes = FALSE

/datum/bounty/item/assistant/skateboard
	name = "Skateboard"
	description = "Nanotrasen has determined walking to be wasteful. Ship a skateboard to CentCom to speed operations up."
	reward = 800 // the tony hawk
	wanted_types = list(/obj/vehicle/ridden/scooter/skateboard)

/datum/bounty/item/assistant/stunprod
	name = "Stunprod"
	description = "CentCom demands a stunprod to use against dissidents. Craft one, then ship it."
	reward = 950
	wanted_types = list(/obj/item/melee/baton/cattleprod)

/datum/bounty/item/assistant/soap
	name = "Soap"
	description = "Soap has gone missing from CentCom's bathrooms and nobody knows who took it. Replace it and be the hero CentCom needs."
	reward = 1200
	required_count = 3 //You can (apparently) get soap from the mining rewards vendor.
	wanted_types = list(/obj/item/soap)

/datum/bounty/item/assistant/spear
	name = "Spears"
	description = "CentCom's security forces are going through budget cuts. You will be paid if you ship a set of spears."
	reward = 1000
	required_count = 5
	wanted_types = list(/obj/item/spear)

/datum/bounty/item/assistant/toolbox
	name = "Toolboxes"
	description = "There's an absence of robustness at Central Command. Hurry up and ship some toolboxes as a solution."
	reward = 1000
	required_count = 6
	wanted_types = list(/obj/item/storage/toolbox)

/datum/bounty/item/assistant/statue
	name = "Statue"
	description = "Central Command would like to commision an artsy statue for the lobby. Ship one out, when possible."
	reward = 2000
	wanted_types = list(/obj/structure/statue)

/datum/bounty/item/assistant/cheesiehonkers
	name = "Cheesie Honkers"
	description = "Apparently the company that makes Cheesie Honkers is going out of business soon. CentCom wants to stock up before it happens!"
	reward = 1000
	required_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/cheesiehonkers)

/datum/bounty/item/assistant/baseball_bat
	name = "Baseball Bat"
	description = "Baseball fever is going on at CentCom! Be a dear and ship them some baseball bats, so that management can live out their childhood dream."
	reward = 1000
	required_count = 5
	wanted_types = list(/obj/item/melee/baseball_bat)

/datum/bounty/item/assistant/extendohand
	name = "Extendo-Hand"
	description = "Commander Betsy is getting old, and can't bend over to get the telescreen remote anymore. Management has requested an extendo-hand to help her out."
	reward = 1250
	wanted_types = list(/obj/item/extendohand)

// /datum/bounty/item/assistant/donut
// 	name = "Donuts"
// 	description = "CentCom's security forces are facing heavy losses against the Syndicate. Ship donuts to raise morale."
// 	reward = 2000
// 	required_count = 10
// 	wanted_types = list(/obj/item/reagent_containers/food/snacks/donut)

// /datum/bounty/item/assistant/donkpocket
// 	name = "Donk-Pockets"
// 	description = "Consumer safety recall: Warning. Donk-Pockets manufactured in the past year contain hazardous lizard biomatter. Return units to CentCom immediately."
// 	reward = 1000
// 	required_count = 10
// 	wanted_types = list(/obj/item/reagent_containers/food/snacks/donkpocket)

/datum/bounty/item/assistant/briefcase
	name = "Briefcase"
	description = "Central Command will be holding a business convention this year. Ship a few briefcases in support."
	reward = 1200
	required_count = 3
	wanted_types = list(/obj/item/storage/briefcase, /obj/item/storage/secure/briefcase)

/datum/bounty/item/assistant/monkey_hide
	name = "Monkey Hide"
	description = "One of the scientists at CentCom is interested in testing products on monkey skin. Your mission is to acquire monkey's hide and ship it."
	reward = 1250
	required_count = 3
	wanted_types = list(/obj/item/stack/sheet/animalhide/monkey)

/datum/bounty/item/assistant/shard
	name = "Shards"
	description = "A killer clown has been stalking CentCom, and staff have been unable to catch her because she's not wearing shoes. Please ship some shards so that a booby trap can be constructed."
	reward = 750
	required_count = 15
	wanted_types = list(/obj/item/shard)

/datum/bounty/item/assistant/comfy_chair
	name = "Comfortable Chairs"
	description = "Commander Pat is unhappy with his chair. He claims it hurts his back. Ship some alternatives out to humor him."
	reward = 900
	required_count = 5
	wanted_types = list(/obj/structure/chair/comfy)

/*
/datum/bounty/item/assistant/geranium
 	name = "Geraniums"
 	description = "Commander Zot has the hots for Commander Zena. Send a shipment of geraniums - her favorite flower - and he'll happily reward you."
 	reward = 1000
 	required_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/grown/poppy/geranium)
	include_subtypes = FALSE
*/

/datum/bounty/item/assistant/poppy
	name = "Poppies"
	description = "Commander Zot really wants to sweep Security Officer Olivia off her feet. Send a shipment of Poppies - her favorite flower - and he'll happily reward you."
	reward = 1000
	required_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/grown/poppy)
	include_subtypes = FALSE

/datum/bounty/item/assistant/shadyjims
	name = "Shady Jim's"
	description = "There's an irate officer at CentCom demanding that he receive a box of Shady Jim's cigarettes. Please ship one. He's starting to make threats."
	reward = 1150
	wanted_types = list(/obj/item/storage/fancy/cigarettes/cigpack_shadyjims)

/datum/bounty/item/assistant/potted_plants
	name = "Potted Plants"
	description = "Central Command is looking to commission a new BirdBoat-class station. You've been ordered to supply the potted plants."
	reward = 2000
	required_count = 8
	wanted_types = list(/obj/item/kirbyplants)

// /datum/bounty/item/assistant/earmuffs
// 	name = "Earmuffs"
// 	description = "Central Command is getting tired of your station's messages. They've ordered that you ship some earmuffs to lessen the annoyance."
// 	reward = 1000
// 	wanted_types = list(/obj/item/clothing/ears/earmuffs)

/datum/bounty/item/assistant/cuffs
	name = "Handcuffs"
	description = "A large influx of escaped convicts have arrived at Central Command. Now is the perfect time to ship out spare handcuffs (or restraints)."
	reward = 1000
	required_count = 5
	wanted_types = list(/obj/item/restraints/handcuffs)
/* I don't like that you can just buy a box of monkey cubes and finish this for -half- of them.
/datum/bounty/item/assistant/monkey_cubes
	name = "Monkey Cubes"
	description = "Due to a recent genetics accident, Central Command is in serious need of monkeys. Your mission is to ship monkey cubes."
	reward = 2000
	required_count = 3
	wanted_types = list(/obj/item/reagent_containers/food/snacks/monkeycube)
*/

/datum/bounty/item/assistant/ied
	name = "IED"
	description = "Nanotrasen's maximum security prison at CentCom is undergoing personnel training. Ship a handful of IEDs to serve as a training tools."
	reward = 2000
	required_count = 3
	wanted_types = list(/obj/item/grenade/iedcasing)

/datum/bounty/item/assistant/corgimeat
	name = "Raw Corgi Meat"
	description = "The Syndicate recently stole all of CentCom's corgi meat. Ship out a replacement immediately."
	reward = 3000
	wanted_types = list(/obj/item/reagent_containers/food/snacks/meat/slab/corgi)

/datum/bounty/item/assistant/bolas
	name = "Bolas"
	description = "Centcom's chef has lost their mind. They're streaking naked though the halls, greased up with butter and cooking oil. Send some bola's so we can capture them."
	reward = 1000
	required_count = 3
	wanted_types = list(/obj/item/restraints/legcuffs/bola)

/datum/bounty/item/assistant/metalshields
	name = "Metal Shields" //I didnt realise how much work it was to make these, you need 2 Cloth, 3 Leather, Tools, 10 Metal, and a Cable Coil Stack for each one.
	description = "NT is testing the effects of electricity on clowns wielding metal shields. We have clowns, and we have electricity. Send us the shields."
	reward = 3000
	required_count = 2
	wanted_types = list(/obj/item/shield/makeshift)

/datum/bounty/item/assistant/toolbelts
	name = "Tool Belts" //Made it 5 so you can't just buy one set of toolbelts to finish the bounty.
	description = "These things always seem to go missing. Ship us a few to help us restock."
	reward = 1350
	required_count = 5
	wanted_types = list(/obj/item/storage/belt/utility)

/datum/bounty/item/assistant/gasmasks
	name = "Gas Masks"
	description = "The good news is that we have more miasma than we'll ever need. The bad news is, somone opened the release valve on the canisters. Ship us some gas masks!"
	reward = 1250
	required_count = 4
	wanted_types = list(/obj/item/clothing/mask/gas)

/datum/bounty/item/assistant/pneumatic_cannon
	name = "Pneumatic Cannons"
	description = "Have you ever launched a tennis ball, newspaper, or ***** at someones head from across the room? No? We haven't either. Help us rectify this."
	reward = 2000
	required_count = 2
	wanted_types = list(/obj/item/pneumatic_cannon/ghetto)
