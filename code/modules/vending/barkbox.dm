/obj/machinery/vending/pet
	name = "Bark Box"
	desc = "A vending machine for pets- people who love their pets!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "pet"
	circuit = /obj/item/circuitboard/machine/pet
	product_slogans = "Bark!;Walk me please!;Ball!;Borf!"
	vend_reply = "Have fun, you animal!"
	products = list(
				/obj/item/clothing/neck/petcollar = 6,
				/obj/item/clothing/neck/petcollar/leather = 6,
				/obj/item/toy/bone = 3,
				/obj/item/toy/bone/red = 3,
				/obj/item/toy/bone/yellow = 3,
				/obj/item/toy/bone/green = 3,
				/obj/item/toy/bone/cyan = 3,
				/obj/item/toy/bone/blue = 3,
				/obj/item/toy/bone/purple = 3,
				/obj/item/ammo_casing/caseless/frisbee = 3,
				/obj/item/ammo_casing/caseless/frisbee/red = 3,
				/obj/item/ammo_casing/caseless/frisbee/yellow = 3,
				/obj/item/ammo_casing/caseless/frisbee/green = 3,
				/obj/item/ammo_casing/caseless/frisbee/cyan = 3,
				/obj/item/ammo_casing/caseless/frisbee/blue = 3,
				/obj/item/ammo_casing/caseless/frisbee/purple = 3,
				/obj/item/ammo_casing/caseless/tennis = 3,
				/obj/item/ammo_casing/caseless/tennis/red = 3,
				/obj/item/ammo_casing/caseless/tennis/yellow = 3,
				/obj/item/ammo_casing/caseless/tennis/green = 3,
				/obj/item/ammo_casing/caseless/tennis/cyan = 3,
				/obj/item/ammo_casing/caseless/tennis/blue = 3,
				/obj/item/ammo_casing/caseless/tennis/purple = 3
				)
	contraband = list(
				/obj/item/clothing/neck/petcollar/locked = 2,
				/obj/item/key/collar = 2,
				/obj/item/electropack/shockcollar = 3,
				/obj/item/assembly/signaler = 3,
				/obj/item/clothing/mask/muzzle = 3,
				/obj/item/gun/ballistic/automatic/tennislauncher = 1,
				/obj/item/gun/ballistic/automatic/frisbeelauncher = 1
				)
	premium = list(
				/obj/item/toy/bone/white = 1,
				/obj/item/ammo_casing/caseless/frisbee/white = 1,
				/obj/item/ammo_casing/caseless/tennis/rainbow = 1,
				/obj/item/toy/bone/rainbow = 1,
				/obj/item/ammo_casing/caseless/frisbee/rainbow = 1
				)
	refill_canister = /obj/item/vending_refill/pet

/obj/item/vending_refill/pet
	machine_name 	= "Barkbox"
	icon			= 'icons/obj/vending_restock.dmi'
	icon_state 		= "refill_pet"