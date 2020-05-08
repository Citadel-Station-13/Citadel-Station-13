// see code/module/crafting/table.dm

///////////////////////Sushi Components///////////////////////////

/datum/crafting_recipe/food/sushi_rice
	name = "Sushi Rice"
	reqs = list(
		/datum/reagent/water  = 40,
		/datum/reagent/consumable/rice = 10
	)
	result = /obj/item/reagent_containers/food/snacks/sushi_rice
	subcategory = CAT_SEAFOOD

/datum/crafting_recipe/food/sea_weed
	name = "Sea Weed Sheet"
	reqs = list(
		/datum/reagent/water = 30,
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/reagent_containers/food/snacks/grown/kudzupod = 1,
	)
	result = /obj/item/reagent_containers/food/snacks/sea_weed
	subcategory = CAT_SEAFOOD

//////////////////////////Sushi/////////////////////////////////

/datum/crafting_recipe/food/sashimi
	name = "Sashimi"
	reqs = list(
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/reagent_containers/food/snacks/spidereggs = 1,
		/obj/item/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sashimi
	subcategory = CAT_SEAFOOD

/datum/crafting_recipe/food/riceball
	name = "Onigiri"
	reqs = list(
		/datum/reagent/consumable/soysauce = 1,
		/obj/item/reagent_containers/food/snacks/sea_weed = 1,
		/obj/item/reagent_containers/food/snacks/sushi_rice = 1
	)
	result = /obj/item/reagent_containers/food/snacks/riceball
	subcategory = CAT_SEAFOOD

/datum/crafting_recipe/food/sushie_egg
	name = "Tobiko"
	reqs = list(
		/datum/reagent/consumable/soysauce = 6,
		/obj/item/reagent_containers/food/snacks/spidereggs = 1,
		/obj/item/reagent_containers/food/snacks/sea_weed = 2,
	)
	result = /obj/item/reagent_containers/food/snacks/tobiko
	subcategory = CAT_SEAFOOD

/datum/crafting_recipe/food/sushie_basic
	name = "Funa Hosomaki"
	reqs = list(
		/datum/reagent/consumable/soysauce = 3,
		/obj/item/reagent_containers/food/snacks/sushi_rice = 1,
		/obj/item/reagent_containers/food/snacks/carpmeat = 2,
		/obj/item/reagent_containers/food/snacks/sea_weed = 3,
	)
	result = /obj/item/reagent_containers/food/snacks/sushie_basic
	subcategory = CAT_SEAFOOD

/datum/crafting_recipe/food/sushie_adv
	name = "Funa Nigiri"
	reqs = list(
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/reagent_containers/food/snacks/sushi_rice = 1,
		/obj/item/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sushie_adv
	subcategory = CAT_SEAFOOD

/datum/crafting_recipe/food/sushie_pro
	name = "Well made Funa Nigiri"
	reqs = list(
		/datum/reagent/consumable/soysauce = 10,
		/obj/item/reagent_containers/food/snacks/sushi_rice = 2,
		/obj/item/reagent_containers/food/snacks/carpmeat = 5,
		/obj/item/reagent_containers/food/snacks/sea_weed = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sushie_pro
	subcategory = CAT_SEAFOOD

//////////////////////////////////////////////FISH///////////////////////////////////////////

/datum/crafting_recipe/food/tuna_can
	name = "Can of Tuna"
	reqs = list(
		/datum/reagent/consumable/sodiumchloride = 15,
		/datum/reagent/consumable/cooking_oil = 5,
		/obj/item/reagent_containers/food/snacks/carpmeat = 1,
	)
	result = /obj/item/reagent_containers/food/snacks/tuna
	subcategory = CAT_SEAFOOD

/datum/crafting_recipe/food/crab_rangoon
	name = "Crab Rangoon"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/doughslice = 1,
		/datum/reagent/consumable/cream = 5,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 1,
		/obj/item/reagent_containers/food/snacks/meat/crab = 1
	)
	result = /obj/item/reagent_containers/food/snacks/crab_rangoon
	subcategory = CAT_SEAFOOD

/datum/crafting_recipe/food/cubancarp
	name = "Cuban carp"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/obj/item/reagent_containers/food/snacks/grown/chili = 1,
		/obj/item/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/reagent_containers/food/snacks/cubancarp
	subcategory = CAT_SEAFOOD

/datum/crafting_recipe/food/fishfingers
	name = "Fish fingers"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/obj/item/reagent_containers/food/snacks/bun = 1,
		/obj/item/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/reagent_containers/food/snacks/fishfingers
	subcategory = CAT_SEAFOOD

/datum/crafting_recipe/food/fishandchips
	name = "Fish and chips"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/fries = 1,
		/obj/item/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips
	subcategory = CAT_SEAFOOD