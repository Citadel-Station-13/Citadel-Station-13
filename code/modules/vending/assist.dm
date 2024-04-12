/obj/machinery/vending/assist
	name = "\improper Part-Mart"
	desc = "All the finest of miscellaneous electronics one could ever need! Not responsible for any injuries caused by reckless misuse of parts."
	// icon_state = "parts"
	// icon_deny = "parts-deny"

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
	refill_canister = /obj/item/vending_refill/assist
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"
	default_price = PRICE_REALLY_CHEAP
	extra_price = PRICE_ALMOST_CHEAP
	payment_department = NO_FREEBIES
	// light_mask = "parts-light-mask"

/obj/item/vending_refill/assist
	machine_name = "Part-Mart"
	icon_state = "refill_parts"
