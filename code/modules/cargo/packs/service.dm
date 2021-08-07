
//Reminders-
// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal
// cost = 700- Minimum cost, or infinite points are possible.
//////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Service //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/service
	group = "Service"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Cargo ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/service/wrapping_paper
	name = "Cargo Packaging Crate"
	desc = "Want to mail your loved ones gift-wrapped chocolates, stuffed animals, or the Clown's severed head? You can do all that, with this crate full of festive (and normal) wrapping paper. Also contains a hand labeler and a destination tagger for easy shipping!"
	cost = 1000
	contains = list(/obj/item/stack/wrapping_paper,
					/obj/item/stack/wrapping_paper,
					/obj/item/stack/wrapping_paper,
					/obj/item/stack/packageWrap,
					/obj/item/stack/packageWrap,
					/obj/item/stack/packageWrap,
					/obj/item/destTagger,
					/obj/item/hand_labeler)
	crate_type = /obj/structure/closet/crate/wooden
	crate_name = "wrapping paper crate"

/datum/supply_pack/service/cargo_supples
	name = "Cargo Supplies Crate"
	desc = "Sold everything that wasn't bolted down? You can get right back to work with this crate containing stamps, an export scanner, destination tagger, hand labeler and some package wrapping. Now with extra toner cartidges!"
	cost = 1000
	contains = list(/obj/item/stamp,
					/obj/item/stamp/denied,
					/obj/item/export_scanner,
					/obj/item/destTagger,
					/obj/item/hand_labeler,
					/obj/item/toner,
					/obj/item/toner,
					/obj/item/stack/packageWrap,
					/obj/item/stack/packageWrap)
	crate_name = "cargo supplies crate"

/datum/supply_pack/service/mule
	name = "MULEbot Crate"
	desc = "Pink-haired Quartermaster not doing her job? Replace her with this tireless worker, today!"
	cost = 2000
	contains = list(/mob/living/simple_animal/bot/mulebot)
	crate_name = "\improper MULEbot Crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/minerkit
	name = "Shaft Miner Starter Kit"
	desc = "All the miners died too fast? Assistant wants to get a taste of life off-station? Either way, this kit is the best way to turn a regular crewman into an ore-producing, monster-slaying machine. Contains meson goggles, a pickaxe, advanced mining scanner, cargo headset, ore bag, gasmask, and explorer suit. Requires QM access to open."
	cost = 2500
	access = ACCESS_QM
	contains = list(/obj/item/pickaxe/mini,
			/obj/item/clothing/glasses/meson,
			/obj/item/t_scanner/adv_mining_scanner/lesser,
			/obj/item/radio/headset/headset_cargo/mining,
			/obj/item/storage/bag/ore,
			/obj/item/clothing/suit/hooded/explorer/standard,
			/obj/item/clothing/mask/gas/explorer)
	crate_name = "shaft miner starter kit"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/service/snowmobile
	name = "Snowmobile kit"
	desc = "trapped on a frigid wasteland? need to get around fast? purchase a refurbished snowmobile, with a FREE 10 microsecond warranty!"
	cost = 1500 // 1000 points cheaper than ATV
	contains = list(/obj/vehicle/ridden/atv/snowmobile = 1,
			/obj/item/key = 1,
			/obj/item/clothing/mask/gas/explorer = 1)
	crate_name = "Snowmobile kit"
	crate_type = /obj/structure/closet/crate/large

//////////////////////////////////////////////////////////////////////////////
/////////////////////// Chef, Botanist, Bartender ////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/service/buildabar
	name = "Build a Bar Crate"
	desc = "Looking to set up your own little safe haven? Maintenance bar too much of a bummer to work on? Maybe you just want to set up shop right in front of the bartender. Whatever your reasons, get a jump-start on this with this handy kit. Contains circuitboards for bar equipment, some parts, and some basic bartending supplies. (Batteries not Included)"
	cost = 3750
	contains = list(/obj/item/storage/box/drinkingglasses,
					/obj/item/storage/box/drinkingglasses,
					/obj/item/stock_parts/matter_bin,
					/obj/item/stock_parts/matter_bin,
					/obj/item/stock_parts/matter_bin,
					/obj/item/stock_parts/matter_bin,
					/obj/item/stock_parts/matter_bin,
					/obj/item/stock_parts/matter_bin,
					/obj/item/stock_parts/manipulator,
					/obj/item/stock_parts/manipulator,
					/obj/item/stock_parts/manipulator,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/capacitor,
					/obj/item/stack/sheet/metal/ten,
					/obj/item/stack/sheet/metal/five,
					/obj/item/stack/sheet/glass/five,
					/obj/item/stack/cable_coil/random,
					/obj/item/reagent_containers/rag,
					/obj/item/book/manual/wiki/barman_recipes,
					/obj/item/book/granter/action/drink_fling,
					/obj/item/reagent_containers/food/drinks/shaker,
					/obj/item/circuitboard/machine/chem_dispenser/drinks/beer,
					/obj/item/circuitboard/machine/chem_dispenser/drinks,
					/obj/item/circuitboard/machine/dish_drive)
	crate_name = "build a bar crate"

/datum/supply_pack/service/food_cart
	name = "Food Cart Crate"
	desc = "Want to sell food on the go? Cook lost their cart? Well we just so happen to have a few carts to spare!"
	cost = 1000
	contains = list(/obj/machinery/food_cart)
	crate_name = "food cart crate"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/service/icecream_cart
	name = "Ice Cream Cart Crate"
	desc = "Plasma fire too hot for you? Want a nice treat after a hard days work? Well now we have the cart for you! This Ice Cream Vat has everthing you need to make you and your friends so ice cream treats! This cart comes stocked with some ingredients for each type of scoopable icecream."
	cost = 2750 //Comes prestocked with basic ingredients
	contains = list(/obj/machinery/icecream_vat)
	crate_name = "ice cream vat crate"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/service/grill
	name = "Grilling Starter Kit"
	desc = "Hey dad I'm Hungry. Hi Hungry I'm THE NEW GRILLING STARTER KIT ONLY 5000 BUX GET NOW! Contains a cooking grill and five fuel coal sheets."
	cost = 3000
	contains = list(/obj/item/stack/sheet/mineral/coal/five,
					/obj/machinery/grill/unwrenched)
	crate_name = "grilling starter kit crate"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/service/grillfuel
	name = "Grilling Fuel Kit"
	desc = "Contains coal and coal accessories. (Note: only ten coal sheets.)"
	cost = 1000
	contains = list(/obj/item/stack/sheet/mineral/coal/ten)
	crate_name = "grilling fuel kit crate"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/service/cutlery
	name = "Kitchen Cutlery Deluxe Set"
	desc = "Need to slice and dice away those \"Tomatoes\"? Well we got what you need! From a nice set of knifes, forks, plates, glasses, and a whetstone for when you got some grizzle that is a bit harder to slice then normal."
	cost = 10000
	contraband = TRUE
	contains = list(/obj/item/sharpener, //Deluxe for a reason
					/obj/item/kitchen/fork,
					/obj/item/kitchen/fork,
					/obj/item/kitchen/knife,
					/obj/item/kitchen/knife,
					/obj/item/kitchen/knife,
					/obj/item/kitchen/knife,
					/obj/item/kitchen/knife/butcher,
					/obj/item/kitchen/knife/butcher,
					/obj/item/kitchen/rollingpin,
					/obj/item/trash/plate,
					/obj/item/trash/plate,
					/obj/item/trash/plate,
					/obj/item/trash/plate,
					/obj/item/reagent_containers/food/drinks/drinkingglass,
					/obj/item/reagent_containers/food/drinks/drinkingglass,
					/obj/item/reagent_containers/food/drinks/drinkingglass,
					/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass,
					/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass)
	crate_name = "kitchen cutlery deluxe set"

/datum/supply_pack/service/replacementdb
	name = "Replacement Defensive Bar Shotgun"
	desc = "Someone stole the Bartender's twin-barreled possession? Give them another one at a significant markup. Comes with one unused double-barrel shotgun, additional shells not included. Requires bartender access to open."
	cost = 2200
	access = ACCESS_BAR
	contraband = TRUE
	contains = list(/obj/item/gun/ballistic/revolver/doublebarrel)
	crate_name = "replacement double-barrel crate"
	crate_type = /obj/structure/closet/crate/secure

//////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Janitor //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/service/advlighting
	name = "Advanced Lighting crate"
	desc = "Thanks to advanced lighting tech we here at the Lamp Factory have be able to produce more lamps and lamp items! This crate has three lamps, a box of lights and a state of the art rapid-light-device!"
	cost = 2750
	contains = list(/obj/item/construction/rld,
					/obj/item/flashlight/lamp,
					/obj/item/flashlight/lamp,
					/obj/item/flashlight/lamp/green,
					/obj/item/storage/box/lights/mixed)
	crate_name = "advanced lighting crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/service/lightbulbs
	name = "Replacement Lights" //Subgrouping this with Advanced Lighting Crate, they're both lighting related.
	desc = "May the light of Aether shine upon this station! Or at least, the light of forty two light tubes and twenty one light bulbs as well as a light replacer."
	cost = 1200
	contains = list(/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed,
					/obj/item/lightreplacer)
	crate_name = "replacement lights"

/datum/supply_pack/service/janitor/advanced
	name = "Advanced Sanitation Crate"
	desc = "Contains all the essentials for an advanced spacefaring cleanup crew. This kit includes a trashbag, an advanced mop, a bottle of space cleaner, a floor buffer, and a holosign projector. Requires Janitorial Access to Open"
	cost = 5700
	access = ACCESS_JANITOR
	contains = list(/obj/item/storage/bag/trash/bluespace,
					/obj/item/reagent_containers/spray/cleaner,
					/obj/item/mop/advanced,
					/obj/item/lightreplacer,
					/obj/item/janiupgrade,
					/obj/item/holosign_creator)
	crate_name = "advanced santation crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/service/janitor/janpimp
	name = "Custodial Cruiser"
	desc = "Clown steal your ride? Assistant lock it in the dorms? Order a new one and get back to cleaning in style!"
	cost = 3000
	access = ACCESS_JANITOR
	contains = list(/obj/vehicle/ridden/janicart,
					/obj/item/key/janitor)
	crate_name = "janitor ride crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/janitor/janitank
	name = "Janitor Backpack Crate"
	desc = "Call forth divine judgement upon dirt and grime with this high capacity janitor backpack. Contains 500 units of station-cleansing cleaner. Requires janitor access to open."
	cost = 1000
	access = ACCESS_JANITOR
	contains = list(/obj/item/watertank/janitor)
	crate_name = "janitor backpack crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/service/janitor/janpremium
	name = "Janitor Supplies (Premium)"
	desc = "The custodial union is in a tizzy, so we've gathered up some better supplies for you. In this crate you can get a brand new chem, Drying Agent. This stuff is the work of slimes or magic! This crate also contains a rag to test out the Drying Angent magic, several cleaning grenades, some spare bottles of ammonia, and an MCE (or Massive Cleaning Explosive)."
	cost = 2700
	contains = list(/obj/item/grenade/clusterbuster/cleaner,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/reagent_containers/rag,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/reagent_containers/spray/drying_agent)
	crate_name = "premium janitorial crate"

/datum/supply_pack/service/janitor/starter
	name = "Janitorial Supplies (Standard)"
	desc = "Fight back against dirt and grime with Nanotrasen's Janitorial Essentials(tm)! Contains three buckets, caution signs, and cleaner grenades. Also has a single mop, spray cleaner, rag, NT soap and a trash bag."
	cost = 1300
	contains = list(/obj/item/reagent_containers/glass/bucket,
					/obj/item/reagent_containers/glass/bucket,
					/obj/item/reagent_containers/glass/bucket,
					/obj/item/mop,
					/obj/item/clothing/suit/caution,
					/obj/item/clothing/suit/caution,
					/obj/item/clothing/suit/caution,
					/obj/item/storage/bag/trash,
					/obj/item/reagent_containers/spray/cleaner,
					/obj/item/reagent_containers/rag,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/soap/nanotrasen)
	crate_name = "standard janitorial crate"

/datum/supply_pack/service/janitor/janicart
	name = "Janicart and Galoshes Crate"
	desc = "The keystone to any successful janitor. As long as you have feet, this pair of galoshes will keep them firmly planted on the ground. Also contains a janitorial cart."
	cost = 2000
	contains = list(/obj/structure/janitorialcart,
					/obj/item/clothing/shoes/galoshes)
	crate_name = "janitorial cart crate"
	crate_type = /obj/structure/closet/crate/large

