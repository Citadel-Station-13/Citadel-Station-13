
// see code/module/crafting/table.dm

////////////////////////////////////////////////BREAD////////////////////////////////////////////////

/datum/crafting_recipe/food/bread
	name = "Bread"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 5,
	)
	tools = list(/obj/item/kitchen/efink)
	result = /obj/item/reagent_containers/food/snacks/store/bread/plain
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/banananutbread
	name = "Banana nut bread"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/reagent_containers/food/snacks/store/bread/plain = 1,
		/obj/item/reagent_containers/food/snacks/boiledegg = 3,
		/obj/item/reagent_containers/food/snacks/grown/banana = 1
	)
	result = /obj/item/reagent_containers/food/snacks/store/bread/banana
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/creamcheesebread
	name = "Cream cheese bread"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/reagent_containers/food/snacks/store/bread/plain = 1,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 2
	)
	result = /obj/item/reagent_containers/food/snacks/store/bread/creamcheese
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/meatbread
	name = "Meat bread"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/store/bread/plain = 1,
		/obj/item/reagent_containers/food/snacks/meat/cutlet/plain = 3,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 3
	)
	result = /obj/item/reagent_containers/food/snacks/store/bread/meat
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/mimanabread
	name = "Mimana bread"
	reqs = list(
		/datum/reagent/consumable/soymilk = 5,
		/obj/item/reagent_containers/food/snacks/store/bread/plain = 1,
		/obj/item/reagent_containers/food/snacks/tofu = 3,
		/obj/item/reagent_containers/food/snacks/grown/banana/mime = 1
	)
	result = /obj/item/reagent_containers/food/snacks/store/bread/mimana
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/spidermeatbread
	name = "Spidermeat bread"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/store/bread/plain = 1,
		/obj/item/reagent_containers/food/snacks/meat/cutlet/spider = 3,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 3
	)
	result = /obj/item/reagent_containers/food/snacks/store/bread/spidermeat
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/tofubread
	name = "Tofu bread"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/store/bread/plain = 1,
		/obj/item/reagent_containers/food/snacks/tofu = 3,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 3
	)
	result = /obj/item/reagent_containers/food/snacks/store/bread/tofu
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/xenomeatbread
	name = "Xenomeat bread"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/store/bread/plain = 1,
		/obj/item/reagent_containers/food/snacks/meat/cutlet/xeno = 3,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 3
	)
	result = /obj/item/reagent_containers/food/snacks/store/bread/xenomeat
	subcategory = CAT_BREAD

////////////////////////////////////////////////TOAST////////////////////////////////////////////////

/datum/crafting_recipe/food/butteredtoast
	name = "Buttered Toast"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 1,
		/obj/item/reagent_containers/food/snacks/butter = 1
	)
	result = /obj/item/reagent_containers/food/snacks/butteredtoast
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/slimetoast
	name = "Slime toast"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 1
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/jelliedtoast
	name = "Jellied toast"
	reqs = list(
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 1
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/peanutbuttertoast
	name = "Peanut butter toast"
	reqs = list(
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 1
	)
	result = /obj/item/reagent_containers/food/snacks/peanut_buttertoast
	subcategory = CAT_BREAD

////////////////////////////////////////////////MISC////////////////////////////////////////////////

/datum/crafting_recipe/food/baguette
	name = "Baguette"
	time = 40
	reqs = list(/datum/reagent/consumable/sodiumchloride = 1,
				/datum/reagent/consumable/blackpepper = 1,
				/obj/item/reagent_containers/food/snacks/pastrybase = 2
	)
	result = /obj/item/reagent_containers/food/snacks/baguette
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/garlicbread
	name = "Garlic Bread"
	time = 40
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/garlic = 1,
				/obj/item/reagent_containers/food/snacks/breadslice/plain = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1
	)
	result = /obj/item/reagent_containers/food/snacks/garlicbread
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/butterbiscuit
	name = "Butter Biscuit"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/bun = 1,
		/obj/item/reagent_containers/food/snacks/butter = 1
	)
	result = /obj/item/reagent_containers/food/snacks/butterbiscuit
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/butterdog
	name = "Butterdog"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/bun = 1,
		/obj/item/reagent_containers/food/snacks/butter = 3,
		)
	result = /obj/item/reagent_containers/food/snacks/butterdog
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/twobread
	name = "Two bread"
	reqs = list(
		/datum/reagent/consumable/ethanol/wine = 5,
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 2
	)
	result = /obj/item/reagent_containers/food/snacks/twobread
	subcategory = CAT_BREAD
