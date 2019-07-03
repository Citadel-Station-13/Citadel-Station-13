/datum/chemical_reaction/fermi/iodomethane
	name = "Methyl Iodide"  //rocket fuel precursor time
	id = "iodomethane"
	results = list("iodomethane" = 1)
	required_reagents = list("methanol" = 1, "phosphorus" = 1, "iodine" = 3)
	mix_message = "<span class='danger'>The mixture suddenly becomes clear, emitting a strong, sickly sweet odour.</span>"
	OptimalTempMin 		= 250 // Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax		= 600 // Upper end for above
	ExplodeTemp			= 650 //Temperature at which reaction explodes
	OptimalpHMin		= 3// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax		= 9 // Higest value for above
	ReactpHLim			= 3 // How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact		= 0 // How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 0.125 // How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 0.125 // How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 5 //Temperature change per 1u produced
	HIonRelease 		= -0.1 //pH change per 1u reaction
	RateUpLim 			= 6 //Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE//If the chemical uses the Fermichem reaction mechanics
	FermiExplode 		= FALSE //If the chemical explodes in a special way
	PurityMin			= 0.3 //The minimum purity something has to be above, otherwise it explodes.

/datum/chemical_reaction/fermi/dimethylmercury
	name = "Dimethylmercury"  //Rocket fuel time
	id = "dimethylmercury"
	results = list("dimethylmercury" = 0.1)
	required_reagents = list("iodomethane" = 1, "mercury" = 0.5, "sodium" = 0.1)
	mix_message = "<span class='danger'>The mixture suddenly becomes clear, emitting a strong, sickly sweet odour.</span>"
	OptimalTempMin 		= 250 // Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax		= 270 // Upper end for above
	ExplodeTemp			= 278 //Temperature at which reaction explodes
	OptimalpHMin		= 1 // Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax		= 2 // Higest value for above
	ReactpHLim			= 3 // How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact		= 0 // How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 8 // How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 8 // How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 1 //Temperature change per 1u produced
	HIonRelease 		= 0.2 //pH change per 1u reaction
	RateUpLim 			= 5 //Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE//If the chemical uses the Fermichem reaction mechanics
	FermiExplode 		= FALSE //If the chemical explodes in a special way
	PurityMin			= 0.5 //The minimum purity something has to be above, otherwise it explodes.
