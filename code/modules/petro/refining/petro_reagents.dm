
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

/datum/reagent/asphalt
	name = "Asphalt"
	id = "asphalt"
	description = "Asphalt. Can be processed into a fireproof material."
	reagent_state = SOLID
	color = "#010101"
	taste_description = "road"

/datum/reagent/fueloil
	name = "Fuel Oil"
	id = "fueloil"
	description = "Heavy fuel oil, also known as bunker oil. Can be used as fuel for a steam or stirling engine, or cracked into lighter fuels. Very cheap."
	reagent_state = LIQUID
	color = "#010101"
	taste_description = "sludge"

/datum/reagent/diesel
	name = "Diesel"
	id = "diesel"
	description = "Diesel fuel. It's quite heavy but can be used to manufacture fuel cartridges for the liquid-fuel generator."
	reagent_state = LIQUID
	color = "#010101"
	taste_description = "metal and burning"

/datum/reagent/kerosene
	name = "Kerosene"
	id = "kerosene"
	description = "STEEL BEAMS, BABY"
	reagent_state = LIQUID
	color = "#010101"
	taste_description = "bushes"

/datum/reagent/kerosene/reaction_turf(turf/T, reac_volume)
	if(reac_volume >= 1)
		T.AddComponent(/datum/component/thermite, reac_volume * 5)//5 times stronger than thermite because it's harder to get


/datum/reagent/naptha
	name = "Naptha"
	id = "naptha"
	description = "Liquid naptha, a light oil. Needs further refining to be turned into gasoline."
	reagent_state = LIQUID
	color = "#010101"
	taste_description = "burning and metal"

/datum/reagent/gasoline
	name = "Gasoline"
	id = "gasoline"
	description = "Gasoline. Valuable in large quantities."
	reagent_state = LIQUID
	color = "#010101"
	taste_description = "metal, burning, and the 20th Century"

/datum/reagent/butane
	name = "Butane"
	id = "butane"
	description = "Butane. Sells okay, explodes good."
	reagent_state = GAS
	color = "#010101"

datum/chemical_reaction/reagent_explosion/butane_explosion
	name = "Butane explosion"
	id = "butane_explosion"
	required_reagents = list("butane" = 1)
	required_temp = 672
	strengthdiv = 4 //half strength of nitro, i think