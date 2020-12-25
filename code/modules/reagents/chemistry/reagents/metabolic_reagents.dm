//inert chems for metabolic functions

/datum/reagent/metabolic
	name = "Metabolic liquid"
	chemical_flags = REAGENT_INVISIBLE //So they don't appear on scanners/sleepers


//Base effects are inert to reduce comps
/datum/reagent/metabolic/on_mob_life(mob/living/carbon/M)
	return

/datum/reagent/metabolic/on_mob_add(mob/living/L, amount)
	return

/datum/reagent/metabolic/on_merge(data, amount, mob/living/carbon/M, purity)
	return

//pH buffer
/datum/reagent/metabolic/stomach_acid
	name = "Stomach acid"
	description = "The acid from a stomach."
	color = "#DCDCFF"
	metabolization_rate = 0
	pH = 1.5

//TODO: White blood cells
//Biomarkers
