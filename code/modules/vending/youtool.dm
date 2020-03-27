/obj/machinery/vending/tool
	name = "\improper YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
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
					/obj/item/clothing/gloves/color/fyellow = 4)
	premium = list(/obj/item/clothing/gloves/color/yellow = 2,
					/obj/item/weldingtool/hugetank = 2)
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 70)
	refill_canister = /obj/item/vending_refill/tool
	resistance_flags = FIRE_PROOF

/obj/item/vending_refill/tool
	icon_state = "refill_engi"