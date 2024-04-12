/obj/machinery/vending/wallmed
	name = "\improper NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = FALSE
	products = list(/obj/item/reagent_containers/syringe = 3,
					/obj/item/reagent_containers/pill/patch/styptic = 5,
					/obj/item/reagent_containers/pill/patch/silver_sulf = 5,
					/obj/item/reagent_containers/medspray/styptic = 2,
					/obj/item/reagent_containers/medspray/silver_sulf = 2,
					/obj/item/reagent_containers/pill/charcoal = 2,
					/obj/item/reagent_containers/medspray/sterilizine = 1,
					/obj/item/healthanalyzer/wound = 2,
					/obj/item/stack/medical/bone_gel = 2,
					/obj/item/stack/medical/nanogel = 2,
					/obj/item/reagent_containers/syringe/dart = 10)
	contraband = list(/obj/item/reagent_containers/pill/tox = 2,
					/obj/item/reagent_containers/pill/morphine = 2)
	premium = list(/obj/item/reagent_containers/medspray/synthflesh = 2)
	refill_canister = /obj/item/vending_refill/wallmed
	default_price = PRICE_FREE
	extra_price = PRICE_NORMAL
	payment_department = ACCOUNT_MED
	tiltable = FALSE
	light_mask = "wallmed-light-mask"

/obj/machinery/vending/wallmed/directional/north
	dir = SOUTH
	pixel_y = 32

/obj/machinery/vending/wallmed/directional/south
	dir = NORTH
	pixel_y = -32

/obj/machinery/vending/wallmed/directional/east
	dir = WEST
	pixel_x = 32

/obj/machinery/vending/wallmed/directional/west
	dir = EAST
	pixel_x = -32

/obj/item/vending_refill/wallmed
	machine_name = "NanoMed"
	icon_state = "refill_medical"

/obj/machinery/vending/wallmed/pubby
	products = list(/obj/item/reagent_containers/syringe = 3,
					/obj/item/reagent_containers/pill/patch/styptic = 1,
					/obj/item/reagent_containers/pill/patch/silver_sulf = 1,
					/obj/item/reagent_containers/medspray/sterilizine = 1)
	premium = list(/obj/item/reagent_containers/medspray/synthflesh = 2)
