
/datum/reagent/crudeoil
	name = "Crude Oil"
	id = "crudeoil"
	description = "A viscous mixture of hydrocarbons, most likely extracted from Lavaland."
	reagent_state = LIQUID
	color = "#010101"
	taste_description = "disgusting oily sludge"

/datum/reagent/crudeoil/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1, 0)
	..()
	return TRUE


/datum/reagent/shaleoil
	name = "Shale Oil"
	id = "shaleoil"
	description = "A viscous mixture of hydrocarbons, most likely extracted from Lavaland. Created by processing oil shale in a pyrolysis chamber."
	reagent_state = LIQUID
	color = "#101010"
	taste_description = "disgusting oily sludge"

/datum/reagent/shaleoil/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1, 0)
	..()
	return TRUE

/datum/reagent/sandoil
	name = "Tar Sand"
	id = "sandoil"
	description = "A extremely viscous mixture of hydrocarbons, most likely extracted from Lavaland. Much too thick to be useful."
	reagent_state = LIQUID
	color = "#000000"
	taste_description = "disgusting oily sludge"

/datum/reagent/sandoil/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1, 0)
	..()
	return TRUE