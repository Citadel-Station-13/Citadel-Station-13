/obj/machinery/vending/dinnerware
	name = "\improper Plasteel Chef's Dinnerware Vendor"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(/obj/item/reagent_containers/glass/bowl = 30,
					/obj/item/storage/bag/tray = 8,
					/obj/item/kitchen/fork = 6,
					/obj/item/kitchen/knife = 6,
					/obj/item/kitchen/rollingpin = 4,
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
					/obj/item/reagent_containers/food/snacks/cube/monkey= 1,
					/obj/item/kitchen/knife/butcher = 2,
					/obj/item/reagent_containers/syringe = 3)
	premium = list(
					/obj/item/reagent_containers/food/condiment/enzyme = 1,
					/obj/item/reagent_containers/glass/bottle/cryoxadone = 2) // Bartender can literally make this with upgraded parts, or it gets stolen from medical.
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	refill_canister = /obj/item/vending_refill/dinnerware
	resistance_flags = FIRE_PROOF
	default_price = 50
	extra_price = 250
	payment_department = ACCOUNT_SRV
	cost_multiplier_per_dept = list(ACCOUNT_SRV = 0)

/obj/item/vending_refill/dinnerware
	icon_state = "refill_cook"