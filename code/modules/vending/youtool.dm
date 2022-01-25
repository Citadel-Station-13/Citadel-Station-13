/obj/machinery/vending/tool
	name = "\improper YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	light_mask = "tool-light-mask"
	products = list(/obj/item/stack/cable_coil/random = 15,
					/obj/item/crowbar = 10,
					/obj/item/weldingtool = 6,
					/obj/item/wirecutters = 10,
					/obj/item/wrench = 10,
					/obj/item/analyzer = 10,
					/obj/item/t_scanner = 10,
					/obj/item/screwdriver = 10,
					/obj/item/flashlight/glowstick = 6,
					/obj/item/flashlight/glowstick/red = 6,
					/obj/item/flashlight = 7)
	contraband = list(/obj/item/weldingtool/largetank = 4,
					/obj/item/clothing/gloves/color/fyellow = 4,
					/obj/item/multitool = 2)
	premium = list(/obj/item/clothing/gloves/color/yellow = 2,
					/obj/item/weldingtool/hugetank = 2)
	refill_canister = /obj/item/vending_refill/youtool
	default_price = PRICE_REALLY_CHEAP
	extra_price = PRICE_EXPENSIVE
	payment_department = ACCOUNT_ENG

/obj/item/vending_refill/youtool
	machine_name = "YouTool"
	icon_state = "refill_engi"
