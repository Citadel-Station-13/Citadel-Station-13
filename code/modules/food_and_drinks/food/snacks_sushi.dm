//////////////////////////Sushi Components///////////////////////

/obj/item/reagent_containers/food/snacks/sushi_rice
	name = "sushi rice"
	desc = "A bowl of sticky rice for making sushi."
	icon_state = "sushi_rice"
	list_reagents = list(/datum/reagent/consumable/sodiumchloride = 5)
	tastes = list("rice" = 5, "salt" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/sea_weed
	name = "seaweed sheet"
	desc = "A thin, light salt sheet of plant mater. This is commonly used in sushi recipes."
	icon_state = "sea_weed"
	list_reagents = list(/datum/reagent/consumable/sodiumchloride = 2)
	tastes = list("plants" = 2, "salt" = 1)
	foodtype = VEGETABLES

/obj/item/reagent_containers/food/snacks/tuna
	name = "canned tuna"
	desc = "A small can of tuna fish beloved by felines."
	icon_state = "tuna_can"
//trash = /obj/item/trash/tuna_used //I dont know if I like this idea - A Masked Cat
	list_reagents = list(/datum/reagent/consumable/sodiumchloride = 5, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/mercury = 2)
	tastes = list("tuna" = 15, "mercury" = 1, "salt" = 3)
	foodtype = MEAT

//////////////////////////Sushi/////////////////////////////////
/obj/item/reagent_containers/food/snacks/sushie_basic
	name = "funa hosomaki"
	desc = "A small cylinder filled with rice and fish."
	icon_state = "sushie_basic"
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1/datum/reagent/consumable/nutriment/protein = 1)
	bitesize = 1
	filling_color = "#F2EEEA" //rgb(242, 238, 234)
	tastes = list("fish" = 1, "rice" = 1, "salt" = 1)
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/sushie_adv
	name = "funa nigiri"
	desc = "A pice of carp lightly placed on some rice."
	icon_state = "sushie_adv"
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 2)
	bitesize = 1
	filling_color = "#F2EEEA" //rgb(242, 238, 234)
	tastes = list("fish" = 1, "rice" = 1, "salt" = 1)
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/sushie_pro
	name = "funa nigiri"
	desc = "A well prepared piece of carp fillet placed on rice. Looks fancy and fresh!"
	icon_state = "sushie_pro"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 1)
	bitesize = 1
	filling_color = "#F2EEEA" //rgb(242, 238, 234)
	tastes = list("fish" = 1, "rice" = 1, "salt" = 1)
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/tobiko
	name = "tobiko"
	desc = "Spider eggs wrapped in a thin salted kudzu pod."
	icon_state = "sushie_egg"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	filling_color = "#FF3333" // R225 G051 B051
	tastes = list("seaweed" = 1, "salty" = 2)
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/riceball
	name = "onigiri"
	desc = "A ball of rice with some light salt and a wrap of kudzu skin."
	icon_state = "riceball"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/sodiumchloride = 2)
	tastes = list("rice" = 4, "salt" = 1)
	foodtype = GRAIN
