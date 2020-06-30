/obj/machinery/vending/kink
	name = "KinkMate"
	desc = "A vending machine for all your unmentionable desires."
	icon_state = "kink"
	circuit = /obj/item/circuitboard/machine/kinkmate
	product_slogans = "Kinky!;Sexy!;Check me out, big boy!"
	vend_reply = "Have fun, you shameless pervert!"
	products = list(
				/obj/item/clothing/under/misc/keyholesweater = 2,
				/obj/item/clothing/under/pants/chaps = 2,
				/obj/item/clothing/under/costume/jabroni = 2,
				/obj/item/clothing/under/costume/maid = 2,
				/obj/item/clothing/under/rank/civilian/janitor/maid = 2,
				/obj/item/clothing/neck/petcollar = 2,
				/obj/item/clothing/neck/petcollar/choker = 2,
				/obj/item/clothing/neck/petcollar/leather = 2,
				/obj/item/restraints/handcuffs/fake/kinky = 5,
				/obj/item/clothing/glasses/sunglasses/blindfold = 4,
				/obj/item/clothing/mask/muzzle = 4,
				/obj/item/clothing/under/misc/gear_harness = 2,
				/obj/item/clothing/under/shorts/polychromic/pantsu = 3,
				/obj/item/clothing/under/misc/poly_bottomless = 3,
				/obj/item/clothing/under/misc/poly_tanktop = 3,
				/obj/item/clothing/under/misc/poly_tanktop/female = 3
				)
	contraband = list(
				/obj/item/electropack/shockcollar = 3,
				/obj/item/assembly/signaler = 3,
				/obj/item/clothing/under/misc/stripper/mankini = 2
				)
	premium = list(
				/obj/item/clothing/neck/petcollar/locked = 2,
				/obj/item/key/collar = 2,
				/obj/item/clothing/head/kitty = 3,
				/obj/item/clothing/head/rabbitears = 3,
				/obj/item/clothing/accessory/skullcodpiece/fake = 3,
				/obj/item/clothing/under/misc/stripper = 2,
				/obj/item/clothing/under/misc/stripper/green = 2,
				/obj/item/clothing/under/dress/corset = 2
				)
	refill_canister = /obj/item/vending_refill/kink
	default_price = PRICE_CHEAP
	extra_price = PRICE_BELOW_NORMAL
	payment_department = NO_FREEBIES

/obj/item/vending_refill/kink
	machine_name 	= "KinkMate"
	icon_state 		= "refill_kink"
