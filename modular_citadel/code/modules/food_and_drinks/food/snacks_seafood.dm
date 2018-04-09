/obj/item/reagent_containers/food/snacks/fish
	icon = 'modular_citadel/icons/obj/food/food.dmi'

/obj/item/reagent_containers/food/snacks/fish/raw_shrimp
	name = "shrimp"
	desc = "You can barbecue it, boil it, broil it, bake it, saute it."
	icon_state = "shrimp_raw"
	list_reagents = list("nutriment" = 1)
	cooked_type = /obj/item/reagent_containers/food/snacks/fish/shrimp
	filling_color = "#FF1C1C"
	bitesize = 2
	tastes = list("raw sea bugs" = 1)
	foodtype = MEAT | GROSS

/obj/item/reagent_containers/food/snacks/fish/feederfish
	name = "feeder fish"
	desc = "A tiny fish that only exists for bigger fish to eat it. Or you. You could eat it."
	icon_state = "feederfish"
	list_reagents = list("nutriment" = 1)
	tastes = list("deep sea trash" = 1)
	filling_color = "#FF1C1C"
	foodtype = MEAT

/obj/item/reagent_containers/food/snacks/fish/salmonsteak
	name = "Salmon steak"
	desc = "A piece of freshly-grilled salmon meat."
	icon_state = "salmonsteak"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"
	bitesize = 3
	list_reagents = list("nutriment" = 3, "vitamin" = 4)
	tastes = list("fish" = 1, "omega-3" = 1)
	foodtype = MEAT

/obj/item/reagent_containers/food/snacks/fish/salmonmeat
	name = "raw salmon"
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	bitesize = 3
	list_reagents = list("nutriment" = 5, "vitamin" = 2)
	cooked_type = /obj/item/reagent_containers/food/snacks/fish/salmonsteak
	tastes = list("fish" = 1)
	foodtype = MEAT

/obj/item/reagent_containers/food/snacks/fish/catfishmeat
	name = "raw catfish"
	desc = "A fillet of raw catfish."
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	bitesize = 3
	list_reagents = list("nutriment" = 3, "vitamin" = 4)
	tastes = list("fish" = 1)
	foodtype = MEAT

/obj/item/reagent_containers/food/snacks/fish/shrimp
	name = "boiled shrimp"
	desc = "Just one of the many things you can do with shrimp!"
	icon_state = "shrimp_cooked"
	bitesize = 3
	list_reagents = list("nutriment" = 1, "vitamin" = 1)
	bonus_reagents = list("vitamin" = 1)
	tastes = list("sea bugs" = 1)
	foodtype = MEAT


/obj/item/reagent_containers/food/snacks/fish/sushi_Ebi
	name = "Ebi Sushi"
	desc = "A simple sushi consisting of cooked shrimp and rice."
	icon_state = "sushi_Ebi"
	bitesize = 3
	list_reagents = list("nutriment" = 1, "vitamin" = 2)
	tastes = list("sea bugs" = 1, "vinegared rice" = 1)
	foodtype = MEAT | GRAIN


/obj/item/reagent_containers/food/snacks/fish/sushi_Ikura
	name = "Ikura Sushi"
	desc = "A simple sushi consisting of salmon roe."
	icon_state = "sushi_Ikura"
	bitesize = 3
	list_reagents = list("nutriment" = 1, "vitamin" = 2)
	tastes = list("fish eggs" = 1, "vinegared rice" = 1)
	foodtype = MEAT | GRAIN

/obj/item/reagent_containers/food/snacks/fish/sushi_Sake
	name = "Sake Sushi"
	desc = "A simple sushi consisting of raw salmon and rice."
	icon_state = "sushi_Sake"
	bitesize = 3
	list_reagents = list("nutriment" = 2, "vitamin" = 1)
	tastes = list("raw fish" = 1, "vinegared rice" = 1)
	foodtype = MEAT | GRAIN

/obj/item/reagent_containers/food/snacks/fish/sushi_SmokedSalmon
	name = "Smoked Salmon Sushi"
	desc = "A simple sushi consisting of cooked salmon and rice."
	icon_state = "sushi_SmokedSalmon"
	bitesize = 3
	list_reagents = list("nutriment" = 2, "vitamin" = 1)
	tastes = list("smoke" = 1, "vinegared rice" = 1)  				// Mouth-watering steamed salmon
	foodtype = MEAT | GRAIN

/obj/item/reagent_containers/food/snacks/fish/sushi_Tamago
	name = "Tamago Sushi"
	desc = "A simple sushi consisting of egg and rice."
	icon_state = "sushi_Tamago"
	bitesize = 3
	list_reagents = list("nutriment" = 1, "vitamin" = 2)
	tastes = list("egg" = 1, "vinegared rice" = 1)
	foodtype = MEAT | GRAIN

/obj/item/reagent_containers/food/snacks/fish/sushi_Inari
	name = "Inari Sushi"
	desc = "A piece of fried tofu stuffed with rice."
	icon_state = "sushi_Inari"
	bitesize = 3
	list_reagents = list("nutriment" = 3)
	tastes = list("tofu" = 1, "vinegared rice" = 2)
	foodtype = GRAIN | MEAT


/obj/item/reagent_containers/food/snacks/fish/sushi_Masago
	name = "Masago Sushi"
	desc = "A simple sushi consisting of goldfish roe."
	icon_state = "sushi_Masago"
	bitesize = 3
	list_reagents = list("nutriment" = 1, "vitamin" = 2)
	tastes = list("fish eggs" = 1, "vinegared rice" = 1)
	foodtype = MEAT | GRAIN


/obj/item/reagent_containers/food/snacks/fish/sushi_Tobiko
	name = "Tobiko Sushi"
	desc = "A simple sushi consisting of shark roe."
	icon_state = "sushi_Masago"
	bitesize = 3
	list_reagents = list("nutriment" = 2, "vitamin" = 1)
	tastes = list("fish eggs" = 1, "vinegared rice" = 1)
	foodtype = MEAT | GRAIN

/obj/item/reagent_containers/food/snacks/fish/sushi_TobikoEgg
	name = "Tobiko and Egg Sushi"
	desc = "A sushi consisting of shark roe and an egg."
	icon_state = "sushi_TobikoEgg"
	bitesize = 3
	list_reagents = list("nutriment" = 2, "vitamin" = 1)
	tastes = list("fish eggs" = 1, "eggs" = 1, "vinegared rice" = 1)
	foodtype = MEAT | GRAIN

/obj/item/reagent_containers/food/snacks/fish/sushi_Tai
	name = "Tai Sushi"
	desc = "A simple sushi consisting of catfish and rice."
	icon_state = "sushi_Tai"
	bitesize = 3
	list_reagents = list("nutriment" = 2, "vitamin" = 1)
	tastes = list("raw fish" = 1, "vinegared rice" = 1)
	foodtype = MEAT | GRAIN

/obj/item/reagent_containers/food/snacks/fish/sushi_Unagi
	name = "Unagi Sushi"
	desc = "A simple sushi consisting of eel and rice."
	icon_state = "sushi_Hokki"
	bitesize = 3
	list_reagents = list("nutriment" = 2, "vitamin" = 1)
	tastes = list("raw fish" = 2, "vinegared rice" = 2, "slime" = 1) // you ever hold an eel?
	foodtype = MEAT | GRAIN
