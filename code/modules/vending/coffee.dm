/obj/machinery/vending/coffee
	name = "\improper Solar's Best Hot Drinks"
	desc = "A vending machine which dispenses hot drinks."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	products = list(/obj/item/reagent_containers/food/drinks/coffee = 25,
					/obj/item/reagent_containers/food/drinks/mug/tea = 25,
					/obj/item/reagent_containers/food/drinks/mug/tea/red = 10,
					/obj/item/reagent_containers/food/drinks/mug/tea/green = 10,
					/obj/item/reagent_containers/food/drinks/mug/coco = 25)
	contraband = list(/obj/item/reagent_containers/food/drinks/ice = 12,
					/obj/item/reagent_containers/food/drinks/mug/tea/mush = 3,)
	premium = list(/obj/item/reagent_containers/food/condiment/milk = 2,
					/obj/item/reagent_containers/food/drinks/bottle/cream = 2,
					/obj/item/reagent_containers/food/condiment/sugar = 1,
					/obj/item/reagent_containers/food/drinks/mug/tea/forest = 3,)
	refill_canister = /obj/item/vending_refill/coffee
	default_price = PRICE_REALLY_CHEAP
	extra_price = PRICE_PRETTY_CHEAP
	payment_department = ACCOUNT_SRV
	light_mask = "coffee-light-mask"
	light_color = COLOR_DARK_MODERATE_ORANGE

/obj/item/vending_refill/coffee
	machine_name = "Solar's Best Hot Drinks"
	icon_state = "refill_joe"
