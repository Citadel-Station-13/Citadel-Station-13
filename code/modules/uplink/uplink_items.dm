GLOBAL_LIST_INIT(uplink_items, subtypesof(/datum/uplink_item))

/proc/get_uplink_items(var/datum/game_mode/gamemode = null, allow_sales = TRUE, allow_restricted = TRUE)
	var/list/filtered_uplink_items = list()
	var/list/sale_items = list()

	for(var/path in GLOB.uplink_items)
		var/datum/uplink_item/I = new path
		if(!I.item)
			continue
		if(I.include_modes.len)
			if(!gamemode && SSticker.mode && !(SSticker.mode.type in I.include_modes))
				continue
			if(gamemode && !(gamemode in I.include_modes))
				continue
		if(I.exclude_modes.len)
			if(!gamemode && SSticker.mode && (SSticker.mode.type in I.exclude_modes))
				continue
			if(gamemode && (gamemode in I.exclude_modes))
				continue
		if(I.player_minimum && I.player_minimum > GLOB.joined_player_list.len)
			continue
		if (I.restricted && !allow_restricted)
			continue

		if(!filtered_uplink_items[I.category])
			filtered_uplink_items[I.category] = list()
		filtered_uplink_items[I.category][I.name] = I
		if(I.limited_stock < 0 && !I.cant_discount && I.item && I.cost > 1)
			sale_items += I
	if(allow_sales)
		for(var/i in 1 to 3)
			var/datum/uplink_item/I = pick_n_take(sale_items)
			var/datum/uplink_item/A = new I.type
			var/discount = A.get_discount()
			var/list/disclaimer = list("Void where prohibited.", "Not recommended for children.", "Contains small parts.", "Check local laws for legality in region.", "Do not taunt.", "Not responsible for direct, indirect, incidental or consequential damages resulting from any defect, error or failure to perform.", "Keep away from fire or flames.", "Product is provided \"as is\" without any implied or expressed warranties.", "As seen on TV.", "For recreational use only.", "Use only as directed.", "16% sales tax will be charged for orders originating within Space Nebraska.")
			A.limited_stock = 1
			I.refundable = FALSE //THIS MAN USES ONE WEIRD TRICK TO GAIN FREE TC, CODERS HATES HIM!
			A.refundable = FALSE
			if(A.cost >= 20) //Tough love for nuke ops
				discount *= 0.5
			A.cost = max(round(A.cost * discount),1)
			A.category = "Discounted Gear"
			A.name += " ([round(((initial(A.cost)-A.cost)/initial(A.cost))*100)]% off!)"
			A.desc += " Normally costs [initial(A.cost)] TC. All sales final. [pick(disclaimer)]"
			A.item = I.item

			if(!filtered_uplink_items[A.category])
				filtered_uplink_items[A.category] = list()
			filtered_uplink_items[A.category][A.name] = A
	return filtered_uplink_items


/**
 * Uplink Items
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/
/datum/uplink_item
	var/name = "item name"
	var/category = "item category"
	var/desc = "item description"
	var/item = null // Path to the item to spawn.
	var/refund_path = null // Alternative path for refunds, in case the item purchased isn't what is actually refunded (ie: holoparasites).
	var/cost = 0
	var/refund_amount = 0 // specified refund amount in case there needs to be a TC penalty for refunds.
	var/refundable = FALSE
	var/surplus = 100 // Chance of being included in the surplus crate.
	var/surplus_nullcrates //Chance of being included in null crates. null = pull from surplus
	var/cant_discount = FALSE
	var/limited_stock = -1 //Setting this above zero limits how many times this item can be bought by the same traitor in a round, -1 is unlimited
	var/list/include_modes = list() // Game modes to allow this item in.
	var/list/exclude_modes = list() // Game modes to disallow this item from.
	var/list/restricted_roles = list() //If this uplink item is only available to certain roles. Roles are dependent on the frequency chip or stored ID.
	var/player_minimum //The minimum crew size needed for this item to be added to uplinks.
	var/purchase_log_vis = TRUE // Visible in the purchase log?
	var/restricted = FALSE // Adds restrictions for VR/Events

/datum/uplink_item/New()
	. = ..()
	if(isnull(surplus_nullcrates))
		surplus_nullcrates = surplus

/datum/uplink_item/proc/get_discount()
	return pick(4;0.75,2;0.5,1;0.25)

/datum/uplink_item/proc/purchase(mob/user, datum/component/uplink/U)
	var/atom/A = spawn_item(item, user, U)
	if(purchase_log_vis && U.purchase_log)
		U.purchase_log.LogPurchase(A, src, cost)

/datum/uplink_item/proc/spawn_item(spawn_path, mob/user, datum/component/uplink/U)
	if(!spawn_path)
		return
	var/atom/A
	if(ispath(spawn_path))
		A = new spawn_path(get_turf(user))
	else
		A = spawn_path
	if(ishuman(user) && istype(A, /obj/item))
		var/mob/living/carbon/human/H = user
		if(H.put_in_hands(A))
			to_chat(H, "[A] materializes into your hands!")
			return A
	to_chat(user, "[A] materializes onto the floor.")
	return A

//Discounts (dynamically filled above)
/datum/uplink_item/discounts
	category = "Discounted Gear"

//All bundles and telecrystals
/datum/uplink_item/bundles_TC
	category = "Bundles and Telecrystals"
	surplus = 0
	cant_discount = TRUE

/datum/uplink_item/bundles_TC/toxic
	name = "Toxic Bundle"
	desc = "Toxins and toxin applicators, for chemical warfare: Contains a miniature energy crossbow, a sleepy pen, \
			a dart gun, a poison kit, a box of spare syringes, and complementary syndicate cigarettes."
	item = /obj/item/storage/box/syndie_kit/bundle/toxic
	cost = 20 // normally 28
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/bundles_TC/explosive
	name = "Explosive Bundle"
	desc = "JC A BOMB!: Contains a syndicate bomb, a pizza bomb, two flashbangs, two emp grenades, two syndicate minibombs \
			two incendiary grenades, a tearstache grenade, and a belt to hold them all."
	item = /obj/item/storage/box/syndie_kit/bundle/explosive
	cost = 20 // normally 41
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/bundles_TC/sabotage
	name = "Sabotage Bundle"
	desc = "Explosives and tools for saboteurs: Contains two C4, X4, and door charges; a camera bug, a power sink, \
			a cryptographic sequencer, a Detomatix cartridge, and a toolbox. Handle with care."
	item = /obj/item/storage/box/syndie_kit/bundle/sabotage
	cost = 20 // normally 32
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/bundles_TC/hacker
	name = "Hacker Bundle"
	desc = "For subverting silicon equipment: Contains a hacked AI upload module, a cryptographic sequencer with two rechargers, \
			a binary encryption key, an EMP flashlight and implant kit, an AI detection tool, and a camera bug."
	item = /obj/item/storage/box/syndie_kit/bundle/hacker
	cost = 20 // normally 25
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

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

// Guns, Launchers, and other ranged weapons of destruction
/datum/uplink_item/munitions
	category = "Syndicate Munitions"

/datum/uplink_item/munitions/pistol
	name = "M92 Pistol"
	desc = "A small, easily concealable handgun, which fires 10mm rounds from an 8 round magazine. \
			The preferred weapon for stealth operations on a budget. Compatible with supressors."
	item = /obj/item/gun/ballistic/automatic/pistol
	cost = 6
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/munitions/machinepistol
	name = "VP78 Machine Pistol"
	desc = "An automatic machine pistol that fires 9mm rounds in 2-round bursts from a 16 round magazine. \
			For when you just need to spray and pray. Compatible with supressors."
	item = /obj/item/gun/ballistic/automatic/pistol/machinepistol
	cost = 10
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/munitions/revolver
	name = "Syndicate Revolver"
	desc = "A bulky and powerful hand cannon that fires devastating .357 rounds from 7 chambers. \
			Capable of dispatching targets with ease at the cost of making a lot of noise."
	item = /obj/item/gun/ballistic/revolver/syndie
	cost = 13
	surplus = 50
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/munitions/antitank
	name = "Anti-Material Pistol"
	desc = "Essentially an anti-material snipe rifle stripped down of all rifling. \
			Fires .50 caliber rounds from a 5 round magazine, but with terrible accuracy. \
			Cheaper than the revolver, and absolutely devastating if it hits"
	item = /obj/item/gun/ballistic/automatic/pistol/antitank/syndicate
	cost = 14
	surplus = 25
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/doublebarrel
	name = "Sawn-Off Double Barrel Shotgun"
	desc = "A brutally simple double barrel shotgun, precut for portability. \
			Designed for close quarter target elimination. Pre-loaded with buckshot shells"
	item = /obj/item/gun/ballistic/revolver/doublebarrel/sawn
	cost = 10
	surplus = 40
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/munitions/shotgun
	name = "Bulldog Shotgun"
	desc = "A semi-automatic shotgun fed by 8-round drums. Compatible with all 12g rounds. Designed for close \
			quarter anti-personnel engagements. Pre-loaded with a buckshot drum."
	item = /obj/item/gun/ballistic/automatic/shotgun/bulldog
	cost = 8
	surplus = 40
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/smg
	name = "C-20r Submachine Gun"
	desc = "An ergonomic Scarborough Arms bullpup submachine gun that fires 10mm rounds in 2 round bursts from a 28-round magazine. \
			Highly versatile and reliable. Compatible with suppressors"
	item = /obj/item/gun/ballistic/automatic/c20r
	cost = 10
	surplus = 40
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/flechettegun
	name = "Flechette Launcher"
	desc = "A highly illegal compact bullpup carbine that fires micro-flechette rounds in 8 round bursts from a 64 round magazine.\
			Flechettes deal very little damage individually, but shred the targets internal organs, causing them to quickly bleed to death. \
			Ideal for extended engagements."
	item = /obj/item/gun/ballistic/automatic/flechette
	cost = 14
	surplus = 30
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/pdw
	name = "M-90gl PDW"
	desc = "A compact personal defense weapon that fires armor piercing 5.7x28mm ammunition in 5-round bursts from a 50 round magazine. \
			This specific model comes with an underbarrel grenade launcher, for flushing out enemies behind cover. \
			While expensive, it is the most versatile and effective of its size on offer."
	item = /obj/item/gun/ballistic/automatic/m90
	cost = 18
	surplus = 50
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/bolt_action
	name = "Surplus Rifle"
	desc = "A horribly outdated bolt action weapon that fires 7.62x51mm rounds from a 5-round clip. \
			Generally only purchased as a last resort, but suprisingly robust on a per shot basis."
	item = /obj/item/gun/ballistic/shotgun/boltaction
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/dangerous/pie_cannon
	name = "Banana Cream Pie Cannon"
	desc = "A special pie cannon for a special clown, this gadget can hold up to 20 pies and automatically fabricates one every two seconds!"
	cost = 10
	item = /obj/item/pneumatic_cannon/pie/selfcharge
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/munitions/machinegun
	name = "L6 Squad Automatic Weapon"
	desc = "A heavy duty Aussec Armoury belt-fed machine gun that carries a massive 100-round magazine of armor piercing 5.56×45mm ammunition that \
			is fired in 8 round bursts. Requires two hands to fire. The L6 is ideal for suppressive fire and support roles."
	item = /obj/item/gun/ballistic/automatic/l6_saw
	cost = 16
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/sniper
	name = "Anti-Material Sniper Rifle"
	desc = "A long-range, scoped, specialist rifle that fires devastating .50 caliber rounds from a 5 round magazine. \
			Incredible at neutralizing nearly any kind of individual target, but absolutely terrible at close range, or against multiple opponents."
	item = /obj/item/gun/ballistic/automatic/sniper_rifle/syndicate
	cost = 16
	surplus = 25
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/rocketlauncher
	name = "PML-9 Rocket Launcher"
	desc = "A powerful and reusable rocket launcher preloaded with an armor piercing HEDP round. \
			Ideal for eliminating heavily armored targets, or, when loaded with HE rounds, large groups of targets."
	item = /obj/item/gun/ballistic/rocketlauncher
	cost = 12
	surplus = 30
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/flamethrower
	name = "Plasma Flamethrower"
	desc = "A flamethrower, fueled by a tank of highly flammable biotoxins stolen from Nanotrasen \
			Make a statement by roasting the filth in their own greed. Use with extreme caution. \
			Ensure the igniter is on before firing."
	item = /obj/item/flamethrower/full/tank
	cost = 4
	surplus = 40
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/munitions/foampistol
	name = "Toy Pistol with Riot Darts"
	desc = "A Donksoft pistol designed to fire foam darts. Carries 8 darts per magazine, \
			and comes pre-loaded with riot darts."
	item = /obj/item/gun/ballistic/automatic/toy/pistol/riot
	cost = 3
	surplus = 10

/datum/uplink_item/munitions/foamsmg
	name = "Toy Submachine Gun"
	desc = "A Donksoft bullpup submachine gun that fires riot grade darts from a 28-round magazine."
	item = /obj/item/gun/ballistic/automatic/c20r/toy
	cost = 6
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/munitions/foammachinegun
	name = "Toy Machine Gun"
	desc = "A Donksoft belt-fed machine gun. This weapon has a massive 75-round magazine of devastating \
			riot grade darts, that can briefly incapacitate someone in just one volley."
	item = /obj/item/gun/ballistic/automatic/l6_saw/toy
	cost = 12
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/device_tools/medgun
	name = "Medbeam Gun"
	desc = "A wonder of Syndicate engineering, the Medbeam gun, or Medi-Gun enables a medic to keep his fellow \
			operatives in the fight, even while under fire. Don't cross the streams!"
	item = /obj/item/gun/medbeam
	cost = 15
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

// Ammunition
/datum/uplink_item/ammo
	category = "Ammunition"
	surplus = 40

/datum/uplink_item/ammo/pistol
	name = "10mm Standard Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the M92 Pistol. These rounds are dirt cheap, \
			but weak when compared to higher caliber options."
	item = /obj/item/ammo_box/magazine/m10mm
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/pistolap
	name = "10mm Armour Piercing Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the M92 Pistol. \
			These rounds are less effective at injuring the target, but are useful for penetrating protective gear."
	item = /obj/item/ammo_box/magazine/m10mm/ap
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/pistolhp
	name = "10mm Hollow Point Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the M92 Pistol. \
			These rounds cause more internal damage to the target, but are easily stopped by armor."
	item = /obj/item/ammo_box/magazine/m10mm/hp
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/pistolfire
	name = "10mm Incendiary Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the M92 Pistol. \
			Loaded with incendiary rounds which are weak in impact, but carry a payload that will ignite the target."
	item = /obj/item/ammo_box/magazine/m10mm/fire
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/pistolzzz
	name = "10mm Soporific Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the M92 Pistol. Loaded with soporific rounds that put the target to sleep. \
			Remember that it takes about three shots to actually put the target to sleep, so plan accordinlgy."
	item = /obj/item/ammo_box/magazine/m10mm/soporific
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/machinepistol
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/machinepistol/standard
	name = "9mm Standard Magazine"
	desc = "An additional 16-round 9mm magazine; compativle with the VP78 Machine Pistol. These rounds are fairly weak individually \
			so be prepared to buy plenty of these."
	item = /obj/item/ammo_box/magazine/pistolm9mm

/datum/uplink_item/ammo/machinepistol/ap
	name = "9mm Armour Piercing Magazine"
	desc = "An additional 16-round 9mm magazine; compatible with the VP78 Machine Pistol. \
			These rounds are less effective at injuring the target, but are useful for penetrating protective gear."
	item = /obj/item/ammo_box/magazine/pistolm9mm/ap

/datum/uplink_item/ammo/machinepistol/hp
	name = "9mm Hollow Point Magazine"
	desc = "An additional 16-round 9mm magazine; compatible with the VP98 Machine Pistol. \
			These rounds cause more internal damage to the target, but are easily stopped by armor."
	item = /obj/item/ammo_box/magazine/pistolm9mm/hp
	cost = 2

/datum/uplink_item/ammo/machinepistol/fire
	name = "9mm Incendiary Magazine"
	desc = "An additional 16-round 9mm magazine; compatible with the VP98 Machine Pistol. \
			Loaded with incendiary rounds which are weak in impact, but carry a payload that will ignite the target."
	item = /obj/item/ammo_box/magazine/pistolm9mm/fire
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/revolver
	name = ".357 Speed Loader"
	desc = "A speed loader that contains seven additional lethal .357 Magnum rounds; compatible with the Nagant revolver. \
			For when you really need a lot of things dead."
	item = /obj/item/ammo_box/a357
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/revolver/rubber
	name = ".357 Rubber Speed Loader"
	desc = "A speed loader that contains seven additional rubber .357 Magnum rounds; compatible with the Nagant revolver. \
			For when you really need a lot of things alive."
	item = /obj/item/ammo_box/a357/rubber
	cost = 3
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/shell
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/ammo/shell/buck
	name = "Box of 12g Buckshot Shells"
	desc = "An additional seven shells of buckshot in a box. Devastating at close range."
	item = /obj/item/storage/box/lethalshot

/datum/uplink_item/ammo/shell/slug
	name = "Box of 12g Slug Shells"
	desc = "An additional seven shells of slug in a box. \
			Ideal for engaging at longer ranges."
	cost = 3
	item = /obj/item/storage/box/lethalslugs

/datum/uplink_item/ammo/shell/rubber
	name = "Box of 12g Rubber Shells"
	desc = "An alternative seven shells of rubber in a box. \
			Highly effective at taking down targets non-lethally."
	cost = 3
	item = /obj/item/storage/box/rubber

/datum/uplink_item/ammo/shell/incendiary
	name = "Box of 12g Incendiary Shells"
	desc = "An alternative seven shells of incendiary in a box. \
			Shoots multiple pellets that will set any target hit on fire. Great against crowds."
	item = /obj/item/storage/box/fireshot

/datum/uplink_item/ammo/shell/scatter
	name = "Box of 12g Scatter Laser Shells"
	desc = "An alternative seven shells of scatter laser in a box. \
			Mostly useful against hostiles using bullet proof gear."
	item = /obj/item/storage/box/lasershot
	cost = 3 // most armor has less laser protection then bullet

/datum/uplink_item/ammo/shotgun
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/shotgun/buck
	name = "12g Buckshot Drum"
	desc = "An additional 8-round buckshot magazine for use with the Bulldog shotgun. Devastating at close range."
	item = /obj/item/ammo_box/magazine/m12g

/datum/uplink_item/ammo/shotgun/slug
	name = "12g Slug Drum"
	desc = "An additional 8-round slug magazine for use with the Bulldog shotgun. \
			Ideal for engaging at longer ranges."
	cost = 3
	item = /obj/item/ammo_box/magazine/m12g/slug

/datum/uplink_item/ammo/shotgun/dragon
	name = "12g Dragon's Breath Drum"
	desc = "An alternative 8-round dragon's breath magazine for use in the Bulldog shotgun. \
			Shoots multiple pellets that will set any target hit on fire. Great against crowds."
	item = /obj/item/ammo_box/magazine/m12g/dragon

/datum/uplink_item/ammo/shotgun/scatter
	name = "12g Scatter Laser shot Slugs"
	desc = "An alternative 8-round Scatter Laser Shot magazine for use in the Bulldog shotgun. \
			Mostly useful against hostiles using bullet proof gear."
	item = /obj/item/ammo_box/magazine/m12g/scatter
	cost = 4 // most armor has less laser protection then bullet

/datum/uplink_item/ammo/shotgun/meteor
	name = "12g Meteorslug Shells"
	desc = "An alternative 8-round meteorslug magazine for use in the Bulldog shotgun. \
            Great for blasting airlocks off their frames and knocking down enemies."
	item = /obj/item/ammo_box/magazine/m12g/meteor

/datum/uplink_item/ammo/shotgun/stun
	name = "12g Stun Slug Drum"
	desc = "An alternative 8-round stun slug magazine for use with the Bulldog shotgun. \
			Effective for quickly disabling a target without killing them outright."
	item = /obj/item/ammo_box/magazine/m12g/stun

/datum/uplink_item/ammo/smg
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/smg/standard
	name = "10mm SMG Magazine"
	desc = "An additional 28-round 10mm magazine suitable for use with the C-20r submachine gun."
	item = /obj/item/ammo_box/magazine/smgm10mm

/datum/uplink_item/ammo/smg/ap
	name = "10mm SMG AP Magazine"
	desc = "An additional 28-round 10mm magazine suitable for use with the C-20r submachine gun. \
			These rounds are less effective at injuring the target, but are useful for penetrating protective gear."
	item = /obj/item/ammo_box/magazine/smgm10mm/ap
	cost = 2

/datum/uplink_item/ammo/smg/hp
	name = "10mm SMG HP Magazine"
	desc = "An additional 28-round 10mm magazine suitable for use with the C-20r submachine gun. \
			These rounds cause more internal damage to the target, but are easily stopped by armor."
	item = /obj/item/ammo_box/magazine/smgm10mm/hp

/datum/uplink_item/ammo/smg/fire
	name = "10mm SMG Incendiary Magazine"
	desc = "An additional 28-round 10mm magazine suitable for use with the C-20r submachine gun. \
			Loaded with incendiary rounds which are weak in impact, but carry a payload that will ignite the target."
	item = /obj/item/ammo_box/magazine/smgm10mm/fire
	cost = 2

/datum/uplink_item/ammo/smg/zzz
	name = "10mm SMG Soporific Magazine"
	desc = "An additional 28-round 10mm magazine suitable for use with the C-20r submachine gun. Loaded with soporific rounds that put the target to sleep. \
			Remember that it takes about three shots to actually put the target to sleep, so plan accordinlgy."
	item = /obj/item/ammo_box/magazine/smgm10mm/soporific
	cost = 2

/datum/uplink_item/ammo/flechettes
	name = "Serrated Flechette Magazine"
	desc = "An additional 64-round flechette magazine; compatible with the Flechette Launcer. \
			Loaded with serrated flechettes that shreds flesh, but is stopped dead in its tracks by armor. \
			These flechettes are highly likely to sever arteries, and even limbs."
	item = /obj/item/ammo_box/magazine/flechette/s
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/flechetteap
	name = "Armor Piercing Flechette Magazine"
	desc = "An additional 64-round flechette magazine; compatible with the Flechette Launcer. \
			Loaded with armor piercing flechettes that are highly effective against armor, but are unable to shred flesh."
	item = /obj/item/ammo_box/magazine/flechette
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/pdw
	name = "5.7x28mm Toploader Magazine"
	desc = "An additional 50-round 5.7x28mm magazine; suitable for use with the M-90gl carbine. \
			Armor piercing out of the box, with a large capacity, these magazines will take you far."
	item = /obj/item/ammo_box/magazine/a57x28
	cost = 3
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/pdwhp
	name = "5.7x28mm HP Toploader Magazine"
	desc = "An alternative 50-round 5.7x28mm HP magazine; suitable for use with the M-90gl carbine. \
			Forfeits the armor piercing capabilities of standard rounds for raw damage."
	item = /obj/item/ammo_box/magazine/a57x28_hp
	cost = 3
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/a40mm
	name = "40mm Grenade"
	desc = "A 40mm HE grenade for use with the M-90gl's under-barrel grenade launcher. \
			Ideal for flushing out the enemy. Not for use in enclosed spaces."
	item = /obj/item/ammo_casing/a40mm
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/bolt_action
	name = "Surplus Rifle Clip"
	desc = "A stripper clip used to quickly load bolt action rifles. Contains 5 rounds."
	item = 	/obj/item/ammo_box/a762
	cost = 1
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/sniper
	cost = 4
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/sniper/basic
	name = ".50 Anti-Material Magazine"
	desc = "An additional standard 5-round magazine for use with .50 sniper rifles."
	item = /obj/item/ammo_box/magazine/sniper_rounds

/datum/uplink_item/ammo/sniper/penetrator
	name = ".50 Penetrator Magazine"
	desc = "A 5-round magazine of penetrator ammo designed for use with .50 sniper rifles. \
			Can pierce walls and multiple enemies with one bullet."
	item = /obj/item/ammo_box/magazine/sniper_rounds/penetrator
	cost = 5

/datum/uplink_item/ammo/sniper/soporific
	name = ".50 Soporific Magazine"
	desc = "A 3-round magazine of soporific ammo designed for use with .50 sniper rifles. Puts enemies to sleep in only one shot."
	item = /obj/item/ammo_box/magazine/sniper_rounds/soporific
	cost = 6

/datum/uplink_item/ammo/machinegun
	cost = 5
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/machinegun/basic
	name = "5.56×45mm Box Magazine"
	desc = "A 100-round magazine of 5.56×45mm ammunition for use with the L6 SAW. \
			Suppressive fire in, suppressive fire out, you do the hokey pokey and that's what it's all about."
	item = /obj/item/ammo_box/magazine/mm556x45

/datum/uplink_item/ammo/machinegun/ap
	name = "5.56×45mm (Armor Penetrating) Box Magazine"
	desc = "A 100-round magazine of 5.56×45mm ammunition for use in the L6 SAW; specially designed \
			to puncture even the most durable of armor."
	item = /obj/item/ammo_box/magazine/mm556x45/ap
	cost = 6

/datum/uplink_item/ammo/machinegun/hollow
	name = "5.56×45mm (Hollow-Point) Box Magazine"
	desc = "An unethical 75-round magazine of 5.56×45mm ammunition for use in the L6 SAW; equipped with hollow-point tips to help \
			with the unarmored masses of crew."
	item = /obj/item/ammo_box/magazine/mm556x45/hollow
	cost = 6

/datum/uplink_item/ammo/machinegun/incen
	name = "5.56×45mm (Incendiary) Box Magazine"
	desc = "A 75-round magazine of 5.56×45mm ammunition for use in the L6 SAW; tipped with a special flammable \
			mixture that'll ignite anyone struck by the bullet. Some men just want to watch the world burn."
	item = /obj/item/ammo_box/magazine/mm556x45/incen
	cost = 6

/datum/uplink_item/ammo/rocket
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/rocket/he
	name = "84mm HE Rocket"
	desc = "A high explosive anti-personnel rocket, for dealing a lot of damage to a wide area."
	item = /obj/item/ammo_casing/caseless/rocket
	cost = 4

/datum/uplink_item/ammo/rocket/hedp
	name = "84mm HEDP Rocket"
	desc = "A high-yield HEDP rocket; extremely effective against armored targets, while impacting a smaller area."
	item = /obj/item/ammo_casing/caseless/rocket/hedp
	cost = 5

/datum/uplink_item/ammo/plasma
	name = "Flamethrower Fuel Tank"
	desc = "An additional plasma tank for fueling the flamethrower. Handle with care."
	item = /obj/item/tank/internals/plasma
	cost = 4
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/ammo/toydarts
	name = "Box of Riot Darts"
	desc = "A box of 40 Donksoft riot darts, for reloading any compatible foam dart magazine. Don't forget to share!"
	item = /obj/item/ammo_box/foambox/riot
	cost = 2
	surplus = 0

// Melee Weapons
/datum/uplink_item/cqc
	category = "Close-Quarters Combat Equipment"

/datum/uplink_item/cqc/edagger
	name = "Energy Dagger"
	desc = "A tiny dagger made of energy that looks and functions as a pen when deactivated. Activating or attacking with it produces a loud, distinctive noise. \
			Very easy to conceal, often goes unnoticed during searches, and makes an effective weapon when thrown."
	item = /obj/item/pen/edagger
	cost = 2

/datum/uplink_item/cqc/switchblade
	name = "Switchblade"
	desc = "A small, retractable blade that can easily be concealed in one's pocket.  \
			Is a lot quieter and subtler than the edagger, but at a higher cost, while being much more likely to be noticed in a search."
	item = /obj/item/switchblade
	cost = 4

/datum/uplink_item/cqc/sword
	name = "Energy Sword"
	desc = "A small, pocketable device that can produce a deadly blade of energy when activated. Can block some attacks, but don't rely on it. \
			Activating it or attacking with it produces a loud, distinctive noise."
	item = /obj/item/melee/transforming/energy/sword/saber
	cost = 7
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/cqc/clownsword
	name = "Bananium Energy Sword"
	desc = "An energy sword that deals no damage, but will slip anyone it contacts, be it by melee attack, thrown \
	impact, or just stepping on it. Beware friendly fire, as even anti-slip shoes will not protect against it."
	item = /obj/item/melee/transforming/energy/sword/bananium
	cost = 3
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/cqc/doublesword
	name = "Double-Bladed Energy Sword"
	desc = "The double-bladed energy sword requires to hands to weild, and does slightly more damage than a standard energy sword. \
			It is capable of deflecting all energy projectiles, and can easily block melee strikes."
	item = /obj/item/twohanded/dualsaber
	player_minimum = 25
	cost = 16
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/dangerous/doublesword/get_discount()
	return pick(4;0.8,2;0.65,1;0.5)

/datum/uplink_item/cqc/rapier
	name = " Plastitanium Rapier"
	desc = "An incredibly sharp rapier capable of piercing all forms of armor with ease. \
			The rapier comes with its own jet black sheath, however this will generally alert hostiles to your allegience. \
			The rapier itself can be used to deflect melee strikes to some degree, and it can be used as a powerful projectile in a pinch."
	item = /obj/item/storage/belt/sabre/rapier
	cost = 8
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/cqc/powerfist
	name = "Power Fist"
	desc = "The power-fist is a metal gauntlet with a built-in piston-ram powered by an external gas supply.\
		 Upon hitting a target, the piston-ram will extend forward to make contact for some serious damage. \
		 Using a wrench on the piston valve will allow you to tweak the amount of gas used per punch to \
		 deal extra damage and hit targets further. Use a screwdriver to take out any attached tanks."
	item = /obj/item/melee/powerfist
	cost = 7

/datum/uplink_item/cqc/plastitanium_toolbox
	name = "Plastitanium Toolbox"
	desc = "A particularly heavy duty toolbox. Great for letting out your inner ape and breaking things."
	item = /obj/item/storage/toolbox/plastitanium
	cost = 2		//18 damage on mobs, 50 on objects, 4.5 stam/hit

/datum/uplink_item/cqc/throwingweapons
	name = "Box of Throwing Weapons"
	desc = "A box of throwing weapons, containing 5 shurikens and 2 reinforced bolas. \
			The bolas can knock a target down and slow them, while the shurikens will embed into targets."
	item = /obj/item/storage/box/syndie_kit/throwing_weapons
	cost = 3

/datum/uplink_item/cqc/martialarts
	name = "Martial Arts Scroll"
	desc = "This scroll contains the secrets of an ancient martial arts technique. You will master unarmed combat, \
			deflecting all ranged weapon fire, but you also refuse to use dishonorable ranged weaponry."
	item = /obj/item/book/granter/martial/carp
	cost = 17
	surplus = 0
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

datum/uplink_item/stealthy_weapons/taeclowndo_shoes
	name = "Tae-clown-do Shoes"
	desc = "A pair of shoes for the most elite agents of the honkmotherland. They grant the mastery of taeclowndo with some honk-fu moves as long as they're worn."
	cost = 12
	item = /obj/item/clothing/shoes/clown_shoes/taeclowndo
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/cqc/cqc
	name = "CQC Manual"
	desc = "A manual that teaches a single user tactical hand-to-hand Close-Quarters Combat before self-destructing."
	item = /obj/item/book/granter/martial/cqc
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	cost = 15
	surplus = 0

/datum/uplink_item/cqc/rapid
	name = "Gloves of the North Star"
	desc = "These gloves let the user punch people very fast. Does not improve the attack speed of any equipped weapons or the meaty fists of a hulk."
	item = /obj/item/clothing/gloves/rapid
	cost = 8

/datum/uplink_item/cqc/combatglovesnano
	name = "Nanotech Combat Gloves"
	desc = "A pair of gloves that are fireproof and shock resistant, and features nanotechnology to teach the wearer the art of krav maga."
	item = /obj/item/clothing/gloves/krav_maga/combatglovesplus
	cost = 5
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	surplus = 0

/datum/uplink_item/cqc/guardian
	name = "Holoparasites"
	desc = "Though capable of near sorcerous feats via use of hardlight holograms and nanomachines, they require an \
			organic host as a home base and source of fuel. Holoparasites come in various types and share damage with their host."
	item = /obj/item/storage/box/syndie_kit/guardian
	cost = 15
	refundable = TRUE
	cant_discount = TRUE
	surplus = 0
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	player_minimum = 25
	restricted = TRUE
	refund_path = /obj/item/guardiancreator/tech/choose/traitor

/datum/uplink_item/cqc/dehy_carp
	name = "Dehydrated Space Carp"
	desc = "Looks like a plush toy carp, but just add water and it becomes a real-life space carp! Activate in \
			your hand before use so it knows not to kill you."
	item = /obj/item/toy/plush/carpplushie/dehy_carp
	cost = 1

// Stealthy Weapons
/datum/uplink_item/toxins
	category = "Toxins and Biohazardous Chemicals"

/datum/uplink_item/toxins/bioterror
	name = "Biohazardous Chemical Sprayer"
	desc = "A handheld chemical sprayer that allows a wide dispersal of selected chemicals. Especially tailored by the Tiger \
			Cooperative, the deadly blend it comes stocked with will disorient, damage, and disable your foes... \
			Use with extreme caution, to prevent exposure to yourself and your fellow operatives."
	item = /obj/item/reagent_containers/spray/chemsprayer/bioterror
	cost = 20
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/toxins/crossbow
	name = "Miniature Energy Crossbow"
	desc = "A short bow mounted across a tiller in miniature. Small enough to \
		fit into a pocket or slip into a bag unnoticed. It will synthesize \
		and fire bolts tipped with a soporific toxin that will briefly stun \
		targets and cause them to gradually lose conciousness. It can produce an \
		infinite number of bolts, but takes time to automatically recharge \
		after each shot."
	item = /obj/item/gun/energy/kinetic_accelerator/crossbow
	cost = 12
	surplus = 50
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/toxins/rad_laser
	name = "Radioactive Microlaser"
	desc = "A radioactive microlaser disguised as a standard Nanotrasen health analyzer. When used, it emits a \
			powerful burst of radiation, which, after a short delay, can incapacitate all but the most protected \
			of humanoids. It has two settings: intensity, which controls the power of the radiation, \
			and wavelength, which controls the delay before the effect kicks in."
	item = /obj/item/healthanalyzer/rad_laser
	cost = 3

/datum/uplink_item/toxins/dart_pistol
	name = "Dart Pistol"
	desc = "A miniaturized version of a normal syringe gun. It is very quiet when fired and can fit into any \
			space a small item can."
	item = /obj/item/gun/syringe/syndicate
	cost = 4
	surplus = 50

/datum/uplink_item/toxins/syringe
	name = "Box of syringes"
	desc = "A box of seven syringes, perfect for use with the dart gun."
	item = /obj/item/storage/box/syringes
	cost = 1
	surplus = 0

/datum/uplink_item/toxins/bioterror
	name = "Box of Bioterror Syringes"
	desc = "A box full of preloaded syringes, containing various chemicals that seize up the victim's motor \
			and broca systems, making it impossible for them to move or speak for some time."
	item = /obj/item/storage/box/syndie_kit/bioterror
	cost = 6
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/toxins/traitor_chem_bottle
	name = "Poison Kit"
	desc = "An assortment of deadly chemicals packed into a compact box. Comes with a syringe for more precise application."
	item = /obj/item/storage/box/syndie_kit/chemical
	cost = 6
	surplus = 50

/datum/uplink_item/toxins/romerol_kit
	name = "Romerol"
	desc = "A highly experimental bioterror agent which creates dormant nodules to be etched into the grey matter of the brain. \
			On death, these nodules take control of the dead body, causing limited revivification, \
			along with slurred speech, aggression, and the ability to infect others with this agent."
	item = /obj/item/storage/box/syndie_kit/romerol
	cost = 25
	cant_discount = TRUE

/datum/uplink_item/toxins/sleepy_pen
	name = "Sleepy Pen"
	desc = "A syringe disguised as a functional pen, filled with a potent mix of drugs, including a \
			strong anesthetic and a chemical that prevents the target from speaking. \
			The pen holds one dose of the mixture, and can be refilled with any chemicals. Note that before the target \
			falls asleep, they will be able to move and act."
	item = /obj/item/pen/sleepy
	cost = 4
	exclude_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/explosives
	category = "Grenades and Explosives"

/datum/uplink_item/explosives/c4
	name = "Composition C-4"
	desc = "C-4 is a versatile plastic explosive of the common variety Composition C. You can use it to breach into rooms, sabotage equipment, or connect \
			an assembly to it in order to alter the way it detonates. It can be attached to almost all objects and has a modifiable timer with a \
			minimum setting of 10 seconds. If you are clever, you can use C-4 as a makeshift grenade."
	item = /obj/item/grenade/plastic/c4
	cost = 1

/datum/uplink_item/explosives/x4
	name = "Composition X-4"
	desc = "X-4 is a plastic explosive of the variety Composition X. It is similar to C-4, but with a stronger, directional blast instead of circular. \
			It is generally less useful for sabotage and assemblies, but is much better for breaching, as it will seriously injure anyone on the other side of a wall. \
			For when you want a controlled explosion that leaves a wider, deeper, hole."
	item = /obj/item/grenade/plastic/x4
	cost = 1
	cant_discount = TRUE

/datum/uplink_item/explosives/detomatix
	name = "Detomatix PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you four opportunities to \
			detonate PDAs of crewmembers who have their message feature enabled. \
			The concussive effect from the explosion will knock the recipient out for a short period, and deafen them for longer."
	item = /obj/item/cartridge/virus/syndicate
	cost = 5
	restricted = TRUE

/datum/uplink_item/explosives/doorcharge
	name = "Airlock Charge"
	desc = "A small explosive charged that can be placed into the wiring of any airlock. \
			The moment someone attempts to open the airlock, the charge will detonate, destroying the airlock and injuring anyone nearby."
	item = /obj/item/doorCharge
	cost = 4

/datum/uplink_item/explosives/pizza_bomb
	name = "Pizza Bomb"
	desc = "A pizza box with a bomb cunningly attached to the lid. The timer needs to be set by opening the box; afterwards, \
			opening the box again will trigger the detonation after the timer has elapsed. Comes with free pizza, for you or your target!"
	item = /obj/item/pizzabox/bomb
	cost = 6
	surplus = 8

/datum/uplink_item/explosives/flashbang
	name = "Flashbang"
	desc = "A non-lethal grenade with a five-second fuse that can be used to blind, deafen, and incapacitate nearby opponents. \
			Just be careful not to be in the blast radius."
	item = /obj/item/grenade/flashbang
	cost = 1

/datum/uplink_item/stealthy_weapons/soap_clusterbang
	name = "Slipocalypse Clusterbang"
	desc = "A traditional clusterbang grenade with a payload consisting entirely of Syndicate soap. Useful in any scenario!"
	item = /obj/item/grenade/clusterbuster/soap
	cost = 6

/datum/uplink_item/explosives/emp
	name = "EMP Grenade"
	desc = "A rather useful utility grenade with a five-second fuse that generates a small electro-magnetic pulse upon detonation. \
			Useful for disabling cyborgs, mechs, and other electronic devices."
	item = /obj/item/grenade/empgrenade
	cost = 1

/datum/uplink_item/explosives/incendiary
	name = "Incendiary Grenade"
	desc = "A spicy grenade with a five-second fuse. Upon detonation, it will set anything in an area around it on fire. \
			Perfect for striking fear into your enemies."
	item = /obj/item/grenade/chem_grenade/incendiary
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/syndicate_minibomb
	name = "Syndicate Minibomb"
	desc = "The minibomb is a high explosive grenade with a five-second fuse. Upon detonation, it will create a small hull breach \
			in addition to dealing serious damage to nearby personnel."
	item = /obj/item/grenade/syndieminibomb
	cost = 6
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/bombanana
	name = "Bombanana"
	desc = "A banana with an explosive taste! discard the peel quickly, as it will explode with the force of a syndicate minibomb \
		a few seconds after the banana is eaten."
	item = /obj/item/reagent_containers/food/snacks/grown/banana/bombanana
	cost = 4 //it is a bit cheaper than a minibomb because you have to take off your helmet to eat it, which is how you arm it
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/bioterrorfoam
	name = "Bioterror Foam Grenade"
	desc = "A powerful chemical foam grenade which creates a deadly torrent of foam that will mute, blind, confuse, \
			mutate, and irritate carbon lifeforms. Specially brewed by Tiger Cooperative chemical weapons specialists \
			using additional spore toxin. Ensure suit is sealed before use."
	item = /obj/item/grenade/chem_grenade/bioterrorfoam
	cost = 5
	surplus = 35
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/virus_grenade
	name = "Fungal Tuberculosis Grenade"
	desc = "A primed bio-grenade packed into a compact box. Comes with five Bio Virus Antidote Kit (BVAK) \
			autoinjectors for rapid application on up to two targets each, a syringe, and a bottle containing \
			the BVAK solution. WARNING: EXTREME BIOHAZARD. HANDLE WITH CAUTION."
	item = /obj/item/storage/box/syndie_kit/tuberculosisgrenade
	cost = 8
	surplus = 35
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	restricted = TRUE

/datum/uplink_item/explosives/tearstache
	name = "Teachstache Grenade"
	desc = "A teargas grenade that launches sticky moustaches onto the face of anyone not wearing a clown or mime mask. The moustaches will \
		remain attached to the face of all targets for one minute, preventing the use of breath masks and other such devices."
	item = /obj/item/grenade/chem_grenade/teargas/moustache
	cost = 4
	surplus = 0

/datum/uplink_item/explosives/viscerators
	name = "Viscerator Delivery Grenade"
	desc = "A unique grenade that deploys a swarm of viscerator drones upon activation, which will chase down and shred \
			any non-operatives in the area."
	item = /obj/item/grenade/spawnergrenade/manhacks
	cost = 5
	surplus = 35
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/buzzkill
	name = "Buzzkill Grenade Box"
	desc = "A box with three grenades that release a swarm of angry bees upon activation. These bees indiscriminately attack friend or foe \
			with random toxins. Courtesy of the BLF and Tiger Cooperative."
	item = /obj/item/storage/box/syndie_kit/bee_grenades
	cost = 15
	surplus = 35
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/syndicate_bomb
	name = "Syndicate Bomb"
	desc = "The Syndicate bomb is a fearsome device capable of massive destruction. It has an adjustable timer, \
			with a minimum of 60 seconds, and can be bolted to the floor with a wrench to prevent \
			movement. The bomb is bulky and cannot be moved; upon ordering this item, a smaller beacon will be \
			transported to you that will teleport the actual bomb to it upon activation. Note that this bomb can \
			be defused, and some crew may attempt to do so."
	item = /obj/item/sbeacondrop/bomb
	cost = 11

/datum/uplink_item/explosives/clown_bomb_clownops
	name = "Clown Bomb"
	desc = "The Clown bomb is a hilarious device capable of massive pranks. It has an adjustable timer, \
			with a minimum of 60 seconds, and can be bolted to the floor with a wrench to prevent \
			movement. The bomb is bulky and cannot be moved; upon ordering this item, a smaller beacon will be \
			transported to you that will teleport the actual bomb to it upon activation. Note that this bomb can \
			be defused, and some crew may attempt to do so."
	item = /obj/item/sbeacondrop/clownbomb
	cost = 15
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/explosives/syndicate_detonator
	name = "Syndicate Detonator"
	desc = "The Syndicate detonator is a companion device to the Syndicate bomb. Simply press the included button \
			and an encrypted radio frequency will instruct all live Syndicate bombs to detonate. \
			Useful for when speed matters or you wish to synchronize multiple bomb blasts. Be sure to stand clear of \
			the blast radius before using the detonator."
	item = /obj/item/syndicatedetonator
	cost = 3
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)


//Mechs and Ghost Spawns
/datum/uplink_item/support
	category = "Reinforcements, Cyborgs, and Mechanized Exosuits"
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/support/reinforcement
	name = "Reinforcements"
	desc = "Call in an additional operative. They won't be equipped with any telecrystals, so it is up to you to arm them."
	item = /obj/item/antag_spawner/nuke_ops
	cost = 25
	refundable = TRUE
	include_modes = list(/datum/game_mode/nuclear)
	restricted = TRUE

/datum/uplink_item/support/clown_reinforcement
	name = "Clown Reinforcements"
	desc = "Call in an additional clown to share the fun, equipped with full starting gear, but no telecrystals."
	item = /obj/item/antag_spawner/nuke_ops/clown
	cost = 20
	include_modes = list(/datum/game_mode/nuclear/clown_ops)
	restricted = TRUE

/datum/uplink_item/support/reinforcement/assault_borg
	name = "Syndicate Assault Cyborg"
	desc = "A cyborg designed and programmed for the systematic extermination of non-Syndicate personnel. \
			Comes equipped with an ammo printing machine gun, grenade launcher, energy sword, emag, pinpointer, flash and crowbar."
	item = /obj/item/antag_spawner/nuke_ops/borg_tele/assault
	refundable = TRUE
	cost = 65
	restricted = TRUE

/datum/uplink_item/support/reinforcement/medical_borg
	name = "Syndicate Medical Cyborg"
	desc = "A combat medical cyborg. Has limited offensive potential, but makes more than up for it with its support capabilities. \
			It comes equipped with a nanite hypospray, a medical beamgun, combat defibrillator, full surgical kit including an energy saw, an emag, pinpointer and flash. \
			Thanks to its organ storage bag, it can perform surgery as well as any humanoid."
	item = /obj/item/antag_spawner/nuke_ops/borg_tele/medical
	refundable = TRUE
	cost = 35
	restricted = TRUE

/datum/uplink_item/support/gygax
	name = "Dark Gygax Exosuit"
	desc = "A lightweight exosuit, painted in a dark scheme. Its speed and equipment selection make it excellent \
			for hit-and-run style attacks. Features an incendiary carbine, flash bang launcher, teleporter, ion thrusters and a Tesla energy array."
	item = /obj/mecha/combat/gygax/dark/loaded
	cost = 80

/datum/uplink_item/support/honker
	name = "Dark H.O.N.K."
	desc = "A clown combat mech equipped with bombanana peel and tearstache grenade launchers, as well as the ubiquitous HoNkER BlAsT 5000."
	item = /obj/mecha/combat/honker/dark/loaded
	cost = 80
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/support/mauler
	name = "Mauler Exosuit"
	desc = "A massive and incredibly deadly military-grade exosuit. Features long-range targeting, thrust vectoring \
			and deployable smoke. Comes equipped with an LMG, scattershot carbine, missile rack, an antiprojectile armor booster and a Tesla energy array."
	item = /obj/mecha/combat/marauder/mauler/loaded
	cost = 140

/datum/uplink_item/support/assault_pod
	name = "Assault Pod Targeting Device"
	desc = "Use this to select the landing zone of your assault pod."
	item = /obj/item/assault_pod
	cost = 30
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	restricted = TRUE

// Stealth Items
/datum/uplink_item/stealthy_tools
	category = "Infiltration and Distruption Tools"

/datum/uplink_item/stealthy_tools/suppressor
	name = "Suppressor"
	desc = "This suppressor will silence the shots of the weapon it is attached to for increased stealth and superior ambushing capability. \
			It is compatible with many small ballistic guns including the M92 and C-20r, but not revolvers or energy guns."
	item = /obj/item/suppressor
	cost = 1
	surplus = 10
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/stealthy_tools/agent_card
	name = "Agent Identification Card"
	desc = "Agent cards prevent artificial intelligences from tracking the wearer, and can copy access \
			from other identification cards. The access is cumulative, so scanning one card does not erase the \
			access gained from another. In addition, they can be forged to display a new assignment and name. \
			This can be done an unlimited amount of times. Some Syndicate areas and devices can only be accessed \
			with these cards."
	item = /obj/item/card/id/syndicate
	cost = 2

/datum/uplink_item/stealthy_tools/chameleon
	name = "Chameleon Kit"
	desc = "A set of items that contain chameleon technology allowing you to disguise as pretty much anything on the station, and more! \
			Due to budget cuts, the shoes don't provide protection against slipping."
	item = /obj/item/storage/box/syndie_kit/chameleon
	cost = 2

/datum/uplink_item/stealthy_tools/syndigaloshes
	name = "No-Slip Chameleon Shoes"
	desc = "These shoes will allow the wearer to run on wet floors and slippery objects without falling down. \
			They do not work on heavily lubricated surfaces."
	item = /obj/item/clothing/shoes/chameleon/noslip
	cost = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	player_minimum = 20

/datum/uplink_item/stealthy_tools/syndigaloshes/nukep
	cost = 4
	exclude_modes = list()
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/stealthy_tools/chameleon_proj
	name = "Chameleon Projector"
	desc = "Projects an image across a user, disguising them as an object scanned with it, as long as they don't \
			move the projector from their hand. Disguised users move slowly, and projectiles pass over them."
	item = /obj/item/chameleon
	cost = 6

/datum/uplink_item/stealthy_tools/cutouts
	name = "Adaptive Cardboard Cutouts"
	desc = "These cardboard cutouts are coated with a thin material that prevents discoloration and makes the images on them appear more lifelike. \
			This pack contains three as well as a crayon for changing their appearances."
	item = /obj/item/storage/box/syndie_kit/cutouts
	cost = 1
	surplus = 20

/datum/uplink_item/stealthy_tools/jammer
	name = "Radio Jammer"
	desc = "This device will disrupt any nearby outgoing radio communication when activated. Does not affect binary chat."
	item = /obj/item/jammer
	cost = 5

/datum/uplink_item/stealthy_tools/emplight
	name = "EMP Flashlight"
	desc = "A small, self-recharging, short-ranged EMP device disguised as a working flashlight. \
		Useful for disrupting headsets, cameras, doors, lockers and borgs during stealth operations. \
		Attacking a target with this flashlight will direct an EM pulse at it and consumes a charge."
	item = /obj/item/flashlight/emp
	cost = 2
	surplus = 30

/datum/uplink_item/stealthy_tools/frame
	name = "F.R.A.M.E. PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you five PDA viruses which \
			when used cause the targeted PDA to become a new uplink with zero TCs, and immediately become unlocked. \
			You will receive the unlock code upon activating the virus, and the new uplink may be charged with \
			telecrystals normally."
	item = /obj/item/cartridge/virus/frame
	cost = 2
	restricted = TRUE

/datum/uplink_item/stealthy_tools/ai_detector
	name = "Artificial Intelligence Detector"
	desc = "A functional multitool that turns red when it detects an artificial intelligence watching it, and can be \
			activated to display their exact viewing location and nearby security camera blind spots. Knowing when \
			an artificial intelligence is watching you is useful for knowing when to maintain cover, and finding nearby \
			blind spots can help you identify escape routes."
	item = /obj/item/multitool/ai_detect
	cost = 1

/datum/uplink_item/stealthy_tools/codespeak_manual
	name = "Codespeak Manual"
	desc = "Syndicate agents can be trained to use a series of codewords to convey complex information, which sounds like random concepts and drinks to anyone listening. \
			This manual teaches you this Codespeak. You can also hit someone else with the manual in order to teach them. This is the deluxe edition, which has unlimited uses."
	item = /obj/item/codespeak_manual/unlimited
	cost = 3

/datum/uplink_item/stealthy_tools/failsafe
	name = "Failsafe Uplink Code"
	desc = "When entered into the uplink, it will automatically self-destruct."
	item = /obj/effect/gibspawner/generic
	cost = 1
	surplus = 0
	restricted = TRUE
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/stealthy_tools/failsafe/spawn_item(spawn_path, mob/user, datum/component/uplink/U)
	if(!U)
		return
	U.failsafe_code = U.generate_code()
	to_chat(user, "The new failsafe code for this uplink is now : [U.failsafe_code].")
	if(user.mind)
		user.mind.store_memory("Failsafe code for [U.parent] : [U.failsafe_code]")
	return U.parent //For log icon

/datum/uplink_item/stealthy_tools/mulligan
	name = "Mulligan"
	desc = "Screwed up and have security on your tail? This handy syringe will give you a completely new identity \
			and appearance."
	item = /obj/item/reagent_containers/syringe/mulligan
	cost = 3
	surplus = 30
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/*/datum/uplink_item/stealthy_tools/syndi_borer
	name = "Syndicate Brain Slug"
	desc = "A small cortical borer, modified to be completely loyal to the owner. \
			Genetically infertile, these brain slugs can assist medically in a support role, or take direct action \
			to assist their host."
	item = /obj/item/antag_spawner/syndi_borer
	refundable = TRUE
	cost = 10
	surplus = 20 //Let's not have this be too common
	exclude_modes = list(/datum/game_mode/nuclear) */

/datum/uplink_item/stealthy_tools/smugglersatchel
	name = "Smuggler's Satchel"
	desc = "This satchel is thin enough to be hidden in the gap between plating and tiling; great for stashing \
			your stolen goods. Comes with a crowbar and a floor tile inside. Properly hidden satchels have been \
			known to survive intact even beyond the current shift. "
	item = /obj/item/storage/backpack/satchel/flat
	cost = 2
	surplus = 30

//Armor and EVA Gear
/datum/uplink_item/suits
	category = "Uniforms, Armor, and Space Suits"
	surplus = 40

/datum/uplink_item/suits/turtlenck
	name = "Tactical Turtleneck"
	desc = "A weakly armored suit that does not have sensors attatched. Be warned that most crewmembers are quick to call out such clothing."
	item = /obj/item/clothing/under/syndicate
	cost = 1
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops) //They already get these

/datum/uplink_item/suits/turtlenck_skirt
	name = "Tactical Skirtleneck"
	desc = "A weakly armored skirt that does not have sensors attatched. Be warned that most crewmembers are quick to call out such clothing."
	item = /obj/item/clothing/under/syndicate/skirt
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

/datum/uplink_item/suits/space_suit
	name = "Syndicate Space Suit"
	desc = "This black and red Syndicate space suit is less encumbering than Nanotrasen variants, \
			fitting inside bags, and being able to hold weapons. While fairly subtle in coloration, perceptive crew members will be quick to call it out."
	item = /obj/item/storage/box/syndie_kit/space
	cost = 4
	exclude_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/suits/space_suit/nukeop
	cost = 4
	exclude_modes = list()
	include_modes = list(/datum/game_mode/nuclear) //Cheaper for ops

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

/datum/uplink_item/suits/hardsuit/nukeop
	cost = 4
	exclude_modes = list()
	include_modes = list(/datum/game_mode/nuclear) //cheaper for ops

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
	desc = "An improved version of the standard Syndicate hardsuit. It features an advanced built-in energy shielding system. \
			The shields can handle up to three impacts within a short duration and will rapidly recharge while not under fire."
	item = /obj/item/clothing/suit/space/hardsuit/shielded/syndi
	cost = 30
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	exclude_modes = list()


// Tools
/datum/uplink_item/tools
	category = "Mil-Spec Tools"

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
	desc = "Simple goggles that allow one to see in the dark. Incredibly useful for infiltration."
	item = /obj/item/clothing/glasses/night
	cost = 2

/datum/uplink_item/device_tools/magboots
	name = "Blood-Red Magboots"
	desc = "A pair of magnetic boots with a Syndicate paintjob that assist with freer movement in space or on-station \
			during gravitational generator failures. These reverse-engineered knockoffs of Nanotrasen's \
			'Advanced Magboots' slow you down in simulated-gravity environments much like the standard issue variety."
	item = /obj/item/clothing/shoes/magboots/syndie
	cost = 2
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/stealthy_tools/combatbananashoes
	name = "Combat Banana Shoes"
	desc = "While making the wearer immune to most slipping attacks like regular combat clown shoes, these shoes \
		can generate a large number of synthetic banana peels as the wearer walks, slipping up would-be pursuers. They also \
		squeak significantly louder."
	item = /obj/item/clothing/shoes/clown_shoes/banana_shoes/combat
	cost = 6
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/tools/military_belt
	name = "Chest Rig"
	desc = "A robust seven-slot set of webbing that is capable of holding all manner of tactical equipment."
	item = /obj/item/storage/belt/military
	cost = 1

/datum/uplink_item/tools/grenadier
	name = "Grenadier's belt"
	desc = "A belt for holding all the grenades you could ever want."
	item = /obj/item/storage/belt/grenade
	include_modes = list(/datum/game_mode/nuclear)
	cost = 2
	surplus = 0

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
	item = /obj/item/storage/backpack/duffelbag/syndie/surgery
	cost = 3

/datum/uplink_item/tools/soap
	name = "Syndicate Soap"
	desc = "A sinister-looking surfactant used to clean blood stains to hide murders and prevent DNA analysis. \
			You can also drop it underfoot to slip people."
	item = /obj/item/soap/syndie
	cost = 1
	surplus = 50

/datum/uplink_item/tools/syndie_glue
	name = "Syndicate Glue"
	desc = "A cheap bottle of one use syndicate brand super glue. \
			Use on any item to make it undroppable. \
			Be careful not to glue an item you're already holding!"
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	item = /obj/item/syndie_glue
	cost = 4

/datum/uplink_item/tools/stimpack
	name = "Stimpack"
	desc = "Stimpacks, the tool of many great heroes, make you nearly immune to stuns and knockdowns for about \
			5 minutes after injection."
	item = /obj/item/reagent_containers/syringe/stimulants
	cost = 5
	surplus = 90

/datum/uplink_item/tools/phantomthief
	name = "Syndicate Mask"
	desc = "A cheap plastic mask fitted with an adrenaline autoinjector, which can be used by simply tensing your muscles"
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

// Electronic Devices
/datum/uplink_item/devices
	category = "Electronic Devices"

/datum/uplink_item/devices/emag
	name = "Cryptographic Sequencer"
	desc = "The cryptographic sequencer, electromagnetic card, or emag, is a small card that unlocks hidden functions \
			in electronic devices, subverts intended functions, and easily breaks security mechanisms. Starts with only 10 charges"
	item = /obj/item/card/emag
	cost = 6

/datum/uplink_item/devices/emagrecharge
	name = "Electromagnet Charging Device"
	desc = "A small device intended for recharging Cryptographic Sequencers. Using it will add five extra charges to the Cryptographic Sequencer."
	item = /obj/item/emagrecharge
	cost = 2

/datum/uplink_item/devices/shield
	name = "Energy Shield"
	desc = "An incredibly robust personal shield projector, capable of reflecting all energy projectiles \
			and blocking physical attacks. It is highly recommended you purchase this if you are using a one handed weapon."
	item = /obj/item/shield/energy
	cost = 16
	surplus = 20
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/devices/bananashield
	name = "Bananium Energy Shield"
	desc = "A clown's most powerful defensive weapon, this personal shield provides near immunity to ranged energy attacks \
		by bouncing them back at the ones who fired them. It can also be thrown to bounce off of people, slipping them, \
		and returning to you even if you miss. WARNING: DO NOT ATTEMPT TO STAND ON SHIELD WHILE DEPLOYED, EVEN IF WEARING ANTI-SLIP SHOES."
	item = /obj/item/shield/energy/bananium
	cost = 16
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)

/datum/uplink_item/devices/camera_bug
	name = "Camera Bug"
	desc = "Enables you to view all cameras on the main network, set up motion alerts and track a target. \
			Bugging cameras allows you to disable them remotely."
	item = /obj/item/camera_bug
	cost = 1
	surplus = 90

/datum/uplink_item/devices/encryptionkey
	name = "Syndicate Encryption Key"
	desc = "A key that, when inserted into a radio headset, allows you to listen to all station department channels \
			as well as talk on an encrypted Syndicate channel with other agents that have the same key."
	item = /obj/item/encryptionkey/syndicate
	cost = 2
	surplus = 75
	restricted = TRUE

/datum/uplink_item/device_tools/binary
	name = "Binary Translator Key"
	desc = "A key that, when inserted into a radio headset, allows you to listen to and talk with silicon-based lifeforms, \
			such as AI units and cyborgs, over their private binary channel. Caution should \
			be taken while doing this, as unless they are allied with you, they are programmed to report such intrusions."
	item = /obj/item/encryptionkey/binary
	cost = 2
	surplus = 75
	restricted = TRUE

/datum/uplink_item/devices/hacked_module
	name = "Hacked AI Law Upload Module"
	desc = "When used with an upload console, this module allows you to upload priority laws to an artificial intelligence. \
			Be careful with wording, as artificial intelligences may look for loopholes to exploit."
	item = /obj/item/aiModule/syndicate
	cost = 7

/datum/uplink_item/devices/compressionkit
	name = "Bluespace Compression Kit"
	desc = "A modified version of a BSRPED that can be used to reduce the size of most items while retaining their original functions! \
			Does not work on storage items. \
			Recharge using bluespace crystals. \
			Comes with 5 charges."
	item = /obj/item/compressionkit
	cost = 8

/datum/uplink_item/devices/briefcase_launchpad
	name = "Briefcase Launchpad"
	desc = "A briefcase containing a launchpad, a device able to teleport items and people to and from targets up to twenty tiles away from the briefcase. \
			Also includes a remote control, disguised as an ordinary folder. Touch the briefcase with the remote to link it."
	surplus = 0
	item = /obj/item/storage/briefcase/launchpad
	cost = 6

/datum/uplink_item/devices/fakenucleardisk
	name = "Decoy Nuclear Authentication Disk"
	desc = "It's just a normal disk. Visually it's identical to the real deal, but it won't hold up under closer scrutiny by the Captain. \
			Don't try to give this to us to complete your objective, we know better!"
	item = /obj/item/disk/nuclear/fake
	cost = 1
	surplus = 1

/datum/uplink_item/devices/singularity_beacon
	name = "Power Beacon"
	desc = "When screwed to wiring attached to an electric grid and activated, this large device pulls any \
			active gravitational singularities or tesla balls towards it. This will not work when the engine is still \
			in containment. Because of its size, it cannot be carried. Ordering this \
			sends you a small beacon that will teleport the larger beacon to your location upon activation."
	item = /obj/item/sbeacondrop
	cost = 14

/datum/uplink_item/devices/powersink
	name = "Power Sink"
	desc = "When screwed to wiring attached to a power grid and activated, this large device lights up and places excessive \
			load on the grid, causing a station-wide blackout. The sink is large and cannot be stored in most \
			traditional bags and boxes. Caution: Will explode if the powernet contains sufficient amounts of energy."
	item = /obj/item/powersink
	cost = 7

/datum/uplink_item/devices/potion
	name = "Syndicate Sentience Potion"
	item = /obj/item/slimepotion/slime/sentience/nuclear
	desc = "A potion recovered at great risk by undercover Syndicate operatives and then subsequently modified with Syndicate technology. \
			Using it will make any animal sentient, and bound to serve you, as well as implanting an internal radio for communication and an internal ID card for opening doors."
	cost = 2
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	restricted = TRUE


// Implants
/datum/uplink_item/implants
	category = "Implants"
	surplus = 50

/datum/uplink_item/implants/adrenal
	name = "Adrenal Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will inject a chemical \
			cocktail which removes all incapacitating effects, lets the user run faster and has a mild healing effect."
	item = /obj/item/storage/box/syndie_kit/imp_adrenal
	cost = 8
	player_minimum = 25

/datum/uplink_item/implants/antistun
	name = "CNS Rebooter Implant"
	desc = "This implant will help you get back up on your feet faster after being stunned. Comes with an autosurgeon."
	item = /obj/item/autosurgeon/anti_stun
	cost = 12
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/implants/reviver
	name = "Reviver Implant"
	desc = "This implant will attempt to revive and heal you if you lose consciousness. Comes with an autosurgeon."
	item = /obj/item/autosurgeon/reviver
	cost = 8
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/implants/freedom
	name = "Freedom Implant"
	desc = "An implant injected into the body and later activated at the user's will. It will attempt to free the \
			user from common restraints such as handcuffs."
	item = /obj/item/storage/box/syndie_kit/imp_freedom
	cost = 5

/datum/uplink_item/implants/radio
	name = "Internal Syndicate Radio Implant"
	desc = "An implant injected into the body, allowing the use of an internal Syndicate radio. \
			Used just like a regular headset, but can be disabled to use external headsets normally and to avoid detection."
	item = /obj/item/storage/box/syndie_kit/imp_radio
	cost = 4
	restricted = TRUE

/datum/uplink_item/implants/uplink
	name = "Uplink Implant"
	desc = "An implant injected into the body, and later activated at the user's will. Has no telecrystals and must be charged by the use of physical telecrystals. \
			Undetectable (except via surgery), and excellent for escaping confinement."
	item = /obj/item/storage/box/syndie_kit/imp_uplink
	cost = 4
	// An empty uplink is kinda useless.
	surplus = 0
	restricted = TRUE

/datum/uplink_item/implants/stealthimplant
	name = "Stealth Implant"
	desc = "This one-of-a-kind implant will make you almost invisible as long as you don't don't excessively move around. \
			On activation, it will conceal you inside a chameleon cardboard box that is only revealed once someone bumps into it."
	item = /obj/item/implanter/stealth
	cost = 8

/datum/uplink_item/implants/storage
	name = "Storage Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will open a small bluespace \
			pocket capable of storing two regular-sized items."
	item = /obj/item/storage/box/syndie_kit/imp_storage
	cost = 8

/datum/uplink_item/implants/emp
	name = "EMP Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will create a small EMP blast around the user."
	item = /obj/item/storage/box/syndie_kit/imp_emp
	cost = 1

/datum/uplink_item/implants/thermals
	name = "Thermal Eyes"
	desc = "These cybernetic eyes will give you thermal vision. Comes with a free autosurgeon."
	item = /obj/item/autosurgeon/thermal_eyes
	cost = 7
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/implants/xray
	name = "X-ray Vision Implant"
	desc = "These cybernetic eyes will give you X-ray vision. Comes with an autosurgeon."
	item = /obj/item/autosurgeon/xray_eyes
	cost = 10
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/implants/microbomb
	name = "Microbomb Implant"
	desc = "An implant injected into the body, and later activated either manually or automatically upon death. \
			The more implants inside of you, the higher the explosive power. \
			This will however, permanently destroy your body."
	item = /obj/item/storage/box/syndie_kit/imp_microbomb
	cost = 2
	include_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/implants/macrobomb
	name = "Macrobomb Implant"
	desc = "An implant injected into the body, and later activated either manually or automatically upon death. \
			Upon death, releases a massive explosion that will wipe out everything nearby."
	item = /obj/item/storage/box/syndie_kit/imp_macrobomb
	cost = 20
	include_modes = list(/datum/game_mode/nuclear)
	restricted = TRUE

// Role-specific items
/datum/uplink_item/role_restricted
	category = "Role-Restricted"
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	surplus = 0

/datum/uplink_item/role_restricted/ancient_jumpsuit
	name = "Ancient Jumpsuit"
	desc = "A tattered old jumpsuit that will provide absolutely no benefit to you. It fills the wearer with a strange compulsion to blurt out 'glorf'."
	item = /obj/item/clothing/under/color/grey/glorf
	cost = 20
	restricted_roles = list("Assistant")

/datum/uplink_item/role_restricted/pie_cannon
	name = "Banana Cream Pie Cannon"
	desc = "A special pie cannon for a special clown, this gadget can hold up to 20 pies and automatically fabricates one every two seconds!"
	cost = 10
	item = /obj/item/pneumatic_cannon/pie/selfcharge
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/blastcannon
	name = "Blast Cannon"
	desc = "A highly specialized weapon, the Blast Cannon is actually relatively simple. It contains an attachment for a tank transfer valve mounted to an angled pipe specially constructed \
			withstand extreme pressure and temperatures, and has a mechanical trigger for triggering the transfer valve. Essentially, it turns the explosive force of a bomb into a narrow-angle \
			blast wave \"projectile\". Aspiring scientists may find this highly useful, as forcing the pressure shockwave into a narrow angle seems to be able to bypass whatever quirk of physics \
			disallows explosive ranges above a certain distance, allowing for the device to use the theoretical yield of a transfer valve bomb, instead of the factual yield."
	item = /obj/item/gun/blastcannon
	cost = 14							//High cost because of the potential for extreme damage in the hands of a skilled gas masked scientist.
	restricted_roles = list("Research Director", "Scientist")

/datum/uplink_item/role_restricted/brainwash_disk
	name = "Brainwashing Surgery Program"
	desc = "A disk containing the procedure to perform a brainwashing surgery, allowing you to implant an objective onto a target. \
	Insert into an Operating Console to enable the procedure."
	item = /obj/item/disk/surgery/brainwashing
	restricted_roles = list("Medical Doctor")
	cost = 3

/datum/uplink_item/role_restricted/clown_bomb
	name = "Clown Bomb"
	desc = "The Clown bomb is a hilarious device capable of massive pranks. It has an adjustable timer, \
			with a minimum of 60 seconds, and can be bolted to the floor with a wrench to prevent \
			movement. The bomb is bulky and cannot be moved; upon ordering this item, a smaller beacon will be \
			transported to you that will teleport the actual bomb to it upon activation. Note that this bomb can \
			be defused, and some crew may attempt to do so. \
			The bomb core can be pried out and manually detonated with other explosives."
	item = /obj/item/sbeacondrop/clownbomb
	cost = 15
	restricted_roles = list("Clown")

/*
/datum/uplink_item/role_restricted/clowncar
	name = "Clown Car"
	desc = "The Clown Car is the ultimate transportation method for any worthy clown! \
			Simply insert your bikehorn and get in, and get ready to have the funniest ride of your life! \
			You can ram any spacemen you come across and stuff them into your car, kidnapping them and locking them inside until \
			someone saves them or they manage to crawl out. Be sure not to ram into any walls or vending machines, as the springloaded seats \
			are very sensetive. Now with our included lube defense mechanism which will protect you against any angry shitcurity!"
	item = /obj/vehicle/sealed/car/clowncar
	cost = 15
	restricted_roles = list("Clown")
*/

/datum/uplink_item/role_restricted/clumsyDNA
	name = "Clumsy Clown DNA"
	desc = "A DNA injector that has been loaded with the clown gene that makes people clumsy.. \
	Making someone clumsy will allow them to use clown firing pins as well as Reverse Revolvers. For a laugh try using this on the HOS to see how many times they shoot themselves in the foot!"
	cost = 1
	item = /obj/item/dnainjector/clumsymut
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/haunted_magic_eightball
	name = "Haunted Magic Eightball"
	desc = "Most magic eightballs are toys with dice inside. Although identical in appearance to the harmless toys, this occult device reaches into the spirit world to find its answers. \
			Be warned, that spirits are often capricious or just little assholes. To use, simply speak your question aloud, then begin shaking."
	item = /obj/item/toy/eightball/haunted
	cost = 2
	restricted_roles = list("Curator")
	limited_stock = 1 //please don't spam deadchat

/datum/uplink_item/role_restricted/his_grace
	name = "His Grace"
	desc = "An incredibly dangerous weapon recovered from a station overcome by the grey tide. Once activated, He will thirst for blood and must be used to kill to sate that thirst. \
	His Grace grants gradual regeneration and complete stun immunity to His wielder, but be wary: if He gets too hungry, He will become impossible to drop and eventually kill you if not fed. \
	However, if left alone for long enough, He will fall back to slumber. \
	To activate His Grace, simply unlatch Him."
	item = /obj/item/his_grace
	cost = 20
	restricted_roles = list("Chaplain")
	surplus = 5 //Very low chance to get it in a surplus crate even without being the chaplain

/datum/uplink_item/role_restricted/explosive_hot_potato
	name = "Exploding Hot Potato"
	desc = "A potato rigged with explosives. On activation, a special mechanism is activated that prevents it from being dropped. \
			The only way to get rid of it if you are holding it is to attack someone else with it, causing it to latch to that person instead."
	item = /obj/item/hot_potato/syndicate
	cost = 4
	restricted_roles = list("Cook", "Botanist", "Clown", "Mime")

/datum/uplink_item/role_restricted/ez_clean_bundle
	name = "EZ Clean Grenade Bundle"
	desc = "A box with three cleaner grenades using the trademark Waffle Co. formula. Serves as a cleaner and causes acid damage to anyone standing nearby. \
			The acid only affects carbon-based creatures."
	item = /obj/item/storage/box/syndie_kit/ez_clean
	cost = 6
	surplus = 20
	restricted_roles = list("Janitor")

/datum/uplink_item/role_restricted/goldenbox
	name = "Gold Toolbox"
	desc = "A gold planted plastitanium toolbox loaded with tools. Comes with a set of AI detection multi-tool and a pare of combat gloves."
	item = /obj/item/storage/toolbox/gold_real
	cost = 3 // Has syndie tools + gloves + a robust weapon
	restricted_roles = list("Assistant", "Curator") //Curator due to this being made of gold - It fits the theme

/datum/uplink_item/role_restricted/mimery
	name = "Guide to Advanced Mimery Series"
	desc = "The classical two part series on how to further hone your mime skills. Upon studying the series, the user should be able to make 3x1 invisible walls, and shoot bullets out of their fingers. \
			Obviously only works for Mimes."
	cost = 12
	item = /obj/item/storage/box/syndie_kit/mimery
	restricted_roles = list("Mime")

/datum/uplink_item/role_restricted/ultrahonkpins
	name = "Hilarious firing pin"
	desc = "A single firing pin made for Clown agents, this firing pin makes any gun honk when fired if not a true clown! \
	This firing pin also helps you fire the gun correctly. May the HonkMother HONK you agent."
	item = /obj/item/firing_pin/clown/ultra
	cost = 2
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/pressure_mod
	name = "Kinetic Accelerator Pressure Mod"
	desc = "A modification kit which allows Kinetic Accelerators to do greatly increased damage while indoors. \
			Occupies 35% mod capacity."
	item = /obj/item/borg/upgrade/modkit/indoors
	cost = 5 //you need two for full damage, so total of 10 for maximum damage
	limited_stock = 2 //you can't use more than two!
	restricted_roles = list("Shaft Miner")

/datum/uplink_item/role_restricted/kitchen_gun
	name = "Kitchen Gun (TM)"
	desc = "A revolutionary .45 caliber cleaning solution! Say goodbye to daily stains and dirty surfaces with Kitchen Gun (TM)! \
	Just five shots from Kitchen Gun (TM), and it'll sparkle like new! Includes two extra ammunition clips!"
	cost = 10
	surplus = 40
	restricted_roles = list("Cook", "Janitor")
	item = /obj/item/storage/box/syndie_kit/kitchen_gun

/datum/uplink_item/role_restricted/kitchen_gun_ammo
	name = "Kitchen Gun (TM) .45 Magazine"
	desc = "An extra eight bullets for an extra eight uses of Kitchen Gun (TM)!"
	cost = 1
	restricted_roles = list("Cook", "Janitor")
	item = /obj/item/ammo_box/magazine/m45/kitchengun

/datum/uplink_item/role_restricted/magillitis_serum
	name = "Magillitis Serum Autoinjector"
	desc = "A single-use autoinjector which contains an experimental serum that causes rapid muscular growth in Hominidae. \
			Side-affects may include hypertrichosis, violent outbursts, and an unending affinity for bananas."
	item = /obj/item/reagent_containers/hypospray/magillitis
	cost = 15
	restricted_roles = list("Geneticist", "Chief Medical Officer")

/datum/uplink_item/role_restricted/modified_syringe_gun
	name = "Modified Syringe Gun"
	desc = "A syringe gun that fires DNA injectors instead of normal syringes."
	item = /obj/item/gun/syringe/dna
	cost = 14
	restricted_roles = list("Geneticist", "Chief Medical Officer")

/datum/uplink_item/role_restricted/chemical_gun
	name = "Reagent Dartgun"
	desc = "A heavily modified syringe gun which is capable of synthesizing its own chemical darts using input reagents. Can hold 100u of reagents."
	item = /obj/item/gun/chem
	cost = 12
	restricted_roles = list("Chemist", "Chief Medical Officer")

/datum/uplink_item/role_restricted/reverse_bear_trap
	name = "Reverse Bear Trap"
	desc = "An ingenious execution device worn on (or forced onto) the head. Arming it starts a 1-minute kitchen timer mounted on the bear trap. When it goes off, the trap's jaws will \
	violently open, instantly killing anyone wearing it by tearing their jaws in half. To arm, attack someone with it while they're not wearing headgear, and you will force it onto their \
	head after three seconds uninterrupted."
	cost = 5
	item = /obj/item/reverse_bear_trap
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/reverse_revolver
	name = "Reverse Revolver"
	desc = "A revolver that always fires at its user. \"Accidentally\" drop your weapon, then watch as the greedy corporate pigs blow their own brains all over the wall. \
	The revolver itself is actually real. Only clumsy people, and clowns, can fire it normally. Comes in a box of hugs. Honk."
	cost = 14
	item = /obj/item/storage/box/hug/reverse_revolver
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/taeclowndo_shoes
	name = "Tae-clown-do Shoes"
	desc = "A pair of shoes for the most elite agents of the honkmotherland. They grant the mastery of taeclowndo with some honk-fu moves as long as they're worn."
	cost = 14
	item = /obj/item/clothing/shoes/clown_shoes/taeclowndo
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/emitter_cannon
	name = "Emitter Cannon"
	desc = "A small emitter fitted into a gun case, do to size constraints and safety it can only shoot about ten times when fully charged."
	cost = 5 //Low ammo, and deals same as 10mm but emp-able
	item = /obj/item/gun/energy/emitter
	restricted_roles = list("Chief Engineer", "Station Engineer", "Atmospheric Technician")

// Pointless
/datum/uplink_item/badass
	category = "(Pointless) Badassery"
	surplus = 0

/datum/uplink_item/badass/cxneb
	name = "Dragon's Tooth Non-Eutactic Blade"
	desc = "An illegal modification of a weapon that is functionally identical to the energy sword, \
			the Non-Eutactic Blade (NEB) forges a hardlight blade on-demand, \
	 		generating an extremely sharp, unbreakable edge that is guaranteed to satisfy your every need. \
	 		This particular model has a polychromic hardlight generator, allowing you to murder in style! \
	 		The illegal modifications bring this weapon up to par with the classic energy sword, and also gives it the energy sword's distinctive sounds."
	item = /obj/item/melee/transforming/energy/sword/cx/traitor
	cost = 8

/datum/uplink_item/badass/costumes/obvious_chameleon
	name = "Broken Chameleon Kit"
	desc = "A set of items that contain chameleon technology allowing you to disguise as pretty much anything on the station, and more! \
			Please note that this kit did NOT pass quality control."
	item = /obj/item/storage/box/syndie_kit/chameleon/broken

/datum/uplink_item/badass/costumes
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops)
	cost = 4
	cant_discount = TRUE

/datum/uplink_item/badass/costumes/centcom_official
	name = "CentCom Official Costume"
	desc = "Ask the crew to \"inspect\" their nuclear disk and weapons system, and then when they decline, pull out a fully automatic rifle and gun down the Captain. \
			Radio headset does not include encryption key. No gun included."
	item = /obj/item/storage/box/syndie_kit/centcom_costume

/datum/uplink_item/badass/costumes/clown
	name = "Clown Costume"
	desc = "Nothing is more terrifying than clowns with fully automatic weaponry."
	item = /obj/item/storage/backpack/duffelbag/clown/syndie

/datum/uplink_item/badass/balloon
	name = "Syndicate Balloon"
	desc = "For showing that you are THE BOSS: A useless red balloon with the Syndicate logo on it. \
			Can blow the deepest of covers."
	item = /obj/item/toy/syndicateballoon
	cost = 20
	cant_discount = TRUE

/datum/uplink_item/badass/syndiecash
	name = "Syndicate Briefcase Full of Cash"
	desc = "A secure briefcase containing 5000 space credits. Useful for bribing personnel, or purchasing goods \
			and services at lucrative prices. The briefcase also feels a little heavier to hold; it has been \
			manufactured to pack a little bit more of a punch if your client needs some convincing."
	item = /obj/item/storage/secure/briefcase/syndie
	cost = 1

/datum/uplink_item/badass/syndiecards
	name = "Syndicate Playing Cards"
	desc = "A special deck of space-grade playing cards with a mono-molecular edge and metal reinforcement, \
			making them slightly more robust than a normal deck of cards. \
			You can also play card games with them or leave them on your victims."
	item = /obj/item/toy/cards/deck/syndicate
	cost = 1
	surplus = 40

/datum/uplink_item/badass/syndiecigs
	name = "Syndicate Smokes"
	desc = "Strong flavor, dense smoke, infused with omnizine."
	item = /obj/item/storage/fancy/cigarettes/cigpack_syndicate
	cost = 2