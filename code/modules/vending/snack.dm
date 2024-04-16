/obj/machinery/vending/snack
	name = "\improper Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	light_mask = "snack-light-mask"
	products = list(/obj/item/reagent_containers/food/snacks/candy = 5,
					/obj/item/reagent_containers/food/snacks/chocolatebar = 5,
					/obj/item/reagent_containers/food/drinks/dry_ramen = 5,
					/obj/item/reagent_containers/food/snacks/chips = 5,
					/obj/item/reagent_containers/food/snacks/sosjerky = 5,
					/obj/item/reagent_containers/food/snacks/no_raisin = 5,
					/obj/item/reagent_containers/food/snacks/spacetwinkie = 5,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 5,
					/obj/item/reagent_containers/food/snacks/cornchips = 5,
					/obj/item/reagent_containers/food/snacks/energybar = 6)
	contraband = list(
					/obj/item/reagent_containers/food/snacks/cracker = 10,
					/obj/item/reagent_containers/food/snacks/honeybar = 5,
					/obj/item/reagent_containers/food/snacks/syndicake = 5,
					/obj/item/reagent_containers/food/snacks/beans = 2)
	premium = list(
					/obj/item/reagent_containers/food/snacks/lollipop = 2,
					/obj/item/reagent_containers/food/snacks/spiderlollipop = 2,
					/obj/item/reagent_containers/food/snacks/chococoin = 1,
					/obj/item/storage/box/marshmallow = 1,
					/obj/item/storage/box/donkpockets = 2)
	refill_canister = /obj/item/vending_refill/snack
	canload_access_list = list(ACCESS_KITCHEN)
	default_price = PRICE_REALLY_CHEAP
	extra_price = PRICE_ALMOST_CHEAP
	payment_department = ACCOUNT_SRV
	input_display_header = "Chef's Food Selection"

/obj/item/vending_refill/snack
	machine_name = "Getmore Chocolate Corp"

/obj/machinery/vending/snack/random
	name = "\improper Random Snackies"
	icon_state = "random_snack"
	desc = "Uh oh!"

/obj/machinery/vending/snack/random/Initialize(mapload)
	. = ..()
	var/T = pick(subtypesof(/obj/machinery/vending/snack) - /obj/machinery/vending/snack/random)
	new T(loc)
	return INITIALIZE_HINT_QDEL

/obj/machinery/vending/snack/blue
	icon_state = "snackblue"

/obj/machinery/vending/snack/orange
	icon_state = "snackorange"

/obj/machinery/vending/snack/green
	icon_state = "snackgreen"

/obj/machinery/vending/snack/teal
	icon_state = "snackteal"
