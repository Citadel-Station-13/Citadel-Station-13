/obj/machinery/vending/medical
	name = "\improper NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	products = list(/obj/item/reagent_containers/syringe = 12,
					/obj/item/reagent_containers/dropper = 3,
					/obj/item/healthanalyzer = 4,
					/obj/item/sensor_device = 2,
					/obj/item/pinpointer/crew = 2,
					/obj/item/reagent_containers/medspray/sterilizine = 1,
					/obj/item/stack/medical/gauze = 8,
					/obj/item/reagent_containers/pill/patch/styptic = 5,
					/obj/item/reagent_containers/medspray/styptic = 2,
					/obj/item/reagent_containers/pill/patch/silver_sulf = 5,
					/obj/item/reagent_containers/medspray/silver_sulf = 2,
					/obj/item/reagent_containers/pill/insulin = 10,
					/obj/item/reagent_containers/pill/salbutamol = 2,
					/obj/item/reagent_containers/glass/bottle/charcoal = 4,
					/obj/item/reagent_containers/glass/bottle/epinephrine = 4,
					/obj/item/reagent_containers/glass/bottle/salglu_solution = 3,
					/obj/item/reagent_containers/glass/bottle/morphine = 4,
					/obj/item/reagent_containers/glass/bottle/toxin = 3,
					/obj/item/reagent_containers/syringe/antiviral = 6,
					/obj/item/storage/hypospraykit/fire = 2,
					/obj/item/storage/hypospraykit/toxin = 2,
					/obj/item/storage/hypospraykit/o2 = 2,
					/obj/item/storage/hypospraykit/brute = 2,
					/obj/item/storage/hypospraykit/enlarge = 2,
					/obj/item/reagent_containers/glass/bottle/vial/small = 5,
					/obj/item/storage/briefcase/medical = 2,
					/obj/item/stack/sticky_tape/surgical = 3,
					/obj/item/healthanalyzer/wound = 4,
					/obj/item/stack/medical/ointment = 2,
					/obj/item/stack/medical/suture = 2,
					/obj/item/stack/medical/bone_gel = 4,
					/obj/item/stack/medical/nanogel = 4)
	contraband = list(/obj/item/reagent_containers/pill/tox = 3,
					/obj/item/reagent_containers/pill/morphine = 4,
					/obj/item/reagent_containers/pill/charcoal = 6)
	premium = list(/obj/item/reagent_containers/medspray/synthflesh = 2,
					/obj/item/storage/box/hug/medical = 1,
					/obj/item/storage/pill_bottle/psicodine = 2,
					/obj/item/reagent_containers/hypospray/medipen = 3,
					/obj/item/storage/belt/medical = 3,
					/obj/item/wrench/medical = 1,
					/obj/item/storage/belt/medolier/full = 2,
					/obj/item/gun/syringe/dart = 2,
					/obj/item/storage/briefcase/medical = 2,
					/obj/item/plunger/reinforced = 2)

	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/medical
	default_price = PRICE_ALMOST_CHEAP
	extra_price = PRICE_ABOVE_NORMAL
	payment_department = ACCOUNT_MED
	cost_multiplier_per_dept = list(ACCOUNT_MED = 0)

/obj/item/vending_refill/medical
	machine_name = "NanoMed Plus"
	icon_state = "refill_medical"

/obj/machinery/vending/medical/syndicate_access
	name = "\improper SyndiMed Plus"
	payment_department = NO_FREEBIES

/obj/machinery/vending/medical/syndicate_access/Initialize()
	. = ..()
	cost_multiplier_per_dept = list("[ACCESS_SYNDICATE]" = 0)
