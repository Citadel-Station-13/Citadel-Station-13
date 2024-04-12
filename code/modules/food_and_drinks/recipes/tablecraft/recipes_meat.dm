// see code/module/crafting/table.dm

////////////////////////////////////////////////KEBABS////////////////////////////////////////////////

/datum/crafting_recipe/food/humankebab
	name = "Human kebab"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/reagent_containers/food/snacks/meat/steak/plain/human = 2
	)
	result = /obj/item/reagent_containers/food/snacks/kebab/human
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/kebab
	name = "Kebab"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/reagent_containers/food/snacks/meat/steak = 2
	)
	result = /obj/item/reagent_containers/food/snacks/kebab/monkey
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/tofukebab
	name = "Tofu kebab"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/reagent_containers/food/snacks/tofu = 2
	)
	result = /obj/item/reagent_containers/food/snacks/kebab/tofu
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/tailkebab
	name = "Lizard tail kebab"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/organ/tail/lizard = 1
	)
	result = /obj/item/reagent_containers/food/snacks/kebab/tail
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/fiestaskewer
	name = "Fiesta Skewer"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/reagent_containers/food/snacks/grown/chili = 1,
		/obj/item/reagent_containers/food/snacks/meat/cutlet = 1,
		/obj/item/reagent_containers/food/snacks/grown/corn = 1,
		/obj/item/reagent_containers/food/snacks/grown/tomato = 1
	)
	result = /obj/item/reagent_containers/food/snacks/kebab/fiesta
	subcategory = CAT_MEAT

// see code/module/crafting/table.dm

////////////////////////////////////////////////MR SPIDER////////////////////////////////////////////////

/datum/crafting_recipe/food/spidereggsham
	name = "Spider eggs ham"
	reqs = list(
		/datum/reagent/consumable/sodiumchloride = 1,
		/obj/item/reagent_containers/food/snacks/spidereggs = 1,
		/obj/item/reagent_containers/food/snacks/meat/cutlet/spider = 2
	)
	result = /obj/item/reagent_containers/food/snacks/spidereggsham
	subcategory = CAT_MEAT

////////////////////////////////////////////////MISC RECIPE's////////////////////////////////////////////////

/datum/crafting_recipe/food/meatslab
	name = "Meat Slab"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/rawcutlet = 3,
	)
	tools = list(/obj/item/kitchen/efink)
	result = /obj/item/reagent_containers/food/snacks/meat/slab
	subcategory = CAT_MEAT


/datum/crafting_recipe/food/ribs
	name = "BBQ Ribs"
	reqs = list(
		/datum/reagent/consumable/bbqsauce = 5,
		/obj/item/reagent_containers/food/snacks/meat/steak/plain = 2,
		/obj/item/stack/rods = 2
	)
	result = /obj/item/reagent_containers/food/snacks/bbqribs
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/nugget
	name = "Chicken nugget"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/cutlet = 1
	)
	result = /obj/item/reagent_containers/food/snacks/nugget
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/sweet_and_sour
	name = "Sweet and sour \"chicken\""
	reqs = list(
		/obj/item/reagent_containers/food/snacks/nugget = 2,
		/obj/item/reagent_containers/food/snacks/pineappleslice = 1,
		/datum/reagent/consumable/soysauce = 2,
		/datum/reagent/consumable/sodiumchloride = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sweet_and_sour
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/corndog
	name = "Corndog meal"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/reagent_containers/food/snacks/meat/cutlet = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1,
		/datum/reagent/consumable/mustard = 5,
		/datum/reagent/consumable/ketchup = 5
	)
	result = /obj/item/reagent_containers/food/snacks/corndog
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/cornedbeef
	name = "Corned beef"
	reqs = list(
		/datum/reagent/consumable/sodiumchloride = 5,
		/obj/item/reagent_containers/food/snacks/meat/steak = 1,
		/obj/item/reagent_containers/food/snacks/grown/cabbage = 2
	)
	result = /obj/item/reagent_containers/food/snacks/cornedbeef
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/bearsteak
	name = "Filet migrawr"
	reqs = list(
		/datum/reagent/consumable/ethanol/manly_dorf = 5,
		/obj/item/reagent_containers/food/snacks/meat/steak/bear = 1,
	)
	tools = list(/obj/item/lighter)
	result = /obj/item/reagent_containers/food/snacks/bearsteak
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/stewedsoymeat
	name = "Stewed soymeat"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/soydope = 2,
		/obj/item/reagent_containers/food/snacks/grown/carrot = 1,
		/obj/item/reagent_containers/food/snacks/grown/tomato = 1
	)
	result = /obj/item/reagent_containers/food/snacks/stewedsoymeat
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/sausage
	name = "Sausage"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meatball = 1,
		/obj/item/reagent_containers/food/snacks/meat/cutlet = 2
	)
	result = /obj/item/reagent_containers/food/snacks/sausage
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/meatloaf
	name = "Meatloaf"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/cutlet = 4,
		/datum/reagent/consumable/eggyolk = 10,
		/datum/reagent/consumable/ketchup = 5
	)
	result = /obj/item/reagent_containers/food/snacks/meatloaf
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/pigblanket
	name = "Pig in a Blanket"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/bun = 1,
		/obj/item/reagent_containers/food/snacks/butter = 1,
		/obj/item/reagent_containers/food/snacks/meat/cutlet = 1
	)
	result = /obj/item/reagent_containers/food/snacks/pigblanket
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/ratkebab
	name = "Rat Kebab"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/reagent_containers/food/snacks/deadmouse = 1
	)
	result = /obj/item/reagent_containers/food/snacks/kebab/rat
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/doubleratkebab
	name = "Double Rat Kebab"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/reagent_containers/food/snacks/deadmouse = 2
	)
	result = /obj/item/reagent_containers/food/snacks/kebab/rat/double
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/ricepork
	name = "Rice and pork"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/salad/boiledrice = 1,
		/obj/item/reagent_containers/food/snacks/meat/cutlet = 2
	)
	result = /obj/item/reagent_containers/food/snacks/salad/ricepork
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/gumbo
	name = "Black eyed gumbo"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/salad/boiledrice = 1,
		/obj/item/reagent_containers/food/snacks/grown/peas = 1,
		/obj/item/reagent_containers/food/snacks/grown/chili = 1,
		/obj/item/reagent_containers/food/snacks/meat/cutlet = 1
	)
	result = /obj/item/reagent_containers/food/snacks/salad/gumbo
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/goliathcalamari
	name = "Goliath Calamari"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/slab/goliath = 2,
		/datum/reagent/consumable/cooking_oil = 10
	)
	result = /obj/item/reagent_containers/food/snacks/goliathcalamari
	subcategory = CAT_MEAT
