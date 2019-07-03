/datum/chemical_reaction/fermi/dimethylmercury
	name = "Dimethylmercury explosion"
	id = "dimethylmercury_explosion"
	mix_message = "<span class='userdanger'>The chemicals vaporize instantly in a rush of heat!</span>"
	required_reagents = list("dimethylmercury" = 1)
	OptimalTempMin 		= 278 // Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax		= 1000 // Upper end for above
	ExplodeTemp			= 278 //Temperature at which reaction explodes
	OptimalpHMin		= 0// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax		= 14 // Higest value for above
	ReactpHLim			= 14 // How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact		= 0 // How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 0 // How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 0 // How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 50 //Temperature change per 1u produced
	HIonRelease 		= 0 //pH change per 1u reaction
	RateUpLim 			= 4800 //Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE//If the chemical uses the Fermichem reaction mechanics
	FermiExplode 		= TRUE //If the chemical explodes in a special way
	PurityMin			= 0 //The minimum purity something has to be above, otherwise it explodes.
