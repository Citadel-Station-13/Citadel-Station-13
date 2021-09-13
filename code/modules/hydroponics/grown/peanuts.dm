/obj/item/seeds/peanutseed
	name = "pack of peanut seeds"
	desc = "These seeds grow to produce fruits botanically classified as legumes, but mundanely referred as nuts."
	icon_state = "seed-peanut"
	species = "peanut"
	plantname = "Peanut Vines"
	product = /obj/item/food/grown/peanut
	yield = 6
	growthstages = 4
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.02, /datum/reagent/consumable/nutriment = 0.15, /datum/reagent/consumable/cooking_oil = 0.03)

/obj/item/food/grown/peanut
	seed = /obj/item/seeds/peanutseed
	name = "peanut"
	desc = "Peanuts for the peanut gallery!" //get me a better description, boys.
	icon_state = "peanut"
	filling_color = "#C4AE7A"
	bitesize = 100
	foodtype = VEGETABLES
	dried_type = /obj/item/food/roasted_peanuts
	cooked_type = /obj/item/food/roasted_peanuts

/obj/item/food/roasted_peanuts
	name = "roasted peanuts"
	desc = "A handful of roasted peanuts, with or without salt."
	icon_state = "roasted_peanuts"
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 1)
	juice_results = list(/datum/reagent/consumable/peanut_butter = 3)
