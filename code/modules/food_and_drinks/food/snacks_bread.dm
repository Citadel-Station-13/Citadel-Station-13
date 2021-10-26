
/obj/item/reagent_containers/food/snacks/store/bread
	icon = 'icons/obj/food/burgerbread.dmi'
	volume = 80
	slices_num = 5
	tastes = list("bread" = 10)
	foodtype = GRAIN
	dunkable = TRUE

/obj/item/reagent_containers/food/snacks/store/bread/proc/bread_teleport()
	// you did WHAT?
	new /mob/living/simple_animal/hostile/bread(get_turf(src))
	visible_message("<span class='warning'>[src] begins to deform and grow grotesque tumors!</span>")
	qdel(src)

/obj/item/reagent_containers/food/snacks/breadslice
	icon = 'icons/obj/food/burgerbread.dmi'
	bitesize = 2
	custom_food_type = /obj/item/reagent_containers/food/snacks/customizable/sandwich
	filling_color = "#FFA500"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	slot_flags = ITEM_SLOT_HEAD
	customfoodfilling = 0 //to avoid infinite bread-ception
	foodtype = GRAIN
	dunkable = TRUE

/obj/item/reagent_containers/food/snacks/store/bread/plain
	name = "bread"
	desc = "Some plain old earthen bread."
	icon_state = "bread"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 7)
	list_reagents = list(/datum/reagent/consumable/nutriment = 10)
	custom_food_type = /obj/item/reagent_containers/food/snacks/customizable/bread
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice/plain
	tastes = list("bread" = 10)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/breadslice/plain
	name = "bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	customfoodfilling = 1
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/store/bread/meat
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman."
	icon_state = "meatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice/meat
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 10)
	list_reagents = list(/datum/reagent/consumable/nutriment = 30, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("bread" = 10, "meat" = 10)
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/breadslice/meat
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/store/bread/xenomeat
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice/xenomeat
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 10)
	list_reagents = list(/datum/reagent/consumable/nutriment = 30, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("bread" = 10, "acid" = 10)
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/breadslice/xenomeat
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	filling_color = "#32CD32"
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 1)
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/store/bread/spidermeat
	name = "spider meat loaf"
	desc = "Reassuringly green meatloaf made from spider meat."
	icon_state = "spidermeatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice/spidermeat
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 10)
	list_reagents = list(/datum/reagent/consumable/nutriment = 30, /datum/reagent/toxin = 15, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("bread" = 10, "cobwebs" = 5)
	foodtype = GRAIN | MEAT | TOXIC

/obj/item/reagent_containers/food/snacks/breadslice/spidermeat
	name = "spider meat bread slice"
	desc = "A slice of meatloaf made from an animal that most likely still wants you dead."
	icon_state = "xenobreadslice"
	filling_color = "#7CFC00"
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/toxin = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	foodtype = GRAIN | MEAT | TOXIC

/obj/item/reagent_containers/food/snacks/store/bread/banana
	name = "banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice/banana
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/banana = 20)
	list_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/banana = 20)
	tastes = list("bread" = 10) // bananjuice will also flavour
	foodtype = GRAIN | FRUIT


/obj/item/reagent_containers/food/snacks/breadslice/banana
	name = "banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	filling_color = "#FFD700"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/banana = 4)
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/store/bread/tofu
	name = "Tofubread"
	desc = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice/tofu
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 10)
	list_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("bread" = 10, "tofu" = 10)
	foodtype = GRAIN | VEGETABLES

/obj/item/reagent_containers/food/snacks/breadslice/tofu
	name = "tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	filling_color = "#FF8C00"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 1)
	foodtype = GRAIN | VEGETABLES

/obj/item/reagent_containers/food/snacks/store/bread/creamcheese
	name = "cream cheese bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice/creamcheese
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 5)
	list_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("bread" = 10, "cheese" = 10)
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/breadslice/creamcheese
	name = "cream cheese bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	filling_color = "#FF8C00"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 1)
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/store/bread/mimana
	name = "mimana bread"
	desc = "Best eaten in silence."
	icon_state = "mimanabread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice/mimana
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 5)
	list_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/toxin/mutetoxin = 5, /datum/reagent/consumable/nothing = 5, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("bread" = 10, "silence" = 10)
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/breadslice/mimana
	name = "mimana bread slice"
	desc = "A slice of silence!"
	icon_state = "mimanabreadslice"
	filling_color = "#C0C0C0"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/mutetoxin = 1, /datum/reagent/consumable/nothing = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/breadslice/custom
	name = "bread slice"
	icon_state = "tofubreadslice"
	filling_color = "#FFFFFF"
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/baguette
	name = "baguette"
	desc = "Bon appetit!"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "baguette"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 1)
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("bread" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/garlicbread
	name = "garlic bread"
	desc = "Alas, it is limited."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "garlicbread"
	item_state = "garlicbread"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin= 4, /datum/reagent/consumable/garlic = 2)
	bitesize = 3
	tastes = list("bread" = 1, "garlic" = 1, "butter" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/butteredtoast
	name = "buttered toast"
	desc = "Butter lightly spread over a piece of toast."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "butteredtoast"
	bitesize = 3
	filling_color = "#FFA500"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("butter" = 1, "toast" = 1)
	foodtype = GRAIN | BREAKFAST

/obj/item/reagent_containers/food/snacks/butterbiscuit
	name = "butter biscuit"
	desc = "Well butter my biscuit!"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "butterbiscuit"
	filling_color = "#F0E68C"
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("butter" = 1, "biscuit" = 1)
	foodtype = GRAIN | BREAKFAST

/obj/item/reagent_containers/food/snacks/butterdog
	name = "butterdog"
	desc = "Made from exotic butters."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "butterdog"
	bitesize = 1
	filling_color = "#F1F49A"
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("butter", "exotic butter")

/obj/item/reagent_containers/food/snacks/butterdog/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 80)

/obj/item/reagent_containers/food/snacks/store/bread/tumor_bread
	name = "dead tumor bread"
	desc = "It's still within its expiration date, right?"
	icon_state = "tumorbread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice/tumor_bread
	list_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/toxin = 10)
	foodtype = GROSS | GRAIN
	tastes = list("wheat and tumors" = 10)

//teleporting tumor bread kills it
/obj/item/reagent_containers/food/snacks/store/bread/tumor_bread/bread_teleport()
	visible_message(src, "<span class='warning'>[src] explodes in a horrible mess of tumor and flour!</span>")
	qdel(src)

/obj/item/reagent_containers/food/snacks/breadslice/tumor_bread
	name = "tumor bread slice"
	desc = "A slice of bread filled with tumors!"
	icon_state = "tumorbreadslice"
	filling_color = "#B2D72C"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin = 2)
	foodtype = GROSS | GRAIN
