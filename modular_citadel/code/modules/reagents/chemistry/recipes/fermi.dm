//TO TWEAK:

/datum/chemical_reaction/eigenstate
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
	ImpureChem = "toxin" //What chemical is produced with an inpure reaction

//serum
/datum/chemical_reaction/SDGF
	name = "synthetic-derived growth factor"
	id = "SDGF"
	results = list("SDGF" = 3)
	required_reagents = list("plasma" = 1, "stable_plasma" = 1, "sugar" = 1)
	//required_reagents = list("stable_plasma" = 5, "slimejelly" = 5, "synthflesh" = 10, "blood" = 10)
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
	ThermicConstant = 20 //Temperature change per 1u produced
	HIonRelease = 0.01 //pH change per 1u reaction
	RateUpLim = 5 //Optimal/max rate possible if all conditions are perfect
	FermiChem = TRUE//If the chemical uses the Fermichem reaction mechanics
	FermiExplode = FALSE //If the chemical explodes in a special way
	ImpureChem = "toxin" //What chemical is produced with an inpure reaction


/datum/chemical_reaction/BElarger
	name = ""
	id = "e"
	results = list("Eigenstasium" = 6)
	required_reagents = list("salglu_solution" = 1, "milk" = 5, "synthflesh" = 2, "silicon" = 2, "crocin" = 2)
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
	ImpureChem = "carpotoxin"
