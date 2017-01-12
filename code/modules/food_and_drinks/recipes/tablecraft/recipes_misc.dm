
// see code/module/crafting/table.dm

// MISC

/datum/crafting_recipe/food/candiedapple
	name = "Candied apple"
	reqs = list(/datum/reagent/water = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/weapon/reagent_containers/food/snacks/grown/apple = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/candiedapple
	category = CAT_FOOD

/datum/crafting_recipe/food/chococoin
	name = "Choco coin"
	reqs = list(
		/obj/item/weapon/coin = 1,
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar = 1,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chococoin
	category = CAT_FOOD

/datum/crafting_recipe/food/fudgedice
	name = "Fudge dice"
	reqs = list(
		/obj/item/weapon/dice = 1,
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar = 1,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fudgedice
	category = CAT_FOOD

/datum/crafting_recipe/food/chocoorange
	name = "Choco orange"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/orange = 1,
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar = 1,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chocoorange
	category = CAT_FOOD

/datum/crafting_recipe/food/loadedbakedpotato
	name = "Loaded baked potato"
	time = 40
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/potato = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato
	category = CAT_FOOD

/datum/crafting_recipe/food/cheesyfries
	name = "Cheesy fries"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/fries = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cheesyfries
	category = CAT_FOOD

/datum/crafting_recipe/food/wrap
	name = "Wrap"
	reqs = list(/datum/reagent/consumable/soysauce = 10,
		/obj/item/weapon/reagent_containers/food/snacks/friedegg = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/cabbage = 1,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/eggwrap
	category = CAT_FOOD

/datum/crafting_recipe/food/beans
	name = "Beans"
	time = 40
	reqs = list(/datum/reagent/consumable/ketchup = 5,
		/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/beans
	category = CAT_FOOD

/datum/crafting_recipe/food/eggplantparm
	name ="Eggplant parmigiana"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/eggplant = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/eggplantparm
	category = CAT_FOOD

/datum/crafting_recipe/food/baguette
	name = "Baguette"
	time = 40
	reqs = list(/datum/reagent/consumable/sodiumchloride = 1,
				/datum/reagent/consumable/blackpepper = 1,
				/obj/item/weapon/reagent_containers/food/snacks/pastrybase = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/baguette
	category = CAT_FOOD

////////////////////////////////////////////////TOAST////////////////////////////////////////////////

/datum/crafting_recipe/food/slimetoast
	name = "Slime toast"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/weapon/reagent_containers/food/snacks/breadslice/plain = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/slime
	category = CAT_FOOD

/datum/crafting_recipe/food/jelliedyoast
	name = "Jellied toast"
	reqs = list(
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/weapon/reagent_containers/food/snacks/breadslice/plain = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/cherry
	category = CAT_FOOD

/datum/crafting_recipe/food/twobread
	name = "Two bread"
	reqs = list(
		/datum/reagent/consumable/ethanol/wine = 5,
		/obj/item/weapon/reagent_containers/food/snacks/breadslice/plain = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/twobread
	category = CAT_FOOD

/datum/crafting_recipe/food/burrito
	name ="Burrito"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burrito
	category = CAT_FOOD

/datum/crafting_recipe/food/cheesyburrito
	name ="Cheesy burrito"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cheesyburrito
	category = CAT_FOOD

/datum/crafting_recipe/food/carneburrito
	name ="Carne de asada burrito"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla = 1,
		/obj/item/weapon/reagent_containers/food/snacks/meat/cutlet = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/carneburrito
	category = CAT_FOOD

/datum/crafting_recipe/food/fuegoburrito
	name ="Fuego plasma burrito"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ghost_chili = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fuegoburrito
	category = CAT_FOOD

/datum/crafting_recipe/food/melonfruitbowl
	name ="Melon fruit bowl"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/watermelon = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/apple = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/orange = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lemon = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/melonfruitbowl
	category = CAT_FOOD

/datum/crafting_recipe/food/spacefreezy
	name ="Space freezy"
	reqs = list(
		/datum/reagent/consumable/bluecherryjelly = 5,
		/datum/reagent/consumable/spacemountainwind = 15,
		/obj/item/weapon/reagent_containers/food/snacks/icecream = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/spacefreezy
	category = CAT_FOOD

/datum/crafting_recipe/food/sundae
	name ="Sundae"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/obj/item/weapon/reagent_containers/food/snacks/grown/cherries = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 1,
		/obj/item/weapon/reagent_containers/food/snacks/icecream = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sundae
	category = CAT_FOOD

/datum/crafting_recipe/food/honkdae
	name ="Honkdae"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/obj/item/clothing/mask/gas/clown_hat = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/cherries = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 2,
		/obj/item/weapon/reagent_containers/food/snacks/icecream = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/honkdae
	category = CAT_FOOD

/datum/crafting_recipe/food/nachos
	name ="Nachos"
	reqs = list(
		/datum/reagent/consumable/sodiumchloride = 1,
		/obj/item/weapon/reagent_containers/food/snacks/tortilla = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/nachos
	category = CAT_FOOD

/datum/crafting_recipe/food/cheesynachos
	name ="Cheesy nachos"
	reqs = list(
		/datum/reagent/consumable/sodiumchloride = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge = 1,
		/obj/item/weapon/reagent_containers/food/snacks/tortilla = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cheesynachos
	category = CAT_FOOD

/datum/crafting_recipe/food/cubannachos
	name ="Cuban nachos"
	reqs = list(
		/datum/reagent/consumable/ketchup = 5,
		/obj/item/weapon/reagent_containers/food/snacks/grown/chili = 2,
		/obj/item/weapon/reagent_containers/food/snacks/tortilla = 1
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cubannachos
	category = CAT_FOOD

/datum/crafting_recipe/food/melonkeg
	name ="Melon keg"
	reqs = list(
		/datum/reagent/consumable/ethanol/vodka = 25,
		/obj/item/weapon/reagent_containers/food/snacks/grown/holymelon = 1,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka = 1
	)
	parts = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/melonkeg
	category = CAT_FOOD

/datum/crafting_recipe/food/honeybar
	name = "Honey nut bar"
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/oat = 1,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/honeybar
	category = CAT_FOOD


/datum/crafting_recipe/stuffedlegion
	name = "Stuffed legion"
	time = 40
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/steak/goliath = 1,
		/obj/item/weapon/legion_skull = 1,
		/datum/reagent/consumable/ketchup = 2,
		/datum/reagent/consumable/capsaicin = 2
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/stuffedlegion
	category = CAT_FOOD

/datum/crafting_recipe/lizardwine
	name = "Lizard wine"
	time = 40
	reqs = list(
		/obj/item/severedtail = 1,
		/datum/reagent/consumable/ethanol = 100
	)
	result = /obj/item/weapon/reagent_containers/food/drinks/bottle/lizardwine
	category = CAT_FOOD