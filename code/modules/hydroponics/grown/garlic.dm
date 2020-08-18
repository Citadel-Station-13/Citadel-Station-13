/obj/item/seeds/garlic
	name = "pack of garlic seeds"
	desc = "A packet of extremely pungent seeds."
	icon_state = "seed-garlic"
	species = "garlic"
	plantname = "Garlic Sprouts"
	product = /obj/item/reagent_containers/food/snacks/grown/garlic
	yield = 6
	potency = 25
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "garlic-grow" 
	icon_harvest = "garlic-harvest"
	icon_dead = "garlic-dead"
	reagents_add = list(/datum/reagent/consumable/garlic = 0.15, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/reagent_containers/food/snacks/grown/garlic
	seed = /obj/item/seeds/garlic
	name = "garlic"
	desc = "Delicious, but with a potentially overwhelming odor."
	icon_state = "garlic"
	filling_color = "#C0C9A0"
	bitesize_mod = 2
	tastes = list("garlic" = 1)
	wine_power = 10

/obj/item/clothing/neck/garlic_necklace
	name = "garlic necklace"
	desc = "A clove of garlic on a cable, tied to itself in a circle, just might fit around your neck. For <strike>loonies<strike> people who fear getting their blood sucked."
	icon_state = "garlic_necklace"
	item_state = "garlic_necklace"
	