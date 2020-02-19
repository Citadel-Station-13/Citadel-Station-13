/////////////Recategorizing this as -Eastern- foods///////////////
///////////////////////Sushi Components///////////////////////////

/datum/crafting_recipe/food/sushi_rice
	name = "Sushi Rice"
	reqs = list(
		/datum/reagent/water  = 40,
		/datum/reagent/consumable/rice = 10
	)
	result = /obj/item/reagent_containers/food/snacks/sushi_rice
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/sea_weed
	name = "Sea Weed Sheet"
	reqs = list(
		/datum/reagent/water = 30,
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/reagent_containers/food/snacks/grown/kudzupod = 1,
	)
	result = /obj/item/reagent_containers/food/snacks/sea_weed
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/tuna_can
	name = "Can of Tuna"
	reqs = list(
		/datum/reagent/consumable/sodiumchloride = 15,
		/datum/reagent/consumable/cooking_oil = 5,
		/obj/item/reagent_containers/food/snacks/carpmeat = 1,
	)
	result = /obj/item/reagent_containers/food/snacks/tuna
	subcategory = CAT_EASTERN

//////////////////////////Sushi/////////////////////////////////

/datum/crafting_recipe/food/sashimi
	name = "Sashimi"
	reqs = list(
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/reagent_containers/food/snacks/spidereggs = 1,
		/obj/item/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sashimi
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/riceball
	name = "Onigiri"
	reqs = list(
		/datum/reagent/consumable/soysauce = 1,
		/obj/item/reagent_containers/food/snacks/sea_weed = 1,
		/obj/item/reagent_containers/food/snacks/sushi_rice = 1
	)
	result = /obj/item/reagent_containers/food/snacks/riceball
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/sushie_egg
	name = "Tobiko"
	reqs = list(
		/datum/reagent/consumable/soysauce = 6,
		/obj/item/reagent_containers/food/snacks/spidereggs = 1,
		/obj/item/reagent_containers/food/snacks/sea_weed = 2,
	)
	result = /obj/item/reagent_containers/food/snacks/tobiko
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/sushie_basic
	name = "Funa Hosomaki"
	reqs = list(
		/datum/reagent/consumable/soysauce = 3,
		/obj/item/reagent_containers/food/snacks/sushi_rice = 1,
		/obj/item/reagent_containers/food/snacks/carpmeat = 2,
		/obj/item/reagent_containers/food/snacks/sea_weed = 3,
	)
	result = /obj/item/reagent_containers/food/snacks/sushie_basic
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/sushie_adv
	name = "Funa Nigiri"
	reqs = list(
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/reagent_containers/food/snacks/sushi_rice = 1,
		/obj/item/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sushie_adv
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/sushie_pro
	name = "Well made Funa Nigiri"
	reqs = list(
		/datum/reagent/consumable/soysauce = 10,
		/obj/item/reagent_containers/food/snacks/sushi_rice = 2,
		/obj/item/reagent_containers/food/snacks/carpmeat = 5,
		/obj/item/reagent_containers/food/snacks/sea_weed = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sushie_pro
	subcategory = CAT_EASTERN

//////////////////Not-Fish//////////////////////

/datum/crafting_recipe/food/chawanmushi
	name = "Chawanmushi"
	reqs = list(
		/datum/reagent/water = 5,
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/reagent_containers/food/snacks/boiledegg = 2,
		/obj/item/reagent_containers/food/snacks/grown/mushroom/chanterelle = 1
	)
	result = /obj/item/reagent_containers/food/snacks/chawanmushi
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/khachapuri
	name = "Khachapuri"
	reqs = list(
		/datum/reagent/consumable/eggyolk = 5,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 1,
		/obj/item/reagent_containers/food/snacks/store/bread/plain = 1
	)
	result = /obj/item/reagent_containers/food/snacks/khachapuri
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/rawkhinkali
	name = "Raw Khinkali"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/doughslice = 1,
		/obj/item/reagent_containers/food/snacks/faggot = 1
	)
	result =  /obj/item/reagent_containers/food/snacks/rawkhinkali
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/meatbun
	name = "Meat bun"
	reqs = list(
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/reagent_containers/food/snacks/bun = 1,
		/obj/item/reagent_containers/food/snacks/faggot = 1,
		/obj/item/reagent_containers/food/snacks/grown/cabbage = 1
	)
	result = /obj/item/reagent_containers/food/snacks/meatbun
	subcategory = CAT_EASTERN

/datum/crafting_recipe/food/fortunecookie
	time = 15
	name = "Fortune cookie"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/pastrybase = 1,
		/obj/item/paper = 1
	)
	parts =	list(
		/obj/item/paper = 1
	)
	result = /obj/item/reagent_containers/food/snacks/fortunecookie
	subcategory = CAT_EASTERN
