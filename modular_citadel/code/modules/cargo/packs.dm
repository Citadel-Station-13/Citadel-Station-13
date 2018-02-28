//supply packs

/datum/supply_pack/misc/kinkmate
	name = "Kinkmate construction kit"
	cost = 2000
	contraband = TRUE
	contains = list(/obj/item/vending_refill/kink, /obj/item/circuitboard/machine/kinkmate)
	crate_name = "Kinkmate construction kit"


//Food and livestocks

/datum/supply_pack/organic/critter/kiwi
	name = "Space kiwi Crate"
	cost = 2000
	contains = list( /mob/living/simple_animal/kiwi)
	crate_name = "space kiwi crate"

/datum/supply_pack/misc/aquariumsupplies
	name = "Aquarium Supplies"
	cost = 1500
	contains = list(/obj/item/weapon/egg_scoop, /obj/item/weapon/fish_net, /obj/item/weapon/fishfood, /obj/item/weapon/tank_brush)
	crate_name = "Aquarium Supplies"

/datum/supply_pack/misc/randomised/aquariumfish
	name = "Fish Eggs"
	cost = 1000
	num_contained = 5
	contains = list(/obj/item/fish_eggs/goldfish,
					/obj/item/fish_eggs/goldfish,
					/obj/item/fish_eggs/goldfish,
					/obj/item/fish_eggs/clownfish,
					/obj/item/fish_eggs/clownfish,
					/obj/item/fish_eggs/clownfish,
					/obj/item/fish_eggs/shark,
					/obj/item/fish_eggs/shark,
					/obj/item/fish_eggs/babycarp,
					/obj/item/fish_eggs/babycarp,
					/obj/item/fish_eggs/babycarp,
					/obj/item/fish_eggs/catfish,
					/obj/item/fish_eggs/catfish,
					/obj/item/fish_eggs/catfish,
					/obj/item/fish_eggs/feederfish,
					/obj/item/fish_eggs/feederfish,
					/obj/item/fish_eggs/feederfish,
					/obj/item/fish_eggs/salmon,
					/obj/item/fish_eggs/salmon,
					/obj/item/fish_eggs/salmon,
					/obj/item/fish_eggs/shrimp,
					/obj/item/fish_eggs/shrimp,
					/obj/item/fish_eggs/shrimp,
					/obj/item/fish_eggs/electric_eel,
					/obj/item/fish_eggs/electric_eel,
					/obj/item/fish_eggs/electric_eel,
					/obj/item/fish_eggs/glofish,
					/obj/item/fish_eggs/glofish,
					/obj/item/fish_eggs/glofish)
	crate_name = "Fish Eggs"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Miscellaneous ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/misc/disco
	name = "Disco Ball"
	cost = 1000000
	contains = list(/obj/machinery/disco)
	crate_name = "Disco Ball"


