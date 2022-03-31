//Reagents produced by metabolising/reacting fermichems inoptimally, i.e. inverse_chems or impure_chems
//Inverse = Splitting
//Invert = Whole conversion

/datum/reagent/impure
	chemical_flags = REAGENT_INVISIBLE | REAGENT_SNEAKYNAME | REAGENT_ORGANIC_PROCESS //by default, it will stay hidden on splitting, but take the name of the source on inverting


/datum/reagent/impure/fermiTox
	name = "Chemical Isomers"
	description = "Toxic chemical isomers made from impure reactions. At low volumes will cause light toxin damage, but as the volume increases, it deals larger amounts, damages the liver, then eventually the heart. This is default impure chem for all chems, and changes only if stated."
	data = "merge"
	color = "FFFFFF"
	can_synth = FALSE
	var/potency = 1 //potency multiplies the volume when added.


//I'm concerned this is too weak, but I also don't want deathmixes.
//TODO: liver damage, 100+ heart
/datum/reagent/impure/fermiTox/on_mob_life(mob/living/carbon/C, method)
	if(C.dna && istype(C.dna.species, /datum/species/jelly))
		C.adjustToxLoss(-2)
	else
		C.adjustToxLoss(2)
	..()
