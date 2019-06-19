/obj/machinery/vending/kink
	name = "KinkMate"
	desc = "A vending machine for all your unmentionable desires."
	icon = 'icons/obj/citvending.dmi'
	icon_state = "kink"
	circuit = /obj/item/circuitboard/machine/kinkmate
	product_slogans = "Kinky!;Sexy!;Check me out, big boy!"
	vend_reply = "Have fun, you shameless pervert!"
	products = list(
				/obj/item/clothing/under/maid = 5,
				/obj/item/clothing/under/stripper_pink = 5,
				/obj/item/clothing/under/stripper_green = 5,
				/obj/item/dildo/custom = 5
				)
	contraband = list(/obj/item/restraints/handcuffs/fake/kinky = 5,
				/obj/item/clothing/neck/petcollar = 5,
				/obj/item/clothing/under/mankini = 1,
				/obj/item/dildo/flared/huge = 1
				)
	premium = list(
				/obj/item/electropack/shockcollar = 3,
				/obj/item/clothing/neck/petcollar/locked = 1
				)
	refill_canister = /obj/item/vending_refill/kink

/obj/item/vending_refill/kink
	machine_name 	= "KinkMate"
	icon			= 'modular_citadel/icons/vending_restock.dmi'
	icon_state 		= "refill_kink"
