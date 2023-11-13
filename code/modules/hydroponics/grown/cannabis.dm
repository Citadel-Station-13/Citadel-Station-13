// Cannabis
/obj/item/seeds/cannabis
	name = "pack of cannabis seeds"
	desc = "Taxable."
	icon_state = "seed-cannabis"
	species = "cannabis"
	plantname = "Cannabis Plant"
	product = /obj/item/reagent_containers/food/snacks/grown/cannabis
	maturation = 8
	potency = 20
	growthstages = 1
	instability = 40
	growing_icon = 'goon/icons/obj/hydroponics.dmi'
	icon_grow = "cannabis-grow"
	icon_dead = "cannabis-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/cannabis/rainbow,
						/obj/item/seeds/cannabis/death)
	reagents_add = list(/datum/reagent/drug/space_drugs = 0.15, /datum/reagent/toxin/lipolicide = 0.35) // gives u the munchies


/obj/item/seeds/cannabis/rainbow
	name = "pack of rainbow weed seeds"
	desc = "These seeds grow into rainbow weed. Groovy."
	icon_state = "seed-megacannabis"
	species = "megacannabis"
	plantname = "Rainbow Weed"
	product = /obj/item/reagent_containers/food/snacks/grown/cannabis/rainbow
	icon_grow = "megacannabis-grow"
	icon_dead = "megacannabis-dead"
	mutatelist = list(/obj/item/seeds/cannabis/ultimate)
	reagents_add = list(/datum/reagent/toxin/mindbreaker = 0.15, /datum/reagent/toxin/lipolicide = 0.35)
	rarity = 40

/obj/item/seeds/cannabis/death
	name = "pack of deathweed seeds"
	desc = "These seeds grow into deathweed. Not groovy."
	icon_state = "seed-blackcannabis"
	species = "blackcannabis"
	plantname = "Deathweed"
	product = /obj/item/reagent_containers/food/snacks/grown/cannabis/death
	icon_grow = "blackcannabis-grow"
	icon_dead = "blackcannabis-dead"
	mutatelist = list(/obj/item/seeds/cannabis/white)
	reagents_add = list(/datum/reagent/toxin/cyanide = 0.35, /datum/reagent/drug/space_drugs = 0.15, /datum/reagent/toxin/lipolicide = 0.15)
	rarity = 40

/obj/item/seeds/cannabis/white
	name = "pack of lifeweed seeds"
	desc = "I will give unto him that is munchies of the fountain of the cravings of life, freely."
	icon_state = "seed-whitecannabis"
	species = "whitecannabis"
	plantname = "Lifeweed"
	product = /obj/item/reagent_containers/food/snacks/grown/cannabis/white
	icon_grow = "whitecannabis-grow"
	icon_dead = "whitecannabis-dead"
	mutatelist = list()
	reagents_add = list(/datum/reagent/medicine/omnizine = 0.35, /datum/reagent/drug/space_drugs = 0.15, /datum/reagent/toxin/lipolicide = 0.15)
	rarity = 40


/obj/item/seeds/cannabis/ultimate
	name = "pack of omega weed seeds"
	desc = "These seeds grow into omega weed."
	icon_state = "seed-ocannabis"
	species = "ocannabis"
	plantname = "Omega Weed"
	product = /obj/item/reagent_containers/food/snacks/grown/cannabis/ultimate
	icon_grow = "ocannabis-grow"
	icon_dead = "ocannabis-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/green)
	mutatelist = list()
	reagents_add = list(/datum/reagent/drug/space_drugs = 0.3,
						/datum/reagent/toxin/mindbreaker = 0.3,
						/datum/reagent/mercury = 0.15,
						/datum/reagent/lithium = 0.15,
						/datum/reagent/medicine/atropine = 0.15,
						/datum/reagent/medicine/haloperidol = 0.15,
						/datum/reagent/drug/methamphetamine = 0.15,
						/datum/reagent/consumable/capsaicin = 0.15,
						/datum/reagent/barbers_aid = 0.15,
						/datum/reagent/drug/bath_salts = 0.15,
						/datum/reagent/toxin/itching_powder = 0.15,
						/datum/reagent/drug/crank = 0.15,
						/datum/reagent/drug/krokodil = 0.15,
						/datum/reagent/toxin/histamine = 0.15,
						/datum/reagent/toxin/lipolicide = 0.15)
	rarity = 69


// ---------------------------------------------------------------

/obj/item/reagent_containers/food/snacks/grown/cannabis
	seed = /obj/item/seeds/cannabis
	icon = 'goon/icons/obj/hydroponics.dmi'
	name = "cannabis leaf"
	desc = "Recently legalized in most galaxies."
	icon_state = "cannabis"
	filling_color = "#00FF00"
	bitesize_mod = 2
	foodtype = VEGETABLES //i dont really know what else weed could be to be honest
	tastes = list("cannabis" = 1)
	wine_power = 20

/obj/item/reagent_containers/food/snacks/grown/cannabis/rainbow
	seed = /obj/item/seeds/cannabis/rainbow
	name = "rainbow cannabis leaf"
	desc = "Is it supposed to be glowing like that...?"
	icon_state = "megacannabis"
	wine_power = 60

/obj/item/reagent_containers/food/snacks/grown/cannabis/death
	seed = /obj/item/seeds/cannabis/death
	name = "death cannabis leaf"
	desc = "Looks a bit dark. Oh well."
	foodtype = VEGETABLES | TOXIC
	icon_state = "blackcannabis"
	wine_power = 40

/obj/item/reagent_containers/food/snacks/grown/cannabis/white
	seed = /obj/item/seeds/cannabis/white
	name = "white cannabis leaf"
	desc = "It feels smooth and nice to the touch."
	foodtype = VEGETABLES | ANTITOXIC
	icon_state = "whitecannabis"
	wine_power = 10

/obj/item/reagent_containers/food/snacks/grown/cannabis/ultimate
	seed = /obj/item/seeds/cannabis/ultimate
	name = "omega cannabis leaf"
	desc = "You feel dizzy looking at it. What the fuck?"
	icon_state = "ocannabis"
	volume = 420
	wine_power = 90
