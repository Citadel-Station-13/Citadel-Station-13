// Watermelon
/obj/item/seeds/watermelon
	name = "pack of watermelon seeds"
	desc = "These seeds grow into watermelon plants."
	icon_state = "seed-watermelon"
	species = "watermelon"
	plantname = "Watermelon Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/watermelon
	lifespan = 50
	endurance = 40
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_dead = "watermelon-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/watermelon/holy)
	reagents_add = list("water" = 0.2, "vitamin" = 0.04, "nutriment" = 0.2)

/obj/item/seeds/watermelon/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is swallowing [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	user.gib()
	new product(drop_location())
	qdel(src)
	return MANUAL_SUICIDE

/obj/item/reagent_containers/food/snacks/grown/watermelon
	seed = /obj/item/seeds/watermelon
	name = "watermelon"
	desc = "It's full of watery goodness."
	icon_state = "watermelon"
	slice_path = /obj/item/reagent_containers/food/snacks/watermelonslice
	slices_num = 5
	dried_type = null
	w_class = WEIGHT_CLASS_NORMAL
	filling_color = "#008000"
	bitesize_mod = 3
	foodtype = FRUIT
	juice_results = list("watermelonjuice" = 0)
	wine_power = 40

// Holymelon
/obj/item/seeds/watermelon/holy
	name = "pack of holymelon seeds"
	desc = "These seeds grow into holymelon plants."
	icon_state = "seed-holymelon"
	species = "holymelon"
	plantname = "Holy Melon Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/holymelon
	mutatelist = list()
	reagents_add = list("holywater" = 0.2, "vitamin" = 0.04, "nutriment" = 0.1)
	rarity = 20

/obj/item/reagent_containers/food/snacks/grown/holymelon
	seed = /obj/item/seeds/watermelon/holy
	name = "holymelon"
	desc = "The water within this melon has been blessed by some deity that's particularly fond of watermelon."
	icon_state = "holymelon"
	filling_color = "#FFD700"
	dried_type = null
	wine_power = 70 //Water to wine, baby.
	wine_flavor = "divinity"

/obj/item/reagent_containers/food/snacks/grown/holymelon/Initialize()
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE) //deliver us from evil o melon god

//ELEMELONS

/obj/item/seeds/elemelon
	name = "pack of elemelon seeds"
	desc = "Rare unknown seeds that grow into large melons."
	icon_state = "seed-elermelon"
	species = "elermelon"
	plantname = "Elemelon Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/elemelon
	lifespan = 90
	endurance = 1 //Lives long, endures none
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_dead = "watermelon-dead"
	genes = list()
	mutatelist = list(/obj/item/seeds/elemelon/air, /obj/item/seeds/elemelon/hell, /obj/item/seeds/elemelon/h2o, /obj/item/seeds/elemelon/earth)
	reagents_add = list("liquid_dark_matter" = 0.1, "singulo" = 0.2)

/obj/item/reagent_containers/food/snacks/grown/elemelon
	seed = /obj/item/seeds/elemelon
	name = "elemelon"
	desc = "This large black fruit is said to be as old as time itself..."
	icon_state = "elermelon"
	filling_color = "#000000"
	dried_type = null
	wine_power = 50
	wine_flavor = "fabrics"

/obj/item/seeds/elemelon/hell
	name = "pack of elemelon seeds"
	desc = "Rare unknown seeds that grow into large melons."
	icon_state = "seed-firemelon"
	species = "elermelon"
	plantname = "Elemelon Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/elemelon/fire
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_dead = "watermelon-dead"
	mutatelist = list()
	reagents_add = list("hell_water" = 0.1, "condensedcapsaicin" = 0.3, "hell_ramen" = 0.5, "clf3" = 0.01) //Better have fire proof gloves

/obj/item/reagent_containers/food/snacks/grown/elemelon/fire
	seed = /obj/item/seeds/elemelon/hell
	name = "hell elemelon"
	desc = "This red fruit is said to originate from the infernal plane, however it can't be found on Lavaland."
	icon_state = "firemelon"
	filling_color = "#000000"
	dried_type = null
	wine_power = 50 //Not bad not good.
	wine_flavor = "brimstone"

/obj/item/seeds/elemelon/air
	name = "pack of elemelon seeds"
	desc = "Rare unknown seeds that grow into large melons."
	icon_state = "seed-airmelon"
	species = "elermelon"
	plantname = "Elemelon Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/elemelon/air
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_dead = "watermelon-dead"
	mutatelist = list()
	reagents_add = list("oxygen" = 0.1, "hydrogen" = 0.03, "co2" = 0.01, "nitrous_oxide" = 0.01, "nitrogen" = 0.35) //Lots of gasses

/obj/item/reagent_containers/food/snacks/grown/elemelon/air
	seed = /obj/item/seeds/elemelon/air
	name = "air elemelon"
	desc = "This translucent, blueish fruit is said to only grow among clouds."
	icon_state = "airmelon"
	filling_color = "#000000"
	dried_type = null
	wine_power = 30 //Hard to get drunk off air
	wine_flavor = "thin"

/obj/item/seeds/elemelon/h2o
	name = "pack of elemelon seeds"
	desc = "Rare unknown seeds that grow into large melons."
	icon_state = "seed-h_two_o_melon"
	species = "elermelon"
	plantname = "Elemelon Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/elemelon/h2o
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_dead = "watermelon-dead"
	mutatelist = list()
	reagents_add = list("water" = 0.4, "hell_water" = 0.04, "holywater" = 0.03, "unholywater" = 0.03, "oxygen" = 0.2, "hydrogen" = 0.1)

/obj/item/reagent_containers/food/snacks/grown/elemelon/h2o
	seed = /obj/item/seeds/elemelon/h2o
	name = "water elemelon"
	desc = "This navy blue fruit is said to originate from an oceanic bluespace pocket."
	icon_state = "h_two_o_melon"
	filling_color = "#000000"
	dried_type = null
	wine_power = 1 //Its water
	wine_flavor = "watered down"

/obj/item/seeds/elemelon/earth
	name = "pack of elemelon seeds"
	desc = "Rare unknown seeds that grow into large melons."
	icon_state = "seed-earthmelon"
	species = "elermelon"
	plantname = "Elemelon Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/elemelon/earth
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_dead = "watermelon-dead"
	mutatelist = list()
	reagents_add = list("iron" = 0.1, "nutriment" = 0.5, "sodiumchloride" = 0.03, "vitamin" = 0.2)

/obj/item/reagent_containers/food/snacks/grown/elemelon/earth
	seed = /obj/item/seeds/elemelon/earth
	name = "soil elemelon"
	desc = "This brown fruit is fabled to be from a massive hollow meteor able to sustain life within its interior."
	icon_state = "earthmelon"
	filling_color = "#000000"
	dried_type = null
	wine_power = 100 //Real salt of the earth
	wine_flavor = "dirt"
