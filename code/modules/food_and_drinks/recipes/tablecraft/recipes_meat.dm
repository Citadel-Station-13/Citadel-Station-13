

////////////////////////////////////////////////KEBABS////////////////////////////////////////////////

/datum/crafting_recipe/food/humankebab
	name = "Human kebab"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain/human = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/human
	category = CAT_FOOD

/datum/crafting_recipe/food/kebab
	name = "Kebab"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/weapon/reagent_containers/food/snacks/meat/steak = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/monkey
	category = CAT_FOOD

/datum/crafting_recipe/food/tofukebab
	name = "Tofu kebab"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/weapon/reagent_containers/food/snacks/tofu = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/tofu
	category = CAT_FOOD

/datum/crafting_recipe/food/tailkebab
	name = "Lizard tail kebab"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/severedtail = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kebab/tail
	category = CAT_FOOD

// see code/module/crafting/table.dm

////////////////////////////////////////////////FISH////////////////////////////////////////////////

/datum/crafting_recipe/food/cubancarp
	name = "Cuban carp"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/obj/item/weapon/reagent_containers/food/snacks/grown/chili = 1,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cubancarp
	category = CAT_FOOD

/datum/crafting_recipe/food/fishandchips
	name = "Fish and chips"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/fries = 1,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishandchips
	category = CAT_FOOD

/datum/crafting_recipe/food/fishfingers
	name = "Fish fingers"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/obj/item/weapon/reagent_containers/food/snacks/bun = 1,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishfingers
	category = CAT_FOOD

/datum/crafting_recipe/food/sashimi
	name = "Sashimi"
	reqs = list(
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/weapon/reagent_containers/food/snacks/spidereggs = 1,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sashimi
	category = CAT_FOOD

////////////////////////////////////////////////MR SPIDER////////////////////////////////////////////////

/datum/crafting_recipe/food/spidereggsham
	name = "Spider eggs ham"
	reqs = list(
		/datum/reagent/consumable/sodiumchloride = 1,
		/obj/item/weapon/reagent_containers/food/snacks/spidereggs = 1,
		/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet/spider = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/spidereggsham
	category = CAT_FOOD

////////////////////////////////////////////////MISC RECIPE's////////////////////////////////////////////////

/datum/crafting_recipe/food/cornedbeef
	name = "Corned beef"
	reqs = list(
		/datum/reagent/consumable/sodiumchloride = 5,
		/obj/item/weapon/reagent_containers/food/snacks/meat/steak = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/cabbage = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cornedbeef
	category = CAT_FOOD

/datum/crafting_recipe/food/bearsteak
	name = "Filet migrawr"
	reqs = list(
		/datum/reagent/consumable/ethanol/manly_dorf = 5,
		/obj/item/weapon/reagent_containers/food/snacks/meat/steak/bear = 1,
	)
	tools = list(/obj/item/weapon/lighter)
	result = /obj/item/weapon/reagent_containers/food/snacks/bearsteak
	category = CAT_FOOD

/datum/crafting_recipe/food/enchiladas
	name = "Enchiladas"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/chili = 2,
		/obj/item/weapon/reagent_containers/food/snacks/tortilla = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/enchiladas
	category = CAT_FOOD

/datum/crafting_recipe/food/stewedsoymeat
	name = "Stewed soymeat"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/soydope = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/carrot = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/tomato = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat
	category = CAT_FOOD

/datum/crafting_recipe/food/sausage
	name = "Sausage"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/faggot = 1,
		/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sausage
	category = CAT_FOOD

/datum/crafting_recipe/food/nugget
	name = "Chicken nugget"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/nugget
	category = CAT_FOOD

/datum/crafting_recipe/food/rawkhinkali
	name = "Raw Khinkali"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice = 1,
		/obj/item/weapon/reagent_containers/food/snacks/faggot = 1
	)
	result =  /obj/item/weapon/reagent_containers/food/snacks/rawkhinkali
	category = CAT_FOOD
