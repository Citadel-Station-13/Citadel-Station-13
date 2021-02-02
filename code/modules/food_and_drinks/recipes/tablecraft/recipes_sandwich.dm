
// see code/datums/recipe.dm


// see code/module/crafting/table.dm

////////////////////////////////////////////////SANDWICHES////////////////////////////////////////////////

/datum/crafting_recipe/food/sandwich
	name = "Sandwich"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 2,
		/obj/item/reagent_containers/food/snacks/meat/steak = 1,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sandwich
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/grilledcheesesandwich
	name = "Grilled cheese sandwich"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 2,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 2
	)
	result = /obj/item/reagent_containers/food/snacks/grilledcheese
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/baconlettucetomato
	name = "BLT sandwich"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meat/bacon = 2,
		/obj/item/reagent_containers/food/snacks/grown/cabbage = 1,
		/obj/item/reagent_containers/food/snacks/grown/tomato = 1,
		/datum/reagent/consumable/mayonnaise = 5
	)
	result = /obj/item/reagent_containers/food/snacks/baconlettucetomato
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/slimesandwich
	name = "Jelly sandwich"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 2,
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/slime
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/cherrysandwich
	name = "Jelly sandwich"
	reqs = list(
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 2,
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/cherry
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/pbj_slimesandwich
	name = "PB&J sandwich"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 2,
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/pbj/slime
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/pbj_slimesandwich/alt
	reqs = list(
		/obj/item/reagent_containers/food/snacks/jelliedtoast/slime = 1,
		/obj/item/reagent_containers/food/snacks/peanut_buttertoast = 1,
	)

/datum/crafting_recipe/food/pbj_sandwich
	name = "PB&J sandwich"
	reqs = list(
		/datum/reagent/consumable/cherryjelly = 5,
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 2,
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/pbj/cherry
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/pbj_sandwich/alt
	reqs = list(
		/obj/item/reagent_containers/food/snacks/jelliedtoast/cherry = 1,
		/obj/item/reagent_containers/food/snacks/peanut_buttertoast = 1,
	)

/datum/crafting_recipe/peanutbutter_sandwich
	name = "Peanut butter sandwich"
	reqs = list(
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 2,
	)
	result = /obj/item/reagent_containers/food/snacks/peanutbutter_sandwich
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/notasandwich
	name = "Not a sandwich"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 2,
		/obj/item/clothing/mask/fakemoustache = 1
	)
	result = /obj/item/reagent_containers/food/snacks/notasandwich
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/tunasandwich
	name = "Tuna sandwich"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/breadslice/plain = 2,
		/obj/item/reagent_containers/food/snacks/tuna = 1,
		/obj/item/reagent_containers/food/snacks/grown/onion = 1,
		/datum/reagent/consumable/mayonnaise = 5
	)
	result = /obj/item/reagent_containers/food/snacks/tuna_sandwich
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/meatballsub
	name = "Meatball sub"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/meatball = 3,
		/obj/item/reagent_containers/food/snacks/bun = 1
	)
	result = /obj/item/reagent_containers/food/snacks/meatballsub
	subcategory = CAT_SANDWICH
	
/datum/crafting_recipe/food/hotdog
	name = "Hot dog"
	reqs = list(
		/datum/reagent/consumable/ketchup = 5,
		/obj/item/reagent_containers/food/snacks/bun = 1,
		/obj/item/reagent_containers/food/snacks/sausage = 1
	)
	result = /obj/item/reagent_containers/food/snacks/hotdog
	subcategory = CAT_SANDWICH //I don't agree with this.
