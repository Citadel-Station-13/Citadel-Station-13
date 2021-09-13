/datum/export/food
	k_elasticity = 0
	include_subtypes = TRUE

/datum/export/booze //Like the kind you bottle!
	k_elasticity = 0
	unit_name = "brand unit of booze"
	include_subtypes = TRUE

/datum/export/food/meat
	cost = 5
	unit_name = "protein based food"
	export_types = list(/obj/item/reagent_containers/food/meat/slab)

/datum/export/food/raw_cutlets
	cost = 3
	unit_name = "protein based food"
	export_types = list(/obj/item/reagent_containers/food/meat/rawcutlet)

/datum/export/food/cooked_cutlets
	cost = 4
	unit_name = "cooked protein based food"
	export_types = list(/obj/item/reagent_containers/food/meat/cutlet)

/datum/export/food/cooked_meat
	cost = 8
	unit_name = "cooked protein based food"
	export_types = list(/obj/item/reagent_containers/food/meat/steak)

/datum/export/food/dough
	cost = 3
	unit_name = "uncooked food base"
	export_types = list(/obj/item/reagent_containers/food/dough, /obj/item/reagent_containers/food/flatdough)

/datum/export/food/cooked_dough
	cost = 5
	unit_name = "cooked food base"
	export_types = list(/obj/item/reagent_containers/food/pizzabread)

/datum/export/food/buns
	cost = 3
	unit_name = "cooked food base"
	export_types = list(/obj/item/reagent_containers/food/bun)

/datum/export/food/buns
	cost = 3
	unit_name = "cooked food base"
	export_types = list(/obj/item/reagent_containers/food/bun)

/datum/export/food/eggs
	cost = 4
	unit_name = "cooked food base"
	export_types = list(/obj/item/reagent_containers/food/friedegg)

/datum/export/food/eggs_food
	cost = 20
	unit_name = "cooked egg based food"
	export_types = list(/obj/item/reagent_containers/food/omelette, /obj/item/reagent_containers/food/benedict, /obj/item/reagent_containers/food/salad/eggbowl)

/datum/export/food/sweets
	cost = 4
	unit_name = "pastery base"
	export_types = list(/obj/item/reagent_containers/food/rawpastrybase, /obj/item/reagent_containers/food/pastrybase)

/datum/export/food/cake_pie_raw
	cost = 12
	unit_name = "uncooked food base"
	export_types = list(/obj/item/reagent_containers/food/cakebatter, /obj/item/reagent_containers/food/piedough)

/datum/export/food/cooked_cake_pie
	cost = 15
	unit_name = "cooked food base"
	export_types = list(/obj/item/reagent_containers/food/cake/plain, /obj/item/reagent_containers/food/pie/plain)

/datum/export/food/glassbottle
	cost = 10
	unit_name = "glass bottle"
	export_types = list(/obj/item/reagent_containers/food/drinks/bottle)

/datum/export/food/produce
	cost = 3
	unit_name = "produce"
	export_types = list(/obj/item/food/grown)
	exclude_types = list(/obj/item/grown/log)

/datum/export/food/egg
	cost = 2
	unit_name = "egg"
	export_types = list(/obj/item/reagent_containers/food/egg)

/datum/export/food/soup
	cost = 30
	unit_name = "bowl of soup"
	export_types = list(/obj/item/reagent_containers/food/soup)

/datum/export/food/bread
	cost = 20
	unit_name = "load of bread"
	export_types = list(/obj/item/reagent_containers/food/bread)

/datum/export/food/bread_slice
	cost = 4
	unit_name = "slice of bread"
	export_types = list(/obj/item/reagent_containers/food/breadslice)

/datum/export/food/burger
	cost = 12
	unit_name = "burger"
	export_types = list(/obj/item/reagent_containers/food/burger)

/datum/export/food/cake
	cost = 50
	unit_name = "cake"
	export_types = list(/obj/item/reagent_containers/food/cake)

/datum/export/food/cake_slice
	cost = 10
	unit_name = "cake slice"
	export_types = list(/obj/item/reagent_containers/food/cakeslice)

/datum/export/food/cheese_wheel
	cost = 70
	unit_name = "cheese wheel"
	export_types = list(/obj/item/reagent_containers/food/cheesewheel)

/datum/export/food/cheese_wheel
	cost = 20
	unit_name = "cheese wedge"
	export_types = list(/obj/item/reagent_containers/food/cheesewedge)

/datum/export/food/candy
	cost = 5
	unit_name = "candy" //Not anything from the vender
	export_types = list(/obj/item/reagent_containers/food/candy_corn, /obj/item/reagent_containers/food/chocolatebar, /obj/item/reagent_containers/food/candiedapple, /obj/item/reagent_containers/food/spiderlollipop, \
						/obj/item/reagent_containers/food/chococoin, /obj/item/reagent_containers/food/fudgedice, /obj/item/reagent_containers/food/chocoorange, /obj/item/reagent_containers/food/lollipop, \
						/obj/item/reagent_containers/food/gumball, /obj/item/reagent_containers/food/tinychocolate)

/datum/export/food/pastery
	cost = 30
	unit_name = "baked goods"
	export_types = list(/obj/item/reagent_containers/food/donut, /obj/item/reagent_containers/food/muffin, /obj/item/reagent_containers/food/waffles, /obj/item/reagent_containers/food/plumphelmetbiscuit, \
						/obj/item/reagent_containers/food/chococornet, /obj/item/reagent_containers/food/cherrycupcake, /obj/item/reagent_containers/food/bluecherrycupcake, /obj/item/reagent_containers/food/honeybun, /obj/item/reagent_containers/food/pancakes)

/datum/export/food/pasta
	cost = 20
	unit_name = "pasta based meal"
	export_types = list(/obj/item/reagent_containers/food/spaghetti, /obj/item/reagent_containers/food/boiledspaghetti, /obj/item/reagent_containers/food/pastatomato, /obj/item/reagent_containers/food/copypasta, \
						/obj/item/reagent_containers/food/meatballspaghetti, /obj/item/reagent_containers/food/spesslaw, /obj/item/reagent_containers/food/chowmein, /obj/item/reagent_containers/food/beefnoodle, /obj/item/reagent_containers/food/butternoodles)

/datum/export/food/pizza
	cost = 120
	unit_name = "pizza"
	export_types = list(/obj/item/reagent_containers/food/pizza)

/datum/export/food/sliced_pizza
	cost = 12
	unit_name = "pizza slice"
	export_types = list(/obj/item/reagent_containers/food/pizzaslice)

/datum/export/food/snowcone
	cost = 3
	unit_name = "snowcone"
	export_types = list(/obj/item/reagent_containers/food/snowcones)

/datum/export/booze/brands
	cost = 200
	unit_name = "export bottle"
	export_types = list(/obj/item/export/bottle/kahlua, /obj/item/export/bottle/whiskey, /obj/item/export/bottle/vodka, /obj/item/export/bottle/gin, \
						/obj/item/export/bottle/rum, /obj/item/export/bottle/tequila, /obj/item/export/bottle/vermouth, /obj/item/export/bottle/wine, /obj/item/export/bottle/grappa, /obj/item/export/bottle/cognac, \
						/obj/item/export/bottle/absinthe, /obj/item/export/bottle/goldschlager, /obj/item/export/bottle/patron, /obj/item/export/bottle/sake, /obj/item/export/bottle/hcider, /obj/item/export/bottle/champagne, \
						/obj/item/export/bottle/applejack, /obj/item/export/bottle/trappist, /obj/item/export/bottle/blazaam, /obj/item/export/bottle/grenadine, /obj/item/export/bottle/fernet)

/datum/export/booze/bottled
	cost = 400
	unit_name = "exotic brews"
	export_types = list(/obj/item/export/bottle/blooddrop, /obj/item/export/bottle/slim_gold, /obj/item/export/bottle/white_bloodmoon, /obj/item/export/bottle/greenroad)

/datum/export/booze/bottledkeg
	cost = 250
	unit_name = "exotic brews"
	export_types = list(/obj/item/export/bottle/minikeg) //Its just beer
