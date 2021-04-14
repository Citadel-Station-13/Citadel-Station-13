/obj/machinery/vending/barkbox
	name = "Bark Box"
	desc = "For all your pet needs!"
	icon_state = "barkbox"
	product_slogans = "Whuff!;Bark!;Give me a treat!"
	products = list(
				/obj/item/storage/fancy/treat_box = 8,
				/obj/item/clothing/neck/petcollar = 5,
				/obj/item/clothing/neck/petcollar/ribbon = 5,
				/obj/item/clothing/neck/petcollar/leather = 5,
				/obj/item/clothing/suit/petharness = 4,
				/obj/item/clothing/suit/petharness/mesh = 4,
				/obj/item/toy/fluff/tennis_poly = 4,
				/obj/item/toy/fluff/tennis_poly/tri = 2,
				/obj/item/toy/fluff/bone_poly = 4,
				/obj/item/toy/fluff/frisbee_poly = 4
				)
	contraband = list(
				/obj/item/clothing/neck/petcollar/locked = 2,
				/obj/item/clothing/neck/petcollar/locked/ribbon = 2,
				/obj/item/clothing/neck/petcollar/locked/leather = 2,
				/obj/item/key/collar = 2,
				/obj/item/dildo/knotted = 3
				)
	premium = list(
				/obj/item/toy/fluff/tennis_poly/tri/squeak = 1,
				/obj/item/toy/fluff/bone_poly/squeak = 1
				)
	refill_canister = /obj/item/vending_refill/barkbox
	default_price = PRICE_CHEAP
	extra_price = PRICE_BELOW_NORMAL
	payment_department = NO_FREEBIES

/obj/item/vending_refill/barkbox
	machine_name 	= "Bark Box"
	icon_state 		= "refill_barkbox"
