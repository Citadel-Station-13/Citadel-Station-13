
//Reminders-
// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal
// cost = 700- Minimum cost, or infinite points are possible.
//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Organic /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/organic
	group = "Food & Hydroponics"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/hydroponics/beekeeping_suits
	name = "Beekeeper Suit Crate"
	desc = "Bee business booming? Better be benevolent and boost botany by bestowing bi-Beekeeper-suits! Contains two beekeeper suits and matching headwear."
	cost = 1300
	contains = list(/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/beekeeper_suit,
					/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/beekeeper_suit)
	crate_name = "beekeeper suits"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/hydroponics/beekeeping_fullkit
	name = "Beekeeping Starter Crate"
	desc = "BEES BEES BEES. Contains three honey frames, a beekeeper suit and helmet, flyswatter, bee house, and, of course, a pure-bred Nanotrasen-Standardized Queen Bee!"
	cost = 1800
	contains = list(/obj/structure/beebox/unwrenched,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/queen_bee/bought,
					/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/beekeeper_suit,
					/obj/item/melee/flyswatter)
	crate_name = "beekeeping starter crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/candy/randomised
	name = "Candy Crate"
	desc = "For people that have a insatiable sweet tooth! Has ten candies to be eaten up.."
	cost = 2500
	var/num_contained = 10 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/reagent_containers/food/snacks/candy,
					/obj/item/reagent_containers/food/snacks/lollipop,
					/obj/item/reagent_containers/food/snacks/gumball,
					/obj/item/reagent_containers/food/snacks/chocolateegg,
					/obj/item/reagent_containers/food/snacks/donut,
					/obj/item/reagent_containers/food/snacks/cookie,
					/obj/item/reagent_containers/food/snacks/sugarcookie,
					/obj/item/reagent_containers/food/snacks/chococornet,
					/obj/item/reagent_containers/food/snacks/mint,
					/obj/item/reagent_containers/food/snacks/spiderlollipop,
					/obj/item/reagent_containers/food/snacks/chococoin,
					/obj/item/reagent_containers/food/snacks/fudgedice,
					/obj/item/reagent_containers/food/snacks/chocoorange,
					/obj/item/reagent_containers/food/snacks/honeybar,
					/obj/item/reagent_containers/food/snacks/tinychocolate,
					/obj/item/reagent_containers/food/snacks/spacetwinkie,
					/obj/item/reagent_containers/food/snacks/syndicake,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers,
					/obj/item/reagent_containers/food/snacks/sugarcookie/spookyskull,
					/obj/item/reagent_containers/food/snacks/sugarcookie/spookycoffin,
					/obj/item/reagent_containers/food/snacks/candy_corn,
					/obj/item/reagent_containers/food/snacks/candiedapple,
					/obj/item/reagent_containers/food/snacks/chocolatebar,
					/obj/item/reagent_containers/food/snacks/candyheart,
					/obj/item/storage/fancy/heart_box,
					/obj/item/storage/fancy/donut_box)
	crate_name = "candy crate"

/datum/supply_pack/organic/cutlery
	name = "Kitchen Cutlery Deluxe Set"
	desc = "Need to slice and dice away those ''Tomatos'' well we got what you need! From a nice set of knifes, forks, plates, glasses, and a whetstone for when you got some grizzle that is a bit harder to slice then normal."
	cost = 10000
	contraband = TRUE
	contains = list(/obj/item/sharpener,
					/obj/item/kitchen/fork,
					/obj/item/kitchen/fork,
					/obj/item/kitchen/knife,
					/obj/item/kitchen/knife,
					/obj/item/kitchen/knife,
					/obj/item/kitchen/knife,
					/obj/item/kitchen/knife/butcher,
					/obj/item/kitchen/knife/butcher,
					/obj/item/kitchen/rollingpin, //Deluxe for a reason
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

/datum/supply_pack/organic/food
	name = "Food Crate"
	desc = "Get things cooking with this crate full of useful ingredients! Contains a two dozen eggs, three bananas, and two bags of flour and rice, two cartons of milk, soymilk, as well as salt and pepper shakers, a enzyme and sugar bottle, and three slabs of monkeymeat."
	cost = 1000
	contains = list(/obj/item/reagent_containers/food/condiment/flour,
					/obj/item/reagent_containers/food/condiment/flour,
					/obj/item/reagent_containers/food/condiment/rice,
					/obj/item/reagent_containers/food/condiment/rice,
					/obj/item/reagent_containers/food/condiment/milk,
					/obj/item/reagent_containers/food/condiment/milk,
					/obj/item/reagent_containers/food/condiment/soymilk,
					/obj/item/reagent_containers/food/condiment/saltshaker,
					/obj/item/reagent_containers/food/condiment/peppermill,
					/obj/item/storage/fancy/egg_box,
					/obj/item/storage/fancy/egg_box,
					/obj/item/reagent_containers/food/condiment/enzyme,
					/obj/item/reagent_containers/food/condiment/sugar,
					/obj/item/reagent_containers/food/snacks/meat/slab/monkey,
					/obj/item/reagent_containers/food/snacks/meat/slab/monkey,
					/obj/item/reagent_containers/food/snacks/meat/slab/monkey,
					/obj/item/reagent_containers/food/snacks/grown/banana,
					/obj/item/reagent_containers/food/snacks/grown/banana,
					/obj/item/reagent_containers/food/snacks/grown/banana)
	crate_name = "food crate"

/datum/supply_pack/organic/cream_piee
	name = "High-yield Clown-grade Cream Pie Crate"
	desc = "Designed by Aussec's Advanced Warfare Research Division, these high-yield, Clown-grade cream pies are powered by a synergy of performance and efficiency. Guaranteed to provide maximum results."
	cost = 6000
	contains = list(/obj/item/storage/backpack/duffelbag/clown/cream_pie)
	crate_name = "party equipment crate"
	contraband = TRUE
	access = ACCESS_THEATRE
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/organic/hunting
	name = "Huntting gear"
	desc = "Even in space, we can fine prey to hunt, this crate contains everthing a fine hunter needs to have a sporting time. This crate needs armory access to open. A true huntter only needs a fine bottle of cognac, a nice coat, some good o' cigars, and of cource a huntting shotgun. "
	cost = 3500
	contraband = TRUE
	contains = list(/obj/item/clothing/head/flatcap,
					/obj/item/clothing/suit/hooded/wintercoat/captain,
					/obj/item/reagent_containers/food/drinks/bottle/cognac,
					/obj/item/storage/fancy/cigarettes/cigars/havana,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/under/rank/curator,
					/obj/item/gun/ballistic/shotgun/lethal)
	access = ACCESS_ARMORY
	crate_name = "sporting crate"
	crate_type = /obj/structure/closet/crate/secure // Would have liked a wooden crate but access >:(

/datum/supply_pack/organic/hydroponics
	name = "Hydroponics Crate"
	desc = "Supplies for growing a great garden! Contains two bottles of ammonia, two Plant-B-Gone spray bottles, a hatchet, cultivator, plant analyzer, as well as a pair of leather gloves and a botanist's apron."
	cost = 1750
	contains = list(/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/hatchet,
					/obj/item/cultivator,
					/obj/item/plant_analyzer,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron)
	crate_name = "hydroponics crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/hydroponics/hydrotank
	name = "Hydroponics Backpack Crate"
	desc = "Bring on the flood with this high-capacity backpack crate. Contains 500 units of life-giving H2O. Requires hydroponics access to open."
	cost = 1200
	access = ACCESS_HYDROPONICS
	contains = list(/obj/item/watertank)
	crate_name = "hydroponics backpack crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/organic/mre
	name = "MRE supply kit (emergency rations)"
	desc = "The lights are out. Oxygen's running low. You've run out of food except space weevils. Don't let this be you! Order our NT branded MRE kits today! This pack contains 5 MRE packs with a randomized menu and an oxygen tank."
	cost = 2000
	contains = list(/obj/item/storage/box/mre/menu1/safe,
					/obj/item/storage/box/mre/menu1/safe,
					/obj/item/storage/box/mre/menu2/safe,
					/obj/item/storage/box/mre/menu2/safe,
					/obj/item/storage/box/mre/menu3,
					/obj/item/storage/box/mre/menu4/safe)
	crate_name = "MRE crate (emergency rations)"

/datum/supply_pack/organic/pizza
	name = "Pizza Crate"
	desc = "Best prices on this side of the galaxy. All deliveries are guaranteed to be 99% anomaly-free!"
	cost = 6000 // Best prices this side of the galaxy.
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable,
					/obj/item/pizzabox/pineapple)
	crate_name = "pizza crate"
	var/static/anomalous_box_provided = FALSE

/datum/supply_pack/organic/pizza/fill(obj/structure/closet/crate/C)
	. = ..()
	if(!anomalous_box_provided)
		for(var/obj/item/pizzabox/P in C)
			if(prob(1)) //1% chance for each box, so 4% total chance per order
				var/obj/item/pizzabox/infinite/fourfiveeight = new(C)
				fourfiveeight.boxtag = P.boxtag
				qdel(P)
				anomalous_box_provided = TRUE
				log_game("An anomalous pizza box was provided in a pizza crate at during cargo delivery")
				if(prob(50))
					addtimer(CALLBACK(src, .proc/anomalous_pizza_report), rand(300, 1800))
				else
					message_admins("An anomalous pizza box was silently created with no command report in a pizza crate delivery.")
				break

/datum/supply_pack/organic/pizza/proc/anomalous_pizza_report()
	print_command_report("[station_name()], our anomalous materials divison has reported a missing object that is highly likely to have been sent to your station during a routine cargo \
	delivery. Please search all crates and manifests provided with the delivery and return the object if is located. The object resembles a standard <b>\[DATA EXPUNGED\]</b> and is to be \
	considered <b>\[REDACTED\]</b> and returned at your leisure. Note that objects the anomaly produces are specifically attuned exactly to the individual opening the anomaly; regardless \
	of species, the individual will find the object edible and it will taste great according to their personal definitions, which vary significantly based on person and species.")

/datum/supply_pack/organic/potted_plants
	name = "Potted Plants Crate"
	desc = "Spruce up the station with these lovely plants! Contains a random assortment of five potted plants from Nanotrasen's potted plant research division. Warranty void if thrown."
	cost = 730
	contains = list(/obj/item/twohanded/required/kirbyplants/random,
					/obj/item/twohanded/required/kirbyplants/random,
					/obj/item/twohanded/required/kirbyplants/random,
					/obj/item/twohanded/required/kirbyplants/random,
					/obj/item/twohanded/required/kirbyplants/random)
	crate_name = "potted plants crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/seeds
	name = "Seeds Crate"
	desc = "Big things have small beginnings. Contains thirteen different seeds."
	cost = 1250
	contains = list(/obj/item/seeds/chili,
					/obj/item/seeds/berry,
					/obj/item/seeds/corn,
					/obj/item/seeds/eggplant,
					/obj/item/seeds/tomato,
					/obj/item/seeds/soya,
					/obj/item/seeds/wheat,
					/obj/item/seeds/wheat/rice,
					/obj/item/seeds/carrot,
					/obj/item/seeds/sunflower,
					/obj/item/seeds/chanter,
					/obj/item/seeds/potato,
					/obj/item/seeds/sugarcane)
	crate_name = "seeds crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/vday
	name = "Surplus Valentine Crate"
	desc = "Turns out we got warehouses of this love-y dove-y crap. Were sending out small barged buddle of Valentine gear. This crate has two boxes of chocolate, three poppy flowers, five candy hearts, and three cards."
	cost = 3000
	contraband = TRUE
	contains = list(/obj/item/storage/fancy/heart_box,
					/obj/item/storage/fancy/heart_box,
					/obj/item/reagent_containers/food/snacks/grown/poppy,
					/obj/item/reagent_containers/food/snacks/grown/poppy,
					/obj/item/reagent_containers/food/snacks/grown/poppy,
					/obj/item/reagent_containers/food/snacks/candyheart,
					/obj/item/reagent_containers/food/snacks/candyheart,
					/obj/item/reagent_containers/food/snacks/candyheart,
					/obj/item/reagent_containers/food/snacks/candyheart,
					/obj/item/reagent_containers/food/snacks/candyheart,
					/obj/item/valentine,
					/obj/item/valentine,
					/obj/item/valentine)
	crate_name = "valentine crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/organic/exoticseeds
	name = "Exotic Seeds Crate"
	desc = "Any entrepreneuring botanist's dream. Contains twelve different seeds, including three replica-pod seeds and two mystery seeds!"
	cost = 1500
	contains = list(/obj/item/seeds/nettle,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/plump,
					/obj/item/seeds/liberty,
					/obj/item/seeds/amanita,
					/obj/item/seeds/reishi,
					/obj/item/seeds/banana,
					/obj/item/seeds/eggplant/eggy,
					/obj/item/seeds/random,
					/obj/item/seeds/random)
	crate_name = "exotic seeds crate"
	crate_type = /obj/structure/closet/crate/hydroponics
