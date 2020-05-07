// Finally, peas. Base plant.
/obj/item/seeds/peas
	name = "pack of pea pods"
	desc = "These seeds grows into vitamin rich peas!"
	icon_state = "seed-peas"
	species = "peas"
	plantname = "Pea Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/peas
	maturation = 3
	potency = 25
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "peas-grow"
	icon_dead = "peas-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/peas/laugh) // TODO: Add /obj/item/seeds/peas/shoot at a later date, for the peashooter mutation line
	reagents_add = list (/datum/reagent/consumable/nutriment/vitamin = 0.1, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/water = 0.04)
	

/obj/item/reagent_containers/food/snacks/grown/peas
	seed = /obj/item/seeds/peas
	name = "peapod"
	desc = "Finally... peas."
	icon_state = "peas"
	filling_color = "#739122"
	bitesize_mod = 1
	foodtype = VEGETABLES
	tastes = list ("peas" = 1, "chalky saltiness" = 1)
	wine_power = 50
	// distill_regeant = /datum/reagent/saltpetre //if allowed, remove wine_power, ya dingus.


// Laughin' Peas
/obj/item/seeds/peas/laugh
	name = "pack of laughin' peas"
	desc = "These seeds give off a very soft purple glow.. they should grow into Laughin' Peas."
	icon_state = "seed-laughpeas"
	species = "peaslaughing"
	plantname = "Laughin' Pea Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/peas/laugh
	maturation = 7
	potency = 10
	yield = 7
	production = 5
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "laughpeas-grow"
	icon_dead = "laughpeas-dead"
	genes = list (/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/purple)
	mutatelist = list (/obj/item/seeds/peas/laugh/peace)
	reagents_add = list (/datum/reagent/consumable/laughter = 0.1, /datum/reagent/consumable/sugar = 0.04)
	rarity = 25 //It actually might make Central Command Officials loosen up a smidge, eh?


/obj/item/reagent_containers/food/snacks/grown/peas/laugh
	seed = /obj/item/seeds/peas/laugh
	name = "laughin' pea pod"
	desc = "Ridens Cicer, guaranteed to improve your mood dramatically upon consumption!"
	icon_state = "laughpeas"
	filling_color = "#ee7bee"
	bitesize_mod = 2
	foodtype = VEGETABLES
	tastes = list ("a prancing rabbit" = 2, "lingering sweetness" = 1)
	wine_power = 90


// World Peas - Peace at last, peace at last...
/obj/item/seeds/peas/laugh/peace
	name = "pack of world peas"
	desc = "These rather large seeds give off a soothing blue glow..."
	icon_state = "seed-worldpeas"
	species = "peasworld"
	plantname = "World Pea Coils"
	product = /obj/item/reagent_containers/food/snacks/grown/peas/laugh/peace
	maturation = 20
	potency = 75
	yield = 1
	production = 10
	growthstages = 4
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "worldpeas-grow"
	icon_dead = "worldpeas-dead"
	genes = list (/datum/plant_gene/trait/glow/blue)
	reagents_add = list (/datum/reagent/pax = 0.1, /datum/reagent/drug/happiness = 0.05, /datum/reagent/consumable/nutriment = 0.15)
	rarity = 50 // This absolutely will make even the most hardened Syndicate Operators relax, and lay down their arms.


/obj/item/reagent_containers/food/snacks/grown/peas/laugh/peace
	name = "world peas cluster"
	desc = "Pax Mundi, a rather peculiar and recent discovery in botanical circles is rumored to be able to pacify even the most enraged of beasts, when consumed. At last... World Peas."
	icon_state = "worldpeas"
	filling_color "#0099CC"
	bitesize_mod = 4
	foodtype = VEGETABLES
	tastes = list ("Tranquility" = 2, "numbing happiness" = 1)
	wine_power = 100
	wine_flavor = "mind-numbing peace and warmth"






