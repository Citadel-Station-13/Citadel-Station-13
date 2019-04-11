/datum/chemical_reaction/eigenstate
	name = "Eigenstasium"
	id = "eigenstate"
	results = list("Eigenstasium" = ``)
	required_reagents = list("bluespace_" = 1, "oxygen" = 1, "sugar" = 1)
	//FermiChem vars:
	OptimalTempMin = 350 // Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax = 500 // Upper end for above
	ExplodeTemp = 550 //Temperature at which reaction explodes
	OptimalpHMin = 4 // Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax = 9.5 // Higest value for above
	ReactpHLim = 2 // How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact = 0 // How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharp = 4 // How sharp the exponential curve is (to the power of value)
	ThermicConstant = -2.5 //Temperature change per 1u produced
	HIonRelease = 0.01 //pH change per 1u reaction
	RateUpLim = 50 //Optimal/max rate possible if all conditions are perfect
	FermiChem = 1
