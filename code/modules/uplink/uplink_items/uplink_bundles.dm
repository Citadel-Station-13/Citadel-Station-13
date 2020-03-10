
//All bundles and telecrystals

/*
	Uplink Items:
	Unlike categories, uplink item entries are automatically sorted alphabetically on server init in a global list,
	When adding new entries to the file, please keep them sorted by category.
*/

/datum/uplink_item/bundles_TC/chemical
	name = "Bioterror bundle"
	desc = "For the madman: Contains a handheld Bioterror chem sprayer, a Bioterror foam grenade, a box of lethal chemicals, a dart pistol, \
			box of syringes, Donksoft assault rifle, and some riot darts. Remember: Seal suit and equip internals before use."
	item = /obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle
	cost = 30 // normally 42
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/bulldog
	name = "Bulldog bundle"
	desc = "Lean and mean: Optimized for people that want to get up close and personal. Contains the popular \
			Bulldog shotgun, a 12g buckshot drum, a 12g taser slug drum and a pair of Thermal imaging goggles."
	item = /obj/item/storage/backpack/duffelbag/syndie/bulldogbundle
	cost = 13 // normally 16
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/c20r
	name = "C-20r bundle"
	desc = "Old Faithful: The classic C-20r, bundled with two magazines, and a (surplus) suppressor at discount price."
	item = /obj/item/storage/backpack/duffelbag/syndie/c20rbundle
	cost = 14 // normally 16
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/contract_kit
	name = "Contract Kit"
	desc = "The Syndicate have offered you the chance to become a contractor, take on kidnapping contracts for TC and cash payouts. Upon purchase,  \
			you'll be granted your own contract uplink embedded within the supplied tablet computer. Additionally, you'll be granted \
			standard contractor gear to help with your mission - comes supplied with the tablet, specialised space suit, chameleon jumpsuit and mask, \
			specialised contractor baton, and three randomly selected low cost items. Can include otherwise unobtainable items."
	item = /obj/item/storage/box/syndie_kit/contract_kit
	cost = 20
	player_minimum = 15
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/bundles_TC/cybernetics_bundle
	name = "Cybernetic Implants Bundle"
	desc = "A random selection of cybernetic implants. Guaranteed 5 high quality implants. Comes with an autosurgeon."
	item = /obj/item/storage/box/cyber_implants
	cost = 40
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/medical
	name = "Medical bundle"
	desc = "The support specialist: Aid your fellow operatives with this medical bundle. Contains a tactical medkit, \
			a Donksoft LMG, a box of riot darts and a pair of magboots to rescue your friends in no-gravity environments."
	item = /obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle
	cost = 15 // normally 20
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/modular
	name = "Modular Pistol Kit"
	desc = "A heavy briefcase containing one modular pistol (chambered in 10mm), one supressor, and spare ammunition, including a box of soporific ammo. \
		Includes a suit jacket that is padded with a robust liner."
	item = /obj/item/storage/briefcase/modularbundle
	cost = 12

/datum/uplink_item/bundles_TC/shredder
	name = "Shredder bundle"
	desc = "A truly horrific weapon designed simply to maim its victim, the CX Shredder is banned by several intergalactic treaties. \
			You'll get two of them with this. And spare ammo to boot. And we'll throw in an extra elite hardsuit and chest rig to hold them all!"
	item = /obj/item/storage/backpack/duffelbag/syndie/shredderbundle
	cost = 30 // normally 41
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/sniper
	name = "Sniper bundle"
	desc = "Elegant and refined: Contains a collapsed sniper rifle in an expensive carrying case, \
			two soporific knockout magazines, a free surplus supressor, and a sharp-looking tactical turtleneck suit. \
			We'll throw in a free red tie if you order NOW."
	item = /obj/item/storage/briefcase/sniperbundle
	cost = 20 // normally 26
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/firestarter
	name = "Spetsnaz Pyro bundle"
	desc = "For systematic suppression of carbon lifeforms in close quarters: Contains a lethal New Russian backpack spray, Elite hardsuit, \
			Stechkin APS pistol, two magazines, a minibomb and a stimulant syringe. \
			Order NOW and comrade Boris will throw in an extra tracksuit."
	item = /obj/item/storage/backpack/duffelbag/syndie/firestarter
	cost = 30
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/bundles_TC/bundle
	name = "Syndicate Bundle"
	desc = "Syndicate Bundles are specialized groups of items that arrive in a plain box. \
			These items are collectively worth more than 20 telecrystals, but you do not know which specialization \
			you will receive. May contain discontinued and/or exotic items."
	item = /obj/item/storage/box/syndicate
	cost = 20
	exclude_modes = list(/datum/game_mode/nuclear)
	cant_discount = TRUE

/datum/uplink_item/bundles_TC/surplus
	name = "Syndicate Surplus Crate"
	desc = "A dusty crate from the back of the Syndicate warehouse. Rumored to contain a valuable assortment of items, \
			but you never know. Contents are sorted to always be worth 50 TC."
	item = /obj/structure/closet/crate
	cost = 20
	player_minimum = 25
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	cant_discount = TRUE
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

/datum/uplink_item/bundles_TC/random
	name = "Random Item"
	desc = "Picking this will purchase a random item. Useful if you have some TC to spare or if you haven't decided on a strategy yet."
	item = /obj/effect/gibspawner/generic // non-tangible item because techwebs use this path to determine illegal tech
	cost = 0
	cant_discount = TRUE

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
	cant_discount = TRUE
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