//TO TWEAK:

//Called for every reaction step
/datum/chemical_reaction/fermi/proc/FermiCreate(holder) //You can get holder by reagents.holder WHY DID I LEARN THIS NOW???
	return

//Called when temperature is above a certain threshold
//....Is this too much?
/datum/chemical_reaction/fermi/proc/FermiExplode(src, datum/reagents/holder, volume, temp, pH, Reaction) //You can get holder by reagents.holder WHY DID I LEARN THIS NOW???
	var/Svol = volume
	var/turf/T = get_turf(holder.my_atom)
	if(temp>600)//if hot, start a fire
		switch(temp)
			if (601 to 800)
				for(var/turf/turf in range(1,T))
					new /obj/effect/hotspot(turf)
					volume /= 3
			if (801 to 1100)
				for(var/turf/turf in range(2,T))
					new /obj/effect/hotspot(turf)
					volume /= 4
			if (1101 to INFINITY)
				for(var/turf/turf in range(3,T))
					new /obj/effect/hotspot(turf)
					volume /= 5

	var/datum/effect_system/smoke_spread/chem/smoke_machine/s = new
	if(pH < 2.5)
		s.set_up("fermiAcid", (volume/3), pH*10, T)
		volume /=3
	for (var/reagent in holder.reagent_list)
		var/datum/reagent/R = reagent
		s.set_up(R.id, R.volume/3, pH*10, T)
		//R.on_reaction(T, volume/10) //Uneeded, I think (hope)
	s.start()

	if (pH > 12)
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round(volume/Svol, 1), T, 0, 0)
		e.start()
	message_admins("Fermi explosion at [T], with a temperature of [temp], pH of [pH], containing [holder.reagent_list]")
	return

/datum/chemical_reaction/fermi/eigenstate
	name = "Eigenstasium"
	id = "eigenstate"
	results = list("eigenstate" = 1)
	required_reagents = list("bluespace" = 1, "stable_plasma" = 1, "sugar" = 1)
	mix_message = "zaps brightly into existance, diffusing the energy from the localised gravity well as light"
	//FermiChem vars:
	OptimalTempMin = 350 // Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax = 500 // Upper end for above
	ExplodeTemp = 550 //Temperature at which reaction explodes
	OptimalpHMin = 4 // Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax = 9.5 // Higest value for above
	ReactpHLim = 2 // How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact = 0 // How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT = 4 // How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH = 2 // How sharp the pH exponential curve is (to the power of value)
	ThermicConstant = -2.5 //Temperature change per 1u produced
	HIonRelease = 0.01 //pH change per 1u reaction
	RateUpLim = 5 //Optimal/max rate possible if all conditions are perfect
	FermiChem = TRUE//If the chemical uses the Fermichem reaction mechanics
	FermiExplode = FALSE //If the chemical explodes in a special way


/datum/chemical_reaction/fermi/eigenstate/FermiCreate(datum/reagents/holder)
	var/location = get_turf(holder.my_atom)
	var/datum/reagent/fermi/eigenstate/E = locate(/datum/reagent/fermi/eigenstate) in holder.reagent_list
	E.location_created = location

//serum
/datum/chemical_reaction/SDGF
	name = "synthetic-derived growth factor"
	id = "SDGF"
	results = list("SDGF" = 3)
	required_reagents = list("plasma" = 1, "stable_plasma" = 1, "sugar" = 1)
	//required_reagents = list("stable_plasma" = 5, "slimejelly" = 5, "synthflesh" = 10, "blood" = 10)
	//FermiChem vars:
	OptimalTempMin 		= 350 		// Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax 		= 500 		// Upper end for above
	ExplodeTemp 		= 550 		// Temperature at which reaction explodes
	OptimalpHMin 		= 4 		// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax 		= 9.5 		// Higest value for above
	ReactpHLim 			= 2 		// How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact 		= 0 		// How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 4 		// How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 2 		// How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 20 		// Temperature change per 1u produced
	HIonRelease 		= 0.01 		// pH change per 1u reaction
	RateUpLim 			= 5 		// Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE		// If the chemical uses the Fermichem reaction mechanics
	FermiExplode 		= TRUE		// If the chemical explodes in a special way

/datum/chemical_reaction/BElarger
	name = ""
	id = "e"
	results = list("Eigenstasium" = 6)
	required_reagents = list("salglu_solution" = 1, "milk" = 5, "synthflesh" = 2, "silicon" = 2, "aphro" = 2)
	//FermiChem vars:
	OptimalTempMin = 350 // Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax = 500 // Upper end for above
	ExplodeTemp = 550 //Temperature at which reaction explodes
	OptimalpHMin = 4 // Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax = 9.5 // Higest value for above
	ReactpHLim = 2 // How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact = 0 // How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT = 4 // How sharp the exponential curve is (to the power of value)
	ThermicConstant = -2.5 //Temperature change per 1u produced
	HIonRelease = 0.01 //pH change per 1u reaction
	RateUpLim = 50 //Optimal/max rate possible if all conditions are perfect
	FermiChem = TRUE

//Nano-b-gone
/datum/chemical_reaction/naninte_b_gone
	name = "Naninte bain"
	id = "naninte_b_gone"
	results = list("naninte_b_gone" = 5)
	required_reagents = list("synthflesh" = 5, "blood" = 3, "uranium" = 1, "salglu_solution" = 3)
	mix_message = "the blood and sugar mixes catalysting a hard coating around the synth flesh"
	//FermiChem vars:
	OptimalTempMin = 450
	OptimalTempMax = 600
	ExplodeTemp = 700
	OptimalpHMin = 6
	OptimalpHMax = 8
	ReactpHLim = 1
	CatalystFact = 0 //To do 1
	CurveSharpT = 4
	CurveSharppH = 2
	ThermicConstant = -2.5
	HIonRelease = 0.01
	RateUpLim = 5
	FermiChem = TRUE
	FermiExplode = FALSE

/datum/chemical_reaction/enthral
	name = "need a name"
	id = "enthral"
	results = list("enthral" = 3)
	required_reagents = list("plasma" = 1, "stable_plasma" = 1, "sugar" = 1)
	required_catalysts = list("blood" = 1)
	//required_reagents = list("stable_plasma" = 5, "slimejelly" = 5, "synthflesh" = 10, "blood" = 10)
	//FermiChem vars:
	OptimalTempMin 		= 350 		// Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax 		= 500 		// Upper end for above
	ExplodeTemp 		= 550 		// Temperature at which reaction explodes
	OptimalpHMin 		= 4 		// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax 		= 9.5 		// Higest value for above
	ReactpHLim 			= 2 		// How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact 		= 0 		// How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 4 		// How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 2 		// How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 20 		// Temperature change per 1u produced
	HIonRelease 		= 0.01 		// pH change per 1u reaction
	RateUpLim 			= 5 		// Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE		// If the chemical uses the Fermichem reaction mechanics
	FermiExplode 		= FALSE		// If the chemical explodes in a special way


/datum/chemical_reaction/enthral/on_reaction(datum/reagents/holder)
	message_admins("On reaction for enthral proc'd")
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	var/datum/reagent/fermi/enthrall/E = locate(/datum/reagent/fermi/enthrall) in holder.reagent_list
	if (B.["gender"] == "female")
		E.creatorGender = "Mistress"
	else
		E.creatorGender = "Master"
	E.creatorName = B.["real_name"]
	E.creatorID = B.["ckey"]
	var/mob/living/creator = holder
	E.creator = creator
	//var/enthrallID = B.get_blood_data()
