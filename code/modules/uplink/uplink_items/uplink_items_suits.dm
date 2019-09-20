/**
 * See Uplink_items file for formating and vars
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/

//Armor and EVA Gear
/datum/uplink_item/suits
	category = "Uniforms, Armor, and Space Suits"
	surplus = 40

//Non-Clown-Ops

//Non-Nuke-Ops

/datum/uplink_item/suits/hardsuit
	name = "Syndicate Hardsuit"
	desc = "The feared suit of a Syndicate nuclear agent. Features slightly better armoring and a built in jetpack \
			that runs off standard atmospheric tanks. Toggling the suit in and out of \
			combat mode will allow you all the mobility of a loose fitting uniform without sacrificing armoring. \
			Additionally the suit is collapsible, making it small enough to fit within a backpack. \
			Nanotrasen crew who spot these suits are known to panic."
	item = /obj/item/clothing/suit/space/hardsuit/syndi
	cost = 8
	exclude_modes = list(/datum/game_mode/nuclear)

//Non-Any-Ops

/datum/uplink_item/suits/turtlenck_skirt
	name = "Tactical Skirtleneck"
	desc = "A weakly armored skirt that does not have sensors attatched. Be warned that most crewmembers are quick to call out such clothing."
	item = /obj/item/clothing/under/syndicate/skirt
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops) //They already get these

/datum/uplink_item/suits/turtlenck
	name = "Tactical Turtleneck"
	desc = "A weakly armored suit that does not have sensors attatched. Be warned that most crewmembers are quick to call out such clothing."
	item = /obj/item/clothing/under/syndicate
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops) //They already get these

/datum/uplink_item/suits/padding
	name = "Soft Padding"
	desc = "Padding that can be stuffed into a jumpsuit to help protect against melee attacks."
	item = /obj/item/clothing/accessory/padding
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/suits/kevlar
	name = "Kevlar Padding"
	desc = "Kevlar Padding that can be stuffed into a jumpsuit to help protect against bullet impacts."
	item = /obj/item/clothing/accessory/kevlar
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/suits/plastic
	name = "Plastic Padding"
	desc = "Plastic Padding that can be stuffed into a jumpsuit to help protect against energy and laser impacts."
	item = /obj/item/clothing/accessory/plastics
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

//Clown-Ops-Only

//Nuke-Ops-Only

/datum/uplink_item/suits/hardsuit/nukeop
	cost = 5
	include_modes = list(/datum/game_mode/nuclear) //cheaper for ops

//Both Ops

/datum/uplink_item/suits/hardsuit/elite
	name = "Elite Syndicate Hardsuit"
	desc = "An upgraded, elite version of the Syndicate hardsuit. It features fireproofing, and also \
			provides the user with superior armor and mobility compared to the standard Syndicate hardsuit."
	item = /obj/item/clothing/suit/space/hardsuit/syndi/elite
	cost = 8
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/suits/hardsuit/shielded
	name = "Shielded Syndicate Hardsuit"
	desc = "An improved version of the standard Syndicate hardsuit. It features an advanced built-in energy shielding system. \
			The shields can handle up to three impacts within a short duration and will rapidly recharge while not under fire."
	item = /obj/item/clothing/suit/space/hardsuit/shielded/syndi
	cost = 30
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

//Any-one

/datum/uplink_item/suits/space_suit
	name = "Syndicate Space Suit"
	desc = "This black and red Syndicate space suit is less encumbering than Nanotrasen variants, \
			fitting inside bags, and being able to hold weapons. While fairly subtle in coloration, perceptive crew members will be quick to call it out."
	item = /obj/item/storage/box/syndie_kit/space
	cost = 4