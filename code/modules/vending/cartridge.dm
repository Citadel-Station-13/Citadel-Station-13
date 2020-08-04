//This one's from bay12
/obj/machinery/vending/cart
	name = "\improper PTech"
	desc = "Cartridges for PDAs."
	product_slogans = "Carts to go!"
	icon_state = "cart"
	icon_deny = "cart-deny"
	products = list(/obj/item/cartridge/medical = 10,
					/obj/item/cartridge/engineering = 10,
					/obj/item/cartridge/security = 10,
					/obj/item/cartridge/janitor = 10,
					/obj/item/cartridge/signal/toxins = 10,
					/obj/item/cartridge/roboticist = 10,
					/obj/item/pda/heads = 10)
	premium = list(/obj/item/cartridge/captain = 2,
					/obj/item/cartridge/quartermaster = 2)
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	refill_canister = /obj/item/vending_refill/cart
	resistance_flags = FIRE_PROOF
	default_price = PRICE_ALMOST_EXPENSIVE
	extra_price = PRICE_ALMOST_ONE_GRAND
	payment_department = ACCOUNT_SRV

/obj/machinery/vending/cart/Initialize()
	. = ..()
	cost_multiplier_per_dept = list("[ACCESS_CHANGE_IDS]" = 0)

/obj/item/vending_refill/cart
	icon_state = "refill_pda"
