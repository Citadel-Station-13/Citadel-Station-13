/obj/machinery/vending/medical
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
					/obj/item/reagent_containers/glass/bottle/vial/small = 5)

/obj/machinery/vending/wardrobe/chap_wardrobe
	premium = list(/obj/item/toy/plush/plushvar = 1,
					/obj/item/toy/plush/narplush = 1)

#define STANDARD_CHARGE 1
#define CONTRABAND_CHARGE 2
#define COIN_CHARGE 3

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
				/obj/item/clothing/under/janimaid = 5,
				/obj/item/clothing/neck/petcollar/choker = 5,
				/obj/item/restraints/handcuffs/fake/kinky = 5,
				/obj/item/clothing/glasses/sunglasses/blindfold = 4,
				/obj/item/clothing/mask/muzzle = 4,
				/obj/item/clothing/under/stripper_pink = 3,
				/obj/item/clothing/under/stripper_green = 3,
				/obj/item/clothing/under/corset = 3,
				/obj/item/clothing/under/gear_harness = 10,
				/obj/item/dildo/custom = 5
				)
	contraband = list(
				/obj/item/clothing/head/kitty = 1,
				/obj/item/clothing/head/rabbitears = 1,
				/obj/item/clothing/under/keyholesweater = 2,
				/obj/item/clothing/under/mankini = 2,
				/obj/item/clothing/under/jabroni = 2,
				/obj/item/dildo/flared/huge = 3,
				/obj/item/reagent_containers/glass/bottle/crocin = 5,
				/obj/item/reagent_containers/glass/bottle/camphor = 5
				)
	premium = list(
				/obj/item/clothing/accessory/skullcodpiece/fake = 3,
				/obj/item/reagent_containers/glass/bottle/hexacrocin = 10,
				/obj/item/clothing/under/pants/chaps = 5
				)
	refill_canister = /obj/item/vending_refill/kink

/obj/machinery/vending/pet
	name = "Bark Box"
	desc = "A vending machine for pets- people who love their pets!"
	icon = 'icons/obj/citvending.dmi'
	icon_state = "pet"
	circuit = /obj/item/circuitboard/machine/pet
	product_slogans = "Bark!;Walk me please!;Ball!;Borf!"
	vend_reply = "Have fun, you animal!"
	products = list(
				/obj/item/clothing/neck/petcollar = 6,
				/obj/item/clothing/neck/petcollar/leather = 6,
				/obj/item/toy/bone/red = 3,
				/obj/item/toy/bone/yellow = 3,
				/obj/item/toy/bone/green = 3,
				/obj/item/toy/bone/cyan = 3,
				/obj/item/toy/bone/blue = 3,
				/obj/item/toy/bone/purple = 3,
				/obj/item/toy/frisbee/red = 3,
				/obj/item/toy/frisbee/yellow = 3,
				/obj/item/toy/frisbee/green = 3,
				/obj/item/toy/frisbee/cyan = 3,
				/obj/item/toy/frisbee/blue = 3,
				/obj/item/toy/frisbee/purple = 3,
				/obj/item/toy/tennis/red = 3,
				/obj/item/toy/tennis/yellow = 3,
				/obj/item/toy/tennis/green = 3,
				/obj/item/toy/tennis/cyan = 3,
				/obj/item/toy/tennis/blue = 3,
				/obj/item/toy/tennis/purple = 3
				)
	contraband = list(
				/obj/item/clothing/neck/petcollar/locked = 2,
				/obj/item/key/collar = 2,
				/obj/item/electropack/shockcollar = 3,
				/obj/item/assembly/signaler = 3,
				/obj/item/clothing/mask/muzzle = 3
				)
	premium = list(
				/obj/item/toy/bone/white = 1,
				/obj/item/toy/bone/black = 2,
				/obj/item/toy/frisbee/rainbow = 1,
				/obj/item/toy/tennis/rainbow = 1,
				)
	refill_canister = /obj/item/vending_refill/pet

/obj/machinery/vending/sovietvend
	name = "KomradeVendtink"
	desc = "Rodina-mat' zovyot!"
	icon = 'icons/obj/citvending.dmi'
	icon_state = "soviet"
	vend_reply = "The fascist and capitalist svin'ya shall fall, komrade!"
	product_slogans = "Quality worth waiting in line for!; Get Hammer and Sickled!; Sosvietsky soyuz above all!; With capitalist pigsky, you would have paid a fortunetink! ; Craftink in Motherland herself!"
	products = list(
		/obj/item/clothing/under/soviet = 20,
		/obj/item/clothing/head/ushanka = 20,
		/obj/item/clothing/shoes/jackboots = 20,
		/obj/item/clothing/head/squatter_hat = 20,
		/obj/item/clothing/under/squatter_outfit = 20,
		/obj/item/clothing/under/russobluecamooutfit = 20,
		/obj/item/clothing/head/russobluecamohat = 20
		)
	contraband = list(
		/obj/item/clothing/under/syndicate/tacticool = 4,
		/obj/item/clothing/mask/balaclava = 4,
		/obj/item/clothing/suit/russofurcoat = 4,
		/obj/item/clothing/head/russofurhat = 4,
		/obj/item/clothing/suit/space/hardsuit/soviet = 3,
		/obj/item/gun/energy/laser/LaserAK = 4
		)
	premium = list()

	refill_canister = /obj/item/vending_refill/soviet


#undef STANDARD_CHARGE
#undef CONTRABAND_CHARGE
#undef COIN_CHARGE


/obj/item/vending_refill/kink
	machine_name 	= "KinkMate"
	icon			= 'modular_citadel/icons/vending_restock.dmi'
	icon_state 		= "refill_kink"

/obj/item/vending_refill/pet
	machine_name 	= "Barkbox"
	icon			= 'modular_citadel/icons/vending_restock.dmi'
	icon_state 		= "refill_pet"

/obj/item/vending_refill/soviet
	machine_name 	= "sovietvend"
	icon_state 		= "refill_soviet"
