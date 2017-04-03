#define STANDARD_CHARGE 1
#define CONTRABAND_CHARGE 2
#define COIN_CHARGE 3

/obj/machinery/vending/kink
	name = "KinkMate"
	desc = "A vending machine for all your unmentionable desires."
	icon = 'icons/obj/citvending.dmi'
	icon_state = "kink"
	product_slogans = "Kinky!;Sexy!;Check me out, big boy!"
	vend_reply = "Have fun, you shameless pervert!"
	products = list(
				/obj/item/clothing/under/maid = 5,
				/obj/item/weapon/dildo/custom = 5
				)
	contraband = list(/obj/item/weapon/restraints/handcuffs/fake/kinky = 5,
				/obj/item/clothing/neck/petcollar = 5,
				/obj/item/weapon/dildo/flared/huge = 1
					)
	premium = list()
	refill_canister = /obj/item/weapon/vending_refill/kink


#undef STANDARD_CHARGE
#undef CONTRABAND_CHARGE
#undef COIN_CHARGE


/obj/item/weapon/vending_refill/kink
	machine_name 	= "KinkMate"
	icon_state 		= "refill_kink"
	charges 		= list(4, 6, 0)// of 10 standard, 11 contraband, 0 premium
	init_charges 	= list(4, 6, 0)
