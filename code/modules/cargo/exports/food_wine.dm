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
	export_types = list(/obj/item/food/meat/slab)

/datum/export/food/raw_cutlets
	cost = 3
	unit_name = "protein based food"
	export_types = list(/obj/item/food/meat/rawcutlet)

/datum/export/food/cooked_cutlets
	cost = 4
	unit_name = "cooked protein based food"
	export_types = list(/obj/item/food/meat/cutlet)

/datum/export/food/cooked_meat
	cost = 8
	unit_name = "cooked protein based food"
	export_types = list(/obj/item/food/meat/steak)

/datum/export/food/dough
	cost = 3
	unit_name = "uncooked food base"
	export_types = list(/obj/item/food/dough, /obj/item/food/flatdough)

/datum/export/food/cooked_dough
	cost = 5
	unit_name = "cooked food base"
	export_types = list(/obj/item/food/pizzabread)

/datum/export/food/buns
	cost = 3
	unit_name = "cooked food base"
	export_types = list(/obj/item/food/bun)

/datum/export/food/buns
	cost = 3
	unit_name = "cooked food base"
	export_types = list(/obj/item/food/bun)

/datum/export/food/eggs
	cost = 4
	unit_name = "cooked food base"
	export_types = list(/obj/item/food/friedegg)

/datum/export/food/eggs_food
	cost = 20
	unit_name = "cooked egg based food"
	export_types = list(/obj/item/food/omelette, /obj/item/food/benedict, /obj/item/food/salad/eggbowl)

/datum/export/food/sweets
	cost = 4
	unit_name = "pastery base"
	export_types = list(/obj/item/food/rawpastrybase, /obj/item/food/pastrybase)

/datum/export/food/cake_pie_raw
	cost = 12
	unit_name = "uncooked food base"
	export_types = list(/obj/item/food/cakebatter, /obj/item/food/piedough)

/datum/export/food/cooked_cake_pie
	cost = 15
	unit_name = "cooked food base"
	export_types = list(/obj/item/food/cake/plain, /obj/item/food/pie/plain)

/datum/export/food/glassbottle
	cost = 10
	unit_name = "glass bottle"
	export_types = list(/obj/item/food/drinks/bottle)

/datum/export/food/produce
	cost = 3
	unit_name = "produce"
	export_types = list(/obj/item/food/grown)
	exclude_types = list(/obj/item/grown/log)

/datum/export/food/egg
	cost = 2
	unit_name = "egg"
	export_types = list(/obj/item/food/egg)

/datum/export/food/soup
	cost = 30
	unit_name = "bowl of soup"
	export_types = list(/obj/item/food/soup)

/datum/export/food/bread
	cost = 20
	unit_name = "load of bread"
	export_types = list(/obj/item/food/bread)

/datum/export/food/bread_slice
	cost = 4
	unit_name = "slice of bread"
	export_types = list(/obj/item/food/breadslice)

/datum/export/food/burger
	cost = 12
	unit_name = "burger"
	export_types = list(/obj/item/food/burger)

/datum/export/food/cake
	cost = 50
	unit_name = "cake"
	export_types = list(/obj/item/food/cake)

/datum/export/food/cake_slice
	cost = 10
	unit_name = "cake slice"
	export_types = list(/obj/item/food/cakeslice)

/datum/export/food/cheese_wheel
	cost = 70
	unit_name = "cheese wheel"
	export_types = list(/obj/item/food/cheese/wheel)

/datum/export/food/cheese_wheel
	cost = 20
	unit_name = "cheese wedge"
	export_types = list(/obj/item/food/cheese)

/datum/export/food/candy
	cost = 5
	unit_name = "candy" //Not anything from the vender
	export_types = list(/obj/item/food/candy_corn, /obj/item/food/chocolatebar, /obj/item/food/candiedapple, /obj/item/food/spiderlollipop, \
						/obj/item/food/chococoin, /obj/item/food/fudgedice, /obj/item/food/chocoorange, /obj/item/food/lollipop, \
						/obj/item/food/gumball, /obj/item/food/tinychocolate)

/datum/export/food/pastery
	cost = 30
	unit_name = "baked goods"
	export_types = list(/obj/item/food/donut, /obj/item/food/muffin, /obj/item/food/waffles, /obj/item/food/plumphelmetbiscuit, \
						/obj/item/food/chococornet, /obj/item/food/cherrycupcake, /obj/item/food/bluecherrycupcake, /obj/item/food/honeybun, /obj/item/food/pancakes)

/datum/export/food/pasta
	cost = 20
	unit_name = "pasta based meal"
	export_types = list(/obj/item/food/spaghetti, /obj/item/food/boiledspaghetti, /obj/item/food/pastatomato, /obj/item/food/copypasta, \
						/obj/item/food/meatballspaghetti, /obj/item/food/spesslaw, /obj/item/food/chowmein, /obj/item/food/beefnoodle, /obj/item/food/butternoodles)

/datum/export/food/pizza
	cost = 120
	unit_name = "pizza"
	export_types = list(/obj/item/food/pizza)

/datum/export/food/sliced_pizza
	cost = 12
	unit_name = "pizza slice"
	export_types = list(/obj/item/food/pizzaslice)

/datum/export/food/snowcone
	cost = 3
	unit_name = "snowcone"
	export_types = list(/obj/item/food/snowcones)

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
