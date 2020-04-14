/obj/machinery/vending/kink
	name = "KinkMate"
	desc = "A vending machine for all your unmentionable desires."
	icon_state = "kink"
	circuit = /obj/item/circuitboard/machine/kinkmate
	product_slogans = "Kinky!;Sexy!;Check me out, big boy!"
	vend_reply = "Have fun, you shameless pervert!"
	products = list(
				/obj/item/clothing/under/costume/maid = 5,
				/obj/item/clothing/under/rank/civilian/janitor/maid = 5,
				/obj/item/clothing/neck/petcollar = 5,
				/obj/item/clothing/neck/petcollar/choker = 5,
				/obj/item/clothing/neck/petcollar/leather = 5,
				/obj/item/restraints/handcuffs/fake/kinky = 5,
				/obj/item/clothing/glasses/sunglasses/blindfold = 4,
				/obj/item/clothing/mask/muzzle = 4,
				/obj/item/clothing/under/misc/stripper = 3,
				/obj/item/clothing/under/misc/stripper/green = 3,
				/obj/item/clothing/under/dress/corset = 3,
				/obj/item/clothing/under/misc/gear_harness = 10,
				/obj/item/dildo/custom = 5,
				/obj/item/electropack/shockcollar = 3,
				/obj/item/assembly/signaler = 3
				)
	contraband = list(
				/obj/item/clothing/neck/petcollar/locked = 2,
				/obj/item/key/collar = 2,
				/obj/item/clothing/head/kitty = 3,
				/obj/item/clothing/head/rabbitears = 3,
				/obj/item/clothing/under/misc/keyholesweater = 2,
				/obj/item/clothing/under/misc/stripper/mankini = 2,
				/obj/item/clothing/under/costume/jabroni = 2,
				/obj/item/dildo/flared/huge = 3,
				/obj/item/reagent_containers/glass/bottle/crocin = 5,
				/obj/item/reagent_containers/glass/bottle/camphor = 5
				)
	premium = list(
				/obj/item/clothing/accessory/skullcodpiece/fake = 3,
				/obj/item/reagent_containers/glass/bottle/hexacrocin = 10,
				/obj/item/clothing/under/pants/chaps = 5
				)
	refill_canister = /obj/item/vending_refill/kink

/obj/item/vending_refill/kink
	machine_name 	= "KinkMate"
	icon_state 		= "refill_kink"
