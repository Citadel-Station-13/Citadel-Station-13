
/*
	Uplink Items:
	Unlike categories, uplink item entries are automatically sorted alphabetically on server init in a global list,
	When adding new entries to the file, please keep them sorted by category.
*/

//Space Suits and Hardsuits

/datum/uplink_item/suits/turtlenck
	name = "Tactical Turtleneck"
	desc = "A slightly armored conspicious jumpsuit that has no suit sensors attached to them, if someone sees you in this hope they think its a fake."
	item = /obj/item/clothing/under/syndicate
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops) //They already get these

/datum/uplink_item/suits/turtlenck_skirt
	name = "Tactical Skirtleneck"
	desc = "A slightly armored conspicious jumpsuit that has no suit sensors attached to them, if someone sees you in this hope they think its a fake."
	item = /obj/item/clothing/under/syndicate/skirt
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops) //They already get these

/datum/uplink_item/suits/padding
	name = "Soft Padding"
	desc = "An inconspicious soft padding meant to be worn underneath jumpsuits, will cushion the user from melee harm."
	item = /obj/item/clothing/accessory/padding
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/suits/kevlar
	name = "Kevlar Padding"
	desc = "An inconspicious kevlar padding meant to be worn underneath jumpsuits, will cushion the wearer from ballistic harm."
	item = /obj/item/clothing/accessory/kevlar
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/suits/plastic
	name = "Ablative Padding"
	desc = "An inconspicious ablative padding meant to be worn underneath jumpsuits, will cushion the wearer from energy lasers harm."
	item = /obj/item/clothing/accessory/plastics
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/suits/space_suit
	name = "Syndicate Space Suit"
	desc = "This red and black Syndicate space suit is less encumbering than Nanotrasen variants, \
			fits inside bags, and has a weapon slot. Nanotrasen crew members are trained to report red space suit \
			sightings, however."
	item = /obj/item/storage/box/syndie_kit/space
	cost = 4

/datum/uplink_item/suits/hardsuit
	name = "Syndicate Hardsuit"
	desc = "The feared suit of a Syndicate nuclear agent. Features slightly better armoring and a built in jetpack \
			that runs off standard atmospheric tanks. Toggling the suit in and out of \
			combat mode will allow you all the mobility of a loose fitting uniform without sacrificing armoring. \
			Additionally the suit is collapsible, making it small enough to fit within a backpack. \
			Nanotrasen crew who spot these suits are known to panic."
	item = /obj/item/clothing/suit/space/hardsuit/syndi
	cost = 8
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops) //you can't buy it in nuke, because the elite hardsuit costs the same while being better

/datum/uplink_item/suits/hardsuit/elite
	name = "Elite Syndicate Hardsuit"
	desc = "An upgraded, elite version of the Syndicate hardsuit. It features fireproofing, and also \
			provides the user with superior armor and mobility compared to the standard Syndicate hardsuit."
	item = /obj/item/clothing/suit/space/hardsuit/syndi/elite
	cost = 8
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	exclude_modes = list()

/datum/uplink_item/suits/hardsuit/shielded
	name = "Shielded Syndicate Hardsuit"
	desc = "An upgraded version of the standard Syndicate hardsuit. It features a built-in energy shielding system. \
			The shields can handle up to three impacts within a short duration and will rapidly recharge while not under fire."
	item = /obj/item/clothing/suit/space/hardsuit/shielded/syndi
	cost = 30
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	exclude_modes = list()

/datum/uplink_item/suits/thiefgloves
	name = "Thieving Gloves"
	desc = "A pair of gloves that are insulated and frictionless, allowing you to steal easily from anyone you see."
	item = /obj/item/clothing/gloves/thief
	cost = 4

/datum/uplink_item/suits/wallwalkers
	name = "Wall Walking Boots"
	desc = "Through bluespace magic stolen from an organisation that hoards technology, these boots simply allow you to slip through the atoms that make up anything, but only while walking, for safety reasons. As well as this, they unfortunately cause minor breath loss as the majority of atoms in your lungs are sucked out into any solid object you walk through."
	item = /obj/item/clothing/shoes/wallwalkers
	cost = 6

/datum/uplink_item/device_tools/guerillagloves
	name = "Guerilla Gloves"
	desc = "A pair of highly robust combat gripper gloves that excels at performing takedowns at close range, with an added lining of insulation. Careful not to hit a wall!"
	item = /obj/item/clothing/gloves/tackler/combat/insulated
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	cost = 2
