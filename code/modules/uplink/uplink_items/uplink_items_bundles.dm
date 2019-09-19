/**
 * See Uplink_items file for formating and vars
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/

//All bundles and telecrystals
/datum/uplink_item/bundles_TC
	category = "Bundles and Telecrystals"
	surplus = 0
	cant_discount = TRUE

//Non-Clown-Ops

//Non-Nuke-Ops

//Non-Any-Ops

/datum/uplink_item/bundles_TC/bundle
	name = "Syndicate Bundle"
	desc = "Syndicate Bundles are specialized groups of items that arrive in a plain box. \
			These items are collectively worth more than 20 telecrystals, but you do not know which specialization \
			you will receive. May contain discontinued and/or exotic items."
	item = /obj/item/storage/box/syndicate
	cost = 20
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/bundles_TC/surplus
	name = "Syndicate Surplus Crate"
	desc = "A dusty crate from the back of the Syndicate warehouse. Rumored to contain a valuable assortment of items, \
			but you never know. Contents are sorted to always be worth 50 TC."
	item = /obj/structure/closet/crate
	cost = 20
	player_minimum = 25
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	var/starting_crate_value = 50

/datum/uplink_item/bundles_TC/surplus/super
	name = "Super Surplus Crate"
	desc = "A dusty SUPER-SIZED from the back of the Syndicate warehouse. Rumored to contain a valuable assortment of items, \
			but you never know. Contents are sorted to always be worth 125 TC."
	cost = 40
	player_minimum = 40
	starting_crate_value = 125

/datum/uplink_item/bundles_TC/surplus/purchase(mob/user, datum/component/uplink/U)
	var/list/uplink_items = get_uplink_items(SSticker && SSticker.mode? SSticker.mode : null, FALSE)

	var/crate_value = starting_crate_value
	var/obj/structure/closet/crate/C = spawn_item(/obj/structure/closet/crate, user, U)
	if(U.purchase_log)
		U.purchase_log.LogPurchase(C, src, cost)
	while(crate_value)
		var/category = pick(uplink_items)
		var/item = pick(uplink_items[category])
		var/datum/uplink_item/I = uplink_items[category][item]

		if(!I.surplus || prob(100 - I.surplus))
			continue
		if(crate_value < I.cost)
			continue
		crate_value -= I.cost
		var/obj/goods = new I.item(C)
		if(U.purchase_log)
			U.purchase_log.LogPurchase(goods, I, 0)
	return C

//Clown-Ops-Only

//Nuke-Ops-Only

/datum/uplink_item/bundles_TC/assault
	name = "Assault Trooper Kit"
	desc = "Be the man on the front lines with this robust kit. Includes a c-20r with two spare magazines, \
			an energy sshield, two flashbangs, an EMP grenade, a fragmentation grenade, two X-4, and thermal glasses."
	item = /obj/item/storage/backpack/duffelbag/syndie/assault
	cost = 25 //Worth 43
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/shredder
	name = "Shredder Kit"
	desc = "A truly horrific weapon designed simply to maim its victim, the CX Shredder is banned by several intergalactic treaties. \
			This kit contains one CX Shredder with an assortment of six spare magazines, two fragmentation grenades, a stimulants injector, and a bar of soap."
	item = /obj/item/storage/backpack/duffelbag/syndie/cqc
	cost = 25 //Worth 41
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/knight
	name = "Energy Knight Kit"
	desc = "Hack and slash with close quarters energy weaponry. Includes an energy sword, an energy shield, \
			a CNS Rebooter implant, no slip shoes, and an adrenals implanter."
	item = /obj/item/storage/backpack/duffelbag/syndie/knight
	cost = 25 //Worth 42
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/cqc
	name = "Close Quarters Combat Kit"
	desc = "Reign supreme in hand to hand combat with this kit. Includes a CQC manual, gloves of the north star \
			an adrenal mask, throwing weapons, a cryptographic sequencer, a bluespace launchpad, soap, and an EMP implanter."
	item = /obj/item/storage/backpack/duffelbag/syndie/cqc
	cost = 25 //Worth 39
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/sniper
	name = "Sniper Kit"
	desc = "A specialist kit for long ranged assassinations. Includes a syndicate .50 caliber sniper rifle, with an assortment of three magazines, \
			a sharp-looking tactical turtleneck suit and tie, a suppressor, an energy dagger, and a door charge."
	item = /obj/item/storage/briefcase/sniperbundle
	cost = 25 //Worth 40
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/infiltrator
	name = "Infiltration Kit"
	desc = "Sneak behind enemy lines and complete key objectives for your team. Includes an additional stechkin pistol, two suppressors, four 10mm magazines, \
			a switchblade, two smoke grenades, a cryptographic sequencer with a spare recharger, a camera bug, a radio jammer, an AI detector, and a stealth implanter."
	item = /obj/item/storage/backpack/duffelbag/syndie/infiltrator
	cost = 25 //Worth 39
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/medic
	name = "Combat Medic Kit"
	desc = "Keep your allies in the fight with this medical kit. Includes a medibeam gun, an advanced health analyzer, \
			a c-20r with two spare 10mm SMG magazines, omnizine laced cigarettes, and a tactical medkit."
	item = /obj/item/storage/backpack/duffelbag/syndie/med/combatmedic
	cost = 25 //Worth ~37
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/engineer
	name = "Combat Engineer Kit"
	desc = "Keep your silicon and mechanized allies alive with this engineering kit. Includes a chest rig full of engineering goodies, \
			magboots, a binary encryption key, an EMP flashlight, a bulldog with two spare drums, \
			a grenade full of manhacks, two C-4 charges, and two X-4 charges."
	item = /obj/item/storage/backpack/duffelbag/syndie/engineer
	cost = 25 //Worth ~36
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/grenadier
	name = "Grenadier's Belt"
	desc = "KABOOM BABY! Includes a grenade belt jam packed with a serious arsenal of explosives. Includes 10 fragmentation grenades, two minibombs \
			two flashbangs, two emp grenades, two incendiary grenades, four smoke grenades, four gluon grenades, an acid grenades, and a screwdriver and multitool \
			for modifying them. An EXCEPTIONAL value."
	item = /obj/item/storage/belt/grenade/full
	cost = 25 //Worth ~90. Sounds like a lot but hasn't been a balance issue thus far.
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/heavy
	name = "Heavy Weapons Specialist Kit"
	desc = "Provide your allies with covering fire with this specialist kit. Includes the L6 SAW along with two magazines, just in case, \
			an elite syndicate hardsuit for absorbing more damage, one incendiary grenade, one minibomb, and two flashbangs for crowd control."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/heavy
	cost = 25 //Worth 42
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/bioterror
	name = "Bioterrorist Kit"
	desc = "An incredibly dangerous kit for biological warfare. Handle with care. Includes a handheld bioterror chem sprayer, a dart gun, \
			a poison kit, a bioterror kit, and the terrifying Fungal Tuberculosis kit. Seal suit and internals before use."
	item = /obj/item/storage/backpack/duffelbag/syndie/bioterror
	cost = 25 //Worth 44!
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/pyro
	name = "Pyromaniac Kit"
	desc = "Set the station on fire with this dangerous kit. Includes a plasma flamethrower with a spare tank, \
			a VP78 machine pistol with three spare magazines, two of them incendiary, three incendiary grenades, a syringe of stimulants, \
			and a fireproof elite syndicate hardsuit to keep you safe from the flames. We are not responsible for any friendly fire that results from the purchase of this kit."
	item = /obj/item/storage/backpack/duffelbag/syndie/pyro
	cost = 25 //Worth 39
	include_modes = list(/datum/game_mode/nuclear)

//Both Ops

/datum/uplink_item/bundles_TC/donk
	name = "Donksoft Kit"
	desc = "A kit chalk full of harmless fun! Includes a toy riot submachine gun, with three extra boxes of riot darts, \
			soap, a fake nuke disk, a syndicate sentience potion, playing cards, a beenade, and a broken chameleon kit."
	item = /obj/item/storage/backpack/duffelbag/syndie/donk
	cost = 25 //Worth 43
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

//Any-one

/datum/uplink_item/bundles_TC/modular
	name = "Modular Pistol Kit"
	desc = "A heavy briefcase containing one modular pistole (chambered in 10mm), one suppressor, and spare ammunition, \
			including a box of soporific ammo. Includes a suit jacket padded with robust liner."
	item = /obj/item/storage/briefcase/modularbundle
	cost = 12

/datum/uplink_item/bundles_TC/random
	name = "Random Item"
	desc = "Picking this will purchase a random item. Useful if you have some TC to spare or if you haven't decided on a strategy yet."
	item = /obj/effect/gibspawner/generic // non-tangible item because techwebs use this path to determine illegal tech
	cost = 0

/datum/uplink_item/bundles_TC/random/purchase(mob/user, datum/component/uplink/U)
	var/list/uplink_items = U.uplink_items
	var/list/possible_items = list()
	for(var/category in uplink_items)
		for(var/item in uplink_items[category])
			var/datum/uplink_item/I = uplink_items[category][item]
			if(src == I || !I.item)
				continue
			if(U.telecrystals < I.cost)
				continue
			if(I.limited_stock == 0)
				continue
			possible_items += I

	if(possible_items.len)
		var/datum/uplink_item/I = pick(possible_items)
		SSblackbox.record_feedback("tally", "traitor_random_uplink_items_gotten", 1, initial(I.name))
		U.MakePurchase(user, I)

/datum/uplink_item/bundles_TC/telecrystal
	name = "1 Raw Telecrystal"
	desc = "A telecrystal in its rawest and purest form; can be utilized on active uplinks to increase their telecrystal count."
	item = /obj/item/stack/telecrystal
	cost = 1
	surplus = 0
	// Don't add telecrystals to the purchase_log since
	// it's just used to buy more items (including itself!)
	purchase_log_vis = FALSE

/datum/uplink_item/bundles_TC/telecrystal/five
	name = "5 Raw Telecrystals"
	desc = "Five telecrystals in their rawest and purest form; can be utilized on active uplinks to increase their telecrystal count."
	item = /obj/item/stack/telecrystal/five
	cost = 5

/datum/uplink_item/bundles_TC/telecrystal/twenty
	name = "20 Raw Telecrystals"
	desc = "Twenty telecrystals in their rawest and purest form; can be utilized on active uplinks to increase their telecrystal count."
	item = /obj/item/stack/telecrystal/twenty
	cost = 20