/obj/item/reagent_containers/food/snacks/sandwich
	name = "sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 1)
	cooked_type = /obj/item/reagent_containers/food/snacks/toastedsandwich
	tastes = list("meat" = 2, "cheese" = 1, "bread" = 2, "lettuce" = 1)
	foodtype = GRAIN | VEGETABLES

/obj/item/reagent_containers/food/snacks/toastedsandwich
	name = "toasted sandwich"
	desc = "Now if you only had a pepper bar."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/carbon = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/carbon = 2)
	tastes = list("toast" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/grilledcheese
	name = "grilled cheese sandwich"
	desc = "Goes great with Tomato soup!"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("toast" = 1, "cheese" = 1)
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/jellysandwich
	name = "jelly sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	bitesize = 3
	tastes = list("bread" = 1, "jelly" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/jellysandwich/slime
	bonus_reagents = list(/datum/reagent/toxin/slimejelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/slimejelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype  = GRAIN | TOXIC

/obj/item/reagent_containers/food/snacks/jellysandwich/cherry
	bonus_reagents = list(/datum/reagent/consumable/cherryjelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/cherryjelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/jellysandwich/pbj
	name = "\improper PB & J sandwich"
	desc = "A grand creation of peanut butter, jelly and bread! An all-american classic."
	icon_state = "pbjsandwich"
	tastes = list("bread" = 1, "jelly" = 1, "peanuts" = 1)

/obj/item/reagent_containers/food/snacks/jellysandwich/pbj/cherry
	bonus_reagents = list(/datum/reagent/consumable/cherryjelly = 5, /datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/cherryjelly = 5, /datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/jellysandwich/pbj/slime
	bonus_reagents = list(/datum/reagent/toxin/slimejelly = 5, /datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/slimejelly = 5, /datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype  = GRAIN | TOXIC

/obj/item/reagent_containers/food/snacks/peanutbutter_sandwich
	name = "peanut butter sandwich"
	desc = "You wish you had some jelly to go with this..."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "peanutbuttersandwich"
	trash = /obj/item/trash/plate
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype  = GRAIN

/obj/item/reagent_containers/food/snacks/notasandwich
	name = "not-a-sandwich"
	desc = "Something seems to be wrong with this, you can't quite figure what. Maybe it's his moustache."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "notasandwich"
	trash = /obj/item/trash/plate
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 6)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("nothing suspicious" = 1)
	foodtype = GRAIN | GROSS

/obj/item/reagent_containers/food/snacks/jelliedtoast
	name = "jellied toast"
	desc = "A slice of toast covered with delicious jam."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "jellytoast"
	trash = /obj/item/trash/plate
	bitesize = 3
	tastes = list("toast" = 1, "jelly" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/jelliedtoast/cherry
	bonus_reagents = list(/datum/reagent/consumable/cherryjelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/cherryjelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype = GRAIN | FRUIT | SUGAR

/obj/item/reagent_containers/food/snacks/jelliedtoast/slime
	bonus_reagents = list(/datum/reagent/toxin/slimejelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/slimejelly = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype = GRAIN | TOXIC | SUGAR

/obj/item/reagent_containers/food/snacks/peanut_buttertoast
	name = "peanut butter toast"
	desc = "A slice of toast covered with delicious peanut butter."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "peanutbuttertoast"
	trash = /obj/item/trash/plate
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("toast" = 1, "peanuts" = 1)
	foodtype = GRAIN


/obj/item/reagent_containers/food/snacks/twobread
	name = "two bread"
	desc = "This seems awfully bitter."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "twobread"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("bread" = 2)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/tuna_sandwich
	name = "tuna sandwich"
	desc = "Both a salad and a sandwich in one."
	icon = 'modular_citadel/icons/obj/food/food.dmi'
	icon_state = "tunasandwich"
	trash = /obj/item/trash/plate
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("tuna" = 4, "mayonnaise" = 2, "bread" = 2)
	foodtype = GRAIN | MEAT
