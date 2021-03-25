/datum/blackmarket_item/consumable
	category = "Consumables"

/datum/blackmarket_item/consumable/clown_tears
	name = "Bowl of Clown's Tears"
	desc = "Guaranteed fresh from Weepy Boggins Tragic Kitchen"
	item = /obj/item/reagent_containers/food/snacks/soup/clownstears
	stock = 1
	price_min = 520
	price_max = 600
	availability_prob = 10

/datum/blackmarket_item/consumable/donk_pocket_box
	name = "Box of Donk Pockets"
	desc = "A well packaged box containing the favourite snack of every spacefarer."
	item = /obj/item/storage/box/donkpockets
	stock_min = 5
	stock_max = 10
	price_min = 250
	price_max = 350
	availability_prob = 100

/datum/blackmarket_item/consumable/suspicious_pills
	name = "Bottle of Suspicious Pills"
	desc = "A random cocktail of luxury drugs that are sure to put a smile on your face!"
	item = /obj/item/storage/pill_bottle
	stock_min = 2
	stock_max = 3
	price_min = 400
	price_max = 700
	availability_prob = 50

/datum/blackmarket_item/consumable/suspicious_pills/spawn_item(loc)
	var/pillbottle = pick(list(/obj/item/storage/pill_bottle/zoom,
				/obj/item/storage/pill_bottle/happy,
				/obj/item/storage/pill_bottle/lsd,
				/obj/item/storage/pill_bottle/aranesp,
				/obj/item/storage/pill_bottle/stimulant))
	return new pillbottle(loc)

/datum/blackmarket_item/consumable/floor_pill
	name = "Strange Pill"
	desc = "The Russian Roulette of the Maintenance Tunnels."
	item = /obj/item/reagent_containers/pill/floorpill
	stock_min = 5
	stock_max = 35
	price_min = 10
	price_max = 60
	availability_prob = 70

/datum/blackmarket_item/consumable/pumpup
	name = "Shoddy Stimulants"
	desc = "Feel the energy inside each needle!"
	item = /obj/item/reagent_containers/hypospray/medipen/stimpack
	stock_max = 5
	price_min = 80
	price_max = 170
	availability_prob = 70

/datum/blackmarket_item/consumable/stray_drink
	name = "A random drink"
	desc = "A surprise drink direcly from the counter. No refunds if the glass breaks."	// it will always break if it's launched at the station
	item = /obj/item/reagent_containers/food/drinks/drinkingglass
	stock_min = 10
	stock_max = 15
	price_min = 100
	price_max = 200
	availability_prob = 100
	// add new drinks here
	var/list/counter = list(
		/datum/reagent/consumable/ethanol/gintonic,
        /datum/reagent/consumable/ethanol/cuba_libre,
        /datum/reagent/consumable/ethanol/martini,
        /datum/reagent/consumable/ethanol/b52,
        /datum/reagent/consumable/ethanol/manhattan,
        /datum/reagent/consumable/ethanol/bahama_mama,
        /datum/reagent/consumable/ethanol/syndicatebomb,
        /datum/reagent/consumable/ethanol/quadruple_sec
	)

// i found no other way to fill a glass with a random reagent at runtime. and i definitely was not going to do the same done in bottle.dm
/datum/blackmarket_item/consumable/stray_drink/spawn_item(loc)
	var/obj/item/reagent_containers/food/drinks/drinkingglass/drink = new item(loc)
	var/picked = pick(counter)
	drink.list_reagents = list()
	drink.list_reagents[picked] = 50
	drink.add_initial_reagents()
	return drink
