// Peach
/obj/item/seeds/peach
	name = "pack of peach seeds"
	desc = "These seeds grow into peach trees."
	icon_state = "seed-peach"
	species = "peach"
	plantname = "Peach Tree"
	product = /obj/item/reagent_containers/food/snacks/grown/peach
	lifespan = 65
	endurance = 40
	yield = 3
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "peach-grow"
	icon_dead = "peach-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/reagent_containers/food/snacks/grown/peach
	seed = /obj/item/seeds/peach
	name = "peach"
	desc = "It's fuzzy!"
	icon_state = "peach"
	filling_color = "#FF4500"
	bitesize = 25
	foodtype = FRUIT
	juice_results = list(/datum/reagent/consumable/peachjuice = 0)
	tastes = list("peach" = 1)
