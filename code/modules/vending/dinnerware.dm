/obj/machinery/vending/dinnerware
	name = "\improper Plasteel Chef's Dinnerware Vendor"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(/obj/item/reagent_containers/glass/bowl = 30,
					/obj/item/storage/bag/tray = 8,
					/obj/item/kitchen/fork = 6,
					/obj/item/kitchen/knife = 6,
					/obj/item/kitchen/efink = 2,
					/obj/item/kitchen/rollingpin = 4,
					/obj/item/kitchen/unrollingpin = 4,
					/obj/item/reagent_containers/food/drinks/drinkingglass = 8,
					/obj/item/clothing/suit/apron/chef = 2,
					/obj/item/storage/box/cups = 2,
					/obj/item/reagent_containers/food/condiment/pack/ketchup = 5,
					/obj/item/reagent_containers/food/condiment/pack/mustard = 5,
					/obj/item/reagent_containers/food/condiment/pack/hotsauce = 5,
					/obj/item/reagent_containers/food/condiment/pack/astrotame = 5,
					/obj/item/reagent_containers/food/condiment/pack/bbqsauce = 5,
					/obj/item/reagent_containers/food/condiment/pack/soysauce = 5,
					/obj/item/reagent_containers/food/condiment/saltshaker = 5,
					/obj/item/reagent_containers/food/condiment/peppermill = 5)
	contraband = list(
					/obj/item/kitchen/knife/butcher = 2,
					/obj/item/reagent_containers/syringe = 3)
	premium = list(
					/obj/item/reagent_containers/food/condiment/enzyme = 1)
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	refill_canister = /obj/item/vending_refill/dinnerware
	resistance_flags = FIRE_PROOF
	default_price = PRICE_REALLY_CHEAP
	extra_price = PRICE_ALMOST_EXPENSIVE
	payment_department = ACCOUNT_SRV
	cost_multiplier_per_dept = list(ACCOUNT_SRV = 0)

/obj/item/vending_refill/dinnerware
	icon_state = "refill_cook"
