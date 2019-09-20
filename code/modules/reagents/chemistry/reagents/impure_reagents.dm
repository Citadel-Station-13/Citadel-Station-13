//Reagents produced by metabolising/reacting fermichems inoptimally, i.e. inverse_chems or impure_chems
//Inverse = Splitting
//Invert = Whole conversion

/datum/reagent/impure
    chemical_flags = REAGENT_INVISIBLE | REAGENT_SNEAKYNAME //by default, it will stay hidden on splitting, but take the name of the source on inverting


/datum/reagent/impure/fermiTox
	name = "FermiTox"
	id = "fermiTox"
	description = "You should be really careful with this...! Also, how did you get this? You shouldn't have this!"
	data = "merge"
	color = "FFFFFF"
	can_synth = FALSE


//I'm concerned this is too weak, but I also don't want deathmixes.
//TODO: liver damage.
/datum/reagent/impure/fermiTox/on_mob_life(mob/living/carbon/C, method)
	if(C.dna && istype(C.dna.species, /datum/species/jelly))
		C.adjustToxLoss(-2)
	else
		C.adjustToxLoss(2)
	..()
