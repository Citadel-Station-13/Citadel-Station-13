/obj/machinery/vending/assist
	products = list(/obj/item/assembly/prox_sensor = 7,
					/obj/item/assembly/igniter = 6,
					/obj/item/assembly/playback = 4,
					/obj/item/assembly/signaler = 6,
					/obj/item/wirecutters = 3,
					/obj/item/stock_parts/cell/crap = 6,
					/obj/item/cartridge/signal = 6)
	contraband = list(/obj/item/assembly/timer = 4,
					/obj/item/assembly/voice = 4,
					/obj/item/assembly/health = 4,
					/obj/item/pressure_plate = 2,
					/obj/item/multitool = 2,
					/obj/item/stock_parts/cell/upgraded = 2)
	premium = list(/obj/item/stock_parts/cell/upgraded/plus = 2,
					/obj/item/flashlight/lantern = 2,
					/obj/item/beacon = 2)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	refill_canister = /obj/item/vending_refill/assist
	resistance_flags = FIRE_PROOF
	default_price = 50
	extra_price = 100
	payment_department = NO_FREEBIES

/obj/item/vending_refill/assist
	icon_state = "refill_engi"