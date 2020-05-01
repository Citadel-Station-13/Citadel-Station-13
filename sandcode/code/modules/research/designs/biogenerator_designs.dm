/datum/design/mutagen
	name = "10u Unstable Mutagen"
	id = "mutagen_bottle"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 200)
	make_reagents = list(/datum/reagent/toxin/mutagen = 10)
	category = list("initial","Botany Chemicals")

/datum/design/ash_bottle
	name = "Ash Bottle"
	id = "ash_bottle"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 15)
	make_reagents = list(/datum/reagent/ash = 10)
	category = list("initial","Botany Chemicals")

/datum/design/diethylamine_bottle
	name = "Diethylamine Bottle"
	id = "diethylamine_bottle"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	make_reagents = list(/datum/reagent/diethylamine = 10)
	category = list("initial","Botany Chemicals")

/datum/design/strange_seed
	name = "Pack of strange seeds"
	id = "strange_seed"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 800)
	build_path = /obj/item/seeds/random
	category = list("initial","Organic Materials")
