
//Reminders-
// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal
// cost = 700- Minimum cost, or infinite points are possible.
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Organic /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/organic
	group = "Food & Hydroponics"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/randomized
	var/num_contained = 15

/datum/supply_pack/organic/randomized/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to num_contained)
		var/item = pick(contains)
		new item(C)

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Meals ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/organic/combomeal2
	name = "Burger Combo #2"
	desc = "We value our customers at the Greasy Griddle, so much so that we're willing to deliver -just for you.- This combo meal contains two burgers, a soda, fries, a toy, and some chicken nuggets."
	cost = 3200
	contains = list(/obj/item/food/burger/bigbite,
					/obj/item/food/burger/cheese,
					/obj/item/food/fries,
					/obj/item/food/condiment/pack/ketchup,
					/obj/item/food/condiment/pack/ketchup,
					/obj/item/food/nugget,
					/obj/item/food/nugget,
					/obj/item/food/nugget,
					/obj/item/food/nugget,
					/obj/item/toy/plush/random)
	crate_name = "combo meal w/toy"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/organic/randomized/candy
	name = "Candy Crate"
	desc = "For people that have an insatiable sweet tooth! Has ten candies to be eaten up.."
	cost = 2500
	num_contained = 10
	contains = list(/obj/item/food/candy,
					/obj/item/food/lollipop,
					/obj/item/food/gumball,
					/obj/item/food/chocolateegg,
					/obj/item/food/donut,
					/obj/item/food/cookie,
					/obj/item/food/sugarcookie,
					/obj/item/food/chococornet,
					/obj/item/food/mint,
					/obj/item/food/spiderlollipop,
					/obj/item/food/chococoin,
					/obj/item/food/fudgedice,
					/obj/item/food/chocoorange,
					/obj/item/food/honeybar,
					/obj/item/food/tinychocolate,
					/obj/item/food/spacetwinkie,
					/obj/item/food/syndicake,
					/obj/item/food/cheesiehonkers,
					/obj/item/food/sugarcookie/spookyskull,
					/obj/item/food/sugarcookie/spookycoffin,
					/obj/item/food/candy_corn,
					/obj/item/food/candiedapple,
					/obj/item/food/chocolatebar,
					/obj/item/food/candyheart,
					/obj/item/storage/fancy/heart_box,
					/obj/item/storage/fancy/donut_box)
	crate_name = "candy crate"

/datum/supply_pack/organic/fiestatortilla
	name = "Fiesta Crate"
	desc = "Spice up the kitchen with this fiesta themed food order! Contains 8 tortilla based food items, as well as a sombrero, moustache, and cloak!"
	cost = 2750
	contains = list(/obj/item/clothing/head/sombrero,
					/obj/item/clothing/suit/hooded/cloak/david,
					/obj/item/clothing/mask/fakemoustache,
					/obj/item/food/taco,
					/obj/item/food/taco,
					/obj/item/food/taco/plain,
					/obj/item/food/taco/plain,
					/obj/item/food/enchiladas,
					/obj/item/food/enchiladas,
					/obj/item/food/carneburrito,
					/obj/item/food/cheesyburrito,
					/obj/item/reagent_containers/glass/bottle/capsaicin,
					/obj/item/reagent_containers/glass/bottle/capsaicin)
	crate_name = "fiesta crate"

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

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Raw Ingredients /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/organic/food
	name = "Food Crate"
	desc = "Get things cooking with this crate full of useful ingredients! Contains a two dozen eggs, three bananas, and two bags of flour and rice, two cartons of milk, soymilk, as well as salt and pepper shakers, an enzyme and sugar bottle, and three slabs of monkeymeat."
	cost = 1000
	contains = list(/obj/item/food/condiment/flour,
					/obj/item/food/condiment/flour,
					/obj/item/food/condiment/rice,
					/obj/item/food/condiment/rice,
					/obj/item/food/condiment/milk,
					/obj/item/food/condiment/milk,
					/obj/item/food/condiment/soymilk,
					/obj/item/food/condiment/saltshaker,
					/obj/item/food/condiment/peppermill,
					/obj/item/storage/fancy/egg_box,
					/obj/item/storage/fancy/egg_box,
					/obj/item/food/condiment/enzyme,
					/obj/item/food/condiment/sugar,
					/obj/item/food/meat/slab/monkey,
					/obj/item/food/meat/slab/monkey,
					/obj/item/food/meat/slab/monkey,
					/obj/item/food/grown/banana,
					/obj/item/food/grown/banana,
					/obj/item/food/grown/banana)
	crate_name = "food crate"

/datum/supply_pack/organic/randomized/fruits
	name = "Fruit Crate"
	desc = "Rich in vitamins and possibly sugar. Contains 15 assorted fruits."
	cost = 1500
	contains = list(/obj/item/food/grown/citrus/lime,
					/obj/item/food/grown/citrus/orange,
					/obj/item/food/grown/banana,
					/obj/item/food/grown/watermelon,
					/obj/item/food/grown/apple,
					/obj/item/food/grown/berries,
					/obj/item/food/grown/citrus/lemon,
					/obj/item/food/grown/pineapple,
					/obj/item/food/grown/cherries,
					/obj/item/food/grown/grapes,
					/obj/item/food/grown/grapes/green,
					/obj/item/food/grown/eggplant,
					/obj/item/food/grown/peach,
					/obj/item/food/grown/strawberry)
	crate_name = "fruit crate"

/datum/supply_pack/organic/cream_piee
	name = "High-yield Clown-grade Cream Pie Crate"
	desc = "Designed by Aussec's Advanced Warfare Research Division, these high-yield, Clown-grade cream pies are powered by a synergy of performance and efficiency. Guaranteed to provide maximum results."
	cost = 6000
	contains = list(/obj/item/storage/backpack/duffelbag/clown/cream_pie)
	crate_name = "party equipment crate"
	contraband = TRUE
	access = ACCESS_THEATRE
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/organic/randomized
	name = "Meat Crate (Exotic)"
	desc = "The best cuts in the whole galaxy. Contains 15 assorted exotic meats."
	cost = 2000
	contains = list(/obj/item/food/meat/slab/human/mutant/slime,
					/obj/item/food/meat/slab/killertomato,
					/obj/item/food/meat/slab/bear,
					/obj/item/food/meat/slab/xeno,
					/obj/item/food/meat/slab/spider,
					/obj/item/food/spidereggs,
					/obj/item/food/meat/rawcrab,
					/obj/item/food/spiderleg,
					/obj/item/food/carpmeat,
					/obj/item/food/meat/slab/human)
	crate_name = "exotic meat crate"

/datum/supply_pack/organic/monkeydripmeat
	name = "Meat Crate (Fresh)"
	desc = "Need some meat? With this do-it-yourself kit you'll be swimming in it! Contains a monkey cube, an IV drip, and some cryoxadone!"
	cost = 2150
	contraband = TRUE
	contains = list(/obj/item/food/cube/monkey,
					/obj/item/restraints/handcuffs/cable,
					/obj/machinery/iv_drip,
					/obj/item/reagent_containers/glass/beaker/cryoxadone,
					/obj/item/reagent_containers/glass/beaker/cryoxadone)
	crate_name = "monkey meat crate"

/datum/supply_pack/organic/fakemeat
	name = "Meat Crate 'Synthetic'"
	desc = "Run outta meat already? Keep the lizards content with this freezer filled with cruelty-free chemically compounded meat! Contains 12 slabs of meat product, and 4 slabs of *carp*."
	cost = 1200 // Buying 3 food crates nets you 9 meat for 900 points, plus like, 6 bags of rice, flour, and egg boxes. This is 12 for 500, but you -only- get meat and carp.
	contains = list(/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/meat/slab/meatproduct,
					/obj/item/food/carpmeat/imitation,
					/obj/item/food/carpmeat/imitation,
					/obj/item/food/carpmeat/imitation,
					/obj/item/food/carpmeat/imitation)
	crate_name = "meaty crate"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/mixedboxes
	name = "Mixed Ingredient Boxes"
	desc = "Get overwhelmed with inspiration by ordering these boxes of surprise ingredients! Get four boxes filled with an assortment of products!"
	cost = 2300
	contains = list(/obj/item/storage/box/ingredients/wildcard,
					/obj/item/storage/box/ingredients/wildcard,
					/obj/item/storage/box/ingredients/wildcard,
					/obj/item/storage/box/ingredients/wildcard)
	crate_name = "wildcard food crate"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/randomized/vegetables
	name = "Vegetable Crate"
	desc = "Grown in vats. Contains 15 assorted vegetables."
	cost = 1300
	contains = list(/obj/item/food/grown/chili,
					/obj/item/food/grown/corn,
					/obj/item/food/grown/tomato,
					/obj/item/food/grown/potato,
					/obj/item/food/grown/carrot,
					/obj/item/food/grown/mushroom/chanterelle,
					/obj/item/food/grown/onion,
					/obj/item/food/grown/pumpkin)
	crate_name = "veggie crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Hydroponics /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

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
	desc = "BEES BEES BEES. Contains three honey frames, a beekeeper suit & helmet, flyswatter, bee house, and, of course, a pure-bred Nanotrasen-Standardized Queen Bee!"
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

/datum/supply_pack/organic/hydroponics/hydrotank
	name = "Hydroponics Backpack Crate"
	desc = "Bring on the flood with this high-capacity backpack crate. Contains 500 units of life-giving H2O. Requires hydroponics access to open."
	cost = 1200
	access = ACCESS_HYDROPONICS
	contains = list(/obj/item/watertank)
	crate_name = "hydroponics backpack crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/organic/hydroponics/maintgarden
	name = "Maintenance Garden Crate"
	desc = "Set up your own tiny paradise with do-it-yourself botany kit. Contains sandstone for dirt plots, pest spray, ammonia, a portable seed generator, basic botanical tools, and some seeds to start off with."
	cost = 2700
	contains = list(/obj/item/storage/bag/plants/portaseeder,
					/obj/item/reagent_containers/spray/pestspray,
					/obj/item/stack/sheet/mineral/sandstone/twelve,
					/obj/item/reagent_containers/glass/bucket,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/hatchet,
					/obj/item/cultivator,
					/obj/item/plant_analyzer,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron,
					/obj/item/flashlight,
					/obj/item/seeds/carrot,
					/obj/item/seeds/carrot,
					/obj/item/seeds/tower,
					/obj/item/seeds/tower,
					/obj/item/seeds/watermelon,
					/obj/item/seeds/watermelon,
					/obj/item/seeds/grass,
					/obj/item/seeds/grass)
	crate_name = "maint garden crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/seeds
	name = "Seeds Crate"
	desc = "Big things have small beginnings. Contains fourteen different seeds."
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
					/obj/item/seeds/sugarcane,
					/obj/item/seeds/ambrosia)
	crate_name = "seeds crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/exoticseeds
	name = "Seeds Crate (Exotic)"
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
					/obj/item/seeds/poppy/lily/trumpet,
					/obj/item/seeds/random,
					/obj/item/seeds/random)
	crate_name = "exotic seeds crate"
	crate_type = /obj/structure/closet/crate/hydroponics

//////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Misc /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/organic/party
	name = "Party Equipment"
	desc = "Celebrate both life and death on the station with Nanotrasen's Party Essentials(tm)! Contains seven colored glowsticks, four beers, two ales, a drinking shaker, and a bottle of patron & goldschlager!"
	cost = 2000
	contains = list(/obj/item/storage/box/drinkingglasses,
					/obj/item/food/drinks/shaker,
					/obj/item/food/drinks/bottle/patron,
					/obj/item/food/drinks/bottle/goldschlager,
					/obj/item/food/drinks/ale,
					/obj/item/food/drinks/ale,
					/obj/item/food/drinks/beer,
					/obj/item/food/drinks/beer,
					/obj/item/food/drinks/beer,
					/obj/item/food/drinks/beer,
					/obj/item/flashlight/glowstick,
					/obj/item/flashlight/glowstick/red,
					/obj/item/flashlight/glowstick/blue,
					/obj/item/flashlight/glowstick/cyan,
					/obj/item/flashlight/glowstick/orange,
					/obj/item/flashlight/glowstick/yellow,
					/obj/item/flashlight/glowstick/pink)
	crate_name = "party equipment crate"

/datum/supply_pack/organic/vday
	name = "Surplus Valentine Crate"
	desc = "Turns out we got warehouses of this love-y dove-y crap. We're sending out small bargain buddle of Valentine gear. This crate has two boxes of chocolate, three poppy flowers, five candy hearts, and three cards."
	cost = 3000
	contraband = TRUE
	contains = list(/obj/item/storage/fancy/heart_box,
					/obj/item/storage/fancy/heart_box,
					/obj/item/food/grown/poppy,
					/obj/item/food/grown/poppy,
					/obj/item/food/grown/poppy,
					/obj/item/food/candyheart,
					/obj/item/food/candyheart,
					/obj/item/food/candyheart,
					/obj/item/food/candyheart,
					/obj/item/food/candyheart,
					/obj/item/valentine,
					/obj/item/valentine,
					/obj/item/valentine)
	crate_name = "valentine crate"
	crate_type = /obj/structure/closet/crate/secure
