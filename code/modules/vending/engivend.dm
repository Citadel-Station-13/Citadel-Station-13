/obj/machinery/vending/engivend
	name = "\improper Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	req_access = list(ACCESS_ENGINE_EQUIP)
	products = list(/obj/item/clothing/glasses/meson/engine = 5,
					/obj/item/clothing/glasses/welding = 5,
					/obj/item/multitool = 5,
					/obj/item/construction/rcd/loaded/upgraded = 3,
					/obj/item/grenade/chem_grenade/smart_metal_foam = 10,
					/obj/item/geiger_counter = 6,
					/obj/item/stock_parts/cell/high = 10,
    		        /obj/item/electronics/airlock = 10,
					/obj/item/electronics/apc = 10,
					/obj/item/electronics/airalarm = 10,
					/obj/item/electronics/firealarm = 10,
					/obj/item/electronics/firelock = 10,
					/obj/item/rcd_ammo = 3
					)
	contraband = list(/obj/item/stock_parts/cell/potato = 3,
					/obj/item/rcd_ammo = 2,
					/obj/item/circuitboard/computer/slot_machine = 1,
					/obj/item/tank/internals/emergency_oxygen/double = 3
					)
	premium = list(/obj/item/storage/belt/utility = 3,
					/obj/item/storage/box/smart_metal_foam = 3,
					/obj/item/rcd_ammo/large = 5
					)
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	refill_canister = /obj/item/vending_refill/engivend
	resistance_flags = FIRE_PROOF

/obj/item/vending_refill/engivend
	icon_state = "refill_engi"