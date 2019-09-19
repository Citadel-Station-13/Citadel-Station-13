/**
 * See Uplink_items file for formating and vars
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/

// Tools
/datum/uplink_item/tools
	category = "Mil-Spec Tools"

//Non-Clown-Ops

//Non-Nuke-Ops

//Non-Any-Ops

/datum/uplink_item/tools/syndie_glue
	name = "Syndicate Glue"
	desc = "A cheap bottle of one use syndicate brand super glue. \
			Use on any item to make it undroppable. \
			Be careful not to glue an item you're already holding!"
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	item = /obj/item/syndie_glue
	cost = 4

//Clown-Ops-Only

/datum/uplink_item/tools/combatbananashoes
	name = "Combat Banana Shoes"
	desc = "While making the wearer immune to most slipping attacks like regular combat clown shoes, these shoes \
		can generate a large number of synthetic banana peels as the wearer walks, slipping up would-be pursuers. They also \
		squeak significantly louder."
	item = /obj/item/clothing/shoes/clown_shoes/banana_shoes/combat
	cost = 6
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

//Nuke-Ops-Only

/datum/uplink_item/tools/grenadier
	name = "Grenadier's belt"
	desc = "A belt for holding all the grenades you could ever want."
	item = /obj/item/storage/belt/grenade
	include_modes = list(/datum/game_mode/nuclear)
	cost = 2
	surplus = 0

//Both Ops

/datum/uplink_item/tools/magboots
	name = "Blood-Red Magboots"
	desc = "A pair of magnetic boots with a Syndicate paintjob that assist with freer movement in space or on-station \
			during gravitational generator failures. These reverse-engineered knockoffs of Nanotrasen's \
			'Advanced Magboots' slow you down in simulated-gravity environments much like the standard issue variety."
	item = /obj/item/clothing/shoes/magboots/syndie
	cost = 2
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

//Any-one

/datum/uplink_item/tools/thermal
	name = "Chameleon Thermal Imaging Glasses"
	desc = "These goggles can be turned to resemble common eyewear found throughout the station. \
			They allow you to see organisms through walls by capturing the upper portion of the infrared light spectrum, \
			emitted as heat and light by objects. Hotter objects, such as warm bodies, cybernetic organisms \
			and artificial intelligence cores emit more of this light than cooler objects like walls and airlocks."
	item = /obj/item/clothing/glasses/thermal/syndi
	cost = 4

/datum/uplink_item/tools/nightvision
	name = "Night Vision Goggles"
	desc = "Simple goggles that allow one to see in the dark. Incredibly useful for infiltration. This pair works for agents with nearsightedness "
	item = /obj/item/clothing/glasses/night/prescription
	cost = 1

/datum/uplink_item/tools/military_belt
	name = "Chest Rig"
	desc = "A robust seven-slot set of webbing that is capable of holding all manner of tactical equipment."
	item = /obj/item/storage/belt/military
	cost = 1

/datum/uplink_item/tools/toolbox
	name = "Full Syndicate Toolbox"
	desc = "A particularly heavy and robust toolbox. It comes loaded with a full tool set including a \
			multitool and combat gloves that are resistant to shocks and heat."
	item = /obj/item/storage/toolbox/syndicate
	cost = 1

/datum/uplink_item/tools/surgerybag
	name = "Syndicate Surgery Duffel Bag"
	desc = "The Syndicate surgery duffel bag is a toolkit containing all surgery tools, surgical drapes, \
			a Syndicate brand MMI, a straitjacket, and a muzzle."
	item = /obj/item/storage/backpack/duffelbag/syndie/med/surgery
	cost = 3

/datum/uplink_item/tools/surgerybag_adv
	name = "Advanced Syndicate Surgery Duffel Bag"
	desc = "The Syndicate surgery duffel bag is a toolkit containing all surgery tools, surgical drapes, \
			a Syndicate brand MMI, a straitjacket, a muzzle, and a full Syndicate Combat Medic Kit"
	item = /obj/item/storage/backpack/duffelbag/syndie/med/surgery_adv
	cost = 10

/datum/uplink_item/tools/soap
	name = "Syndicate Soap"
	desc = "A sinister-looking surfactant used to clean blood stains to hide murders and prevent DNA analysis. \
			You can also drop it underfoot to slip people."
	item = /obj/item/soap/syndie
	cost = 1
	surplus = 50

/datum/uplink_item/tools/stimpack
	name = "Stimpack"
	desc = "Stimpacks, the tool of many great heroes, make you nearly immune to stuns and knockdowns for about \
			5 minutes after injection."
	item = /obj/item/reagent_containers/syringe/stimulants
	cost = 4
	surplus = 90

/datum/uplink_item/tools/phantomthief
	name = "Syndicate Mask"
	desc = "A cheap plastic mask fitted with an adrenaline autoinjector, which can be used by simply tensing your muscles. \
			It will briefly allow you to attack much faster than you normally can. It has a 5 minute cooldown so use it wisely."
	item = /obj/item/clothing/glasses/phantomthief/syndicate
	cost = 2

/datum/uplink_item/tools/syndietome
	name = "Syndicate Tome"
	desc = "Using rare artifacts acquired at great cost, the Syndicate has reverse engineered \
			the seemingly magical books of a certain cult. Though lacking the esoteric abilities \
			of the originals, these inferior copies are still quite useful, being able to provide \
			both weal and woe on the battlefield, even if they do occasionally bite off a finger."
	item = /obj/item/storage/book/bible/syndicate
	cost = 7

/datum/uplink_item/tools/nutcracker
	name = "Nutcracker"
	desc = "An oversized version of what you'd initially expect here. Big enough to crush skulls."
	item = /obj/item/nutcracker
	cost = 1
